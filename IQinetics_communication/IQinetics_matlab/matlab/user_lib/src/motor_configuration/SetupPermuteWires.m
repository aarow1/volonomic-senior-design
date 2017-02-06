function permute_changed = SetupPermuteWires(mot,bat,varargin)
    p = inputParser;
    addOptional(p,'verbose',false);
    addOptional(p,'save',false);
    parse(p,varargin{:});
    verbose = p.Results.verbose;
    
    out(verbose,'Checking permute wires');
    permute_changed = 0;
    
    mot.set('velocity_filter_fc',100);
    mot.set('lead_time',0);

    mot_prop = mot.get_all();
    
    test_current = mot_prop.motor_I_max*.25; % test at 25 percent of max
    
    pwm_cmd = test_current*mot_prop.motor_R_ohm/bat.get('volts');

    for i = 1:100 % one second
        mot.set('cmd_spin_pwm',pwm_cmd);
        pause(.01);
    end
    speed = mot.get('obs_velocity');
    
    mot.set('cmd_coast');
    if abs(speed) < 1 % If the motor didn't really spin
        permute_wires = mot.get('permute_wires');
        if permute_wires == 0
            mot.set('permute_wires',1);
        else
            mot.set('permute_wires',0);
        end
        permute_changed = 1;
        out(verbose,['No spin detected, changing permute wires to ' num2str(mot.get('permute_wires'))]);
    else
        out(verbose,['Spin detected, leaving permute wires alone at ' num2str(mot.get('permute_wires'))]);
        if(speed < 0)
            out(verbose,'Motor spun backwards, adjusting calibration');
            mot.set('calibration_angle',mot_prop.calibration_angle+pi/double(mot_prop.motor_pole_pairs));
        end
    end
end