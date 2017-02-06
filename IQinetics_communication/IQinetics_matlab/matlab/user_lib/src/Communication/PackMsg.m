%{
    pack_msg:
        takes in a msgSpec, checks that user created msg is valid and 
        converts that msg into a buffer into something that encodeSerial
        can use
%}
function pkt_out = PackMsg( msg_spec, msg )
    [spec, pkt] = BundleMsg(msg_spec, msg);
    [ pkt_out ] = encodeSerial( spec, pkt );
end
