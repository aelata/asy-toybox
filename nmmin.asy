// nmmin.asy - Nelder-Mead minimization

// (c) 2025-2026 aelata
// This script is licensed under the MIT No Attribution license (MIT-0).
// https://opensource.org/license/mit-0

real[][] nmini(real[] x, real[] s=array(x.length, 1.0)) {
  int n = x.length;
  real c = 1 / (sqrt(n + 1) + 2);
  real[][] v = new real[n + 1][n + 1];
  v[0][0] = 0;
  for (int j: sequence(n))
    v[0][1 + j] = x[j];
  for (int i: sequence(n)) {
    v[i + 1][0] = 0;
    for (int j: sequence(n))
      v[i + 1][1 + j] = x[j];
    v[i + 1][1 + i] += c * s[i];
  }
  return v;
}

real[] nmmin(
  real f(real[]), real[][] v,
  real[] tol=array(v.length - 1, 1e-3), int MAX_ITER=100,
  bool verbose=true)
{
  int n = v.length - 1;
  real ALPHA = 1, BETA = 1 + 2 / n, GAMMA = 0.75 - 0.5 / n, SIGMA = 1 - 1 / n;
  for (int i: sequence(v.length))
    v[i][0] = f(v[i][1:]);
  real[] c = new real[v.length]; // centroid
  for (int iter: sequence(MAX_ITER)) {
    v = sort(v);
    if (verbose) {
      write("#", iter, v[0][0]);
      write(v[0][1:], v[n][1:] - v[0][1:]);
    }
  if (all(abs(v[n][1:] - v[0][1:]) < tol)) break;
    for (int j: sequence(1, n)) {
      c[j] = 0;
      for (int i: sequence(n)) // except worst (last)
        c[j] += v[i][j];
      c[j] /= n;
    }
    c[0] = 0;
    real[] r = c - ALPHA * (v[n] - c); // reflection
    r[0] = f(r[1:]);
    if        (r[0] < v[0][0]) {
      real[] e = c - BETA * (v[n] - c); // expansion
      e[0] = f(e[1:]);
      v[n] = (e[0] < r[0]) ? e : r;
    } else if (r[0] < v[n - 1][0]) {
      v[n] = r;
    } else if (r[0] < v[n][0]) {
      real[] oc = c - GAMMA * (v[n] - c); // outside contraction
      oc[0] = f(oc[1:]);
      if (oc[0] < r[0]) {
        v[n] = oc;
      } else { // shrink
        for (int i: sequence(1, n)) {
          v[i] = v[0] + SIGMA * (v[i] - v[0]);
          v[i][0] = f(v[i][1:]);
        }
      }
    } else {
      real[] ic = c + GAMMA * (v[n] - c); // inside contraction
      ic[0] = f(ic[1:]);
      if (ic[0] < r[0]) {
        v[n] = ic;
      } else { // shrink
        for (int i: sequence(1, n)) {
          v[i] = v[0] + SIGMA * (v[i] - v[0]);
          v[i][0] = f(v[i][1:]);
        }
      }
    }
  }
  return v[0][1:];
}
