// colspc.asy - HSV, HSL, HSI, HSY, CIELAB, CIELUV, OKLab color space

// (c) 2025-2026 aelata
// This script is licensed under the MIT No Attribution (MIT-0) License.
// https://opensource.org/license/mit-0

// Most of the code below is based on the following textbook:
//   W. Burger and M. J. Burge, Digital Image Processing, 3rd ed.,
//   Cham, Switzerland: Springer, 2022, pp.387-438.
//   doi: 10.1007/978-3-031-05744-1.

struct HSV { // HSV color space
  static pen RGB(real H, real S, real V) {
    H = H % 360 / 60;
    S = min(max(S, 0), 1);
    V = min(max(V, 0), 1);
    int c1 = floor(H);
    real c2 = H - c1;
    real x = (1 - S) * V, y = (1 - S * c2) * V, z = (1 - S * (1 - c2)) * V;
    if (c1 == 0) return rgb(V, z, x);
    if (c1 == 1) return rgb(y, V, x);
    if (c1 == 2) return rgb(x, V, z);
    if (c1 == 3) return rgb(x, y, V);
    if (c1 == 4) return rgb(z, x, V);
    if (c1 == 5) return rgb(V, x, y);
    return rgb(0, 0, 0);
  }

  real H, S, V;
  void operator init(real H, real S, real V) {
    this.H = H % 360;
    this.S = min(max(S, 0), 1);
    this.V = min(max(V, 0), 1);
  }
  void operator init(pen p) {
    real[] c = colors(rgb(p));
    real c_hi = max(c), c_lo = min(c), c_rng = c_hi - c_lo;
    H = 0;
    if (0 < c_rng) {
      real[] _c = (c_hi - c) / c_rng;
      if        (c_hi == c[0]) {
        H = _c[2] - _c[1];
        if (H < 0)
          H += 6;
      } else if (c_hi == c[1]) {
        H = _c[0] - _c[2] + 2;
      } else if (c_hi == c[2]) {
        H = _c[1] - _c[0] + 4;
      }
    }
    H *= 60;
    S = (c_hi == 0) ? 0 : c_rng / c_hi;
    V = c_hi;
  }

  pen rgb() { return RGB(H, S, V); }
  real[] reals() { return new real[] {H, S, V}; }
  triple triple() { return (H, S, V); }
}
pen operator cast(HSV c) { return c.rgb(); }
real[] operator cast(HSV c) { return c.reals(); }
triple operator cast(HSV c) { return c.triple(); }
HSV operator cast(pen p) { return HSV(p); }

struct HSL { // HSL color space
  static pen RGB(real H, real S, real L) {
    S = min(max(S, 0), 1);
    L = min(max(L, 0), 1);
    real V = L + S * min(L, 1 - L);
    real S = (V == 0) ? 0 : 2 * (1 - L / V);
    return HSV.RGB(H, S, V);
  }

  real H, S, L;
  void operator init(real H, real S, real L) {
    this.H = H % 360;
    this.S = min(max(S, 0), 1);
    this.L = min(max(L, 0), 1);
  }
  void operator init(pen p) {
    HSV hsv = HSV(p);
    H = hsv.H;
    L = hsv.V * (1 - 0.5 * hsv.S);
    S = (L == 0 || L == 1) ? 0 : (hsv.V - L) / min(L, 1 - L);
  }

  pen rgb() { return RGB(H, S, L); }
  real[] reals() { return new real[] {H, S, L}; }
  triple triple() { return (H, S, L); }
}
pen operator cast(HSL c) { return c.rgb(); }
real[] operator cast(HSL c) { return c.reals(); }
triple operator cast(HSL c) { return c.triple(); }
HSL operator cast(pen p) { return HSL(p); }

struct HSI { // HSI color space
  static pen RGB(real H, real S, real I) {
    S = min(max(S, 0), 1);
    I = min(max(I, 0), 1);
    real[] c = colors(HSL.RGB(H, S, 0.5));
    real I0 = (c[0] + c[1] + c[2]) / 3;
    real L = (I < I0) ? I / I0 * 0.5 : 1 - (1 - I) / (1 - I0) * 0.5;
    return HSL.RGB(H, S, L);
  }

  real H, S, I;
  void operator init(real H, real S, real I) {
    this.H = H % 360;
    this.S = min(max(S, 0), 1);
    this.I = min(max(I, 0), 1);
  }
  void operator init(pen p) {
    real[] c = colors(rgb(p));
    HSV hsv = HSV(p);
    H = hsv.H;
    I = (c[0] + c[1] + c[2]) / 3;
    S = (0 < I) ? 1 - min(c) / I : 0;
  }

  pen rgb() { return RGB(H, S, I); }
  real[] reals() { return new real[] {H, S, I}; }
  triple triple() { return (H, S, I); }
}
pen operator cast(HSI c) { return c.rgb(); }
real[] operator cast(HSI c) { return c.reals(); }
triple operator cast(HSI c) { return c.triple(); }
HSI operator cast(pen p) { return HSI(p); }

