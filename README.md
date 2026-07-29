<div align="center">

# Telescope Optical Designer (MATLAB)

**Design a refracting telescope from its lenses — get the magnification, the
tube length, the ray-transfer matrix, and a ray diagram.**

A general MATLAB tool for two-lens refracting telescopes (Galilean and
Keplerian). Give it focal lengths — or lens radii and a refractive index — and
it returns the angular magnification, the afocal lens spacing, the ABCD system
matrix, and a paraxial ray diagram.

![Language](https://img.shields.io/badge/language-MATLAB%20%2F%20Octave-orange)
![Domain](https://img.shields.io/badge/domain-Optics-1f6feb)
![Type](https://img.shields.io/badge/type-simulation-8957e5)
![License](https://img.shields.io/badge/license-MIT-green)

</div>

---

## Overview

**EN —** This tool models a refracting telescope as two thin lenses and works
out everything that matters: the **angular magnification** `M = -f_obj/f_eye`,
the **afocal spacing** `d = f_obj + f_eye`, and the **ABCD ray-transfer
matrix** of the whole system. It supports both **Galilean** telescopes
(diverging eyepiece, upright image) and **Keplerian** telescopes (converging
eyepiece, inverted image), and it can start from either focal lengths or from
lens radii via the lensmaker's equation. It draws a paraxial ray diagram that
shows the afocal property (parallel rays in, parallel rays out).

**AR —** الأداة بتمثّل التلسكوب الكاسر بعدستين رفيعتين وبتحسب كل المهم: **التكبير
الزاوي** `M = -f_obj/f_eye`، و**المسافة الأفوكال** بين العدستين
`d = f_obj + f_eye`، و**مصفوفة نقل الشعاع (ABCD)** للنظام كله. بتدعم النوع
**الجاليلي** (عينية مقعّرة، صورة معتدلة) والنوع **الكبلري** (عينية محدّبة، صورة
مقلوبة)، وتقدر تبدأ من الأبعاد البؤرية مباشرةً أو من أنصاف أقطار العدسات عبر
معادلة صانع العدسات. وبترسم مخطط أشعة يوضّح خاصية الأفوكال (أشعة متوازية تدخل،
أشعة متوازية تخرج).

---

## ✨ What it computes

| Output | Meaning |
|--------|---------|
| `magnification` | Angular magnification `M = -f_obj/f_eye` (sign = orientation). |
| `separation` | Afocal lens spacing `d = f_obj + f_eye`. |
| `ABCD` | 2×2 system ray-transfer matrix (`L_eye · Gap(d) · L_obj`). |
| `afocal_residual` | The `C` element — should be ~0, confirming an afocal system. |
| `upright` | True for Galilean (upright), false for Keplerian (inverted). |

---

## 🧠 Corrected Physics (what was wrong before, and why)

This is a from-scratch rebuild of an earlier version that was **physically
incorrect**. The corrections:

1. **Lensmaker division-by-zero.** The old code set both radii equal
   (`R1 = R2`), which makes `1/R1 - 1/R2 = 0` and the focal length **infinite**
   — every downstream number was invalid. A real lens needs surfaces of
   different curvature; `lens_focal_length()` now enforces this and uses the
   proper Cartesian sign convention.
2. **Galilean eyepiece must diverge.** A Galilean telescope needs a **negative**
   (diverging) eyepiece; the old code used two identical converging lenses. The
   spacing is `d = f_obj + f_eye`, which for a negative eyepiece is *shorter*
   than the objective focal length.
3. **Magnification was never computed.** The single most important output of a
   telescope — its angular magnification — was missing entirely. It is now
   `M = -f_obj/f_eye`, and it equals the `D` element of the afocal system matrix.
4. **Correct ABCD matrix.** The system matrix is built from the lens **spacing**,
   not each lens's own thickness, and the tool reports the `C` element so you can
   confirm the design is genuinely afocal.

---

## 🚀 Quick Start

```matlab
% Design one telescope
cfg = struct('type','galilean','f_obj',900,'f_eye',-100);
res = telescope_design(cfg);
disp(res.magnification)     % 9.00x, upright
draw_telescope(cfg, res);   % ray diagram

% Or run the full set of worked examples + comparison table
run_examples
```

Works in **MATLAB** and largely in **GNU Octave** (free).

---

## 📁 Project Structure

```
telescope-optical-designer/
├── README.md
└── matlab/
    ├── lens_focal_length.m   % lensmaker's equation (with sign checks)
    ├── telescope_design.m    % core design: M, spacing, ABCD
    ├── draw_telescope.m      % paraxial ray diagram (reusable in a GUI)
    └── run_examples.m        % batch of Galilean + Keplerian cases
```

The design and drawing functions are deliberately separated from the batch
script so the **same two functions can back a GUI**: a form collects `type`,
`f_obj`/`f_eye` (or radii + n), calls `telescope_design()`, and renders the
result with `draw_telescope(cfg, res, ax)` into a GUI axes.

---

## ⚠️ Honest Limitations

- **Paraxial, thin-lens model.** It ignores lens thickness, aberrations
  (spherical, chromatic), field of view, and finite aperture. It is a design
  and teaching tool, not full optical-design software.
- **Two-lens systems only** (objective + eyepiece).
- **No stray-light, coatings, or real glass dispersion** — refractive index is a
  single value per lens.

---

## 🗺 Roadmap

- **Phase 1 (done):** correct paraxial design (Galilean + Keplerian), ABCD
  matrix, ray diagram, batch examples.
- **Phase 2:** interactive GUI — enter parameters, get the design and drawing
  live (the code is already structured for this).
- **Phase 3:** add field of view, exit-pupil, and eye-relief calculations.
- **Phase 4:** basic chromatic-aberration estimate from an Abbe number.

---

## 👤 Author

**Ahmed Darwish** — engineering, Python, embedded systems, and AI.

## 📄 License

MIT.

<div align="center">

⭐ **If this tool is useful, consider starring the repository on GitHub.**

</div>
