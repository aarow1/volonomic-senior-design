function [electric_lead_rate] = SetupEfficiencyLead(mot,bat,max_test_lead)  
    % I'm not ready for real use
    min_test_lead = 0;
    lead_steps = 20;
    dwell_time = 4;

    mot.set('speed_filter_fc',100);  
    
    leads = linspace(min_test_lead,max_test_lead,lead_steps);
    
    %% Forewards
    pwms_fw = [];
    speeds_fw = [];
    watts_fw = [];
    
    mot_prop = mot.get_all();
    test_current = mot_prop.motor_IMax*1; % test at max current in case it stalls for some reason
    pwm_cmd = test_current*mot_prop.motor_R/bat.get('volts_filt');
    for i = 1:round(100*dwell_time)
        mot.set('cmd_pwm',pwm_cmd*i/(100*dwell_time));
        pause(.01);
    end
    for i = 1:round(100*dwell_time) % wait for dwell time
        mot.set('cmd_pwm',pwm_cmd);
        pause(.01);
    end
    test_speed = mot.get_state.speed;
    mot.set('cmd_pwm',0);
    
    %TODO::potentially use KV to step up voltage by expected V
    
    mot.set('speed_ctrl_kp',0);
    mot.set('speed_ctrl_kd',0);
    mot.set('speed_ctrl_ki',0);
    
    got_to_speed=0;
    for i = 1:100
        mot.set('speed_ctrl_kp',i*.001);
        for i = 1:round(10*dwell_time) % wait 1/10 of dwell time
            mot.set('cmd_speed',test_speed);
            pause(.01);
        end
        if abs(mot.get_state.speed-test_speed) < abs(test_speed)*.1 % if within 10 percent
            got_to_speed = 1;
            break;
        end
    end

    if got_to_speed == 0
        mot.set('cmd_pwm',pwm_cmd);
        error('Did not reach speed in time/within expected Kp');
    end

    for i = 1:length(leads)
        mot.set('cmd_speed',test_speed);
        mot.set('electrical_lead_rate',leads(i));
        temp_pwms = [];
        temp_speeds = [];
        temp_watts = [];
%         disp([num2str((i-1)/lead_steps*50) '%'])
        pause(.1);
        start_time = toc;
        j = 1;
        while toc < start_time+dwell_time
%             state = mot.get_state;
            temp_watts(j) = bat.get('watts_filt');
%             if(~isempty(state))
%                 temp_pwms(j) = state.pwm;
%                 temp_speeds(j) = state.speed;
%             end
%             mot.set('cmd_speed',test_speed);
            j = j+1;
            pause(.001);
        end
%         pwms_fw(i) = mean(temp_pwms);
%         speeds_fw(i) = mean(temp_speeds);
        watts_fw(i) = mean(temp_watts);
        if (length(watts_fw) > 2 && min(watts_fw) == watts_fw(end-1) && min(watts_fw) < watts_fw(end))% end condition
            break;
        end
    end
    mot.set('cmd_pwm',0);
    pause(.5);

    [~,i_fw] = min(watts_fw);

    %% Backwards
    pwms_bw = [];
    speeds_bw = [];
    watts_bw = [];
    
    
    for i = 1:100 % ramp to speed in dwell_time
        mot.set('cmd_speed',-test_speed/100*i);
        pause(dwell_time/100);
    end

    for i = 1:length(leads)
        mot.set('cmd_speed',-test_speed);
        mot.set('electrical_lead_rate',leads(i));
        temp_pwms = [];
        temp_speeds = [];
        temp_watts = [];
%         disp([num2str((i-1)/lead_steps*50+50) '%'])
        pause(.1);
        start_time = toc;
        j = 1;
        while toc < start_time+dwell_time
%             state = mot.get_state;
            temp_watts(j) = bat.get('watts_filt');
%             if(~isempty(state))
%                 temp_pwms(j) = state.pwm;
%                 temp_speeds(j) = state.speed;
%             end
%             mot.set('cmd_speed',-test_speed);
            j = j+1;
            pause(.001);
        end
%         pwms_bw(i) = mean(temp_pwms);
%         speeds_bw(i) = mean(temp_speeds);
        watts_bw(i) = mean(temp_watts);
        if (length(watts_bw) > 2 && min(watts_bw) == watts_bw(end-1) && min(watts_bw) < watts_bw(end))% end condition
            break;
        end
    end

    [~,i_bw] = min(watts_bw);
    
    leads_mean = (leads(i_fw) + leads(i_bw))/2;
    mismatch_pu = .25; % 50%

    figure(2);
    plot(leads(1:length(watts_fw)),watts_fw,leads(i_fw),watts_fw(i_fw),'x',leads(1:length(watts_bw)),watts_bw,'g',leads(i_bw),watts_bw(i_bw),'gx',(leads(i_fw) + leads(i_bw))/2,0,'ro');
    xlabel('Leads (rad/(rad/s))')
    ylabel('Power (W)')
    
    if i_fw == i_bw
        electric_lead_rate = leads(i_fw);
%         disp(['Setting electric lead rate to: ' num2str(leads(i_fw))]);
    elseif abs(leads_mean - leads(i_fw)) < leads_mean*mismatch_pu && abs(leads_mean - leads(i_bw)) < leads_mean*mismatch_pu % if leads not spread by more than mismatch_pu
        electric_lead_rate = leads_mean;
%         disp('The two directions did not agree.  Taking average.');
    else
        error('Forwards and backwards leads mismatch.  Perhaps the calibraion is off.');
    end
    mot.set('electrical_lead_rate',electric_lead_rate);
end