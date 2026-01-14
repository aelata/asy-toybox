## colpal
Color palette module

```cpp {cmd=env args=[asyco -n] output=none #prep hide}
import solids;
import colpal;

triple[] resample(guide3 g, int n) { // n points
  int m = cyclic(g) ? n : n - 1;
  triple[] a = sequence(
    new triple(int i) { return relpoint(g, i / m); }, n);
  a.cyclic = cyclic(g);
  return a;
}

guide3 resampled(guide3 g, int n, interpolate3 join=operator --) {
  return join(... resample(g, n));
}

guide3 collapse(
  triple[] a, interpolate3 join=operator --, bool3 cyclic=default)
{
  guide3 g = join(... a);
  if (cyclic == default)
    cyclic = a.cyclic;
  return cyclic ? join(g, cycle) : g;
}

currentlight = nolight;
currentprojection = orthographic(dir(56, 34 - 90), center=false);

int NLAT = 30, NLON = 90;
pen spen = white + opacity(0.6), bpen = black + 1bp;
```

```cpp {cmd=env args=[asyco -n] continue=prep output=none #prepCyl hide}
unitsize(3cm);
picture pic;
unitsize(pic, 3cm);

void draw_cyl(pen palcyl(real, real), pen palsph(real, real), string z) {
  real h = 2; // diameter of unit sphere
  revolution cyl = cylinder(r=1, h=h);
  void _erase_pre() {
    erase(pic);
    draw(pic, -2.5X -- 2.5X, Arrow3);
    draw(pic, -2.5Y -- 2.5Y, Arrow3);
  }

  void _post_add(pair xy) {
    draw(pic, cyl, backpen=nullpen);
    draw(pic, Label(z, EndPoint), h * Z -- 3Z, Arrow3);
    add(pic, xy);
  }

  /*
  _erase_pre();
  draw(pic, unitdisk, black); // bottom
  revolution r = revolution(
    O, resampled((1,0,0)--(1,0,h), NLAT + 1));
  pen[] cpal = colpal1(NLAT, NLON, palcyl);
  draw(pic, surface(r, NLON), cpal);
  draw(pic, shift(0, 0, h) * unitdisk, white); // top
  _post_add((0, 0));
  */
  _erase_pre();
  draw(pic, surface(unitcircle3), spen);
  draw(pic, surface(cyl), spen);
  draw(pic, cyl, backpen=0.8white + solid);
  revolution r = revolution(
    O, resampled((0, 0, 0) .. (1, 0, h / 2) .. (0, 0, h), NLAT + 1));
  pen[] cpal = colpal1(NLAT, NLON, palsph);
  draw(pic, surface(r, NLON), cpal);
  draw(pic, r.silhouette(), bpen);
  _post_add((4.5, 0));
}
```

```cpp {cmd=env args=[asyco -n] continue=prep output=none #prepLab hide}
triple _Lab_triple(pen p); // defined later

path3 Lab_path(pen p0, pen p1, int n=16) {
  real[] c0 = colors(rgb(p0));
  real[] c1 = colors(rgb(p1));
  triple v0 = (c0[0], c0[1], c0[2]);
  triple v1 = (c1[0], c1[1], c1[2]);
  triple f(int i) {
    triple v = interp(v0, v1, i / n);
    return _Lab_triple(rgb(v.x, v.y, v.z));
  }
  return operator --(... sequence(f, n + 1));
}

void Lab_face(
  picture pic=currentpicture,
  pen p0, pen p1, pen p2, pen surfacepen=nullpen, int nx=16, int ny=nx)
{
  real[] c0 = colors(rgb(p0)), c1 = colors(rgb(p1)), c2 = colors(rgb(p2));
  real[] dx = c1 - c0, dy = c2 - c0;
  triple[][] f = new triple[ny + 1][nx + 1];
  for (int i: sequence(ny + 1)) {
    for (int j: sequence(nx + 1)) {
      real[] c = c0 + dy * i / ny + dx * j / nx;
      f[i][j] = _Lab_triple(rgb(c[0], c[1], c[2]));
    }
  }
  if (surfacepen == nullpen) {
    pen[] p = new pen[nx * ny];
    for (int i: sequence(ny)) {
      for (int j: sequence(nx)) {
        real[] c = c0 + dy * (i + 0.5) / ny + dx * (j + 0.5) / nx;
        p[i * nx + j] = rgb(c[0], c[1], c[2]);
      }
    }
    draw(pic, surface(f), surfacepen=p, meshpen=nullpen);
  } else {
    draw(pic, surface(f), surfacepen=surfacepen, meshpen=nullpen);
  }
}

pen[] c6 = {red, yellow, green, cyan, blue, magenta};
```

