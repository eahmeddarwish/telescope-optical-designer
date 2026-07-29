function res = telescope_design(cfg)
%TELESCOPE_DESIGN  Paraxial design of a two-lens refracting telescope.
%
%   res = TELESCOPE_DESIGN(cfg)
%
%   cfg is a struct describing the telescope. Provide the focal lengths
%   directly, OR provide radii + refractive index and let this function
%   compute them via lens_focal_length().
%
%   Required:
%     cfg.type   : 'galilean' or 'keplerian'
%   Provide EITHER focal lengths:
%     cfg.f_obj  : objective focal length  (mm, > 0)
%     cfg.f_eye  : eyepiece  focal length  (mm; < 0 Galilean, > 0 Keplerian)
%   OR radii + index:
%     cfg.obj = struct('R1',..,'R2',..,'n',..)
%     cfg.eye = struct('R1',..,'R2',..,'n',..)
%
%   Returned res fields:
%     f_obj, f_eye      focal lengths actually used (mm)
%     separation        lens spacing for the afocal condition, d = f_obj + f_eye
%     magnification     angular magnification, M = -f_obj / f_eye
%     mag_abs           |M|
%     upright           true if the image is upright (Galilean)
%     ABCD              2x2 system ray-transfer matrix (eyepiece*gap*objective)
%     afocal_residual   the C element of ABCD; ~0 confirms an afocal telescope
%     type_ok           true if the eyepiece sign matches the declared type
%
%   Theory notes:
%     - Afocal spacing:  d = f_obj + f_eye  (so total power = 0, C = 0).
%     - Angular magnification equals the D element of the afocal matrix,
%       M = -f_obj/f_eye. Galilean (f_eye<0) -> M>0 upright; Keplerian
%       (f_eye>0) -> M<0 inverted.

    % ---- resolve focal lengths -------------------------------------------
    if isfield(cfg, 'f_obj') && isfield(cfg, 'f_eye')
        fo = cfg.f_obj;
        fe = cfg.f_eye;
    elseif isfield(cfg, 'obj') && isfield(cfg, 'eye')
        fo = lens_focal_length(cfg.obj.R1, cfg.obj.R2, cfg.obj.n);
        fe = lens_focal_length(cfg.eye.R1, cfg.eye.R2, cfg.eye.n);
    else
        error('telescope_design:input', ...
              'Provide either (f_obj,f_eye) or (obj,eye) radii structs.');
    end

    if fo <= 0
        error('telescope_design:objective', ...
              'The objective must be converging (f_obj > 0).');
    end

    % ---- core results ----------------------------------------------------
    res.f_obj        = fo;
    res.f_eye        = fe;
    res.separation   = fo + fe;          % afocal condition
    res.magnification = -fo / fe;        % angular magnification
    res.mag_abs      = abs(res.magnification);
    res.upright      = res.magnification > 0;

    % ---- ABCD system matrix:  L_eye * Gap(d) * L_obj ---------------------
    d    = res.separation;
    Lobj = [1, 0; -1/fo, 1];
    Gap  = [1, d;    0,  1];
    Leye = [1, 0; -1/fe, 1];
    M    = Leye * Gap * Lobj;

    res.ABCD            = M;
    res.afocal_residual = M(2,1);        % C element (should be ~0)

    % ---- declared-type sanity check --------------------------------------
    if strcmpi(cfg.type, 'galilean')
        res.type_ok = fe < 0;
    elseif strcmpi(cfg.type, 'keplerian')
        res.type_ok = fe > 0;
    else
        error('telescope_design:type', ...
              "cfg.type must be 'galilean' or 'keplerian'.");
    end
end
