classdef As5047Client < Client
    methods
        function obj = As5047Client(varargin)
            args = varargin;
            args = [args, {'type', 'As5047', 'filename', 'as5047.json'}];
            obj@Client(args{:});
        end
        
        function [diaagc] = ParseDiaagc(obj)
            raw = obj.get('diagnostic');
            diaagc.magh = boolean(bitand(raw,uint16(2048))); % bit 11
            diaagc.magl = boolean(bitand(raw,uint16(1024))); % bit 10
            diaagc.cof = boolean(bitand(raw,uint16(512))); % bit 9
            diaagc.lf = boolean(bitand(raw,uint16(256))); % bit 8
            diaagc.agc = uint8(bitand(raw,uint16(255))); % bit 0:7
        end
        
        function [settings1] = ParseSettings1(obj)
            raw = obj.get('settings1');
            settings1.noiseset = boolean(bitand(raw,uint16(2))); % bit 1
            settings1.dir = boolean(bitand(raw,uint16(4))); % bit 2
            settings1.uvw_abi = boolean(bitand(raw,uint16(8))); % bit 3
            settings1.daecdis = boolean(bitand(raw,uint16(16))); % bit 4
            settings1.abibin = boolean(bitand(raw,uint16(32))); % bit 5
            settings1.dataselect = uint8(bitand(raw,uint16(64))); % bit 6
            settings1.pwmon = boolean(bitand(raw,uint16(128))); % bit 7
        end
        
        function [settings2] = ParseSettings2(obj)
            raw = obj.get('settings2');
            settings2.uvwpp = uint8(bitand(raw,uint16(7))); % bit 0:2
            settings2.hys = uint8(bitshift(bitand(raw,uint16(24)),3)); % bit 3:4
            settings2.abires = uint8(bitshift(bitand(raw,uint16(224)),5)); % bit 5:7
        end
        
        function SetVerifyDefaults(obj)
            obj.set_verify('settings1',uint16(36)); % set DIR, ABIBIN
            %obj.set_verify('settings1',uint16(32806)); % set NOISESET, DIR, ABIBIN
            %obj.set_verify('settings1',uint16(32820)); % set DIR, DAECDIS, ABIBIN
            obj.set_verify('settings2',uint16(0));
        end
    end
end