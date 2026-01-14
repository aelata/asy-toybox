// isoline.asy - isoline for complex argument (phase)

// (c) 2025 aelata
// This software is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

from contour access draw;

private pair[] resample(path p, int n) {
  int m = cyclic(p) ? n : n - 1;
  pair[] a = sequence(
    new pair(int i) { return relpoint(p, i / m); }, n);
  a.cyclic = cyclic(p);
  return a;
}

private guide collapse(
  pair[] a, interpolate join=operator --, bool3 cyclic=default)
{
  guide s = join(... a);
  if (cyclic == default)
    cyclic = a.cyclic;
  return cyclic ? join(s, cycle) : s;
}

private pair[][] _isoline( // f[nx + 1][ny + 1]
  real[][] f, real c, real g(real)=null)
{
  // int[] pow2 = sequence(new int(int k) { return 2**k; }, 8);
  static int[] pow2 = {
    1, 2, 4, 8, 16, 32, 64, 128}; // bits for SW, S, SE, E, NE, N, NW, W
  int log2(int n) {
    return 63 - CLZ(n); // return (popcount(intMax) + 1) - CLZ(n);
  }
  // step for next square
  static int[] si = {-1, 0, 1, 1, 1, 0, -1, -1};
  static int[] sj = {-1, -1, -1, 0, 1, 1, 1, 0};

  int nx = f.length - 1, ny = f[0].length - 1;
  real[][] t = new real[nx + 1][];
  for (int i: sequence(nx + 1))
    t[i] = (g == null) ? f[i] - c : map(g, f[i] - c);
  real[][] wx = new real[nx][ny + 1]; // intersections on horizontal edges
  real[][] wy = new real[nx + 1][ny]; // intersections on vertical   edges
  int[][] m = new int[nx][]; // m[nx][ny]: bit mask of intersections
  for (int i: sequence(nx)) {
    m[i] = array(ny, 0);
    real t00, t01 = t[i][0], t10, t11 = t[i + 1][0];
    for (int j: sequence(ny)) {
      t00 = t01; // t[i][j]
      t01 = t[i][j + 1];
      t10 = t11; // t[i + 1][j]
      t11 = t[i + 1][j + 1];
      if (isnan(t00) && isnan(t10) && isnan(t11) && isnan(t01)) continue;
      if (t00 < 0 && t10 < 0 && t11 < 0 && t01 < 0) continue;
      if (0 < t00 && 0 < t10 && 0 < t11 && 0 < t01) continue;
      int mij = 0;
      if (t00 == 0) mij += 1;  // SW
      if (t10 == 0) mij += 4;  // SE
      if (t11 == 0) mij += 16; // NE
      if (t01 == 0) mij += 64; // NW
      if (mij == 85) continue; // 85 == 1 + 4 + 16 + 64; i.e., all t == 0
      if (t00 * t10 < 0) { // S
        mij += 2;
        wx[i][j] = t00 / (t00 - t10);
      }
      if (t10 * t11 < 0) { // E
        mij += 8;
        wy[i + 1][j] = t10 / (t10 - t11);
      }
      if (t11 * t01 < 0) { // N
        mij += 32;
        wx[i][j + 1] = t01 / (t01 - t11);
      }
      if (t01 * t00 < 0) { // W
        mij += 128;
        wy[i][j] = t00 / (t00 - t01);
      }
      m[i][j] = mij;
    }
  }

  pair[] xy;
  void xy_push(int i, int j, int cij) {
    void _xy_push(pair z, real eps=1e-3) { // do not add close point
      if (xy.length == 0 || eps < abs(xy[xy.length - 1] - z))
        xy.push(z);
    }

    if        (cij == 1) {
      _xy_push((i + wx[i][j], j));
    } else if (cij == 3) {
      _xy_push((i + 1, j + wy[i + 1][j]));
    } else if (cij == 5) {
      _xy_push((i + wx[i][j + 1], j + 1));
    } else if (cij == 7) {
      _xy_push((i, j + wy[i][j]));
    } else if (cij == 0) { // 0, 2, 4, 6 are rare
      _xy_push((i, j));
    } else if (cij == 2) {
      _xy_push((i + 1, j));
    } else if (cij == 4) {
      _xy_push((i + 1, j + 1));
    } else if (cij == 6) {
      _xy_push((i, j + 1));
    }
  }

  pair[][] xys;
  void xys_push(pair[] xy, real eps=1e-3) {
    if (xy.length <= 1) return;
    if (1 < xys.length && xys[xys.length - 1][0] == xy[0]) return;
    xys.push(copy(xy));
  }

  void trace2(int i, int j, int mask) { // trace squares of two intersections
    int mij, cij;
    if (i < 0 || nx <= i || j < 0 || ny <= j) return;
    mij = m[i][j];
    if (mij == 0 || popcount(mij) != 2) return;
    mij = AND(mij, mask);
    if (mij == 0) return;
    cij = log2(mij); // pick the intersection on the mask
    xy.delete();
    xy_push(i, j, cij);
    while (0 <= i && i < nx && 0 <= j && j < ny) {
      mij = m[i][j];
      m[i][j] = 0;
      if (mij == 0 || popcount(mij) != 2) break;
      cij = log2(XOR(mij, pow2[cij])); // pick the other intersection
      xy_push(i, j, cij);
      if        (cij == 0 && 0 < i && popcount(m[i - 1][j]) == 2) {
        i -= 1;
        cij = 2;
      } else if (cij == 0 && 0 < j && popcount(m[i][j - 1]) == 2) {
        j -= 1;
        cij = 6;
      } else if (cij == 2 && 0 < j && popcount(m[i][j - 1]) == 2) {
        j -= 1;
        cij = 4;
      } else if (cij == 2 && i < nx - 1 && popcount(m[i + 1][j]) == 2) {
        i += 1;
        cij = 0;
      } else if (cij == 4 && i < nx - 1 && popcount(m[i + 1][j]) == 2) {
        i += 1;
        cij = 6;
      } else if (cij == 4 && j < ny - 1 && popcount(m[i][j + 1]) == 2) {
        j += 1;
        cij = 2;
      } else if (cij == 6 && j < ny - 1 && popcount(m[i][j + 1]) == 2) {
        j += 1;
        cij = 0;
      } else if (cij == 6 && 0 < i && popcount(m[i - 1][j]) == 2) {
        i -= 1;
        cij = 4;
      } else {
        i += si[cij];
        j += sj[cij];
        cij = (cij + 4) % 8; // code in next square
      }
    }
    xys_push(xy);
  }

  // search borders
  for (int i: sequence(nx)) // S
    trace2(i, 0, 7 /* 1 + 2 + 4 */);
  for (int j: sequence(ny)) // E
    trace2(nx - 1, j, 28 /* 4 + 8 + 16 */);
  for (int i: sequence(nx)) // N
    trace2(i, ny - 1, 112 /* 16 + 32 + 64 */);
  for (int j: sequence(ny)) // W
    trace2(0, j, 193 /* 64 + 128 + 1 */);
  // search inside (non-loop)
  for (int i: sequence(nx)) {
    for (int j: sequence(ny)) {
      int mij = m[i][j];
      if (mij == 0 || popcount(mij) != 1) continue;
      m[i][j] = 0;
      int cij = log2(mij);
      trace2(i + si[cij], j + sj[cij], pow2[(cij + 4) % 8]);
    }
  }
  // search inside (loop)
  for (int i: sequence(nx)) {
    for (int j: sequence(ny)) {
      int mij = m[i][j];
      if (mij == 0 || popcount(mij) != 2) continue;
      trace2(i, j, pow2[log2(mij)]); // pick one of the intersections
    }
  }

  return xys;
}

