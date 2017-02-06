%BundleMsg takes in a msgSpec, checks that user created msg is valid and 
%        converts that msg into a buffer.  The buffer could then be passed
%        into encodeSerial

function [spec_type, data] = BundleMsg( msg_spec, msg )
    spec_type = msg_spec.Type;
    spec_fields = msg_spec.Fields;
    field_names = fieldnames(spec_fields);
    data = uint8([]);
    for i = 1:length(field_names)
        field = field_names{i};
        if ~isfield(msg, field)
            disp(['msg does not have field: ' field]);
            error('');
            data = [];
            return;
        end
        data = [data typecastx(cast( msg.(field), spec_fields.(field) ), 'uint8')];
    end
end
