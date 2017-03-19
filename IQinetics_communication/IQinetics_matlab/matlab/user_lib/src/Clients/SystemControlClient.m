classdef SystemControlClient < Client

    methods

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Constructor, from JSON Parameters

        function obj = SystemControlClient(varargin)
            args = varargin;
            args = [args, {'filename', 'system_control.json'}];
            obj@Client(args{:});
        end
    end
end