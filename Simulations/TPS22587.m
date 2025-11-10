% FILENAME: tps55287_setup_calculations_final.m
%
% DESCRIPTION:
% This script calculates the primary external component values for setting up
% the Texas Instruments TPS55287. It uses the correct interpretation of the
% FSW formula where resistance is in Ohms (Ω) and the resulting frequency
% is in Megahertz (MHz).
%
% Last Updated: October 15, 2025

%% --- Clear Workspace and Command Window ---
clc;
clear;
close all;

%% ========================================================================
%  1. SWITCHING FREQUENCY RESISTOR (R_FSW) - FINAL CORRECTED
%  ========================================================================
%  This section uses the correct unit interpretation for Equation 3.
%  - R_FSW must be in Ohms (Ω)
%  - The result of the formula is in Megahertz (MHz)

% -- To find R_FSW from a desired frequency --
% -- User Input --
f_sw_desired_MHz = 0.811; % [MHz] Enter desired frequency (e.g., 0.4 for 400 kHz)

% -- Calculation --
% Rearranged formula: R_FSW (Ω) = ( (1000 / f_sw_MHz) - 35) / 0.05
R_FSW_Ohm = ((1000 / f_sw_desired_MHz) - 35) / 0.05;

% -- Display Result --
fprintf('--- 1. Switching Frequency Resistor (R_FSW) - FINAL ---\n');
fprintf('For a target frequency of %.2f MHz (%d kHz), the required resistor is %.0f Ohms (%.2f kOhm).\n\n', ...
        f_sw_desired_MHz, f_sw_desired_MHz*1000, R_FSW_Ohm, R_FSW_Ohm/1000);


%% ========================================================================
%  2. DITHERING CAPACITOR (C_DITH)
%  ========================================================================
%  This calculation is correct but uses the properly calculated R_FSW in Ohms.

% -- User Inputs --
F_MOD_desired_Hz = 980 % [Hz] Desired modulation frequency (typically below 1 kHz)

% -- Calculation --
C_DITH_Farads = 1 / (2.8 * R_FSW_Ohm * F_MOD_desired_Hz);

% -- Display Result --
fprintf('--- 2. Dither Capacitor (C_DITH) ---\n');
fprintf('Using R_FSW = %.1f kOhm and targeting F_MOD = %d Hz...\n', R_FSW_Ohm/1000, F_MOD_desired_Hz);
fprintf('The required dithering capacitor is %.3f nF.\n\n', C_DITH_Farads * 1e9);


%% ========================================================================
%  3. PROGRAMMABLE INPUT UVLO RESISTORS
%  ========================================================================
%  This calculation is independent of the R_FSW error and remains unchanged.

% -- Datasheet Constants --
V_UVLO_threshold = 1.23; % [V] Internal reference at the EN/UVLO pin
I_UVLO_HYS_Amps = 5e-6;  % [A] Internal hysteresis current

% -- User Inputs --
V_IN_UVLO_ON_desired = 4.182; % [V] Desired input voltage for the converter to turn ON
R2_kOhm = 10; % [kOhm] Choose a standard value for the bottom resistor

% -- Calculation --
R1_kOhm = R2_kOhm * (V_IN_UVLO_ON_desired / V_UVLO_threshold - 1);
V_hysteresis_Volts = I_UVLO_HYS_Amps * (R1_kOhm * 1000);
V_IN_UVLO_OFF = V_IN_UVLO_ON_desired - V_hysteresis_Volts;

% -- Display Results --
fprintf('--- 3. Programmable UVLO Settings ---\n');
fprintf('Desired Turn-ON Voltage: %.2f V\n', V_IN_UVLO_ON_desired);
fprintf('With R2 = %.1f kOhm, the required R1 is %.2f kOhm.\n', R2_kOhm, R1_kOhm);
fprintf('This results in a voltage hysteresis of %.2f V.\n', V_hysteresis_Volts);