private pair[][][] _isoline( // f[nx + 1][ny + 1]
  real[][] f, real[] c, real g(real)=null)
{
  pair[][][] p = new pair[c.length][][];
  for (int k: sequence(c.length))
    p[k] = _isoline(f, c[k], g);
  return p;
}

guide[][] isoline( // f[nx + 1][ny + 1]
  real[][] f, real[] c,
  real g(real)=null, int n=0, interpolate join=operator --)
{
  pair[][][] p = _isoline(f, c, g);
  guide[][] q = new guide[p.length][];
  for (int i: sequence(p.length)) {
    guide[] qi = new guide[p[i].length];
    for (int j: sequence(p[i].length))
      qi[j] = collapse(
        (n <= 1) ? p[i][j] : resample(collapse(p[i][j], join), n),
        join);
    q[i] = qi;
  }

  return q;
}

guide[][] isoline( // f[nx + 1][ny + 1] in box(a, b)
  real[][] f, pair a, pair b, real[] c,
  real g(real)=null, int n=0, interpolate join=operator --)
{
  int nx = f.length - 1, ny = f[0].length - 1;
  real cx = (b.x - a.x) / nx, cy = (b.y - a.y) / ny;
  pair scale_xy(pair z) { return (cx * z.x + a.x, cy * z.y + a.y); }

  pair[][][] p = _isoline(f, c, g);
  guide[][] q = new guide[p.length][];
  for (int i: sequence(p.length)) {
    guide[] qi = new guide[p[i].length];
    for (int j: sequence(p[i].length)) {
      pair[] pij = map(
        scale_xy,
        (n <= 1) ? p[i][j] : resample(collapse(p[i][j], join), n));
      pij.cyclic = p[i][j].cyclic;
      qi[j] = collapse(pij, join);
    }
    q[i] = qi;
  }

  return q;
}

guide[][] isoline( // f(pair) in box(a, b)
  real f(pair), pair a, pair b, real[] c, int nx=100, int ny=nx,
  real g(real)=null, int n=0, interpolate join=operator --)
{
  real cx = (b.x - a.x) / nx, cy = (b.y - a.y) / ny;

  real[][] z = new real[nx + 1][];
  for (int i: sequence(nx + 1)) {
    real x = cx * i + a.x;
    z[i] = sequence(
      new real(int j) { return f((x, cy * j + a.y)); }, ny + 1);
  }

  return isoline(z, a, b, c, g, n, join);
}

guide[][] isoline( // f(real, real) in box(a, b)
  real f(real, real), pair a, pair b, real[] c, int nx=100, int ny=nx,
  real g(real)=null, int n=0, interpolate join=operator --)
{
  return isoline(
    new real(pair z) { return f(z.x, z.y); }, a, b, c, nx, ny, g, n, join);
}

real zc_phase(real t) {
  t = (t + pi) % 2pi - pi;
  return (abs(t) < pi / 6) ? t : nan;
}
