function [] = sendPkt(pkt_type)
%% Including global variables
global q_des w_ff f_des q_curr_vicon w_vicon
global pos_control_on
global motor_forces motor_speeds
global tau_att tau_w ki_torque
global xbee send_vicon
global ping_time
persistent time

if isempty(time)
    time = 0;
end
%% Packet entry definitions
PKT_START_ENTRY = 32;
ALL_INPUTS_TYPE = 33;
NO_VICON_TYPE = 34;
MOTOR_FORCES_TYPE = 35;
MOTOR_SPEEDS_TYPE = 36;
GAINS_TYPE = 37;
PING_TYPE = 38;
RETURN_TYPE = 39;
STOP_TYPE = 40;
PKT_END_ENTRY = 69;

INT_16_MAX  = 32767.0;
MOTOR_SPEEDS_MAX = 32767.0;
MOTOR_FORCES_MAX = 10.0;
GAINS_MAX = 10.0;
QUATERNION_MAX = 1.0;
W_MAX = 10.0;
W_FF_MAX = 10.0;
F_DES_MAX = 10.0;
KI_TORQUE_MAX = 10.0;

%% Compose and send packet
switch (pkt_type)
    case 'motor_forces'
        pkt = [PKT_START_ENTRY MOTOR_FORCES_TYPE ...
            scaleToInt(motor_forces, MOTOR_FORCES_MAX) ...
            PKT_END_ENTRY];
        
    case 'motor_speeds'
        pkt = [PKT_START_ENTRY MOTOR_SPEEDS_TYPE ...
            scaleToInt(motor_speeds, MOTOR_SPEEDS_MAX) ...
            PKT_END_ENTRY];
        
    case 'all_inputs'
        time_data = toc*1000;
        time_data_1 = floor(time_data/INT_16_MAX);
        time_data_2 = (time_data) - (time_data_1*INT_16_MAX);
        pkt = [PKT_START_ENTRY ALL_INPUTS_TYPE ...
            time_data_1 time_data_2 ...
            scaleToInt(q_curr_vicon, QUATERNION_MAX) ...
            scaleToInt(q_des, QUATERNION_MAX) ...
            scaleToInt(w_vicon, W_MAX)...
            scaleToInt(w_ff, W_FF_MAX) ...
            scaleToInt(f_des, F_DES_MAX) ...
            PKT_END_ENTRY];
        
    case 'no_vicon'
        pkt = [PKT_START_ENTRY NO_VICON_TYPE ...
            scaleToInt(q_des,QUATERNION_MAX) ...
            scaleToInt(w_ff,W_FF_MAX) ...
            scaleToInt(f_des,F_DES_MAX) ...
            PKT_END_ENTRY];
    case 'gains'
        pkt = [PKT_START_ENTRY GAINS_TYPE ...
            scaleToInt(tau_att,GAINS_MAX) ...
            scaleToInt(tau_w,GAINS_MAX) ...
            scaleToInt(ki_torque,GAINS_MAX) ...
            PKT_END_ENTRY];
    case 'ping'
        ping_time;
        ping_data_1 = floor(ping_time/INT_16_MAX);
        ping_data_2 = (ping_time) - (ping_data_1*INT_16_MAX);
        pkt = [PKT_START_ENTRY PING_TYPE ...
            ping_data_1 ...
            ping_data_2 ...
            PKT_END_ENTRY];
    case 'stop'
        pkt = [PKT_START_ENTRY STOP_TYPE PKT_END_ENTRY];
    otherwise
        fprintf('You fucked up\n');
        return;
end
% tic;
fwrite(xbee,pkt,'int16');
% msg = rosmessage(packet_pub);
% msg.data = cast(pkt, 'int16');
% send(packet_pub, msg);
% fprintf('fwrite freq = %2.2f\n', 1/toc);

persistent ctr
if isempty(ctr)
    ctr = 0;
end

if send_vicon
    ctr = ctr+1;
    if (ctr >= 20)
        fprintf('sending vicon...\t pos_control: %i \t frequency: %3.2f \n',...
            pos_control_on, 1/((toc-time)/20));
        ctr = 0;
        time = toc;
    end
elseif ~isequal(pkt_type,'ping')
    fprintf('sending %s pkt\n',pkt_type);
end
end

