## colspc
RGB color space, Cylindrical color space (CCS), and Uniform color space (UCS).

```cpp {cmd=asyco args=[-n] #prep output=none hide}
import colpal;
import geom3;

currentlight = nolight;
currentprojection = orthographic(dir(64, 36 - 90), center=false);

unitsize(3cm);

picture pic;
unitsize(pic, 3cm);

real s = sqrt(3 / 2);
real h = s * sqrt(3); // diagonal length of unit cube

string[] l6 = {"R", "Y", "G", "C", "B", "M", "$O$", "W"};
pen[] c6 = {red, yellow, green, cyan, blue, magenta, black, white};

int NLAT = 30, NLON = 90;
pen spen = white + opacity(0.6), bpen = black + 1bp; // surfacepen and meshpen
```

### RGB color space
```cpp {cmd=asyco args=[-n] continue=prep #rgb output=none hide}
triple[] t6 = {
  (1, 0, 0), (1, 1, 0), (0, 1, 0), (0, 1, 1), (0, 0, 1), (1, 0, 1),
  (0, 0, 0), (1, 1, 1)
};
path3[] ph = new path3[6]; // polyhedron == cube
pen[][] fc = new pen[6][]; // face color
for (int i: sequence(6)) {
  int j = (i + 1) % 6, k = (i + 2) % 6, o = 6 + i % 2;
  ph[i] = t6[o] -- t6[i] -- t6[j] -- t6[k] -- cycle;
  fc[i] = new pen[] {c6[o], c6[i], c6[j], c6[k]};
}
```

```cpp {cmd=asyco args=[--dothide -render 0] continue=rgb output=html .hide}
transform3 T = scale3(s);
ph = T * ph;
t6 = T * t6;
pair[] a6 = new pair[] {S, S, S, N, W, N, S, N} * 2.5;

erase(pic);
draw(pic, Label("$R$", EndPoint), -2.5X -- 2.5X, Arrow3);
draw(pic, Label("$G$", EndPoint), -2.5Y -- 2.5Y, Arrow3);
draw(pic, Label("$B$", EndPoint), O -- 3Z, Arrow3);
for (int i: sequence(6))
  draw(pic, surface(ph[i]), spen, bpen);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, Label("$R$", EndPoint), -2.5X -- 2.5X, Arrow3);
draw(pic, Label("$G$", EndPoint), -2.5Y -- 2.5Y, Arrow3);
draw(pic, Label("$B$", EndPoint), O -- 3Z, Arrow3);
label(pic, l6[6], t6[6], a6[6]);
for (int i: new int[] {3, 4, 5}) { // front
  draw(pic, surface(scale(ph[i], 1.01), fc[i]));
  draw(pic, ph[i], bpen);
}
add(pic, (4.5, 0));
```

<div style="break-after:page;"></div>

### Cylindrical color space
#### HSI
```cpp {cmd=asyco args=[-render 0] continue=rgb output=html .hide}
transform3 T = scale3(s);
T = rotate(-30, Z) * rotate(aTan(sqrt(2)), X) * rotate(45, Z) * T;
ph = T * ph;
t6 = T * t6;
pair[] a6 = new pair[] {E, E, N, W, W, S, S, NW} * 2.5;

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
for (int i: new int[] {0, 1, 2}) // back
  draw(pic, surface(ph[i]), spen, bpen);
draw(pic, Label("$I$", EndPoint), O -- 3Z, Arrow3);
for (int i: new int[] {3, 4, 5}) // front
  draw(pic, surface(ph[i]), spen, bpen);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, Label("$I$", EndPoint), O -- 3Z, Arrow3);
label(pic, l6[6], t6[6], a6[6]);
for (int i: new int[] {3, 4, 5}) { // front
  draw(pic, surface(scale(ph[i], 1.01), fc[i]));
  draw(pic, ph[i], bpen);
}
add(pic, (4.5, 0));
```

