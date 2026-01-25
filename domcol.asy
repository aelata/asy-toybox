// domcol.asy - domain coloring of complex functions

// (c) 2025-2026 aelata
// This script is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

import palette;
import graph;
import solids;

import colpal;
import isoline;

private pen _pal(real l, real t) { return palLuv(l, t); } // default palette

private int _NX = 500;   // # of points along real-axis
private int _NZ = 10000; // # of histogram bins along modulus-axis

pair[][] seq(
  pair f(pair), explicit pair a, explicit pair b, int nx=_NX, int ny=nx)
{
  pair[][] z = new pair[nx][ny];
  for (int i: sequence(nx)) {
    real x = interp(a.x, b.x, (i + 0.5) / nx);
    for (int j: sequence(ny)) {
      real y = interp(a.y, b.y, (j + 0.5) / ny);
      z[i][j] = f((x, y));
    }
  }
  return z;
}

real[][] map(real f(real), real[][] x) { // Src=real[][], Dst=real[][]
  real[][] y = new real[x.length][];
  for (int i: sequence(x.length))
    y[i] = map(f, x[i]);
  return y;
}

real[][] map(real f(pair), pair[][] z) { // Src=pair[][], Dst=real[][]
  real[][] w = new real[z.length][];
  for (int i: sequence(z.length))
    w[i] = map(f, z[i]);
  return w;
}

from mapArray(Src=real, Dst=string) access map;

// lightness function
real lfn(real), rfn(real);

void set_lfn(real a) {
  static real l1(real r) { return r / (1 + r); }
  static real r1(real l) { return l / (1 - l); }
  if        (a <= 0) {
    lfn = new real(real r) { return 2 / pi * atan(r); };
    rfn = new real(real l) { return tan(0.5 * pi * l); };
  } else if (a == 1) {
    lfn = new real(real r) { return (0 <= r) ? l1(r) : -l1(-r); };
    rfn = new real(real l) { return (0 <= l) ? r1(l) : -r1(-l); };
  } else if (a == 2) {
    lfn = new real(real r) { return (0 <= r) ? l1(r * r) : -l1(r * r); };
    rfn = new real(real l) {
      return (0 <= l) ? sqrt(r1(l)) : -sqrt(r1(-l)); };
  } else {
    lfn = new real(real r) { return (0 <= r) ? l1(r**a) : -l1((-r)**a); };
    rfn = new real(real l) {
      return (0 <= l) ? r1(l)**(1 / a) : -r1(-l)**(1 / a); };
  }
}

set_lfn(1); // set default lightness function

real lfn(real r, real s) {
  if (isnan(r))
    return nan;
  if (0 <= r) {
    if (infinity <= r)
      return 1 - realEpsilon;
    return min((s == 0 || s == 1) ? lfn(r) : lfn(r / s), 1 - realEpsilon);
  } else {
    if (r <= -infinity)
      return -1 + realEpsilon;
    return -min((s == 0 || s == 1) ? lfn(-r) : lfn(-r / s), 1 - realEpsilon);
  }
}

real lfn(explicit pair z, real s=1) { return lfn(abs(z), s); }

real rfn(real l, real s) {
  if (isnan(l))
    return nan;
  if (0 <= l) {
    if (1 - realEpsilon <= l)
      return +infinity;
    return min((s == 0 || s == 1) ? rfn(l) : s * rfn(l), infinity);
  } else {
    if (l <= -1 + realEpsilon)
      return -infinity;
    return -min((s == 0 || s == 1) ? rfn(-l) : s * rfn(-l), infinity);
  }
}

pair[][] seq(
  pair f(pair), real rmax=infinity, real c=1, real tmax=2pi,
  int nx=_NX, int ny=nx, bool clip=true)
{
  tmax /= 2pi;
  if (c != 0)
    rmax = lfn(rmax, c);
  pair[][] z = new pair[nx][ny];
  for (int i: sequence(nx)) {
    real x = interp(-rmax, rmax, (i  + 0.5) / nx);
    for (int j: sequence(ny)) {
      real y = interp(-rmax, rmax, (j  + 0.5) / ny);
      real r = hypot(x, y);
      if (clip == false || r <= rmax) {
        if (c != 0)
          r = rfn(r, c);
        real t = atan2(y, x) * tmax;
        z[i][j] = f((r * cos(t), r * sin(t)));
      } else {
        z[i][j] = (nan, nan);
      }
    }
  }
  return z;
}

