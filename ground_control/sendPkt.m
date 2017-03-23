function [] = sendPkt(pkt_type)
%% Including global variables
global q_des w_ff f_des q_curr_vicon w_vicon
global pos_control_on
global motor_forces motor_speeds
global tau_att tau_w ki_torque
global xbee send_vicon
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
STOP_TYPE = 38;
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
        pkt = [PKT_START_ENTRY ALL_INPUTS_TYPE ...
            scaleToInt(q_curr_vicon, QUATERNION_MAX) ...
            scaleToInt(q_des, QUATERNION_MAX) ...
            scaleToInt(w_vicon, W_MAX)...
            scaleToInt(w_ff, W_FF_MAX) ...
            scaleToInt(f_des, F_DES_MAX) ...
            PKT_END_ENTRY];
% 
%         pkt = [PKT_START_ENTRY ALL_INPUTS_TYPE ...
%             scaleToInt(q_curr_vicon, QUATERNION_MAX) ...
%             scaleToInt(w_vicon, W_MAX)...
%             scaleToInt(f_des, F_DES_MAX) ...
%             PKT_END_ENTRY];
        
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
    case 'stop'
        pkt = [PKT_START_ENTRY STOP_TYPE PKT_END_ENTRY];
    otherwise
        fprintf('You fucked up\n');
        return;
end
% tic;
fwrite(xbee,pkt,'int16');
% fprintf('fwrite freq = %2.2f\n', 1/toc);

persistent ctr
if isempty(ctr)
    ctr = 0;
end

if send_vicon
    ctr = ctr+1;
    if mod(ctr, 20) == 0 
        fprintf('sending vicon...\t pos_control: %i \t frequency: %3.2f \n',...
            pos_control_on, 1/((toc-time)/20));
        ctr = 0;
        time = toc;
    end
else
    fprintf('sending %s pkt\n',pkt_type);
end
end