```cpp {cmd=asyco args=[-render 0] continue=rgb output=html .hide}
transform3 T = scale3(s);
T = rotate(-30, Z) * rotate(aTan(sqrt(2)), X) * rotate(45, Z) * T;
ph = T * ph;
t6 = T * t6;
pair[] a6 = new pair[] {N, S, N, S, N, S, S, W} * 2.5;

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, O -- h * Z);

revolution r = cylinder(r=1, h=h);
skeleton s = r.skeleton(currentprojection);
for (int i: sequence(1, 2))
  r.transverse(s, i / 3, currentprojection);
for (int i: sequence(1, 2))
  draw(pic, s.transverse.back[i], gray(0.0)+dashed);
draw(pic, surface(r), white+opacity(0.6));
draw(pic, surface(unitcircle3), white+opacity(0.6));
draw(pic, shift(h * Z) * surface(unitcircle3), white+opacity(0.6));
for (int i: sequence(2, 3))
  draw(pic, s.transverse.front[i], gray(0.5)+dashed);
draw(pic, r, frontpen=black+1bp, backpen=0.8white+solid+1bp);

draw(pic, Label("$I$", EndPoint), h * Z -- 3Z, Arrow3);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, unitdisk, black); // bottom
revolution r = revolution(O, resampled((1,0,0)--(1,0,h), NLAT + 1));
pen pal(real l, real t) { return HSI.RGB(t, 1.0, l); }
pen[] cpal = colpal1(NLAT, NLON, pal);
draw(pic, surface(r, NLON), cpal);
draw(pic, shift(0, 0, h) * unitdisk, white); // top

revolution r = cylinder(r=1, h=h);
draw(pic, r, black+1bp, nullpen);
draw(pic, Label("$I$", EndPoint), h * Z -- 3Z, Arrow3);

add(pic, (4.5, 0));
```

<div style="break-after:page;"></div>

#### HSV
```cpp {cmd=asyco args=[-n] continue=prep #hsv output=none .hide}
path3 p6 = shift(h * Z) * path3(subpath(polygon(6), 1, 7) & cycle);
triple[] t6 = triples(p6);
t6.append(new triple[] {O, h * Z});
```

```cpp {cmd=asyco args=[-render 0 --clip-prefix=h6-] continue=hsv output=html .hide}
pair[] a6 = new pair[] {SE, NE, N, NW, SW, SW, S, W} * 2.5;

path3[] ph = new path3[12]; // polyhedron == hexagonal pyramid
pen[][] fc = new pen[12][];
for (int i: sequence(6)) {
  int j = (i + 1) % 6;
  ph[i] = O -- t6[i] -- t6[j] -- cycle;
  ph[i + 6] = h * Z -- t6[i] -- t6[j] -- cycle;
  fc[i] = new pen[] {black, c6[i], c6[j]};
  fc[i + 6] = new pen[] {white, c6[i], c6[j]};
}

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
for (int i: new int[] {0, 1, 2, 3}) // back
  draw(pic, surface(ph[i]), spen, bpen);
draw(pic, O -- h * Z);
for (int i: new int[] {4, 5}) // front side
  draw(pic, surface(ph[i]), spen, bpen);
draw(pic, surface(p6), spen); // front top
draw(pic, p6, bpen);

draw(pic, Label("$V$", EndPoint), h * Z -- 3Z, Arrow3);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
label(pic, "$O$", O, 2.5S);
for (int i: new int[] {4, 5, 6, 7, 8, 9, 10, 11}) // front
  draw(pic, surface(scale(ph[i], 1.02), fc[i]));
for (int i: new int[] {4, 5}) // front side
  draw(pic, ph[i], bpen);
draw(pic, p6, bpen); // front top
draw(pic, Label("$V$", EndPoint), h * Z -- 3Z, Arrow3);
add(pic, (4.5, 0));
```

```cpp {cmd=asyco args=[-render 0] continue=hsv output=html .hide}
pair[] a6 = new pair[] {S, N, N, N, S, S, S, W} * 2.5;

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, O -- h * Z, grey);

revolution r = cylinder(r=1, h=h);
draw(pic, surface(r), white+opacity(0.6));
draw(pic, surface(unitcircle3), white+opacity(0.6));
draw(pic, shift(h * Z) * surface(unitcircle3), white+opacity(0.6));
draw(pic, r, frontpen=black+1bp, backpen=0.8white+solid+1bp);
draw(pic, Label("$V$", EndPoint), h * Z -- 3Z, Arrow3);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
// bottom
draw(pic, unitdisk, black);
// cylinder
revolution r = revolution(O, resampled((1,0,0)--(1,0,h), NLAT + 1));
surface s = surface(r, NLON);
pen pal(real l, real t) { return HSV.RGB(t, 1.0, l); }
pen[] cpal = colpal1(NLAT, NLON, pal);
draw(pic, s, cpal);
// top
r = revolution(O, resampled((0,0,h)--(1,0,h), NLAT + 1));
s = surface(r, NLON);
pen pal(real l, real t) { return HSV.RGB(t, l, 1.0); }
pen[] cpal = colpal1(NLAT, NLON, pal);
draw(pic, s, cpal);

draw(pic, cylinder(r=1, h=h), black+1bp, nullpen);
draw(pic, Label("$V$", EndPoint), h * Z -- 3Z, Arrow3);

add(pic, (4.5, 0));
```

