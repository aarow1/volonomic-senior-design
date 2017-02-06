classdef BufferedVoltageMonitorClient < Client

    methods

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Constructor, from JSON Parameters

        function obj = BufferedVoltageMonitorClient(varargin)
            args = varargin;
            args = [args, {'filename', 'buffered_voltage_monitor.json'}];
            obj@Client(args{:});
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Convenience Functions

        function [gain] = calcVoltsGain(obj, meas1, reported)
            gain = obj.get('volts_gain')*meas1/reported;
        end
        
        function volts_mean = get_volts_mean(obj, nSamples)
            volts = zeros(nSamples,1);
            for k=1:nSamples; volts(k) = double(obj.get('volts')); end;
            volts_mean = mean(volts);
        end
        
    end
end