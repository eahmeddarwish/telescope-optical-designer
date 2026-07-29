%RUN_EXAMPLES  Design several telescopes, print a comparison, and draw each.
%
%   This script is the "batch" entry point. A future GUI would collect the
%   same cfg fields from the user and call telescope_design() + draw_telescope()
%   exactly as done here.
%
%   Run:  >> run_examples

clear; clc; close all;

% ---- define a set of cases (general — no fixed "group" parameters) -------
cases = {};

% 1) Galilean (opera glass): upright image, short tube
cases{end+1} = struct('name', 'Galilean opera glass', ...
                      'type', 'galilean', 'f_obj', 300, 'f_eye', -50);

% 2) Galilean spyglass: higher power
cases{end+1} = struct('name', 'Galilean spyglass', ...
                      'type', 'galilean', 'f_obj', 900, 'f_eye', -100);

% 3) Keplerian astronomical: inverted image, high power
cases{end+1} = struct('name', 'Keplerian astronomical', ...
                      'type', 'keplerian', 'f_obj', 1000, 'f_eye', 50);

% 4) Same as (2) but defined from lens radii + refractive index
cases{end+1} = struct('name', 'Galilean from radii', 'type', 'galilean', ...
        'obj', struct('R1', 500, 'R2', -500, 'n', 1.5), ...   % f_obj = +500
        'eye', struct('R1', -100, 'R2',  100, 'n', 1.5));      % f_eye = -100

% ---- compute + tabulate --------------------------------------------------
fprintf('%-26s %8s %8s %8s %10s %9s\n', ...
        'Case', 'f_obj', 'f_eye', 'd(mm)', 'Mag', 'Image');
fprintf('%s\n', repmat('-', 1, 74));

for i = 1:numel(cases)
    cfg = cases{i};
    res = telescope_design(cfg);

    orient = 'inverted';
    if res.upright, orient = 'upright'; end

    fprintf('%-26s %8.1f %8.1f %8.1f %9.2fx %9s\n', ...
            cfg.name, res.f_obj, res.f_eye, res.separation, ...
            res.magnification, orient);

    % sanity checks printed only if something is off
    if ~res.type_ok
        fprintf('   [warn] eyepiece sign does not match declared type "%s"\n', cfg.type);
    end
    if abs(res.afocal_residual) > 1e-9
        fprintf('   [warn] afocal residual (C) = %.3g (expected ~0)\n', res.afocal_residual);
    end

    draw_telescope(cfg, res);
end

fprintf('\nEach figure shows parallel rays entering and leaving parallel\n');
fprintf('(the afocal property), with the beam narrowed by the magnification.\n');