#### HSL
```cpp {cmd=asyco args=[-n] continue=prep #hsl output=none .hide}
path3 p6 = shift(0.5h * Z) * path3(subpath(polygon(6), 1, 7) & cycle);
triple[] t6 = triples(p6);
t6.append(new triple[] {O, h * Z});
```

```cpp {cmd=env args=[asyco -render 0] continue=hsl output=html .hide}
pair[] a6 = new pair[] {E, E, dir(-50), W, W, dir(122), S, NW} * 2.5;
path3[] ph = new path3[12]; // polyhedron == hexagonal bipyramid
pen[][] fc = new pen[12][];
for (int i: sequence(6)) {
  int j = (i + 1) % 6;
  ph[i] = O -- t6[i] -- t6[j] -- cycle;
  ph[i + 6] = h * Z -- t6[i] -- t6[j] -- cycle;
  fc[i] = new pen[] {black, c6[i], c6[j]};
  fc[i + 6] = new pen[] {white, c6[i], c6[j]};
}

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
for (int i: new int[] {0, 1, 2, 3, 7, 8}) // back
  draw(pic, surface(ph[i]), spen, bpen);
draw(pic, Label("$L$", EndPoint), O -- 3Z, Arrow3);
for (int i: new int[] {4, 5, 6, 9, 10, 11}) // front
  draw(pic, surface(ph[i]), spen, bpen);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, Label("$L$", EndPoint), O -- 3Z, Arrow3);
label(pic, l6[6], t6[6], a6[6]);
for (int i: new int[] {4, 5, 6, 9, 10, 11}) { // front
  draw(pic, surface(scale(ph[i], 1.01), fc[i]));
  draw(pic, ph[i], bpen);
}
add(pic, (4.5, 0)); // 3D elements over polyhedron
```

```cpp {cmd=env args=[asyco -render 0] continue=hsl output=html .hide}
pair[] a6 = new pair[] {N, N, S, N, N, N, S, W} * 2.5;

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, O -- h * Z);

revolution r = cylinder(r=1, h=h);
skeleton s = r.skeleton(currentprojection);
r.transverse(s, 0.5, currentprojection);
draw(pic, s.transverse.back[1], gray(0.5)+dashed);
draw(pic, surface(r), white+opacity(0.6));
draw(pic, surface(unitcircle3), white+opacity(0.6));
draw(pic, shift(h * Z) * surface(unitcircle3), white+opacity(0.6));
draw(pic, s.transverse.front[2], gray(0.5)+dashed);
draw(pic, r, frontpen=black+1bp, backpen=0.8white+solid+1bp);

draw(pic, Label("$L$", EndPoint), h * Z -- 3Z, Arrow3);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, unitdisk, black); // bottom
revolution r = revolution(O, resampled((1,0,0)--(1,0,h), NLAT + 1));
pen pal(real l, real t) { return HSL.RGB(t, 1.0, l); }
pen[] cpal = colpal1(NLAT, NLON, pal);
draw(pic, surface(r, NLON), cpal);
draw(pic, shift(0, 0, h) * unitdisk, white); // top

revolution r = cylinder(r=1, h=h);
draw(pic, r, black+1bp, nullpen);
draw(pic, Label("$L$", EndPoint), h * Z -- 3Z, Arrow3);

add(pic, (4.5, 0));
```

<div style="break-after:page;"></div>

#### HSY
```cpp {cmd=env args=[asyco -n] continue=prep #hsy output=none .hide}
path3 p6 = shift(0.5h * Z) * path3(subpath(polygon(6), 1, 7) & cycle);
triple[] t6 = triples(p6);
t6.append(new triple[] {O, h * Z});
for (int i: sequence(6))
  t6[i] = (t6[i].x, t6[i].y, h * HSY(c6[i]).Y);
```

```cpp {cmd=env args=[asyco -render 0] continue=hsy output=html .hide}
path3[] ph = new path3[12]; // polyhedron == dodecahedron
pen[][] fc = new pen[12][]; // face color
for (int i: sequence(6)) {
  int j = (i + 1) % 6;
  ph[i] = O -- t6[i] -- t6[j] -- cycle;
  ph[i + 6] = h * Z -- t6[i] -- t6[j] -- cycle;
  fc[i] = new pen[] {black, c6[i], c6[j]};
  fc[i + 6] = new pen[] {white, c6[i], c6[j]};
}
pair[] a6 = new pair[] {E, N, N, N, NW, NW, S, 1.2dir(212)} * 2.5;

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, O -- h * Z);
for (int i: new int[] {0, 1, 2, 3}) // back
  draw(pic, surface(ph[i]), spen, bpen);
draw(pic, Label("$Y$", EndPoint), h * Z -- 3Z, Arrow3);
for (int i: new int[] {4, 5, 6, 7, 8, 9, 10, 11}) // front
  draw(pic, surface(ph[i]), spen, bpen);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
label(pic, "$O$", O, 2.5S);
for (int i: new int[] {4, 5, 6, 7, 8, 9, 10, 11}) { // front
  draw(pic, surface(scale(ph[i], 1.01), fc[i]));
  draw(pic, ph[i], bpen);
}
draw(pic, Label("$Y$", EndPoint), h * Z -- 3Z, Arrow3);
add(pic, (4.5, 0));
```