```cpp {cmd=env args=[asyco -n] output=none #prepBar hide}
import graph;
import palette;
import colpal;

void draw_colpal(
  picture pic=currentpicture,
  pen pal(real, real), string xlab="$H,\ t$", string ylab="$L$",
  int NLAT=200, int NLON=180, pair l=(0, 1))
{
  pen[][] cpal = colpal(nl=NLAT, nt=NLON, pal);
  image(pic, cpal, (0, 0), (360, 100));
  draw(pic, box((0, 0), (360, 100)));
  xaxis(
    pic, Label(xlab, MidPoint), xmin=0.0, xmax=360.0,
    RightTicks(Ticks=new real[] {0, 90, 180, 270, 360}, Size=4));
  string tL(real y) { return format("%.3g", interp(l.x, l.y, y / 100)); }
  yaxis(
    pic, Label(ylab, MidPoint), ymin=0.0, ymax=100,
    LeftTicks(ticklabel=tL, Ticks=new real[] {0, 50, 100}, Size=4));
  string tl(real y) { return format("%.3g", interp(0, 1, y / 100)); }
  yaxis(
    pic, Label("$l$", MidPoint), axis=Right, ymin=0.0, ymax=100,
    RightTicks(ticklabel=tl, Ticks=new real[] {0, 50, 100}, Size=4));
}
```

### Cylindrical color space
#### HSL
```cpp {cmd=env args=[asyco -render 0] continue=prepCyl output=html .hide}
pen palcyl(real l, real t) { return HSL.RGB(t, 1.0, l); }
pen palsph(real l, real t) { return palHSL(l, t); }
draw_cyl(palcyl, palsph, "$L\ (2\times)$");
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
pen pal(real l, real t) { return palHSL(l, t); }
draw_colpal(pal, ylab="$L$");
```

#### HSI
```cpp {cmd=env args=[asyco -render 0] continue=prepCyl output=html .hide}
pen palcyl(real l, real t) { return HSI.RGB(t, 1.0, l); }
pen palsph(real l, real t) { return palHSI(l, t); }
draw_cyl(palcyl, palsph, "$I\ (2\times)$");
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
pen pal(real l, real t) { return palHSI(l, t); }
draw_colpal(pal, ylab="$I$");
```

#### HSY
```cpp {cmd=env args=[asyco -render 0] continue=prepCyl output=html .hide}
pen palcyl(real l, real t) { return HSY.RGB(t, 1.0, l); }
pen palsph(real l, real t) { return palHSY(l, t); }
draw_cyl(palcyl, palsph, "$Y\ (2\times)$");
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
pen pal(real l, real t) { return palHSY(l, t); }
draw_colpal(pal, ylab="$Y$");
```

