classdef EncoderClient < Client

    properties (Constant, Hidden)
        kTypeEncoder = 53;
        kParamState = 8;
    end

    methods

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Constructor, from JSON Parameters

        function obj = EncoderClient(varargin)
            args = varargin;
            args = [args, {'type', 'Encoder', 'filename', 'encoder.json'}];
            obj@Client(args{:});
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Special Operations

        function data = get_state(obj)
            % Function "get_state()" is discouraged.  Prefer individual access
            % except when extreme performance is required.')
            msg.msg_type = EncoderClient.kParamState;
            msg.access = EncoderClient.kGet;
            spec = struct('Type', EncoderClient.kTypeEncoder,...
                'Fields', struct('msg_type', 'uint8', 'access','uint8'));
            obj.com.SendMsg(spec, msg);
            [type_idn, pkt] = WaitForMessage(obj, EncoderClient.kTypeEncoder, EncoderClient.kParamState);
            if ~isempty(type_idn) && pkt(2) == EncoderClient.kReply % if we got a message and it is a response
                spec = struct( ...
                    'Type', EncoderClient.kTypeEncoder, ...
                    'Fields', struct( ...
                    'param_idn',    'uint8', ...
                    'access',       'uint8', ...
                    'time',         'uint32', ...
                    'rev',          'uint32', ...
                    'absolute_rev', 'uint32', ...
                    'rad',          'single', ...
                    'absolute_rad', 'single', ...
                    'rad_per_sec',  'single'));
                data = UnpackMsg(spec, pkt);
                data = rmfield(data, {'param_idn', 'access'});
            else
                data = [];
            end
        end
    end

    methods
        % Get bytes from serial until target type_idn, param_idn is
        % receieved.  Return type and packet.
        function [rx_type, rx_packet] = WaitForMessage(obj, type_idn, param_idn)
            rx_type = [];
            rx_packet = [];
            com = obj.com;
            end_time = toc + 0.1;
            while(toc < end_time)
                com.GetBytes();
                while true
                    [msg_type, pkt] = com.PeekPacket();                 % check for messages
                    if ~isempty(msg_type)                               % if we got a message
                        if msg_type == type_idn && pkt(1) == param_idn
                            rx_type = msg_type;
                            rx_packet = pkt;
                            return;
                        end
                    else
                        break;
                    end
                end
            end
        end
    end

end