```cpp {cmd=env args=[asyco -f svg -render 0 --dothide] output=html continue=hsy .hide}
pair[] a6 = new pair[] {SSW, SW, SE, SE, N, N, S, W} * 2.5;

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, O -- h * Z, grey);
revolution r = cylinder(r=1, h=h);
skeleton s = r.skeleton(P=currentprojection);
for (int i: sequence(6))
  r.transverse(s=s, t=t6[i].z / h, P=currentprojection);
for (int i: sequence(6))
  draw(pic, s.transverse.back[i + 1], black+dashed);
draw(pic, surface(r), white+opacity(0.6));
draw(pic, surface(unitcircle3), white+opacity(0.6));
draw(pic, shift(h * Z) * surface(unitcircle3), white+opacity(0.6));
for (int i: sequence(6))
  draw(pic, s.transverse.front[i + 2], gray(0.5)+dashed);
draw(pic, r, frontpen=black+1bp, backpen=0.8white+solid+1bp);
draw(pic, Label("$Y$", EndPoint), h * Z -- 3Z, Arrow3);
for (int i: sequence(8))
  dot3(pic, l6[i], t6[i], c6[i], a6[i]);
add(pic, (0, 0));

erase(pic);
draw(pic, -2.5X -- 2.5X, Arrow3);
draw(pic, -2.5Y -- 2.5Y, Arrow3);
draw(pic, unitdisk, black); // bottom
revolution r = revolution(O, resampled((1,0,0)--(1,0,h), NLAT + 1));
pen pal(real l, real t) { return HSY.RGB(t, 1.0, l); }
pen[] cpal = colpal1(NLAT, NLON, pal);
draw(pic, surface(r, NLON), cpal);
draw(pic, shift(0, 0, h) * unitdisk, white); // top

revolution r = cylinder(r=1, h=h);
draw(pic, r, bpen, nullpen);
draw(pic, Label("$Y$", EndPoint), h * Z -- 3Z, Arrow3);
add(pic, (4.5, 0));
```

<div style="break-after:page;"></div>

### Uniform color space
```cpp {cmd=env args=[asyco -n] #ucs output=html hide}
import geom3;
import colpal;

triple _ucs_triple(pen p); // defined later

path3 ucs_path(pen p0, pen p1, int n=16) {
  real[] c0 = colors(rgb(p0));
  real[] c1 = colors(rgb(p1));
  triple v0 = (c0[0], c0[1], c0[2]);
  triple v1 = (c1[0], c1[1], c1[2]);
  triple f(int i) {
    triple v = interp(v0, v1, i / n);
    return _ucs_triple(rgb(v.x, v.y, v.z));
  }
  return operator --(... sequence(f, n + 1));
}

void ucs_face(
  picture pic=currentpicture,
  pen p0, pen p1, pen p2, pen surfacepen=nullpen, int nx=16, int ny=nx)
{
  real[] c0 = colors(rgb(p0)), c1 = colors(rgb(p1)), c2 = colors(rgb(p2));
  real[] dx = c1 - c0, dy = c2 - c0;
  triple[][] f = new triple[ny + 1][nx + 1];
  for (int i: sequence(ny + 1)) {
    for (int j: sequence(nx + 1)) {
      real[] c = c0 + dy * i / ny + dx * j / nx;
      f[i][j] = _ucs_triple(rgb(c[0], c[1], c[2]));
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
```

