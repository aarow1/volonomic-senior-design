function calibration_angle = SetupLowPrecisionCalibration(mot,bat,varargin)
    p = inputParser;
    addOptional(p,'save',false);
    addOptional(p,'verbose',false);
    parse(p,varargin{:});
    
    out(p.Results.verbose,'Performing low precision calibration');

    mot.set('velocity_filter_fc',100);
    mot.set('lead_time',0);

    mot_prop = mot.get_all();
    
    calibration_current = mot_prop.motor_I_max; % calibrate at 100 percent of max
    
    pwm_cal = calibration_current*mot_prop.motor_R_ohm/bat.get('volts');
    
    cal_time = .4;
    mot.set('calibration_time',cal_time);
    mot.set('cmd_calibrate',pwm_cal);
    tic;
    while(toc < cal_time+.25)
        mot.get('obs_angle'); % Keep alive
    end
    
    calibration_angle = mot.get('calibration_angle');%mot.get_calibration_angle();
    out(p.Results.verbose,['Calibration was ' num2str(mot_prop.calibration_angle) ' and is now ' num2str(calibration_angle)]);
    if isempty(calibration_angle)
        calibration_angle = mot.get('calibration_angle');
        if isempty(calibration_angle)
            error('Driver is not reporting a calibration angle');
        end
    end
    if ~(calibration_angle < 2*pi && calibration_angle > -2*pi)
        error('Low precision calibration out of range.');
    end
    
    if p.Results.save
        out(p.Results.verbose,'Saving motor properties');
        mot.save('calibration_angle');
    end
end