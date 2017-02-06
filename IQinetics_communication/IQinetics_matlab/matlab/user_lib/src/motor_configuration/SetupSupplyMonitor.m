function [v_gain, i_gain, i_bias] = SetupSupplyMonitor(mot,bat,varargin)
    p = inputParser;
    addOptional(p,'save',false);
    addOptional(p,'verbose',false);
    parse(p,varargin{:});
    
    bat.get_all
    
    response = input('Are the above supply monitor parameters correct?  [Y/N]: ','s');
    if strcmpi(response,'y')
        return;
    end
    
    out(p.Results.verbose,'Setting up supply monitor');

    v_in = input('Enter the supply voltage: ');
    if (v_in < 4 || v_in > 17) % voltage out of acceptable range
        error('Voltage out of range');
    end

    out(p.Results.verbose,'Sampling voltage...');
    v_gain = bat.calcVoltsGain(v_in,bat.get_volts_mean(1000));
    bat.set('volts_gain',v_gain);
    out(p.Results.verbose,'done');
    
    if(~isa(bat,'BufferedVoltageMonitorClient'))
        mot.set('lead_time',0);
        mot_prop = mot.get_all();
        calibration_current = mot_prop.motor_I_max*.5; % calibrate at 50 percent of max
        pwm_cal = calibration_current*mot_prop.motor_R_ohm/v_in;

        a_low_act = input('Enter the supply current (amps): ');
        out(p.Results.verbose,'Sampling current...');
        a_low_meas = bat.get_amps_raw_mean(10000);
        out(p.Results.verbose,'done');

        disp(['The driver will now draw ~', num2str(calibration_current*pwm_cal+a_low_act), 'A.']);
        disp('Watch and remember the actual power supply current.');
        disp('Press Enter when ready.');
        pause();
        out(p.Results.verbose,'Sampling current...');
        mot.set('cmd_phase_pwm',pwm_cal);
        a_high_meas = bat.get_amps_raw_mean(10000);
        mot.set('cmd_coast');
        out(p.Results.verbose,'done');

        a_high_act = input('Enter the supply current (amps): ');

        [i_gain, i_bias] = bat.calcAmpsGainAndBias(a_low_act, a_low_meas, a_high_act, a_high_meas);
        bat.set('amps_gain',i_gain);
        bat.set('amps_bias',i_bias);

        bat.set('reset_joules',1);
        
        if p.Results.save
            out(p.Results.verbose,'Saving supply monitor settings');
            bat.save('volts_gain');
            bat.save('amps_bias');
            bat.save('amps_gain');
        end
    else
        if p.Results.save
            out(p.Results.verbose,'Saving voltage monitor settings');
            bat.save('volts_gain');
        end
    end
    
end