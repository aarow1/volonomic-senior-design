classdef As5047Client < Client
    methods
        function obj = As5047Client(varargin)
            args = varargin;
            args = [args, {'type', 'As5047', 'filename', 'as5047.json'}];
            obj@Client(args{:});
        end
    end
end