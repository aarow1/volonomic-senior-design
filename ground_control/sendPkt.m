function [] = sendPkt(pkt_type)
%% Including global variables
global q_des w_ff f_des q_curr_vicon
global motor_forces motor_speeds
global tau_att tau_w
global xbee
%% Packet entry definitions
PKT_START_ENTRY = 32;
ALL_INPUTS_TYPE = 33;
NO_VICON_TYPE = 34;
MOTOR_FORCES_TYPE = 35;
MOTOR_SPEEDS_TYPE = 36;
GAINS_TYPE = 37;
STOP_TYPE = 38;
PKT_END_ENTRY = 69;

%% Compose and send packet
switch (pkt_type)
    case 'motor_forces'
        pkt = [PKT_START_ENTRY MOTOR_FORCES_TYPE motor_forces PKT_END_ENTRY];
    case 'motor_speeds'
        pkt = [PKT_START_ENTRY MOTOR_SPEEDS_TYPE motor_speeds PKT_END_ENTRY];
    case 'all_inputs'
        pkt = [PKT_START_ENTRY ALL_INPUTS_TYPE q_curr_vicon q_des w_ff f_des PKT_END_ENTRY];
    case 'no_vicon'
        pkt = [PKT_START_ENTRY NO_VICON_TYPE q_des w_ff f_des PKT_END_ENTRY];
    case 'gains'
        pkt = [PKT_START_ENTRY GAINS_TYPE tau_att tau_w PKT_END_ENTRY];
    case 'stop'
        pkt = [PKT_START_ENTRY STOP_TYPE PKT_END_ENTRY];
    otherwise
        fprintf('You fucked up\n');
        return;
end
fwrite(xbee,pkt,'float32');
end

