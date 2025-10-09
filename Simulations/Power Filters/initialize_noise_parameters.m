% =========================================================================
% INITIALIZE_NOISE_PARAMETERS.M
%
% This script defines the 'params' struct for the generatePowerNoise function.
% Run this script before starting the Simulink simulation to load the
% parameters into the MATLAB workspace.
% =========================================================================

disp('Loading power source noise parameters into workspace...');

% Create the main parameter structure
params = struct();

% --- 1. USB PD Parameters ---
params.usb_pd = struct();
params.usb_pd.base_voltage      = 20.0;         % Nominal V, for reference
params.usb_pd.V_reg_percent     = 5.0;         % DC regulation tolerance (+/- %)
params.usb_pd.V_ripple_pp       = 0.150;       % 150mV Peak-to-Peak ripple
params.usb_pd.f_sw              = 75000;       % 75 kHz switching frequency
params.usb_pd.f_whine           = 1400;        % 1.4 kHz coil whine frequency
params.usb_pd.A_whine           = 0.015;       % 15mV coil whine amplitude
params.usb_pd.psd_hf            = 1e-14;       % Power Spectral Density for HF noise (V^2/Hz)

% --- 2. Li-Po Battery Parameters ---
params.li_po = struct();
params.li_po.N_series           = 4;           % 4s battery pack
params.li_po.ESR_base           = 0.015;       % 15 mOhm per cell (for a new battery)
params.li_po.soc                = 0.75;        % Current State-of-Charge (75%)
params.li_po.load_current       = 2.0;         % Assumed static load current (Amps)
params.li_po.f_bms              = 30000;       % 30 kHz BMS switching frequency
params.li_po.A_bms              = 0.025;       % 25mV BMS noise amplitude
params.li_po.P_bms_event        = 1e-5;        % Probability of a BMS noise burst per sample

% --- 3. Wall-Wart Parameters ---
params.wall_wart = struct();
params.wall_wart.base_voltage   = 12.0;        % Nominal 12V output
params.wall_wart.load_current   = 0.5;         % Assumed static load current (Amps)

% Sub-model A: Unregulated Linear Supply
params.wall_wart.linear = struct();
params.wall_wart.linear.V_no_load_factor = 1.4; % No-load voltage is 140% of nominal
params.wall_wart.linear.R_out            = 2.5;  % 2.5 Ohm output resistance
params.wall_wart.linear.f_ripple         = 120;  % 120 Hz for 60Hz mains
params.wall_wart.linear.V_ripple_pp      = 4.0;  % 4V p-p ripple (33% of nominal)

% Sub-model B: Low-Cost SMPS
params.wall_wart.smps = struct();
params.wall_wart.smps.f_sw_unstable    = 25000;  % 25 kHz unstable switching freq
params.wall_wart.smps.f_jitter         = 10;     % 10% frequency jitter
params.wall_wart.smps.V_ripple_smps_pp = 1.0;    % 1V p-p switching ripple
params.wall_wart.smps.f_whine_loud     = 4000;   % 4 kHz loud coil whine
params.wall_wart.smps.A_whine_loud     = 0.2;    % 200mV coil whine amplitude

disp('Parameters loaded successfully.');