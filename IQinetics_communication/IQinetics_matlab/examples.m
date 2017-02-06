% Include "IQinetics_matlab" in your path with subfolders.
% Plug in the motor driver to an FTDI or similar device, BAUD is 115200.  
% Brown is ground
% Red is the motor driver's RX (FTDI TX)
% Orange is the motor driver's TX (FTDI RX)
%
% Power it with 5-12.6V using the XT-30 connector.  
% (This board is designed to go up to 16.8V, though this is largely 
% untested.  It is not recommended to go into the 12.6V-16.8V range)

% In Matlab, type:
% This makes a communication object allowing other objects talk over serial
% replace 'COM18' with the com port of the FTDI, 
% If using Mac/Linux it will likely be '/dev/ttyUSB'.
com = MessageInterface('/dev/tty.usbserial-AFYJJVYG',115200);

% This makes a motor control client, which allows you to send commands and 
% get information about the motor control part of the motor driver
% Note how you have to pass in the com object with a string value pair so 
% that this mot object knows how to talk to its motor driver
mot = ComplexMotorControlClient('com',com);

% Find out what the motor control object can communicate and units
mot.list

% Get all of its values
mot.get_all

% Get just the obs_supply_volts value
mot.get('obs_supply_volts')

% Set a velocity Kp gain (ram only, not persistent) 
mot.set('velocity_Kp', .03);

% Set and get after to make sure
mot.set_verify('velocity_Kp', .04);

% Set multiple things
mot_gains.velocity_Kp = .03;
mot_gains.velocity_Ki = .05;
mot.set_all(mot_gains);

% Save the velocity Kp gain in flash (persistent)
mot.save('velocity_Kp');

% Save every parameter 
mot.save_all();

% Make a system control object, lets you software reset and learn about the
% build version
sys = SystemControlClient('com',com);

% Make a voltage monitor client, lets you query the voltage sensor
volt = BufferedVoltageMonitorClient('com',com);

% Make an encoder client, lets you directly communicate with the encoder
enc = EncoderClient('com',com);

% Other notes:
% All objects except for the MessageInterface have a "list", "get", "set", 
% "save", 'save_verify', "get_all", "set_all", "save_all" 
% It is not recommended to overwrite factory settings.

% This motor driver has a 0.5 second timeout.  If it does not receive a
% message (any message) within the timeout, the motor enters "coast" mode.

% To make the motor spin, use one of the below commands:
% This is a raw PWM (values -1 to 1) command
% mot.set('cmd_spin_pwm',.1);
% This is a voltage command (-input voltage to input voltage)
% mot.set('cmd_spin_volts',1);
% This goes to a position using the angle_Kp, Ki, Kd values
% mot.set('cmd_angle', pi/2); % radians
% This sets a desired speed using the velocity_Kp, Ki, Kd PID gains as well
% as the velocity_ff0, ff1, ff2 feed forward values where
% drive_volts = ff0 + velocity*ff1 + velocity^2*ff2 + PID
% mot.set('cmd_velocity', 100); % radians/second
% This sets a desired current (current is estimated on your board, this is 
% good to +- 25%, amps_Kp, Ki, Kd are not used
% mot.set('ctrl_spin_amps',1); % Amps
% This sets a desired torque (also estimated, +-25%)
% mot.set('ctrl_spin_torque', .01); %Nm