### Uniform color space
#### CIELAB
```cpp {cmd=env args=[asyco -f svg -render 0] continue=prepLab output=html .hide}
_Lab_triple = new triple(pen p) { return Lab(p).triple(); };
pen pal(real l, real t) { return palLab(l, t); }
real A = 33.2, B = 28.5, C = 63.2; // from palLab

unitsize(3cm / 100);
picture pic;
unitsize(pic, 3cm / 100);

void _erase_pre() {
  erase(pic);
  draw(pic, Label("$a^*$", EndPoint), -200X -- 200X, Arrow3);
  draw(pic, Label("$b^*$", EndPoint), -200Y -- 200Y, Arrow3);
  draw(pic, O -- 100Z, grey);
}

void _post_add(pair xy) {
  for (int i: new int[] {1, 3, 5}) // front
    draw(pic, Lab_path(white, c6[i]));
  for (int i: sequence(6)) // border
    draw(pic, Lab_path(c6[i], c6[(i + 1) % 6]));
  draw(pic, Label("$L^*$", EndPoint), 100Z -- 200Z, Arrow3);
  add(pic, xy);
}

_erase_pre();
for (int i: new int[] {1, 3, 5}) // front
  Lab_face(pic, white, c6[i], c6[(i + 2) % 6]);
//_post_add((0, 0));

_erase_pre();
for (int i: new int[] {0, 2, 4}) { // back
  Lab_face(pic, black, c6[i], c6[(i + 2) % 6], spen);
  draw(pic, Lab_path(black, c6[i]), grey);
}
revolution sph =
  shift(C * Z) * scale(A, A, B) * sphere(O, 1, n=NLAT);
pen[] cpal = colpal1(nl=NLAT, nt=NLON, pal);
draw(pic, surface(sph, n=NLON), cpal);
// draw(pic, sph.silhouette());
revolution sph =
  scale(A, A, B) * sphere(O, 1, n=NLAT);
draw(pic, shift(C * Z) * sph.silhouette(), bpen); // workaround
_post_add((3.75 * 100, 0));
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
pen pal(real l, real t) { return palLab(l, t); }
real A = 33.2, B = 28.5, C = 63.2; // from palLab
draw_colpal(pal, ylab="$L*$", l=(C - B, C + B));
```

#### CIELUV
```cpp {cmd=env args=[asyco -f svg -render 0] continue=prepLab output=html .hide}
_Lab_triple = new triple(pen p) { return Luv(p).triple(); };
pen pal(real l, real t) { return palLuv(l, t); }
real A = 37.8, B = 36.0, C = 59.9; // from palLuv

unitsize(3cm / 100);
picture pic;
unitsize(pic, 3cm / 100);

void _erase_pre() {
  erase(pic);
  draw(pic, Label("$u^*$", EndPoint), -200X -- 200X, Arrow3);
  draw(pic, Label("$v^*$", EndPoint), -200Y -- 200Y, Arrow3);
  draw(pic, O -- 100Z, grey);
}

void _post_add(pair xy) {
  for (int i: new int[] {1, 3, 5}) // front
    draw(pic, Lab_path(white, c6[i]));
  for (int i: sequence(6)) // border
    draw(pic, Lab_path(c6[i], c6[(i + 1) % 6]));
  draw(pic, Label("$L^*$", EndPoint), 100Z -- 200Z, Arrow3);
  add(pic, xy);
}

_erase_pre();
for (int i: new int[] {1, 3, 5}) // front
  Lab_face(pic, white, c6[i], c6[(i + 2) % 6]);
//_post_add((0, 0));

_erase_pre();
for (int i: new int[] {0, 2, 4}) { // back
  Lab_face(pic, black, c6[i], c6[(i + 2) % 6], spen);
  draw(pic, Lab_path(black, c6[i]), grey);
}
revolution sph =
  shift(C * Z) * scale(A, A, B) * sphere(O, 1, n=NLAT);
pen[] cpal = colpal1(nl=NLAT, nt=NLON, pal);
draw(pic, surface(sph, n=NLON), cpal);
// draw(pic, sph.silhouette(), bpen);
revolution sph =
  scale(A, A, B) * sphere(O, 1, n=NLAT);
draw(pic, shift(C * Z) * sph.silhouette(), bpen); // workaround
_post_add((3.75 * 100, 0));
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
pen pal(real l, real t) { return palLuv(l, t); }
real A = 37.8, B = 36.0, C = 59.9; // from palLuv
draw_colpal(pal, ylab="$L*$", l=(C - B, C + B));
```

