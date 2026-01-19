// geom2.asy - miscellaneous 2D geometry functions

// (c) 2025-2026 aelata
// This software is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

real[] reals(pair a) { // cast may cause ambiguity
  return new real[] {a.x, a.y};
}

pair[] pairs(guide p) {
  pair[] a = sequence(
    new pair(int i) { return point(p, i); }, size(p));
  a.cyclic = cyclic(p);
  return a;
}

pair[] resample(guide g, int n) { // n pts
  int m = cyclic(g) ? n : n - 1;
  pair[] a = sequence(
    new pair(int i) { return relpoint(g, i / m); }, n);
  a.cyclic = cyclic(g);
  return a;
}

guide collapse(
  pair[] a, interpolate join=operator --, bool3 cyclic=default)
{
  guide g = join(... a);
  if (cyclic == default)
    cyclic = a.cyclic;
  return cyclic ? join(g, cycle) : g;
}

guide resampled(guide g, int n, interpolate join=operator --) {
  return collapse(resample(g, n), join);
}

void mark_angle(
  picture pic=currentpicture, Label L="", pair A, pair O, pair B,
  real size=16bp, pen p=currentpen)
{
  void d(frame f, transform t) {
    path g = arc(t * O, t * O + size * unit(t * (A - O)), t * B);
    picture opic;
    draw(opic, L=L, g, p=p);
    add(f, opic.fit());
  }
  pic.add(d);
}

void mark_right_angle(
  picture pic=currentpicture, pair A, pair O, pair B,
  real size=8bp, pen p=currentpen)
{
  void d(frame f, transform t) {
    pair dA = size * unit(t * (A - O));
    pair dB = size * unit(t * (B - O));
    path g = shift(t * O) * (dA -- (dA + dB) -- dB);
    draw(f, g, p);
  }
  pic.add(d);
}

// m must be an unit direction vector
pair project(pair m, pair a) { return dot(m, a) * m; }
pair reject(pair m, pair a) { return a - dot(m, a) * m; }
pair reflect(pair m, pair a) { return -a + 2 dot(m, a) * m; }

struct line2 {
  pair m;
  pair xH;

  static line2 with_value(pair m, pair xH=(0, 0)) { // factory method
    line2 l = new line2;
    l.m = unit(m);
    l.xH = reject(l.m, xH);
    return l;
  }
  pair[] value() { return new pair[] {m, xH}; } // writable something

  void operator init(pair x1, pair x2) {
    m = unit(x2 - x1);
    xH = reject(m, x1);
  }
  void operator init(path p) { // use the first two points
    operator init(point(p, 0), point(p, 1));
  }

  pair project(pair a) { return a + reject(m, xH - a); }
  pair reflect(pair a) { return a + 2 reject(m, xH - a); }
  real distance(pair a) { return cross(m, a - xH); }
  line2 reflect(line2 l) {
    return line2(reflect(l.xH), reflect(l.xH + l.m));
  }
  pair intersect(line2 l) {
    real d = cross(m, l.m);
    return (d != 0) ? xH + cross(l.xH - xH, l.m) / d * m : (inf, inf);
  }
  static line2 x(real y=0) { return with_value((1, 0), (0, y)); }
  static line2 y(real x=0) { return with_value((0, 1), (x, 0)); }
  pair x_intercept(real y=0) { return intersect(line2.x(y)); }
  pair y_intercept(real x=0) { return intersect(line2.y(x)); }
  real intersect(pair a, pair b) {
    real d =  cross(m, b - a);
    return (d != 0) ? cross(m, xH - a) / d : inf;
  }

  path path(real a=-1, real b=-a, real o=0) {
    return interp(xH, xH + m, a + o) -- interp(xH, xH + m, b + o);
  }

  path path(pair a, pair b, real eps=1e-15) { // clipped by rectangle
    static int log2(int n) { return 63 - CLZ(n); }

    pair lo = minbound(a, b), hi = maxbound(a, b);
    pair[] p = new pair[8];
    p[0:4] = new pair[] {lo, (hi.x, lo.y), hi, (lo.x, hi.y)};
    real[] d = new real[4];

    int c = 0;
    for (int i: sequence(4)) {
      d[i] = distance(p[i]);
      if (abs(d[i]) < eps)
        c += 2**i;
    }
    if (d[0] * d[1] < 0) {
      c += 2**4;
      p[4] = x_intercept(lo.y);
    }
    if (d[1] * d[2] < 0) {
      c += 2**5;
      p[5] = y_intercept(hi.x);
    }
    if (d[2] * d[3] < 0) {
      c += 2**6;
      p[6] = x_intercept(hi.y);
    }
    if (d[3] * d[0] < 0) {
      c += 2**7;
      p[7] = y_intercept(lo.x);
    }
    if (popcount(c) != 2)
      return nullpath;

    int i0 = log2(c), i1 = log2(XOR(c, 2**i0));
    return (dot(m, p[i0]) < dot(m, p[i1])) ?
      p[i0] -- p[i1] : p[i1] -- p[i0];
  }
}

line2 operator *(transform T, line2 l) {
  return line2(T * l.xH, T * (l.xH + l.m));
}

void draw(
  picture pic=currentpicture, Label L="", line2 l, pen p=currentpen)
{
  guide g = l.path(point(pic, SW), point(pic, NE));
  if (g == nullpath) return;
  draw(pic, g, p);
  if (L != "")
    label(pic, L, g, p);
}
