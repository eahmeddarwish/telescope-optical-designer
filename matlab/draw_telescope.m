function draw_telescope(cfg, res, ax)
%DRAW_TELESCOPE  Paraxial ray diagram of a two-lens telescope.
%
%   draw_telescope(cfg, res)        % new figure
%   draw_telescope(cfg, res, ax)    % draw into an existing axes (e.g. a GUI)
%
%   Traces parallel input rays through the objective and eyepiece using the
%   exact thin-lens ray-transfer relations, which visually demonstrates the
%   afocal property (parallel in -> parallel out) and the beam compression
%   that accompanies angular magnification.

    if nargin < 3 || isempty(ax)
        figure('Color', 'w');
        ax = axes();
    end
    hold(ax, 'on');

    fo = res.f_obj;
    fe = res.f_eye;
    d  = res.separation;

    xObj = 0;          % objective at x = 0
    xEye = d;          % eyepiece at x = d
    span = max(abs([fo, fe])) * 0.8;     % how far to draw input/output rays
    h    = max(abs([fo, fe])) * 0.18;    % input ray height

    % ---- optical axis ----------------------------------------------------
    plot(ax, [xObj - span, xEye + span], [0 0], 'k--', 'LineWidth', 0.8);

    % ---- lens glyphs -----------------------------------------------------
    draw_lens(ax, xObj, h*1.6, fo > 0, 'Objective');
    draw_lens(ax, xEye, h*1.2, fe > 0, 'Eyepiece');

    % ---- trace two parallel input rays (angle = 0) -----------------------
    for y0 = [h, -h]
        % segment 1: parallel ray up to the objective
        plot(ax, [xObj - span, xObj], [y0, y0], 'b', 'LineWidth', 1.2);

        % refraction at objective:  theta' = theta - y/f
        th1 = 0 - y0 / fo;
        yE  = y0 + th1 * d;                 % height reached at the eyepiece

        % segment 2: objective -> eyepiece
        plot(ax, [xObj, xEye], [y0, yE], 'b', 'LineWidth', 1.2);

        % refraction at eyepiece
        th2 = th1 - yE / fe;
        yOut = yE + th2 * span;

        % segment 3: output ray
        plot(ax, [xEye, xEye + span], [yE, yOut], 'b', 'LineWidth', 1.2);
    end

    % ---- annotations -----------------------------------------------------
    axis(ax, 'equal');
    grid(ax, 'on');
    xlabel(ax, 'Optical axis (mm)');
    ylabel(ax, 'Height (mm)');
    orient_str = 'inverted';
    if res.upright, orient_str = 'upright'; end
    title(ax, sprintf('%s telescope  |  M = %.2fx (%s)  |  d = %.1f mm', ...
          upper_first(cfg.type), res.magnification, orient_str, d));
    hold(ax, 'off');
end

% ------------------------------------------------------------------ helpers
function draw_lens(ax, x, halfHeight, converging, label)
    % Vertical lens body
    plot(ax, [x x], [-halfHeight halfHeight], 'k', 'LineWidth', 2);
    a = halfHeight * 0.28;
    if converging
        % outward arrowheads (>-< becomes convex cue)
        plot(ax, [x-a x x+a], [halfHeight-a halfHeight halfHeight-a], 'k', 'LineWidth', 2);
        plot(ax, [x-a x x+a], [-halfHeight+a -halfHeight -halfHeight+a], 'k', 'LineWidth', 2);
    else
        % inward arrowheads (concave cue)
        plot(ax, [x-a x x+a], [halfHeight halfHeight-a halfHeight], 'k', 'LineWidth', 2);
        plot(ax, [x-a x x+a], [-halfHeight -halfHeight+a -halfHeight], 'k', 'LineWidth', 2);
    end
    text(ax, x, halfHeight*1.15, label, 'HorizontalAlignment', 'center', ...
         'FontWeight', 'bold');
end

function s = upper_first(s)
    if ~isempty(s), s(1) = upper(s(1)); end
end