struct sRGB {
  static real wR = 0.2126, wG = 0.7152, wB = 0.0722;
  static real[] wt = {wR, wG, wB};
  static real g = 1 / 2.4;
  static real a0 = 0.0031308;
  static real s = g / (a0 * (g - 1) + a0**(1 - g)); // 12.92
  static real d = 1 / (a0**g * (g - 1) + 1) - 1; // 0.055
  static real regamma(real a) {
    return (a <= a0) ? s * a : (1 + d) * a**g - d;
  }
  static real degamma(real b) {
    return (b <= s * a0) ? b / s : ((b + d) / (1 + d))**(1 / g);
  }
  static real[] regamma(real[] a) { return map(regamma, a); }
  static real[] degamma(real[] b) { return map(degamma, b); }

  static real[][] M = { // CIEXYZ to sRGB
    { 3.240479, -1.537150, -0.498535},
    {-0.969256,  1.875992,  0.041556},
    { 0.055648, -0.204043,  1.057311}
  };
  static real[][] Minv = { // sRGB to CIEXYZ
    { 0.412453,  0.357580,  0.180423},
    { 0.212671,  0.715160,  0.072169},
    { 0.019334,  0.119193,  0.950227}
  };
}

struct HSY { // HSY color space
  static pen RGB(real H, real S, real Y) {
    S = min(max(S, 0), 1);
    Y = min(max(Y, 0), 1);
    real y = sRGB.degamma(Y);
    Y = dot(sRGB.wt, colors(HSL.RGB(H, S, 0.5)));
    real L = (y < Y) ? y / Y * 0.5 : 1 - (1 - y) / (1 - Y) * 0.5;
    return rgb(sRGB.regamma(colors(HSL.RGB(H, S, L))));
  }

  real H, S, Y;
  void operator init(real H, real S, real Y) {
    this.H = H % 360;
    this.S = min(max(S, 0), 1);
    this.Y = min(max(Y, 0), 1);
  }
  void operator init(pen p) {
    real[] c = sRGB.degamma(colors(rgb(p)));
    HSL hsl = HSL(rgb(c[0], c[1], c[2]));
    H = hsl.H;
    S = hsl.S;
    Y = sRGB.regamma(dot(sRGB.wt, c));
  }

  pen rgb() { return RGB(H, S, Y); }
  real[] reals() { return new real[] {H, S, Y}; }
  triple triple() { return (H, S, Y); }
}
pen operator cast(HSY c) { return c.rgb(); }
real[] operator cast(HSY c) { return c.reals(); }
triple operator cast(HSY c) { return c.triple(); }
HSY operator cast(pen p) { return HSY(p); }

struct Lab { // CIELAB color space
  static real eps = (6 / 29)**3;
  static real kappa = (29 / 3)**3 / 116;
  static real f1(real c) {
    return (c <= eps) ? kappa * c + 16 / 116 : c**(1 / 3);
  }
  static real f2(real c) {
    real c3 = c**3;
    return (c3 <= eps) ? (c -  16 / 116) / kappa : c3;
  }
  static real[] ref = {0.95045, 1.00000, 1.08905};
  static bool valid_rgb = false;
  static bool valid() { return valid_rgb; }

  static pen RGB(real L, real a, real b) {
    L = min(max(L, 0), 100);
    a = min(max(a, -128), 127);
    b = min(max(b, -128), 127);
    L = (L + 16) / 116;
    real[] xyz = {
      ref[0] * f2(L + a / 500),
      ref[1] * f2(L),
      ref[2] * f2(L - b / 200),
    };
    real[] c = sRGB.M * xyz;
    valid_rgb =
      0 <= c[0] && c[0] <= 1 &&
      0 <= c[1] && c[1] <= 1 &&
      0 <= c[2] && c[2] <= 1;
    return rgb(sRGB.regamma(c));
  }

  real L, a, b;
  void operator init(real L, real a, real b) {
    this.L = min(max(L, 0), 100);
    this.a = min(max(a, -128), 127);
    this.b = min(max(b, -128), 127);
  }
  void operator init(pen p) {
    real[] xyz = sRGB.Minv * sRGB.degamma(colors(rgb(p)));
    for (int i = 0; i < 3; i += 1)
      xyz[i] = f1(xyz[i] / ref[i]);
    L = 116 * xyz[1] - 16;
    a = 500 * (xyz[0] - xyz[1]);
    b = 200 * (xyz[1] - xyz[2]);
  }

  pen rgb() { return RGB(L, a, b); }
  real[] reals() { return new real[] {L, a, b}; }
  triple triple() { return (a, b, L); } // not (L, a, b)
}
pen operator cast(Lab c) { return c.rgb(); }
real[] operator cast(Lab c) { return c.reals(); }
triple operator cast(Lab c) { return c.triple(); }
Lab operator cast(pen p) { return Lab(p); }

