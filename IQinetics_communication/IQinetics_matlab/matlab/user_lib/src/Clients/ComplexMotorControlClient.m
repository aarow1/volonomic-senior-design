classdef ComplexMotorControlClient < Client

    methods

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Constructor, from JSON Parameters

        function obj = ComplexMotorControlClient(varargin)
            args = varargin;
            args = [args, {'filename', 'complex_motor_control.json'}];
            obj@Client(args{:});
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Modified Superclass Operations

        function set_all(obj, s)
            % Skip certain fields from set_all operation; mostly commands
            % that would actuate the motor.
            fields = {...
                'cmd_mode', ...
                'cmd_phase_pwm', ...
                'cmd_phase_volts', ...
                'cmd_spin_pwm', ...
                'cmd_spin_volts', ...
                'cmd_brake', ...
                'cmd_coast', ...
                'cmd_calibrate', ...
                'cmd_velocity', ...
                'cmd_angle', ...
                'cmd_amps'};
            mask = isfield(s, fields);
            set_all@Client(obj, rmfield(s, fields(mask)));
        end

    end
end