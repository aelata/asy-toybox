// geom3.asy - miscellaneous 3D geometry functions

// (c) 2025-2026 aelata
// This script is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

import solids; // revolution for dot3
import geom2;

real[] reals(triple a) { // cast may cause ambiguity
  return new real[] {a.x, a.y, a.z};
}

triple[] triples(guide3 g) {
  triple[] a = sequence(
    new triple(int i) { return point(g, i); }, size(g));
  a.cyclic = cyclic(g);
  return a;
}

triple[] resample(guide3 g, int n) { // n points
  int m = cyclic(g) ? n : n - 1;
  triple[] a = sequence(
    new triple(int i) { return relpoint(g, i / m); }, n);
  a.cyclic = cyclic(g);
  return a;
}

guide3 collapse(
  triple[] a, interpolate3 join=operator --, bool3 cyclic=default)
{
  guide3 g = join(... a);
  if (cyclic == default)
    cyclic = a.cyclic;
  return cyclic ? join(g, cycle) : g;
}

guide3 resampled(guide3 g, int n, interpolate3 join=operator --) {
  return collapse(resample(g, n), join);
}

path3 scale(path3 p, real z=1) { // mainly for slightly larger path3
  if (z == 1 || size(p) < 2)
    return p;
  assert(piecewisestraight(p));
  triple[] pts = triples(p);
  triple g = O;
  for (int i: sequence(pts.length))
    g += pts[i];
  g /= pts.length;
  for (int i: sequence(pts.length))
    pts[i] = g + (pts[i] - g) * z;
  return collapse(pts);
}

void mark_angle(
  picture pic=currentpicture, Label L="", triple A, triple O, triple B,
  real size=12bp, pen p = currentpen)
{
  picture opic;
  path3 g = arc((0, 0, 0), scale3(size) * unit(A - O), B - O);
  draw(opic, L, g, p);
  add(pic, opic, O);
}

void mark_right_angle(
  picture pic=currentpicture, triple A, triple O, triple B,
  real size=8bp, pen p=currentpen)
{
  picture opic;
  triple dA = scale3(size) * unit(A - O);
  triple dB = scale3(size) * unit(B - O);
  path3 g = dA -- (dA + dB) -- dB;
  draw(opic, g, p);
  add(pic, opic, O);
}

// m must be an unit direction vector
triple project(triple m, triple a) { return dot(m, a) * m; }
triple reject(triple m, triple a) { return a - dot(m, a) * m; }
triple reflect(triple m, triple a) { return -a + 2 dot(m, a) * m; }

struct line3 {
  triple m;
  triple xH;
  static line3 with_value(triple m, triple xH=(0, 0, 0)) {
    line3 l = new line3;
    l.m = unit(m);
    l.xH = reject(l.m, xH);
    return l;
  }
  triple[] value() { return new triple[] {m, xH}; }

  void operator init (triple x1, triple x2) {
    m = unit(x2 - x1);
    xH = reject(m, x1);
  }
  void operator init(path3 p) { // use the first two points
    operator init(point(p, 0), point(p, 1));
  }

  triple project(triple a) { return a + reject(m, xH - a); }
  triple reflect(triple a) { return a + 2 reject(m, xH - a); }
  real distance(triple a) { return abs(cross(m, a - xH)); }
  line3 reflect(line3 l) {
    return line3(reflect(l.xH), reflect(l.xH + l.m));
  }
  triple nearest(line3 l) {
    real c = dot(m, l.m);
    real C = dot(l.xH - xH, m - c * l.m);
    c = 1 - c * c;
    if (c != 0)
      C /= c;
    return xH + C * m;
  }
  real distance(line3 l) { return dot(unit(cross(m, l.m)), l.xH - xH); }

  triple intersect(triple n, triple xH) { // with plane (n and xH)
    real d = dot(n, m);
    return (d != 0) ? this.xH + dot(n, xH - this.xH) / d * m : (inf, inf, inf);
  }
  triple xy_intercept(real z=0) { return intersect(Z, z * Z); }
  triple yz_intercept(real x=0) { return intersect(X, x * X); }
  triple zx_intercept(real y=0) { return intersect(Y, y * Y); }

  static line3 x(real y=0, real z=0) { return with_value(X, (0, y, z)); }
  static line3 y(real z=0, real x=0) { return with_value(Y, (x, 0, z)); }
  static line3 z(real x=0, real y=0) { return with_value(Z, (x, y, 0)); }

  path3 path(real a=-1, real b=-a, real o=0) {
    return interp(xH, xH + m, a + o) -- interp(xH, xH + m, b + o);
  }

