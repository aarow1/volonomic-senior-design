function ConfigureMotorDriver(mot,bat,varargin)
% This function will calibrate the motor and supply monitor
% and calculate the max efficiency and max speed lead angles.
%
% A motor object and a supply monitor object must be passed in
%
% Ex: ConfigureMotorDriver(mot,bat,'save',false,'verbose',true)

p = inputParser;
addOptional(p,'verbose',false);
addOptional(p,'save',false);
parse(p,varargin{:});

%% Gather motor parameters
SetupMotorProperties(mot,varargin{:});

%% Calibrate supply monitor
SetupSupplyMonitor(mot,bat,varargin{:});

%% Low precision calibration
fprintf('Please wait...');
SetupLowPrecisionCalibration(mot,bat,varargin{:});

%% Permute wires detection
permute_counter = 0;
permute_changed = SetupPermuteWires(mot,bat,varargin{:});
while (permute_changed && permute_counter<=4)
    permute_counter = permute_counter + 1;
    SetupLowPrecisionCalibration(mot,bat);
    permute_changed = SetupPermuteWires(mot,bat,varargin{:});
end
if permute_counter == 5
    error('Failed to find proper permute wires');
end

%% High precision calibration and field weakening lead calibration
[~,lead_field_weaken] = SetupHighPrecisionCalibration(mot,bat,varargin{:});

%% Efficiency lead calibration
% [~] = SetupEfficiencyLead(mot,bat,lead_field_weaken); %Not ready for prime time

end