#### CIELAB
```cpp {cmd=env args=[asyco -render 0 --dothide] output=html continue=ucs .hide}
_ucs_triple = new triple(pen p) { return Lab(p).triple(); };
pen pal(real l, real t) { return palLab(l, t); }

currentlight = nolight;
currentprojection = orthographic(dir(60, 36 - 90), center=false);

string[] l6 = {"R", "Y", "G", "C", "B", "M", "$O$", "W"};
pen[] c6 = {red, yellow, green, cyan, blue, magenta, black, white};
pair[] a6 = new pair[] {E, N, N, W, S, E, SSE, E} * 2.5;
pen spen = white + opacity(0.6), bpen = black + 1bp;

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
    draw(pic, ucs_path(white, c6[i]), bpen);
  for (int i: sequence(6)) // border
    draw(pic, ucs_path(c6[i], c6[(i + 1) % 6]), bpen);
  draw(pic, Label("$L^*$", EndPoint), 100Z -- 200Z, Arrow3);
  add(pic, xy);
}

_erase_pre();
for (int i: new int[] {0, 2, 4}) { // back
  ucs_face(pic, black, c6[i], c6[(i + 2) % 6], spen);
  draw(pic, ucs_path(black, c6[i]), grey);
}
_post_add((0, 0));

erase(pic);
for (int i: sequence(8))
  dot3(pic, l6[i], Lab(c6[i]).triple(), 4, c6[i], a6[i]);
add(pic, (0, 0));

_erase_pre();
for (int i: new int[] {1, 3, 5}) // front
  ucs_face(pic, white, c6[i], c6[(i + 2) % 6]);
_post_add((3.75 * 100, 0));
```

#### CIELUV
```cpp {cmd=env args=[asyco -f svg -render 0 --dothide] output=html continue=ucs .hide}
_ucs_triple = new triple(pen p) { return Luv(p).triple(); };
pen pal(real l, real t) { return palLuv(l, t); }

currentlight = nolight;
currentprojection = orthographic(dir(56, 32 - 90), center=false);

string[] l6 = {"R", "Y", "G", "C", "B", "M", "$O$", "W"};
pen[] c6 = {red, yellow, green, cyan, blue, magenta, black, white};
pair[] a6 = new pair[] {S, N, NW, N, S, S, S, E} * 2.5;
pen spen = white + opacity(0.6), bpen = black + 1bp;

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
    draw(pic, ucs_path(white, c6[i]), bpen);
  for (int i: sequence(6)) // border
    draw(pic, ucs_path(c6[i], c6[(i + 1) % 6]), bpen);
  draw(pic, Label("$L^*$", EndPoint), 100Z -- 200Z, Arrow3);
  add(pic, xy);
}

_erase_pre();
for (int i: new int[] {0, 2, 4}) { // back
  ucs_face(pic, black, c6[i], c6[(i + 2) % 6], spen);
  draw(pic, ucs_path(black, c6[i]), grey);
}
_post_add((0, 0));

erase(pic);
for (int i: sequence(8))
  dot3(pic, l6[i], Luv(c6[i]).triple(), 4, c6[i], a6[i]);
add(pic, (0, 0));

_erase_pre();
for (int i: new int[] {1, 3, 5}) // front
  ucs_face(pic, white, c6[i], c6[(i + 2) % 6]);
_post_add((3.75 * 100, 0));
```

#### OKLab
```cpp {cmd=asyco args=[-f svg -render 0 --dothide] output=html continue=ucs .hide}
_ucs_triple = new triple(pen p) { return OKLab(p).triple(); };
pen pal(real l, real t) { return palOKLab(l, t); }

currentlight = nolight;
currentprojection = orthographic(dir(60, 36 - 90), center=false);

string[] l6 = {"R", "Y", "G", "C", "B", "M", "$O$", "W"};
pen[] c6 = {red, yellow, green, cyan, blue, magenta, black, white};
pair[] a6 = new pair[] {E, N, NW, W, W, S, S, 0.5SE} * 2.5;
pen spen = white + opacity(0.6), bpen = black + 1bp;

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
    draw(pic, ucs_path(white, c6[i]), bpen);
  for (int i: new int[] {0, 4}) // front
    draw(pic, ucs_path(black, c6[i]), bpen);
  for (int i: sequence(6))
    draw(pic, ucs_path(c6[i], c6[(i + 1) % 6]), bpen);
  draw(pic, Label("$L$", EndPoint), Z -- 1.5Z, Arrow3);
  add(pic, xy);
}

_erase_pre();
for (int i: new int[] {2}) // back
  draw(pic, ucs_path(black, c6[i]), grey);
_post_add((0, 0));

erase(pic);
for (int i: sequence(8))
  dot3(pic, l6[i], OKLab(c6[i]).triple(), 0.02, c6[i], a6[i]);
add(pic, (0, 0));

_erase_pre();
for (int i: new int[] {1, 3, 5}) // front
  ucs_face(pic, white, c6[i], c6[(i + 2) % 6]);
for (int i: new int[] {4}) // front
  ucs_face(pic, black, c6[i], c6[(i + 2) % 6]);
_post_add((3.75 * 0.50, 0));
```
