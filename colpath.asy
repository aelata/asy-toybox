// colpath.asy - draw path with color gradient

// (c) 2025-2026 aelata
// This software is licensed under the MIT No Attribution (MIT-0) License.
// https://opensource.org/license/mit-0

import three;

import geom2;
import geom3;

void draw(
  picture pic=currentpicture, path p, pen p0, pen p1, int n=16)
{
  p = resampled(p, n);
  for (int i = 0; i < n; i += 1)
    draw(pic, subpath(p, i, i + 1), interp(p0, p1, (i + 0.5) / n));
}

void draw_colpath(
  picture pic=currentpicture, guide g, pen[] c, int n=96,
  interpolate join=operator --, int primary_pen=0)
{
  int l = c.length;
  if (1 < l) {
    if (0 <= primary_pen)
      for (int i: sequence(l))
        c[i] = colorless(c[primary_pen]) + rgb(c[i]);
    if (cyclic(g)) {
      g = resampled(g, n, join); // n pts, n segs
      for (int i: sequence(n)) {
        real t = l * (i + 0.5) / n;
        int k = floor(t);
        draw(subpath(g, i, i + 1), interp(c[k % l], c[(k + 1) % l], t - k));
      }
    } else {
      g = resampled(g, n + 1, join); // n + 1 pts, n segs
      for (int i: sequence(n)) {
        real t = (l - 1) * (i + 0.5) / n;
        int k = floor(t);
        draw(subpath(g, i, i + 1), interp(c[k], c[k + 1], t - k));
      }
    }
  } else {
    draw(pic, g, (l == 1) ? c[0] : currentpen);
  }
}

void draw(
  picture pic=currentpicture, path3 p, pen p0, pen p1, int n=16)
{
  p = resampled(p, n);
  for (int i = 0; i < n; i += 1)
    draw(pic, subpath(p, i, i + 1), interp(p0, p1, (i + 0.5) / n));
}

void draw_colpath( // draw path3 with color segments
  picture pic=currentpicture, guide3 g, pen[] c, int n=96,
  interpolate3 join=operator --, int primary_pen=0)
{
  int l = c.length;
  if (1 < l) {
    if (0 <= primary_pen)
      for (int i: sequence(l))
        c[i] = colorless(c[primary_pen]) + rgb(c[i]);
    if (cyclic(g)) {
      g = resampled(g, n, join); // n pts, n segs
      for (int i: sequence(n)) {
        real t = l * (i + 0.5) / n;
        int k = floor(t);
        draw(subpath(g, i, i + 1), interp(c[k % l], c[(k + 1) % l], t - k));
      }
    } else {
      g = resampled(g, n + 1, join); // n + 1 pts, n segs
      for (int i: sequence(n)) {
        real t = (l - 1) * (i + 0.5) / n;
        int k = floor(t);
        draw(subpath(g, i, i + 1), interp(c[k], c[k + 1], t - k));
      }
    }
  } else {
    draw(pic, g, (l == 1) ? c[0] : currentpen);
  }
}