struct Luv { // CIELUV color space
  static real eps = (6 / 29)**3;
  static real kappa = (29 / 3)**3 / 116;
  static real f1(real c) {
    return (c <= eps) ? kappa * c + 16 / 116 : c**(1 / 3);
  }
  static real f2(real c) {
    real c3 = c**3;
    return (c3 <= eps) ? (c -  16 / 116) / kappa : c3;
  }
  static real fu(real[] xyz) {
    return (0 < xyz[0]) ? 4 xyz[0] / (xyz[0] + 15 xyz[1] + 3 xyz[2]) : 0;
  }
  static real fv(real[] xyz) {
    return (0 < xyz[1]) ? 9 xyz[1] / (xyz[0] + 15 xyz[1] + 3 xyz[2]) : 0;
  }

  static real[] ref = {0.95045, 1.00000, 1.08905};
  static real uref = fu(ref);
  static real vref = fv(ref);
  static bool valid_rgb = false;
  static bool valid() { return valid_rgb; }

  static pen RGB(real L, real u, real v) {
    L = min(max(L, 0), 100);
    u = min(max(u, -84), 176);
    v = min(max(v, -135), 108);
    real up = (0 < L) ? uref + u / (13 * L) : uref;
    real vp = (0 < L) ? vref + v / (13 * L) : vref;
    L = (L + 16) / 116;
    real Y = ref[1] * f2(L);
    real[] xyz = {
      Y * 9 * up / (4 * vp),
      Y,
      Y * (12 - 3 * up - 20 * vp) / (4 * vp),
    };
    real[] c = sRGB.M * xyz;
    valid_rgb =
      0 <= c[0] && c[0] <= 1 &&
      0 <= c[1] && c[1] <= 1 &&
      0 <= c[2] && c[2] <= 1;
    return rgb(sRGB.regamma(c));
  }

  real L, u, v;
  void operator init(real L, real u, real v) {
    this.L = min(max(L, 0), 100);
    this.u = min(max(u, -84), 176);
    this.v = min(max(v, -135), 108);
  }
  void operator init(pen p) {
    real[] xyz = sRGB.Minv * sRGB.degamma(colors(rgb(p)));
    real Y = f1(xyz[1] / ref[1]);
    L = 116 * Y - 16;
    u = 13 * L * (fu(xyz) - uref);
    v = 13 * L * (fv(xyz) - vref);
  }

  pen rgb() { return RGB(L, u, v); }
  real[] reals() { return new real[] {L, u, v}; }
  triple triple() { return (u, v, L); } // not (L, u, v)
}
pen operator cast(Luv c) { return c.rgb(); }
real[] operator cast(Luv c) { return c.reals(); }
triple operator cast(Luv c) { return c.triple(); }
Luv operator cast(pen p) { return Luv(p); }

// OKLab
//   B. Ottosson, A perceptual color space for image processing,
//   Accessed: Sep. 21, 2025. [Online].
//   Available: https://bottosson.github.io/posts/oklab

struct OKLab { // OKLab color space
  static real[][] M2= {
    { 0.2104542553,  0.7936177850, -0.0040720468},
    { 1.9779984951, -2.4285922050,  0.4505937099},
    { 0.0259040371,  0.7827717662, -0.8086757660}
  };
  static real[][] M2inv= {
    { 1,  0.3963377774,  0.2158037573},
    { 1, -0.1055613458, -0.0638541728},
    { 1, -0.0894841775, -1.2914855480}
  };
  static real[][] M_M1inv= {
    { 4.0767416621, -3.3077115913,  0.2309699292},
    {-1.2684380046,  2.6097574011, -0.3413193965},
    {-0.0041960863, -0.7034186147,  1.7076147010}
  };
  static real[][] M1_Minv= {
    { 0.4122214708,  0.5363325363,  0.0514459929},
    { 0.2119034982,  0.6806995451,  0.1073969566},
    { 0.0883024619,  0.2817188376,  0.6299787005}
  };
  static bool valid_rgb = false;
  static bool valid() { return valid_rgb; }

  static pen RGB(real L, real a, real b) {
    L = min(max(L, 0), 1);
    a = min(max(a, -0.4), 0.4);
    b = min(max(b, -0.4), 0.4);
    real[] Lab = {L, a, b};
    real[] c = M_M1inv * ((M2inv * Lab)**3);

    valid_rgb =
      0 <= c[0] && c[0] <= 1 &&
      0 <= c[1] && c[1] <= 1 &&
      0 <= c[2] && c[2] <= 1;
    return rgb(sRGB.regamma(c));
  }

  real L, a, b;
  void operator init(real L, real a, real b) {
    this.L = min(max(L, 0), 1);
    this.a = min(max(a, -0.4), 0.4);
    this.b = min(max(b, -0.4), 0.4);
  }
  void operator init(pen p) {
    real[] c = M2 * ((M1_Minv * sRGB.degamma(colors(rgb(p))))**(1/3));
    L = c[0];
    a = c[1];
    b = c[2];
  }

  pen rgb() { return RGB(L, a, b); }
  real[] reals() { return new real[] {L, a, b}; }
  triple triple() { return (a, b, L); } // not (L, a, b)
}
pen operator cast(OKLab c) { return c.rgb(); }
real[] operator cast(OKLab c) { return c.reals(); }
triple operator cast(OKLab c) { return c.triple(); }
OKLab operator cast(pen p) { return OKLab(p); }