  path3 path(triple a, triple b, real eps=1e-15) {
    static int log2(int n) { return 63 - CLZ(n); }
    static bool inside(real x, real lo, real hi) { return lo < x && x < hi; }

    triple lo = minbound(a, b), hi = maxbound(a, b);
    triple[] p = new triple[14];
    p[0:8] = new triple[] {
      lo, (hi.x, lo.y, lo.z), (hi.x, hi.y, lo.z), (lo.x, hi.y, lo.z),
      (lo.x, lo.y, hi.z), (hi.x, lo.y, hi.z), hi, (lo.x, hi.y, hi.z)};
    real[] d = new real[8];

    int c = 0;
    for (int i: sequence(8)) {
      d[i] = distance(p[i]);
      if (d[i] < eps)
        c += 2**i;
    }
    p[8] = xy_intercept(lo.z);
    if (inside(p[8].x, lo.x, hi.x) && inside(p[8].y, lo.y, hi.y))
      c += 2**8;
    p[9] = xy_intercept(hi.z);
    if (inside(p[9].x, lo.x, hi.x) && inside(p[9].y, lo.y, hi.y))
      c += 2**9;
    p[10] = yz_intercept(lo.x);
    if (inside(p[10].y, lo.y, hi.y) && inside(p[10].z, lo.z, hi.z))
      c += 2**10;
    p[11] = yz_intercept(hi.x);
    if (inside(p[11].y, lo.y, hi.y) && inside(p[11].z, lo.z, hi.z))
      c += 2**11;
    p[12] = zx_intercept(lo.y);
    if (inside(p[12].z, lo.z, hi.z) && inside(p[12].x, lo.x, hi.x))
      c += 2**12;
    p[13] = zx_intercept(hi.y);
    if (inside(p[13].z, lo.z, hi.z) && inside(p[13].x, lo.x, hi.x))
      c += 2**13;
    if (popcount(c) != 2)
      return nullpath3;

    int i0 = log2(c), i1 = log2(XOR(c, 2**i0));
    return (dot(m, p[i0]) < dot(m, p[i1])) ?
      p[i0] -- p[i1] : p[i1] -- p[i0];
  }
}

line3 operator *(transform3 T, line3 l) {
  return line3(T * l.xH, T * (l.xH + l.m));
}

struct plane3 {
  triple n; // unit normal vector
  triple xH; // supporting point (nearest point from the origin)

  static plane3 with_value(triple n, triple xH=(0, 0, 0)) {
    plane3 P = new plane3;
    P.n = unit(n);
    P.xH = project(P.n, xH);
    return P;
  }
  triple[] value() { return new triple[] {n, xH}; }

  void operator init(triple x1, triple x2, triple x3) {
    n = unit(cross(x2 - x1, x3 - x1));
    xH = project(n, x1);
  }
  void operator init(line3 l, triple a) {
    n = unit(cross(l.m, a - l.xH));
    xH = project(n, a);
  }
  void operator init(path3 p) { // use the first three points
    operator init(point(p, 0), point(p, 1), point(p, 2));
  }

  triple project(triple a) { return a + project(n, xH - a); }
  triple reflect(triple a) { return a + 2 project(n, xH - a); }
  real distance(triple a) { return dot(n, a - xH); }

  line3 project(line3 l) {
    return line3(this.project(l.xH), this.project(l.xH + l.m));
  }
  line3 reflect(line3 l) {
    return line3(this.reflect(l.xH), this.reflect(l.xH + l.m));
  }
  triple intersect(line3 l) {
    real d = dot(n, l.m);
    return (d != 0) ? l.xH + dot(n, xH - l.xH) / d * l.m : (inf, inf, inf);
  }
  real intersect(triple a, triple b) {
    real d = dot(n, b - a);
    return (d != 0) ? dot(n, xH - a) / d : inf;
  }
  triple x_intercept(real y=0, real z=0) { return intersect(line3.x(y, z)); }
  triple y_intercept(real z=0, real x=0) { return intersect(line3.y(z, x)); }
  triple z_intercept(real x=0, real y=0) { return intersect(line3.z(x, y)); }

  line3 intersect(plane3 P) {
    triple m = unit(cross(n, P.n));
    real c = dot(n, P.n);
    triple xl = xH + P.xH - c * (dot(P.n, P.xH) * n + dot(n, xH) * P.n);
    c = 1 - c * c;
    if (c != 0)
      xl /= c;
    return line3(xl, xl + m);
  }

  static plane3 xy(real z=0) { return with_value( Z, z * Z); }
  static plane3 yx(real z=0) { return with_value(-Z, z * Z); }
  static plane3 yz(real x=0) { return with_value( X, x * X); }
  static plane3 zy(real x=0) { return with_value(-X, x * X); }
  static plane3 zx(real y=0) { return with_value( Y, y * Y); }
  static plane3 xz(real y=0) { return with_value(-Y, y * Y); }
}

void draw(
  picture pic=currentpicture, Label L="", line3 l, pen p=currentpen,
  projection P=currentprojection, real a=0, real b=1-a, real eps=1e-15,
  bool above=false)
{
  pair sw = point(pic, SW, false), ne = point(pic, NE, false);
  if (sw == ne) { // 2D drawing area is not available
    frame f = pic.fit3(P); // size includes fixed-size object
    sw = point(f, SW);
    ne = point(f, NE);
  }
  transform T = pic.calculateTransform();
  pair x1 = T * project(l.xH, P), x2 = T * project(l.xH + l.m, P);
  frame f;
  path g = ((eps < abs(x2 - x1)) ? line2(x1, x2).path(sw, ne) : x1);
  g = subpath(g, reltime(g, a), reltime(g, b));
  picture opic;
  draw(opic, L, g, p);
  add(pic, opic.fit(), above=above);
}

void dot3(
  picture pic=currentpicture, Label L="",
  triple c=O, real r=0.05, real rr=1.2*r, int NLAT=18, int NLON=36,
  pen fillcol=white, pen drawcol=black, align align=NoAlign,
  projection P=currentprojection, real away=0)
{
  triple n = (P.infinity) ? P.camera : dir(P.camera - c);
  if (P.infinity)
    c += away * n;
  path3 circ = circle(c=c, r=rr, normal=n);
  draw(pic, surface(circ), drawcol, nolight);
  revolution sph = sphere(c, r, n=NLAT);
  draw(pic, surface(sph, n=NLON), fillcol, nolight);
  if (L != "")
    label(pic, L, c, align=align);
}
