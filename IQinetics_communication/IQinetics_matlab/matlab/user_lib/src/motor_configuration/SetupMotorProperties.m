function SetupMotorProperties(mot,varargin)

    p = inputParser;
    addOptional(p,'save',false);
    addOptional(p,'verbose',false);
    parse(p,varargin{:});
    
    mot_prop_in = mot.get_all();
    mot_prop_list = fieldnames(mot_prop_in);
    for i = 1:length(mot_prop_list)
        if ~isempty(strfind(mot_prop_list{i},'motor_'))
            disp([mot_prop_list{i} ': ' num2str(mot_prop_in.(mot_prop_list{i}))]);
        end
    end
    response = input('Are the above motor parameters correct?  [Y/N]: ','s');
    if strcmpi(response,'y')
        return;
    end
    
    out(p.Results.verbose,'Setting up motor properties');
    
    mot_prop.motor_pole_pairs = int16(input('Enter the number of pole pairs (number of magnets divided by 2): '));
    mot_prop.motor_Kv = input('Enter the motor Kv (RPM/volt): ');
    mot_prop.motor_R_ohm = input('Enter the motor resistance (ohm): ');
    mot_prop.motor_I_max = input('Enter the motor max current (amps): ');
    mot_prop.motor_emf_shape = 1; % Make sinusoidal standard

    mot.set_all(mot_prop);
%     pause(.01);
    mot_prop2 = mot.get_all();
    if (mot_prop.motor_pole_pairs ~= mot_prop2.motor_pole_pairs || mot_prop.motor_emf_shape ~= mot_prop2.motor_emf_shape ...
            || ~approxEqual(mot_prop.motor_Kv,mot_prop2.motor_Kv) || ~approxEqual(mot_prop.motor_R_ohm,mot_prop2.motor_R_ohm) ...
            || ~approxEqual(mot_prop.motor_I_max,mot_prop2.motor_I_max)) 
        error('Motor properties not set on controller.  Make sure the inputs are valid.');
    end
    
    if p.Results.save
        out(p.Results.verbose,'Saving motor properties');
        mot.save('motor_pole_pairs');
        mot.save('motor_Kv');
        mot.save('motor_R_ohm');
        mot.save('motor_I_max');
        mot.save('motor_emf_shape');
    end
end