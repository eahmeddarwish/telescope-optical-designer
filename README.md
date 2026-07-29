<div align="center">

# 🔭 Telescope Optical Designer

### Design a Refracting Telescope from Its Lenses — Magnification, Tube Length, ABCD Matrix & Ray Diagram

![MATLAB](https://img.shields.io/badge/MATLAB-%2F%20Octave-orange?logo=mathworks&logoColor=white)
![Domain](https://img.shields.io/badge/Domain-Optics-1f6feb)
![Type](https://img.shields.io/badge/Type-Simulation-8957e5)
[![License: MIT](https://img.shields.io/badge/License-MIT-00C896.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-eahmeddarwish-181717?logo=github)](https://github.com/eahmeddarwish/telescope-optical-designer)
![Status](https://img.shields.io/badge/status-corrected%20%26%20verified-brightgreen)

**Built by [Ahmed Darwish](mailto:eahmeddarwish@gmail.com)**

[📖 Documentation](#-corrected-physics--الفيزياء-المصحّحة) · [⚠️ Honest Limitations](#-honest-limitations--محدوديات-صادقة) · [⭐ Star on GitHub](https://github.com/eahmeddarwish/telescope-optical-designer)

</div>

![Telescope ray diagram](docs/hero.png)

---

## 🌍 Overview | نظرة عامة

**[English]**
A general MATLAB / Octave tool for two-lens refracting telescopes. Give it focal
lengths — or lens radii and a refractive index — and it returns the **angular
magnification** `M = -f_obj/f_eye`, the **afocal spacing** `d = f_obj + f_eye`,
the **ABCD ray-transfer matrix** of the whole system, and a paraxial **ray
diagram**. It handles both **Galilean** telescopes (diverging eyepiece, upright
image) and **Keplerian** telescopes (converging eyepiece, inverted image).

This is a from-scratch rebuild of an earlier version that was *physically
incorrect*. The corrections are documented below —
[Corrected physics](#-corrected-physics--الفيزياء-المصحّحة).

**[العربية]**
أداةٌ عامة بـ MATLAB / Octave للتلسكوبات الكاسرة بعدستين. أعطِها الأبعاد البؤرية
— أو أنصاف أقطار العدسات ومعامل الانكسار — فتُرجع **التكبير الزاوي**
`M = -f_obj/f_eye`، و**المسافة الأفوكال** `d = f_obj + f_eye`، و**مصفوفة نقل
الشعاع (ABCD)** للنظام كله، و**مخطط أشعة** بارَاكسي. تدعم النوع **الجاليلي**
(عينية مقعّرة، صورة معتدلة) والنوع **الكبلري** (عينية محدّبة، صورة مقلوبة).

هذه إعادة بناءٍ كاملة لنسخةٍ سابقة كانت *غير صحيحةٍ فيزيائيًا*. التصحيحات موثّقةٌ
أدناه — [الفيزياء المصحّحة](#-corrected-physics--الفيزياء-المصحّحة).

---

## ✨ What it computes | ماذا يحسب

| Output | Meaning |
|---|---|
| 🔎 `magnification` | Angular magnification `M = -f_obj/f_eye` (sign = orientation) |
| 📏 `separation` | Afocal lens spacing `d = f_obj + f_eye` |
| 🧮 `ABCD` | 2×2 system ray-transfer matrix (`L_eye · Gap(d) · L_obj`) |
| ✅ `afocal_residual` | The `C` element — should be ~0, confirming an afocal system |
| 🔄 `upright` | True for Galilean (upright), false for Keplerian (inverted) |

---

## 🔬 Corrected physics | الفيزياء المصحّحة

**[English]**
This rebuild fixes four real errors from the earlier version:

1. **Lensmaker division-by-zero.** The old code set both radii equal
   (`R1 = R2`), making `1/R1 - 1/R2 = 0` and the focal length **infinite** —
   every downstream number was invalid. `lens_focal_length()` now enforces
   different curvatures and uses the proper Cartesian sign convention.
2. **Galilean eyepiece must diverge.** A Galilean telescope needs a **negative**
   (diverging) eyepiece; the old code used two identical converging lenses. The
   spacing `d = f_obj + f_eye` is then *shorter* than the objective focal length.
3. **Magnification was never computed.** The single most important output was
   missing. It is now `M = -f_obj/f_eye`, and it equals the `D` element of the
   afocal system matrix.
4. **Correct ABCD matrix.** The system matrix is built from the lens **spacing**,
   not each lens's own thickness, and the `C` element is reported so you can
   confirm the design is genuinely afocal.

> Verified numerically: for `f_obj = 900, f_eye = -100`, the tool gives
> `M = +9.00×` (upright), `d = 800`, and `C ≈ 0` — a true afocal telescope.

**[العربية]**
إعادة البناء تصلح أربعة أخطاءٍ حقيقيةٍ من النسخة السابقة:

1. **قسمةٌ على صفر في معادلة العدسة.** الكود القديم جعل نصفَي القطر متساويين
   (`R1 = R2`)، فصار `1/R1 - 1/R2 = 0` والبعد البؤري **لا نهائيًّا** — وكل رقمٍ
   بعده باطل. `lens_focal_length()` الآن يفرض اختلاف الانحناءَين ويستخدم اصطلاح
   الإشارة الكارتيزي الصحيح.
2. **عينية الجاليلي يجب أن تكون مفرّقة.** التلسكوب الجاليلي يحتاج عينيةً **سالبة**
   (مقعّرة)؛ الكود القديم استخدم عدستين محدّبتين متطابقتين. عندها تكون المسافة
   `d = f_obj + f_eye` *أقصر* من البعد البؤري للعدسة الشيئية.
3. **التكبير لم يُحسب أبدًا.** أهم ناتجٍ كان مفقودًا. صار الآن `M = -f_obj/f_eye`،
   وهو يساوي عنصر `D` في مصفوفة النظام الأفوكال.
4. **مصفوفة ABCD صحيحة.** مصفوفة النظام مبنيةٌ على **المسافة** بين العدستين لا على
   سُمك كل عدسة، وعنصر `C` معروضٌ لتأكيد أن التصميم أفوكال فعلًا.

> تحقّق عددي: عند `f_obj = 900, f_eye = -100` تعطي الأداة `M = +9.00×` (معتدلة)،
> `d = 800`، و`C ≈ 0` — تلسكوب أفوكال حقيقي.

---

## 🚀 Quick Start | البدء السريع

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

## ⚙️ Configuration | الإعدادات

A telescope is described by a `cfg` struct:

| Field | Notes |
|---|---|
| `type` | `'galilean'` or `'keplerian'` |
| `f_obj` / `f_eye` | Focal lengths (mm); `f_eye < 0` Galilean, `> 0` Keplerian |
| `obj` / `eye` | *(alternative)* `struct('R1',..,'R2',..,'n',..)` to derive focal lengths |

---

## 📁 Project Structure | هيكل المشروع

```
.
├── matlab/
│   ├── lens_focal_length.m   # lensmaker's equation (with sign checks)
│   ├── telescope_design.m    # core design: M, spacing, ABCD
│   ├── draw_telescope.m      # paraxial ray diagram (reusable in a GUI)
│   └── run_examples.m        # batch of Galilean + Keplerian cases
├── docs/
│   └── hero.png
└── LICENSE
```

The design and drawing functions are separated from the batch script so the
**same two functions can back a GUI**: a form collects `type`, `f_obj`/`f_eye`
(or radii + n), calls `telescope_design()`, and renders with
`draw_telescope(cfg, res, ax)` into a GUI axes.

---

## ⚠️ Honest limitations | محدوديات صادقة

**[English]**
- **Paraxial, thin-lens model.** Ignores lens thickness, aberrations (spherical,
  chromatic), field of view, and finite aperture. A design/teaching tool, not
  full optical-design software.
- **Two-lens systems only** (objective + eyepiece).
- **Single refractive index per lens** — no real glass dispersion or coatings.

**[العربية]**
- **نموذجٌ بارَاكسي رفيع العدسة.** يتجاهل سُمك العدسة والزيوغ (الكروي واللوني)
  ومجال الرؤية والفتحة المحدودة. أداة تصميم/تعليم، لا برنامج تصميمٍ ضوئيٍّ كامل.
- **أنظمة عدستين فقط** (شيئية + عينية).
- **معامل انكسارٍ واحدٍ لكل عدسة** — بلا تشتّتٍ زجاجيٍّ حقيقيٍّ أو طلاءات.

---

## 🗺️ Roadmap | خطط التطوير

- [x] **Phase 1** — Correct paraxial design (Galilean + Keplerian), ABCD matrix, ray diagram, batch examples *(current)*
- [ ] **Phase 2** — Interactive GUI: enter parameters, get design + drawing live
- [ ] **Phase 3** — Field of view, exit-pupil, and eye-relief calculations
- [ ] **Phase 4** — Chromatic-aberration estimate from an Abbe number

---

## 👤 Author | المطور

<div align="center">

**Ahmed Darwish**

*Electrical & Computer Engineer | Python · Arduino · Raspberry Pi · AI/ML*

[![Email](https://img.shields.io/badge/Email-eahmeddarwish%40gmail.com-EA4335?logo=gmail&logoColor=white)](mailto:eahmeddarwish@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-eahmeddarwish-181717?logo=github)](https://github.com/eahmeddarwish)

</div>

---

## 📄 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.

```
MIT License — Copyright (c) 2026 Ahmed Darwish
Free to use, modify, and distribute with attribution.
```

---

<div align="center">

⭐ **If this tool is useful, please give it a star on GitHub!** ⭐

*Made with ❤️ by Ahmed Darwish*

</div>
