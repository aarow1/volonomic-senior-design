function [t, w] = speedStepResponse(com, motor, w1, w2)

% test parameters
rampTime = 3;
settlingTime = 3;

% initialize vectors
t = zeros(1,settlingTime*1000);
w = zeros(1,settlingTime*1000);

% initial ramp to speed
rampToSpeed(motor, w1, rampTime);
pauseWithPoll(com, settlingTime);

% step and measure
tic;
stop_time = toc + settlingTime;
motor.set('cmd_speed', w2);
k=1;
while toc < stop_time
    w(k) = motor.get('act_speed');
    t(k) = toc;
%     time = toc;
%     if(time > stop_time)
%         break;
%     end
%     disp(time);
%     disp(stop_time);
%     pause(0.001);
    k=k+1;
end
t = t(1:k-1);
w = w(1:k-1);