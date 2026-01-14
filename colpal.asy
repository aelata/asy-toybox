// colpal.asy - color palette

// (c) 2025 aelata
// This software is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

import colspc;

private pen _palcyl2(
  pen pal(real, real, real), real l, real t, real a, real b, real c)
{
  l = min(max(l, 0), 1);
  real L = 2 * b * l + (c - b);
  l = 2 * l - 1; // [0, 1] to [-1, 1]
  real S = a * sqrt(max(1 - l * l, 0));
  return pal(t, S, L);
}

private pen _palcyln(
  pen pal(real, real, real), real l, real t, real a, real b, real c, real n)
{
  l = min(max(l, 0), 1);
  real L = 2 * b * l + (c - b);
  real S = a * max(1 - abs((L - c) / b)**n, 0)**(1/n); // n from super ellipse
  return pal(t, S, L);
}

private pen _palsph(
  pen pal(real, real, real), real l, real t, real a, real b, real c)
{
  l = min(max(l, 0), 1);
  real L = 2 * b * l + (c - b);
  l = 2 * l - 1; // [0, 1] to [-1, 1]
  real r = a * sqrt(max(0, 1 - l * l));
  return pal(L, r * Cos(t), r * Sin(t));
}

pen palHSL(real l, real t, real a=1, real b=0.5, real c=0.5) {
  return _palcyl2(HSL.RGB, l, t, a, b, c);
}

pen palHSL(real l, real t, real a, real b, real c, real n) {
  return _palcyln(HSL.RGB, l, t, a, b, c, n);
}

pen palHSI(real l, real t, real a=1, real b=0.5, real c=0.5) {
  return _palcyl2(HSI.RGB, l, t, a, b, c);
}

pen palHSI(real l, real t, real a, real b, real c, real n) {
  return _palcyln(HSI.RGB, l, t, a, b, c, n);
}

pen palHSY(real l, real t, real a=1, real b=0.5, real c=0.5) {
  return _palcyl2(HSY.RGB, l, t, a, b, c);
}

pen palHSY(real l, real t, real a, real b, real c, real n) {
  return _palcyln(HSY.RGB, l, t, a, b, c, n);
}

pen palLab(real l, real t, real a=1, real b=0.5, real c=0.5) {
  static real A = 33.2, B = 28.5, C = 63.2; // by trial and error
  return _palsph(Lab.RGB, l, t, A * a, B * b * 2, C * c * 2);
}

pen palLuv(real l, real t, real a=1, real b=0.5, real c=0.5) {
  static real A = 37.8, B = 36.0, C = 59.9; // by trial and error
  return _palsph(Luv.RGB, l, t, A * a, B * b * 2, C * c * 2);
}

pen palOKLab(real l, real t, real a=1, real b=0.5, real c=0.5) {
  static real A = 0.106, B = 0.248, C = 0.671; // by trial and error
  return _palsph(OKLab.RGB, l, t, A * a, B * b * 2, C * c * 2);
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
