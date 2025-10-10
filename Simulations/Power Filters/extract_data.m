% Get the sample time of your discrete system
Ts = linsys1.Ts;

% Time vector with exactly 2000 samples over 2 seconds
num_samples = 2000;
t = linspace(0, 2, num_samples);

% Frequency vector for Bode and Nyquist (0 to 50 MHz)
f_max = 50e6;  % 50 MHz
w_max = 2*pi*f_max;  % rad/s
w = logspace(0, log10(w_max), 1000);

% Bode plot data
[mag, phase] = bode(linsys1, w);
mag = squeeze(mag);
phase = squeeze(phase);
f_bode = w / (2*pi);  % Convert to Hz
bode_data = [f_bode(:), mag(:), phase(:)];
T_bode = array2table(bode_data, 'VariableNames', {'Frequency_Hz', 'Magnitude', 'Phase_deg'});
writetable(T_bode, 'linsys1_bode.csv');

% Step response - compute at all time points, then downsample
t_full = 0:Ts:2;
y_step_full = step(linsys1, t_full);
% Downsample to 2000 points
idx = round(linspace(1, length(t_full), num_samples));
step_data = [t_full(idx)', y_step_full(idx)];
T_step = array2table(step_data, 'VariableNames', {'Time_s', 'Output'});
writetable(T_step, 'linsys1_step.csv');

% Impulse response - compute at all time points, then downsample
y_impulse_full = impulse(linsys1, t_full);
impulse_data = [t_full(idx)', y_impulse_full(idx)];
T_impulse = array2table(impulse_data, 'VariableNames', {'Time_s', 'Output'});
writetable(T_impulse, 'linsys1_impulse.csv');

% Nyquist plot data
[re, im, w_nyq] = nyquist(linsys1, w);
re = squeeze(re);
im = squeeze(im);
f_nyq = w_nyq / (2*pi);
nyquist_data = [f_nyq(:), re(:), im(:)];
T_nyquist = array2table(nyquist_data, 'VariableNames', {'Frequency_Hz', 'Real', 'Imaginary'});
writetable(T_nyquist, 'linsys1_nyquist.csv');