#### OKLab
```cpp {cmd=env args=[asyco -f svg -render 0] continue=prepLab output=html .hide}
_Lab_triple = new triple(pen p) { return OKLab(p).triple(); };
pen pal(real l, real t) { return palOKLab(l, t); }
real A = 0.106, B = 0.248, C = 0.671; // from palOKLab

unitsize(3cm / 0.5);
picture pic;
unitsize(pic, 3cm / 0.5);

void _erase_pre() {
  erase(pic);
  draw(pic, Label("$a$", EndPoint), -X -- X, Arrow3);
  draw(pic, Label("$b$", EndPoint), -Y -- Y, Arrow3);
  draw(pic, O -- Z, grey);
}

void _post_add(pair xy) {
  for (int i: new int[] {1, 3, 5}) // front
    draw(pic, Lab_path(white, c6[i]));
  for (int i: new int[] {0, 4}) // front
    draw(pic, Lab_path(black, c6[i]));
  for (int i: sequence(6))
    draw(pic, Lab_path(c6[i], c6[(i + 1) % 6]));
  draw(pic, Label("$L$", EndPoint), Z -- 1.5Z, Arrow3);
  add(pic, xy);
}

_erase_pre();
for (int i: new int[] {1, 3, 5}) // front
  Lab_face(pic, white, c6[i], c6[(i + 2) % 6]);
for (int i: new int[] {4}) // front
  Lab_face(pic, black, c6[i], c6[(i + 2) % 6]);
//_post_add((0, 0));

_erase_pre();
for (int i: new int[] {2}) // back
  draw(pic, Lab_path(black, c6[i]), grey);
revolution sph =
  shift(C * Z) * scale(A, A, B) * sphere(O, 1, n=NLAT);
pen[] cpal = colpal1(nl=NLAT, nt=NLON, pal);
draw(pic, surface(sph, n=NLON), cpal);
// draw(pic, sph.silhouette(), bpen);
revolution sph =
  scale(A, A, B) * sphere(O, 1, n=NLAT);
draw(pic, shift(C * Z) * sph.silhouette(), bpen); // workaround
_post_add((3.75 * 0.50, 0));
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
pen pal(real l, real t) { return palOKLab(l, t); }
real A = 0.106, B = 0.248, C = 0.671; // from palOKLab
draw_colpal(pal, ylab="$L$", l=(C - B, C + B));
```

### Cylindrical color subspace
$a \in [-1, 1],\ c \in (0,1),\ c \pm b \in [0, 1],\ n \in (0,\infty)$.

$$
\left|\frac{S}{a}\right|^n + \left|\frac{L - c}{b}\right|^n = 1
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import graph;

pair f(real t, real a=1, real b=0.5, real c=0.5, real n=2) {
  return (
    a * sgn(Cos(t)) * abs(Cos(t))**(2 / n),
    b * sgn(Sin(t)) * abs(Sin(t))**(2 / n) + c);
}

unitsize(3cm);

real h = 2; // diameter of unit sphere

xaxis(YZero, -1.5, 1.5, RightTicks(new real[] {-1, 1}), Arrow);
yaxis(XZero, -0.25h, 1.25h, Arrow);
label("$S$", (1.5, 0), E);
label(format("$L\ (%g\times)$", h), (0, 1.25h), N);
label("$O$", (0, 0), 1.5SW);
label("$1$", (0, h), 1.5NW);
draw(box((-1, 0), (1, h)));

real a = 0.8, b = 0.4, c = 0.5;
string s = format("$a=%g, ", a) + format("b=%g, ", b) + format("c=%g$", c);
b *= h;
c *= h;
dot("$c$", (0, c), 2W);
draw("$a$", (0, c) -- (a, c), Arrow);
draw("$b$", (0, c) -- (0, c + b), Arrow, align=W);

draw(
  graph(new pair(real t) { return f(t, a, b, c, 3); }, 0, 360),
  blue+1bp);
draw(
  graph(new pair(real t) { return f(t, a, b, c, 2); }, 0, 360),
  black+1bp);
draw(
  graph(new pair(real t) { return f(t, a, b, c, 1); }, 0, 360),
  red+1bp);