real deg(pair z) { return degrees(z, warn=false); } // [0, 360)
real rad(pair z) { return angle(z, warn=false) % 2pi; }  // [0, 2pi)

private int _U = 8; // weight for each point
private int _MASK_LOWER = 1;
private int _MASK_UPPER = 2;
private int _MASK_REVERSE = 4;

int[] hist(real[][] l, int nz=_NZ) { // l: [0, 1)
  int[] h = array(nz, 0);
  for (int i: sequence(l.length))
    for (int j: sequence(l[i].length))
      if (!isnan(l[i][j]))
        h[(int)(l[i][j] * nz)] += _U;
  return h;
}

int[] cumsum(int[] h) {
  int[] H = new int[h.length];
  H[0] = h[0];
  for (int i: sequence(1, h.length - 1))
    H[i] = H[i - 1] + h[i];
  return H;
}

real cdf(real l, int[] H) { // H: cumulative histogram, l: [0, 1)
  if (l <= 0)
    return 0.0;
  if (l < 1.0 - realEpsilon) {
    l *= H.length;
    int i = (int)l; // integer    part
    // real f = l - i; // fractional part
    real f = 0.5; // better for constant value function?
    int Hmax = H[H.length - 1] # _U;
    if (Hmax == 0)
      return 0.0; // empty cumulative histogram
    if (i == 0)
      return f * (H[0] # _U) / Hmax;
    return (((1 - f) * (H[i - 1] # _U) + f * (H[i] # _U))) / Hmax;
  }
  return 1.0 - realEpsilon;
}

real lfn(real r, real s, int[] H) {
  return (s != 0) ? lfn(r, s) : cdf(lfn(r, 1), H);
}

private real _lmin(int[] H) { // lmin from H
  if (H.length == 0 || AND(H[H.length - 1], _MASK_LOWER) == 0 ||
      AND(H[0], _MASK_LOWER) != 0)
    return 0.0; // extend
  for (int i: sequence(1, H.length - 1))
    if (AND(H[i] - H[i - 1], _MASK_LOWER) != 0)
      return (i + 0.5) / H.length;
  return 1.0 - realEpsilon;
}

private real _lmax(int[] H) { // lmax from H
  if (H.length == 0 || AND(H[H.length - 1], _MASK_UPPER) == 0 ||
      AND(H[H.length - 1] - H[H.length - 2], _MASK_UPPER) != 0)
    return 1.0 - realEpsilon; // extend
  for (int i: sequence(H.length - 2, 1, -1))
    if (AND(H[i] - H[i - 1], _MASK_UPPER) != 0)
      return (i + 0.5) / H.length;
  return 0.0;
}

real quantile(real q, int[] H) {
  real lmin = _lmin(H);
  real lmax = _lmax(H);
  if (q <= 0) {
    q = 0;
  } else if (q < 1.0 - realEpsilon) {
    int k = (int)(q * (H[H.length - 1] # _U));
    int i = search(H, k * _U + AND(H[H.length - 1], _MASK_LOWER));
    if (i < 0) {
      q = (k / (H[0] # _U)) / H.length;
    } else if (i < H.length - 1) {
      int H0 = H[i] # _U;
      int H1 = H[i + 1] # _U;
      if (H0 == H1)
        q = i / H.length;
      else
        q = (i + (k - H0) / (H1 - H0)) / H.length;
    } else {
      q = 1;
    }
  } else {
    q = 1;
  }
  return min((lmax - lmin) * q + lmin, 1.0 - realEpsilon);
}

real modulus(real x, real s, int[] H) {
  return (0 < s || H.length == 0) ? rfn(x, s) : rfn(quantile(x, H), s);
}

pair modulus_range(real s=1, int[] H) {
  return (rfn(_lmin(H), s), rfn(_lmax(H), s));
}

int[] Hist(
  real[][] l, real s=1, int nz=_NZ,
  bool autoscale=false, pair rlim=(0, infinity))
{
  real lmin, lmax;
  int[] h, H;
  if (autoscale) {
    h = hist(l, nz);
    H = cumsum(h);
    lmin = (0 <= rlim.x) ? quantile(rlim.x, H) : lfn(0.0, s);
    lmax = (rlim.y <= 1) ? quantile(rlim.y, H) : lfn(rlim.y, s);
  } else {
    lmin = lfn(rlim.x, s);
    lmax = lfn(rlim.y, s);
  }
  if (s == 0) {
    if (h.length == 0)
      h = hist(l, nz);
  } else {
    h = array(nz, _U);
  }
  if (0 < lmin) { // mark lower limit
    int n = (int)(lmin * nz);
    for (int i: sequence(n))
      h[i] = 0;
    h[n] = OR(h[n], _MASK_LOWER);
  } else {
    h[0] = OR(h[0], _MASK_LOWER);
  }
  if (lmax < 1.0 - realEpsilon) { // mark upper limit
    int n = (int)(lmax * nz);
    for (int i: sequence(n + 1, nz - 1))
      h[i] = 0;
    h[n] = OR(h[n], _MASK_UPPER);
  } else {
    h[h.length - 1] = OR(h[h.length - 1], _MASK_UPPER); // sentinel
  }
  return cumsum(h);
}

private void _image(
  picture pic=currentpicture,
  real[][] l, real[][] t, pair a, pair b, int[] H,
  pen pal(real, real), bool reverse, pen background)
{
  pen[][] p = new pen[l.length][l[0].length];
  for (int i: sequence(l.length)) {
    for (int j: sequence(l[0].length)) {
      if (isnan(l[i][j]) || isnan(t[i][j])) {
        p[i][j] = background;
      } else {
        real lij = cdf(l[i][j], H);
        p[i][j] = pal(reverse ? 1.0 - lij : lij, degrees(t[i][j]));
      }
    }
  }
  image(pic, p, a, b);
}

int[] image(
  picture pic=currentpicture,
  real[][] zr, real[][] zt, explicit pair a=(-1, -1), explicit pair b=(1, 1),
  real s=1, int[] H = new int[], int nz=_NZ,
  bool autoscale=false, pair r=(0, infinity),
  pen pal(real, real)=_pal, bool3 reverse=default, pen background=white)
{
  real [][] zl = map(new real(real r) { return lfn(r, s); }, zr);
  if (H.length == 0) {
    H = Hist(zl, s, nz, autoscale, r);
    if (reverse == default)
      reverse = false;
    if (reverse)
      H[H.length - 1] = OR(H[H.length - 1], _MASK_REVERSE);
  } else {
    if (reverse == default)
      reverse = (AND(H[H.length - 1], _MASK_REVERSE) != 0);
  }
  if (pic != null)
    _image(pic, zl, zt, a, b, H, pal, reverse, background);
  return H;
}

int[] image(
  picture pic=currentpicture,
  pair[][] z, explicit pair a=(-1, -1), explicit pair b=(1, 1),
  real c=1, int[] H = new int[], int nz=_NZ,
  bool autoscale=false, pair r=(0, infinity),
  pen pal(real, real)=_pal, bool3 reverse=default, pen background=white)
{
  return image(
    pic, map(abs, z), map(rad, z), a, b, c, H, nz,
    autoscale, r, pal, reverse, background);
}

int[] image(
  picture pic=currentpicture,
  pair f(pair z)=new pair(pair z) { return z; },
  bool linear=true, real rmax=0, real c=1,
  pair a=(-1, -1), pair b=(1, 1), real s=1, int[] H = new int[],
  int nx=_NX, int ny=nx, int nz=_NZ,
  bool autoscale=false, pair r=(0, infinity),
  pen pal(real, real)=_pal, bool3 reverse=default, pen background=white)
{
  if (linear == false && rmax == 0)
    rmax = infinity;
  pair[][] z = (linear) ? seq(f, a, b, nx, ny) : seq(f, rmax, c, nx, ny);
  return image(
    pic, z, a, b, s, H, nz, autoscale, r, pal, reverse, background);
}

string ticklbl_inf(real x, string format="$%.3g$") {
  if (x <= -infinity)
    return "$-\infty$";
  if (infinity <= x)
    return "$\infty$";
  return format(format, x);
}

private string _fmt = "$%.3g$";
private string _ticklbl(real x) { return ticklbl_inf(x, _fmt); }

// gcd - greatest common divisor
private int gcd(int m, int n) {
  while (n != 0) {
    int l = m % n;
    m = n;
    n = l;
  }
  return m;
}

string ticklbl_pi(real x, int div=1, real fuzz=1e-6) {
  string r = "";
  int s = sgn(x);
  x = abs(x) * div;
  int i = round(x);
  if (abs(x - i) < fuzz) {
    if (i == 0) {
      r = "0";
    } else {
      r = "\pi";
      int g = gcd(i, div);
      i #= g;
      div #= g;
      if (1 < i)
        r = format("%d", i) + r;
      if (1 < div)
        r += format("/%d", div);
      if (s < 0)
        r = "-" + r;
    }
    r = "$" + r + "$";
  }
  return r;
}

string ticklbl_deg(real x) { return _ticklbl(180 * x); }
string ticklbl_rad(real x) { return ticklbl_pi(x); }

void xaxis(
  picture pic=currentpicture, pair X, pair x, real y=0,
  real[] pos, string[] lbl=new string[],
  pair dir=S, pen p=currentpen, string format=_fmt)
{
  real Xmin = X.x, Xmax = X.y;
  real xmin = x.x, xmax = x.y;
  draw(pic, (xmin, y) -- (xmax, y), p);
  for (int i: sequence(pos.length)) {
    real x = (Xmax != Xmin) ?
      xmin + (xmax - xmin) * (pos[i] - Xmin) / (Xmax - Xmin) :
      0.5 * (xmin + xmax);
    string s = (i < lbl.length) ? lbl[i] : format(format, pos[i]);
    xtick(pic, (x, y), dir, p);
    labelx(pic, s, (x, y), 3dir, p);
  }
}

void yaxis(
  picture pic=currentpicture, pair Y, pair y, real x=0,
  real[] pos, string[] lbl=new string[],
  pair dir=W, pen p=currentpen, string format=_fmt)
{
  real Ymin = Y.x, Ymax = Y.y;
  real ymin = y.x, ymax = y.y;
  draw(pic, (x, ymin) -- (x, ymax), p);
  for (int i: sequence(pos.length)) {
    real y = (Ymax != Ymin) ?
      ymin + (ymax - ymin) * (pos[i] - Ymin) / (Ymax - Ymin) :
      0.5 * (ymin + ymax);
    string s = (i < lbl.length) ? lbl[i] : format(format, pos[i]);
    ytick(pic, (x, y), dir, p);
    labely(pic, s, (x, y), 3dir, p);
  }
}

void xaxis(
  picture pic=currentpicture, pair X, pair x, explicit real y=0, int n=1,
  pair dir=S, pen p=currentpen, string ticklbl(real)=_ticklbl)
{
  real[] pos = new real[n + 1];
  string[] lbl = new string[n + 1];
  real Xmin = X.x, Xmax = X.y;
  for (int i: sequence(n + 1)) {
    pos[i] = interp(Xmin, Xmax, i / n);
    lbl[i] = ticklbl(pos[i]);
  }
  xaxis(pic, X, x, y, pos, lbl, dir, p);
}

void yaxis(
  picture pic=currentpicture, pair Y, pair y, explicit real x=0, int n=1,
  pair dir=W, pen p=currentpen, string ticklbl(real)=_ticklbl)
{
  real[] pos = new real[n + 1];
  string[] lbl = new string[n + 1];
  real Ymin = Y.x, Ymax = Y.y;
  for (int i: sequence(n + 1)) {
    pos[i] = interp(Ymin, Ymax, i / n);
    lbl[i] = ticklbl(pos[i]);
  }
  yaxis(pic, Y, y, x, pos, lbl, dir, p);
}

void raxis(
  picture pic=currentpicture,
  real rmax=infinity, real c=1, int nr=4, real y=-1.2, pen p=currentpen)
{
  string lbl(real x) {
    return ticklbl_inf((c == 0) ? rmax * x : rfn(x * lfn(rmax, c), c));
  }
  xaxis(pic, YEquals(y), 0, 1, p, RightTicks(lbl, N=nr));
}

void taxis(
  picture pic=currentpicture,
  real tmax=2pi, real o=0, int nt=8, pen p=currentpen)
{
  for (int i: sequence(nt)) {
    pair z = expi(2pi * i / nt);
    draw(
      pic, Label(ticklbl_pi(tmax / pi * i / nt, 4), EndPoint),
      z -- z * 1.05, p);
  }
  draw(pic, unitcircle, p);
}

private void _rtpalette_colpal(
  picture pic, int[] H, pair a, pair b, pair tlim,
  pen p, pen pal(real, real), bool3 reverse)
{
  if (reverse == default)
    reverse = (0 < H.length) ?
      (AND(H[H.length - 1], _MASK_REVERSE) != 0) : false;
  pen[][] cp = colpal((0, 1), tlim, pal, reverse);
  image(pic, cp, a, b);
  draw(pic, box(a, b), p);
}

private void _rtpalette_taxis(
  picture pic, pair a, pair b, pair tlim, int nt, bool flip,
  string ticklbl(real))
{
  if (flip)
    xaxis(pic, tlim, (a.x, b.x), a.y, nt, S, ticklbl);
  else
    xaxis(pic, tlim, (a.x, b.x), b.y, nt, N, ticklbl);
}

private void _rtpalette_raxis(
  picture pic, pair a, pair b, pair llim, bool flop, real[] ls, string[] lbls)
{
  if (flop)
    yaxis(pic, llim, (a.y, b.y), a.x, ls, lbls, W);
  else
    yaxis(pic, llim, (a.y, b.y), b.x, ls, lbls, E);
}

real[] rtpalette(
  picture pic=currentpicture,
  real c=1, int[] H=new int[], pair a=(1.2, -1), pair b=(1.5, 1),
  pair rlim=(0, infinity), int nr=8,
  pair tlim=(-1, 1), int nt=2, bool flip=false, bool flop=false,
  string format=_fmt, string ticklbl(real)=ticklbl_rad, pen p=currentpen,
  pen pal(real, real)=_pal, bool3 reverse=default)
{
  if (pic != null) {
    _rtpalette_colpal(pic, H, a, b, tlim, p, pal, reverse);
    if (0 < nt)
      _rtpalette_taxis(pic, a, b, tlim, nt, flip, ticklbl);
  }
  real lmin = lfn(rlim.x, c, H);
  real lmax = (infinity <= rlim.y) ?
    1 : lfn(rlim.y, c, H); // not 1 - realEpsilon
  real[] ls = uniform(lmin, lmax, nr);
  real[] rs = map(new real(real l) { return modulus(l, c, H); }, ls);
  if (0 < rs.length) {
    rs[0] = rlim.x;
    rs[rs.length - 1] = rlim.y;
    if (pic != null)
      _rtpalette_raxis(pic, a, b, (lmin, lmax), flop, ls, map(_ticklbl, rs));
    if (rs[0] == 0.0)
      rs.delete(0);
    if (0 < rs.length && infinity <= rs[rs.length - 1])
      rs.delete(rs.length - 1);
  }
  return rs;
}

real[] rtpalette(
  picture pic=currentpicture,
  real c=1, int[] H=new int[], pair a=(1.2, -1), pair b=(1.5, 1),
  pair rlim=(0, infinity), real[] rs, bool endlabels=true,
  pair tlim=(-1, 1), int nt=2, bool flip=false, bool flop=false,
  string format=_fmt, string ticklbl(real)=ticklbl_rad, pen p=currentpen,
  pen pal(real, real)=_pal, bool3 reverse=default)
{
  _rtpalette_colpal(pic, H, a, b, tlim, p, pal, reverse);
  if (0 < nt)
    _rtpalette_taxis(pic, a, b, tlim, nt, flip, ticklbl);
  if (0 < rs.length) {
    real[] rs1 = rs[:]; // copy(rs)
    real[] ls1 = map(new real(real r) { return lfn(r, c, H); }, rs1);
    if (endlabels && rlim.x == 0 && all(0 < rs)) {
      rs1.insert(0, 0.0);
      ls1.insert(0, 0.0);
    }
    if (endlabels && rlim.y == infinity && all(rs < infinity)) {
      rs1.push(infinity);
      ls1.push(1.0);
    }
    pair llim = ( // lmax may be not 1 - realEpsilon but 1
      lfn(rlim.x, c, H), (infinity <= rlim.y) ? 1 : lfn(rlim.y, c, H));
    _rtpalette_raxis(pic, a, b, llim, flop, ls1, map(_ticklbl, rs1));
  }
  return rs;
}

void isomodulus(
  picture pic=currentpicture, real[][] r,
  explicit pair a=(-1, -1), explicit pair b=(1, 1), real[] rs,
  pen p=currentpen)
{
  guide[][] g = isoline(r, a, b, rs);
  draw(pic, g, p);
}

void isomodulus(
  picture pic=currentpicture, pair[][] z,
  explicit pair a=(-1, -1), explicit pair b=(1, 1), real[] rs,
  pen p=currentpen)
{
  isomodulus(pic, map(abs, z), a, b, rs, p);
}

void isophase(
  picture pic=currentpicture, real[][] t,
  explicit pair a=(-1, -1), explicit pair b=(1, 1), real[] ts,
  pen p=nullpen)
{
  guide[][] g = isoline(t, a, b, ts, g=zc_phase);
  if (p == nullpen) {
    pen[] c = sequence(
      new pen(int i) { return HSV.RGB(degrees(ts[i]), 1.0, 1.0); },
      ts.length);
    draw(pic, g, c);
  } else {
    draw(pic, g, p);
  }
}

void isophase(
  picture pic=currentpicture, pair[][] z,
  explicit pair a=(-1, -1), explicit pair b=(1, 1), real[] ts,
  pen p=nullpen)
{
  isophase(pic, map(rad, z), a, b, ts, p);
}

void isophase(
  picture pic=currentpicture, real[][] t,
  explicit pair a=(-1, -1), explicit pair b=(1, 1), int nt=6)
{
  real s = 2pi / nt;
  guide[][] g = isoline(t, a, b, s * sequence(nt), g=zc_phase);
  pen[] c = sequence(
    new pen(int i) { return HSV.RGB(degrees(s * i), 1.0, 1.0); }, nt);
  draw(pic, g, c);
}

void isophase(
  picture pic=currentpicture, pair[][] z,
  explicit pair a=(-1, -1), explicit pair b=(1, 1), int nt=6)
{
  isophase(pic, map(rad, z), a, b, nt);
}

int _NR = 200, _NT = 360;
pair[][] rtseq( // vs xyseq
  pair f(pair), explicit pair a=(0, 0), pair b=(infinity, 2pi), real c=1,
  int nr=_NR, int nt=_NT)
{
  pair[][] z = new pair[nr][nt];
  if (c != 0) {
    a = (lfn(a.x, c), a.y);
    b = (lfn(b.x, c), b.y);
  }
  for (int i: sequence(nr)) {
    real r = interp(a.x, b.x, (i + 0.5) / nr);
    if (c != 0)
      r = rfn(r, c);
    for (int j: sequence(nt)) {
      real t = interp(a.y, b.y, (j + 0.5) / nt);
      z[i][j] = f((r * cos(t), r * sin(t)));
    }
  }
  return z;
}

private void _rtimage(
  picture pic=currentpicture,
  real[][] l, real[][] t, int[] H, pair a=(0, 0pi), pair b=(1, 2*pi),
  pen pal(real, real), bool reverse, pen background)
{
  int nl = l.length, nt = l[0].length;
  pen[] cpal = new pen[nl * nt];
  for (int i: sequence(nl)) {
    for (int j: sequence(nt)) {
      if (isnan(l[i][j]) || isnan(t[i][j])) {
        cpal[i * nt + j] = background;
      } else {
        real lij = cdf(l[i][j], H);
        cpal[i * nt + j] = pal(reverse ? 1.0 - lij : lij, degrees(t[i][j]));
      }
    }
  }
  triple f(pair t) { return (t.x * cos(t.y), t.x * sin(t.y), t.y); }
  surface s = surface(f, a, b, l.length, l[0].length);
  draw(pic, s, cpal);
}

int[] rtimage(
  picture pic=currentpicture,
  real[][] r, real[][] t, real s=0, int[] H=new int[], int nz=_NZ,
  bool autoscale=false, pair rlim=(0, infinity),
  pen pal(real, real)=_pal, bool3 reverse=default, pen background=white)
{
  real[][] l = map(new real(pair r) { return lfn(r, s); }, r);
  if (H.length == 0) {
    H = Hist(l, s, nz, autoscale, rlim);
    if (reverse == default)
      reverse = false;
    if (reverse)
      H[H.length - 1] = OR(H[H.length - 1], _MASK_REVERSE);
  } else {
    if (reverse == default)
      reverse = (AND(H[H.length - 1], _MASK_REVERSE) != 0);
  }
  if (pic != null)
    _rtimage(pic, l, t, H, pal, reverse, background);
  return H;
}
