function [cal_angle, electric_lead_rate] = SetupHighPrecisionCalibration(mot,bat,varargin)
    p = inputParser;
    addOptional(p,'verbose',false);
    addOptional(p,'save',false);
    parse(p,varargin{:});
    verbose = p.Results.verbose;
    
    out(verbose,'Starting high precision calibration');
    
    dwell_time = 2;
    encoder_count = 4096;
    
    mot.set('velocity_filter_fc',100);
    mot.set('lead_time',0);
    mot.set('cmd_spin_pwm',0);
    
    mot_prop = mot.get_all();
    
    test_current = mot_prop.motor_I_max*.75; % test at 3/4 current, worst case (if it stalls for some reason)

    pwm_cmd = test_current*mot_prop.motor_R_ohm/bat.get('volts');
    
    orig_cal_ang = mot.get('calibration_angle');
    if isempty(orig_cal_ang)
        orig_cal_ang = mot.get('calibration_angle');
        if isempty(orig_cal_ang)
            error('Driver is not reporting a calibration angle');
        end
    end

    % generate angles
    test_angles = 0:2*pi/encoder_count:2*pi/double(mot_prop.motor_pole_pairs)/2;
    angles_fw = orig_cal_ang + test_angles;
    angles_bw = orig_cal_ang -test_angles;
    
    rampToPwm(mot,pwm_cmd,1);
    success = false;
    while success == false    
        speeds_fw = [];
        found_max_fw = 0;
        
        for j = 1:length(angles_fw)
            i = angles_fw(j);
            mot.set('calibration_angle',i);
            speeds = [];
            current_time = toc;
            start_time = current_time;
            while(current_time < start_time+dwell_time)
                state = mot.get('obs_velocity');
                if ~isempty(state)
                    speeds(end+1) = state;
    %                 mot.set('cmd_pwm',pwm_cmd);
                end
                current_time = toc;
            end
            speeds_fw(end+1) = mean(speeds);
            if (length(speeds_fw) > 2 && max(speeds_fw) == speeds_fw(end-1) && max(speeds_fw) > speeds_fw(end))% end condition
                found_max_fw = 1;
                success = true;
                break;
            elseif (length(speeds_fw) > 2 && speeds_fw(end-1) > speeds_fw(end))
                out(verbose,'Slowing down, calibration must be off, adjusting calibration');
                angles_fw = angles_fw - pi/4/double(mot_prop.motor_pole_pairs);
                angles_bw = angles_bw - pi/4/double(mot_prop.motor_pole_pairs);
                break;
            end
        end
    end
    
    rampToPwm(mot,0,1);
    pause(.1);

    pwm_cmd = -pwm_cmd;
    rampToPwm(mot,pwm_cmd,1);
    success = false;
    while success == false 
        speeds_bw = [];
        found_max_bw = 0;
        
        for j = 1:length(angles_bw)
            i = angles_bw(j);
            mot.set('calibration_angle',i);
            speeds = [];
            current_time = toc;
            start_time = current_time;
            while(current_time < start_time+dwell_time)
                state = mot.get('obs_velocity');
                if ~isempty(state)
                    speeds(end+1) = state;
    %                 mot.set('cmd_pwm',pwm_cmd);
                end
                current_time = toc;
            end
            speeds_bw(end+1) = mean(speeds);
            if (length(speeds_bw) > 2 && min(speeds_bw) == speeds_bw(end-1) && min(speeds_bw) < speeds_bw(end))% end condition
                found_max_bw = 1;
                success = true;
                break;
            elseif (length(speeds_bw) > 2 && speeds_bw(end-1) < speeds_bw(end))
                out(verbose,'Slowing down, calibration must be off, adjusting calibration');
                angles_bw = angles_bw + pi/4/double(mot_prop.motor_pole_pairs);
                break;
            end
        end
    end
    rampToPwm(mot,0,1);
    
    cal_angle = [];
    electric_lead_rate = [];

    if (found_max_fw && found_max_bw)
        fw_max_speed = speeds_fw(end-1);
        bw_max_speed = speeds_bw(end-1);
        fw_angle = angles_fw(length(speeds_fw)-1);
        bw_angle = angles_bw(length(speeds_bw)-1);
        cal_angle = mean([fw_angle, bw_angle]);
        lead_angle = (mod(fw_angle,2*pi/double(mot_prop.motor_pole_pairs)/2) - mod(bw_angle,2*pi/double(mot_prop.motor_pole_pairs)/2))/2;
        lead_speed = mean([fw_max_speed, -bw_max_speed]);
        electric_lead_rate = lead_angle/lead_speed;
%         disp(['Calibration angle: ' num2str(cal_angle)]);
%         disp(['Electric lead rate for speed: ' num2str(electric_lead_rate)]);
        mot.set('calibration_angle',cal_angle);
%         mot.set('electrical_lead_rate',electric_lead_rate);
    end
    figure(1);
    plot(angles_fw(1:length(speeds_fw)),speeds_fw,angles_bw(1:length(speeds_bw)),speeds_bw)
    xlabel('angles (radians)');
    ylabel('speeds (rad/s)');
end