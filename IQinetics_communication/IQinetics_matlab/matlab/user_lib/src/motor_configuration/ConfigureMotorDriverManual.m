function ConfigureMotorDriverManual(mot,bat)
sample_time = 1; %seconds
num_points = 20;

lead_lim = [2.0e-4 3.0e-4];

run = 1;
if isa(bat,'BufferedVoltageMonitorClient')
    do_current = false;
    volt_string = 'volts';
else
    do_current = true;
    volt_string = 'volts_filt';
end

%% Setup figure
fig_handle = figure('KeyPressFcn',@KeyPressCallback);

subplot(2,2,1)
speed_handle = plot(0,0,'*');
hold all;
for idx = 2:num_points
    speed_handle(end+1) = plot(0,0,'*');
end
for idx = 1:length(speed_handle)
speed_handle(idx).Color = [1,1,1]*(1-idx/length(speed_handle));
end
xlim(lead_lim);
ylabel(num2str(0));
grid on;
title('Speed')

subplot(2,2,2)
watt_handle = plot(0,0,'*');
hold all;
for idx = 2:num_points
    watt_handle(end+1) = plot(0,0,'*');
end
for idx = 1:length(watt_handle)
watt_handle(idx).Color = [1,1,1]*(1-idx/length(watt_handle));
end
xlim(lead_lim);
ylabel(num2str(0));

grid on;
title('Watts')

subplot(2,2,3)
volt_handle = plot(0,0,'*');
hold all;
for idx = 2:num_points
    volt_handle(end+1) = plot(0,0,'*');
end
for idx = 1:length(volt_handle)
volt_handle(idx).Color = [1,1,1]*(1-idx/length(volt_handle));
end
xlim(lead_lim);
grid on;
title('Voltage')
    
subplot(2,2,4)
current_handle = plot(0,0,'*');
hold all;
for idx = 2:num_points
    current_handle(end+1) = plot(0,0,'*');
end
for idx = 1:length(current_handle)
current_handle(idx).Color = [1,1,1]*(1-idx/length(current_handle));
end
xlim(lead_lim);
ylabel(num2str(0));
grid on;
title('Current')

%% Run the test
while(run)
    watts = [];
    volts = [];
    currents = [];
    speeds = [];
    pwms = [];
    tic
    while toc < sample_time
%         state = mot.get_state;
%         if ~isempty(state)
%             speeds(end+1) = state.speed;
%             pwms(end+1) = state.pwm;
%         end
        speed = mot.get('obs_velocity');
        if ~isempty(speed)
            speeds(end+1) = speed;
        end
        pwm = mot.get('drive_pwm');
        if ~isempty(pwm)
            pwms(end+1) = pwm;
        end
        volt = bat.get(volt_string);
        if(do_current)
            current = bat.get('amps_filt');
            watt = bat.get('watts_filt');
        else
            current = [];
            watt = [];
        end
        if ~isempty(volt)
            volts(end+1) = volt;
        end
        if ~isempty(current)
            currents(end+1) = current;
        end
        if ~isempty(watt)
            watts(end+1) = watt;
        end
        drawnow;
    end
    PlotData(watts,volts,currents,speeds,pwms);
end

%% cleanup
close(fig_handle);

%% Helper functions
    function PlotData(watts_in,volts_in,currents_in,speeds_in,pwms_in)
        figure(fig_handle);
        fig_handle.Name = num2str(mean(pwms_in));
        lead = mot.get('lead_time');
        ShiftData(speed_handle,lead,mean(speeds_in));
        ShiftData(watt_handle,lead,mean(watts_in));
        ShiftData(volt_handle,lead,mean(volts_in));
        ShiftData(current_handle,lead,mean(currents_in));
    end

    function ShiftData(handle, x, y)
        for i = 1:length(handle)-1
            handle(i).XData = handle(i+1).XData;
            handle(i).YData = handle(i+1).YData;
        end
        handle(end).XData = x;
        handle(end).YData = y;
        if (y == 0) || isempty(y) || isnan(y)
            handle(end).Parent.YLim = [-1,1];
        elseif sign(y) == 1
            handle(end).Parent.YLim = [y*.9,y/.9];
        else
            handle(end).Parent.YLim = [y/.9,y*.9];
        end
        handle(end).Parent.YLabel.String = num2str(y,'%.2f');
        
        if ~isempty(x) && ~isnan(x)
            xlim(handle(end).Parent,[x-1e-5, x+1e-5]);
        end
    end

    function KeyPressCallback(src,evt)
       switch evt.Key
           case 'rightarrow'
               calibration = mot.get('calibration_angle')+2*pi/(8192*4)
               mot.set('calibration_angle',calibration)
           case 'leftarrow'
               calibration = mot.get('calibration_angle')-2*pi/(8192*4)
               mot.set('calibration_angle',calibration)
           case 'uparrow'
               lead = mot.get('lead_time')+1e-6
               mot.set('lead_time',lead);
           case 'downarrow'
               lead = mot.get('lead_time')-1e-6
               mot.set('lead_time',lead);
           case 'd'
               speed_samp = mot.get('cmd_velocity');
               if isempty(speed_samp) || isnan(speed_samp) || speed_samp == 0
                   speed_samp = 0;
               end
               speed = speed_samp-50
               mot.set('cmd_velocity',speed);
           case 'e'
               speed_samp = mot.get('cmd_velocity');
               if isempty(speed_samp) || isnan(speed_samp) || speed_samp == 0
                   speed_samp = 0;
               end
               speed = speed_samp+50
               mot.set('cmd_velocity',speed);
           case 'w'
               speed_samp = mot.get('cmd_velocity');
               if isempty(speed_samp) || isnan(speed_samp) || speed_samp == 0
                   speed_samp = 0;
               end
               speed = speed_samp+10
               mot.set('cmd_velocity',speed);
           case 's'
               speed_samp = mot.get('cmd_velocity');
               if isempty(speed_samp) || isnan(speed_samp) || speed_samp == 0
                   speed_samp = 0;
               end
               speed = speed_samp-10
               mot.set('cmd_velocity',speed);
           case 'q'
               pwm_samp = mot.get('cmd_spin_pwm');
               if isempty(pwm_samp) ||isnan(pwm_samp) || pwm_samp == 0
                   pwm_samp = 0;
               end
               pwm = pwm_samp + .01
               mot.set('cmd_spin_pwm',pwm);
           case 'a'
               pwm_samp = mot.get('cmd_spin_pwm');
               if isempty(pwm_samp) || isnan(pwm_samp) || pwm_samp == 0
                   pwm_samp = 0;
               end
               pwm = pwm_samp - .01
               mot.set('cmd_spin_pwm',pwm);
           case 't'
               mot.set('motor_emf_shape',0);
           case 'c'
               mot.set('motor_emf_shape',1);
           case 'z'
               disp('Shutting down');
               run=0;
               rampToPwm(mot,0,1);
           otherwise
               disp(['I do not recognize: ' evt.Key])
       end
    end

end
