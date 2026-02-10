// colpal.asy - color palette

// (c) 2025-2026 aelata
// This script is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

import colspc;

// f_ut - a mixture of uniform and isosceles triangular distributions
//   f_ut = (1 - a) * f_u + a * f_t   (a in [-1, 1])

/*
// _pdf_ut - Probability density function
private real _pdf_ut(real x, real a=0) { // [0, 1] -> [0, 1]
  if (x < 0) return 0;
  if (1 < x) return 0;
  if (a == 0) return 1;
  return (x <= 0.5) ? (1 - a) + a * 4 * x : (1 - a) + a * 4 * (1 - x);
}

// _cdf_ut - Cumulative distribution function
private real _cdf_ut(real x, real a=0) {
  if (x < 0) return 0;
  if (1 < x) return 1;
  if (a == 0) return x;
  return (x <= 0.5) ?
    (1 - a) * x + a * 2 * x * x : (1 - a) * x + a * (1 - 2 * (1 - x)**2);
}
*/

// _icdf_ut - Inverse cumulative distribution function
private real _icdf_ut(real x, real a=0) {
  if (x < 0) return 0;
  if (1 < x) return 1;
  if (a == 0) return x;
  return (x <= 0.5) ?
    (-(1 - a) + sqrt((1 - a)**2 + 8a * x)) / (4a) :
    ((1 + 3a) - sqrt((1 + 3a)**2 - 8a * (x + a))) / (4a);
}

private pen _palcyl(
  pen pal(real, real, real), real l, real t, real a, real b, real c,
  real n, real alpha)
{
  l = min(max(0, l), 1);
  if (alpha != 0)
    l = _icdf_ut(l, alpha);
  real S, L = 2 * b * l + (c - b);
  if (n == 2) {
    l = 2 * l - 1; // [0, 1] to [-1, 1]
    S = a * sqrt(max(0, 1 - l * l));
  } else {
    S = a * max(0, 1 - abs((L - c) / b)**n)**(1/n); // n from super ellipse
  }
  return pal(t, S, L);
}

private pen _palsph(
  pen pal(real, real, real), real l, real t, real a, real b, real c,
  real n, real alpha)
{
  l = min(max(0, l), 1);
  if (alpha != 0)
    l = _icdf_ut(l, alpha);
  real r, L = 2 * b * l + (c - b);
  if (n == 2) {
    l = 2 * l - 1; // [0, 1] to [-1, 1]
    r = a * sqrt(max(0, 1 - l * l));
  } else {
    r = a * max(0, 1 - abs((L - c) / b)**n)**(1/n); // n from super ellipse
  }
  return pal(L, r * Cos(t), r * Sin(t));
}

pen palHSL(
  real l, real t, real a=1, real b=0.5, real c=0.5, real n=2, real alpha=0)
{
  return _palcyl(HSL.RGB, l, t, a, b, c, n, alpha);
}

pen palHSI(
  real l, real t, real a=1, real b=0.5, real c=0.5, real n=2, real alpha=0)
{
  return _palcyl(HSI.RGB, l, t, a, b, c, n, alpha);
}

pen palHSY(
  real l, real t, real a=1, real b=0.5, real c=0.5, real n=2, real alpha=0)
{
  return _palcyl(HSY.RGB, l, t, a, b, c, n, alpha);
}

pen palLab(
  real l, real t, real a=1, real b=0.5, real c=0.5, real n=2, real alpha=0)
{
  static real A = 33.2, B = 28.5, C = 63.2; // by trial and error
  return _palsph(Lab.RGB, l, t, A * a, B * b * 2, C * c * 2, n, alpha);
}

pen palLuv(
  real l, real t, real a=1, real b=0.5, real c=0.5, real n=2, real alpha=0)
{
  static real A = 37.8, B = 36.0, C = 59.9; // by trial and error
  return _palsph(Luv.RGB, l, t, A * a, B * b * 2, C * c * 2, n, alpha);
}

pen palOKLab(
  real l, real t, real a=1, real b=0.5, real c=0.5, real n=2, real alpha=0)
{
  static real A = 0.106, B = 0.248, C = 0.671; // by trial and error
  return _palsph(OKLab.RGB, l, t, A * a, B * b * 2, C * c * 2, n, alpha);
}

pen[][] colpal(
  explicit pair l=(0, 1), explicit pair t=(0, 2), int nl=200, int nt=180,
  pen pal(real, real), bool reverse=false)
{
  if (reverse)
    l = (l.y, l.x);
  t *= 180;
  pen[][] cpal = new pen[nt][nl];
  for (int j: sequence(nt)) {
    real tj = interp(t.x, t.y, (j + 0.5) / nt);
    for (int i: sequence(nl)) {
      real li = interp(l.x, l.y, (i + 0.5) / nl);
      cpal[j][i] = pal(li, tj);
    }
  }
  return cpal;
}

pen[] colpal1(
  explicit pair l=(0, 1), explicit pair t=(0, 2), int nl=40, int nt=120,
  pen pal(real, real))
{
  t *= 180;
  pen[] cpal = new pen[nt * nl];
  for (int j: sequence(nt)) {
    real tj = interp(t.x, t.y, (j + 0.5) / nt);
    for (int i: sequence(nl)) {
      real li = interp(l.x, l.y, (i + 0.5) / nl);
      cpal[i * nt + j] = pal(li, tj);
    }
  }
  return cpal;
}

pen[] colpal1(
  real[] l, explicit pair t=(0, 2), int nt=120, pen pal(real, real))
{
  t *= 180;
  pen[] cpal = new pen[nt * l.length];
  for (int j: sequence(nt)) {
    real tj = interp(t.x, t.y, (j + 0.5) / nt);
    for (int i: sequence(l.length))
      cpal[i * nt + j] = pal(l[i], tj);
  }
  return cpal;
}
