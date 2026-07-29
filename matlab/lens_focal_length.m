function f = lens_focal_length(R1, R2, n)
%LENS_FOCAL_LENGTH  Thin-lens focal length from the lensmaker's equation.
%
%   f = LENS_FOCAL_LENGTH(R1, R2, n)
%
%   1/f = (n - 1) * (1/R1 - 1/R2)
%
%   Sign convention (Cartesian): a radius is POSITIVE when its center of
%   curvature lies on the outgoing-light (right) side of the surface.
%     Biconvex  (converging):  R1 > 0, R2 < 0  ->  f > 0
%     Biconcave (diverging) :  R1 < 0, R2 > 0  ->  f < 0
%
%   This function deliberately rejects R1 == R2, which is physically a lens
%   of zero optical power (infinite focal length) and was the bug in an
%   earlier version of this project.

    if R1 == R2
        error('lens_focal_length:degenerate', ...
              ['R1 == R2 gives zero optical power (infinite focal length). ', ...
               'A real lens needs surfaces with different curvature; for a ', ...
               'converging lens use R1 > 0 and R2 < 0.']);
    end
    if n <= 1
        error('lens_focal_length:refractiveIndex', ...
              'Refractive index n must be greater than 1.');
    end

    f = 1 / ((n - 1) * (1/R1 - 1/R2));
end