add(align(s, NE), (-1.75, 1.25h), align=SE);
add(align(pack(Label("$n=3$", blue), "$n=2$", Label("$n=1$", red)), SE), (1, 1.25h));
```

```cpp {cmd=env args=[asyco -render 0] continue=prep output=html #prepHSY .hide}
unitsize(3cm);

triple f(real t, real a=1, real b=0.5, real c=0.5, real n=2) {
  return (
    a * sgn(Cos(t)) * abs(Cos(t))**(2 / n), 0,
    b * sgn(Sin(t)) * abs(Sin(t))**(2 / n) + c);
}

void draw_HSY(real a=1, real b=0.5, real c=0.5, real n=2) {
  real h = 2; // diameter of unit sphere
  revolution cyl = cylinder(r=1, h=h);
  draw(-2.5X -- 2.5X, Arrow3);
  draw(-2.5Y -- 2.5Y, Arrow3);
  draw(O -- h * Z);

  draw(surface(unitcircle3), spen);
  draw(surface(cyl), spen);
  draw(surface(shift(h * Z) * unitcircle3), spen);
  draw(cyl, backpen=0.8white + solid + 1pt);

  revolution r = revolution(
    O, resampled((0, 0, 0) .. (1, 0, h / 2) .. (0, 0, h), NLAT + 1));

  int NLAT = 36, NLON = 72;
  path3 p = collapse(sequence(
    new triple(int i) { return f(-90 + 180 * (i / NLAT), a, b * h, c * h, n); },
    NLAT + 1));
  p = resampled(p, NLAT + 1);
  real[] z = sequence(new real(int i) { return point(p, i).z; }, NLAT + 1);
  real[] l = sequence(new real(int i) { return 0.5 * (z[i] + z[i + 1]); }, NLAT);
  l  = (l / h - (c - b)) / (2b);
  revolution r = revolution(O, p);
  pen pal(real l, real t) { return palHSY(l, t, a, b, c, n); }
  pen[] cpal = colpal1(l, NLON, pal);
  draw(surface(r, NLON), cpal);

  if (1 < n) {
    draw(r.silhouette(), bpen);
  } else {
    revolution rt = revolution(O, subpath(p, reltime(p, 0.5), reltime(p, 1)));
    draw(rt, m=2, bpen, nullpen);
    revolution rb = revolution(O, subpath(p, reltime(p, 0), reltime(p, 0.5)));
    draw(rb, m=2, nullpen, nullpen, bpen);
  }

  draw(cyl, backpen=nullpen);
  draw(h * (b + c) * Z --  h * Z -- 3Z, grey);
  draw(Label("$Y\ (2 \times)$", EndPoint), h * Z -- 3Z, Arrow3);
}
```

#### HSY, n = 3 (spheroid)
```cpp {cmd=env args=[asyco -render 0] continue=prepHSY output=html .hide}
draw_HSY(a=0.8, b=0.4, c=0.5, n=3);
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
real a = 0.8, b = 0.4, c = 0.5, n = 3;
pen pal(real l, real t) { return palHSY(l, t, a, b, c, n); }
draw_colpal(pal, ylab="$Y$", l = (c - b, c + b));
```

#### HSY, n = 2 (sphere)
```cpp {cmd=env args=[asyco -render 0] continue=prepHSY output=html .hide}
draw_HSY(a=0.8, b=0.4, c=0.5, n=2);
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
real a = 0.8, b = 0.4, c = 0.5, n = 2;
pen pal(real l, real t) { return palHSY(l, t, a, b, c, n); }
draw_colpal(pal, ylab="$Y$", l = (c - b, c + b));
```

#### HSY, n = 1 (bicone)
```cpp {cmd=env args=[asyco -render 0] continue=prepHSY output=html .hide}
draw_HSY(a=0.8, b=0.4, c=0.5, n=1);
```

```cpp {cmd=env args=[asyco] continue=prepBar output=html .hide}
unitsize(16cm / 400);
real a = 0.8, b = 0.4, c = 0.5, n = 1;
pen pal(real l, real t) { return palHSY(l, t, a, b, c, n); }
draw_colpal(pal, ylab="$Y$", l = (c - b, c + b));
```

---
