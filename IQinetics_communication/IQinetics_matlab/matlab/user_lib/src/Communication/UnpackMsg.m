%{
    unpack_msg: given a packet of bytes and a msgSpec fill a 
                msg struct of the appropriate form 

    Note: this function does not know how to unpack arrays
          inside of messages, a more powerful message definition
          is required. 
%}

function msg = UnpackMsg( msg_spec, pkt )
    if ~isa(pkt, 'uint8')
        error('pkt must be of type "uint8"');
    end
%     spec_type = msg_spec.Type;
    spec_fields = msg_spec.Fields;
    field_names = fieldnames(spec_fields);
    ind = 1;
    msg = struct();
    for i = 1:length(field_names)
        field = field_names{i};
        numerical_type = spec_fields.(field);
        % Get sizeof numerical type
%         nbytes = length(typecastx(cast(0, numerical_type ),'uint8'));
        nbytes = NumBytes(numerical_type);
        % typecast bytes in packet to correct type
%         val = typecast( pkt(1:nbytes), numerical_type );
        val = typecastx( pkt(ind:(ind+nbytes-1)), numerical_type );
        % pop elements from packet corresponding to val
%         pkt = pkt(nbytes+1:end);
        ind = ind+nbytes;
        % populate msg struct with correct value
        msg.(field) = val;
    end
end

