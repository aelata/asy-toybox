## Domain coloring
With `domcol` module, you can visualize complex functions by domain coloring. You can also draw isolines for the modulus (magnitude) and the phase (argument) of a complex array.

### Minimum example
`image` visualizes a complex function `f` over a rectangle defined by the lower left point `a` and the upper right point `b`. `rtpalette` draws a color palette and labels.

$$
f(z) = \frac{(z^2 - 1)(z - 2 - i)^2}{z^2 + 2 + 2i}
$$

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
image(f, a, b);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(pa, pb);
```

### Scaling factor
You can set a scaling factor `s` for the modulus-axis. The factor must be a positive number and the default value is `1`.
$$
\def\mapstofrom#1{\substack{\raisebox{-0.5pt}{\rule{.4pt}{1ex}}\xrightarrow{\hspace{#1}} \\ \xleftarrow{\hspace{#1}}\raisebox{-0.5pt}{\rule{.4pt}{1ex}}}}
\begin{array}{c}
&\small l(r/s) \\
r \in [0,\infty) &
\mapstofrom{2cm} & l \in [0,1) \\
&\small s\,r(l) \\[12pt]
\end{array}
$$

The functions $l(r) = r/(1 + r)$ and $r(l) = l/(1 - l)$ are used by default.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 3;
image(f, a, b, s);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(s, pa, pb);
```

### Isolines
You can draw iso-modulus lines with `isomodulus` and iso-phase lines with `isophase`. Calculating function values at each point in advance is recommended. `rtpalette` returns tick values except $0$ and $\infty$. You can use the tick values to draw iso-modulus lines.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 3;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, s);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(s, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

### Circular domain
You can visualize a domain of a circle of radius `rmax` with scaling factor `c`.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

real rmax = infinity, c = 3;
pair[][] z = seq(f, rmax, c=c);

real s = 3;
int[] H = image(z, s);
real[] rs = rtpalette(s, H);
isomodulus(z, rs);
isophase(z);

raxis(rmax, c);
taxis();
```

### Modulus range

You can set a modulus range with the minimum and the maximum value. The default range is `(0, infinity)`.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 3;
pair rlim = (0.3, 30);
image(f, a, b, s, rlim);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(s, pa, pb, rlim);
```

You can also set an approximate modulus range with `autoscale=true`, or the lower and the upper quantiles. `image` returns an integer array, which contains the information of the specified range. You can get the range with `modulus_range`.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 3;
pair rlim = (0.01, 0.9); // trim lower 1% and upper 10%
int[] H = image(f, a, b, s, autoscale=true, rlim);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(s, pa, pb, modulus_range(s, H));
```

### Reversed palette
You can reverse a color palette by setting `reverse=true` in the argument of `image`. I prefer a visualization with dark at infinity.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 3;
image(f, a, b, s, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(s, pa, pb, reverse=true);
```

### Color space
The palette with Luv color space is used by default. You can use the palette with HSY color space for higher contrast or the OKLab color space for more uniform color. A color palette can be reversed with the negative vale of `b` in a palette function.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pen pal(real l, real t) { return palHSY(l, t, a=0.6, b=-0.4); }
// pen pal(real l, real t) { return palLab(l, t, b=-0.5); }
// pen pal(real l, real t) { return palOKLab(l, t, b=-0.5); }

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 3;
image(f, a, b, s, pal);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(s, pa, pb, pal);
```

### Ticks of color palette
The modulus-axis is divided by `nr` (default: `8`) and the phase-axis is divided by `nt` (default: `2`). The ticks and labels of the modulus-axis or the phase-axis can be turned off with `nr=0` or `nt=0`. To specify the tick values of modulus, you can pass the values (the array of `real`) to `rtpalette`.
```cpp {cmd=env args=[asyco] output=html}
import domcol;

real[] rs = {0.5, 1, 2};

unitsize(3cm, -7cm);
picture pic;
unitsize(pic, 3cm, 2.5cm);

erase(pic);
rtpalette(pic);
add(pic, (0, 0));

erase(pic);
rtpalette(pic, reverse=true);
add(pic, (1, 0));

erase(pic);
rtpalette(pic, rlim=(infinity, 0));
add(pic, (2, 0));

erase(pic);
rtpalette(pic, rlim=(infinity, 0), reverse=true);
add(pic, (3, 0));

erase(pic);
rtpalette(pic, nr=4, nt=0);
add(pic, (0, 1));

erase(pic);
rtpalette(pic, rs);
add(pic, (1, 1));

erase(pic);
rtpalette(pic, rs, endlabels=false);
add(pic, (2, 1));

erase(pic);
rtpalette(pic, rlim=(0.5, 2), nr=4, tlim=(0, 2), nt=1);
add(pic, (3, 1));
```

### Quantile of modulus
If you set a scaling factor `s` to `0`, `image` uses quantiles of the modulus.

$$
\def\mapstofrom#1{\substack{\raisebox{-0.5pt}{\rule{.4pt}{1ex}}\xrightarrow{\hspace{#1}} \\ \xleftarrow{\hspace{#1}}\raisebox{-0.5pt}{\rule{.4pt}{1ex}}}}
\begin{array}{c}
&\small l(r) && \small\textrm{cdf}(l)\\
r \in [0,\infty) &
\mapstofrom{2cm} & l \in [0,1) &
\mapstofrom{2cm} & q \in[0,1] \\
&\small r(l) && \small \textrm{quantile}(q) \\[12pt]
\end{array}
$$

`image` returns an integer array, a cumulative weighted histogram, which is used to get quantiles and the range of complex modulus. `rtpalette` uses the array to draw labels.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 0;
int[] H = image(f, a, b, s, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(s, H, pa, pb);
```


#### Reusing quantiles
You can reuse the previously calculated cumulative weighted histogram with another `image`.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

picture pic;

erase(pic);
unitsize(pic, 0.75cm);
pair a = (-5, -5), b = (5, 5);
real s = 0;
int[] H = image(pic, f, a, b, s, reverse=true);
xaxis(pic, Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(pic, Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(pic, box(a, b));

pair a = (-2, -2), b = (3, 3);
draw(pic, box(a, b));
add(pic, (0cm, 0));

erase(pic);
unitsize(pic, 0.75cm * 2);
image(pic, f, a, b, s, H); // use previous H
xaxis(pic, Bottom, a.x, b.x, RightTicks(N=5));
yaxis(pic, Left, a.y, b.y, LeftTicks(N=5));
draw(pic, box(a, b));
pair pa = (b.x + 0.4, a.y);
pair pb = (b.x + 1.2, b.y);
rtpalette(pic, s, H, pa, pb);
add(pic, (9cm - 0.75cm, -0.75cm));
```

You can also reuse the previously calculated cumulative weghted histogrm with another `isomodulus`.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

picture pic;

erase(pic);
unitsize(pic, 0.75cm);
pair a = (-5, -5), b = (5, 5);
real s = 0;
pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }
pair[][] z = seq(f, a, b);
int[] H = image(pic, z, a, b, s, reverse=true);
xaxis(pic, Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(pic, Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(pic, box(a, b));
label(pic, "$f(z)$", ((a.x + b.x) / 2, b.y), 2N);
pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(pic, s, H, pa, pb);
isomodulus(pic, z, a, b, rs);
isophase(pic, z, a, b);
add(pic, (9cm, 0));

erase(pic);
unitsize(pic, 0.75cm / 10);
pair a = (-50, -50), b = (50, 50);
pair f(pair z) { return z; }
pair[][] z = seq(f, a, b);
image(pic, z, a, b, s, H); // use previous H
xaxis(pic, Bottom, a.x, b.x, RightTicks(N=2));
yaxis(pic, Left, a.y, b.y, LeftTicks(N=2));
draw(pic, box(a, b));
label(pic, "$z$", ((a.x + b.x) / 2, b.y), 2N);
isomodulus(pic, z, a, b, rs); // use previous rs
isophase(pic, z, a, b);
add(pic, (0, 0));
```

---

### Cumulative weighted histogram
The `image` function defined in `domcol.asy` returns an integer array. The array is the cumulative histogram of a weighted histogram of $l \in [0, 1)$ with a weight of 8 for each point. The specified lower and upper limits are encoded with a weight of 1 and 2 in the histogram. A reverse flag is encoded with a weight 4 at the last bin.

A cumulative distribution function is obtained from the cumulative weighted histogram,  which also provides approximate quantiles.
```cpp {cmd=env args=[asyco] output=html}
import domcol;

unitsize(8cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real s = 0;
int[] H = image(pic=null, f, a, b, s);

write("     q         l         r");
for (int i: sequence(8 + 1)) {
  real q = 1 - i / 8;
  write(
    format("%6.3g", q) +
    format("%10.3g", quantile(q, H)) + format("%10.3g", modulus(q, s, H)));
}

pair a = (0, 0), b = (1, 1);
pair[] xy = pairs(sequence(H.length) / H.length, H / H[H.length - 1]);
draw(operator --(... xy), red);
xaxis(Label("$l$", MidPoint), a.x, b.x, RightTicks(N=4));
yaxis(Label("$q$", MidPoint), a.y, b.y, LeftTicks(N=4));
string rlabel(real l) {
  return (1 - realEpsilon <= l) ? "$\infty$" : format("$%.3g$", rfn(l));
}
xaxis(
  Label("$r$", MidPoint), Top, a.x, b.x, LeftTicks(ticklabel=rlabel, N=4));
draw(box(a, b));
```

### Lightness function
A lightness function $l(r)$ maps the infinite interval $[0, \infty)$ to the finite interval $[0, 1)$.

$$
r \in [0, \infty) \xmapsto{\ l(r)\ } l \in [0, 1)
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import graph;

size(12cm, 8cm, IgnoreAspect);
real l0(real r) { return 2 / pi * atan(r); }
real l1(real r) { return r / (1 + r); }
real l2(real r) { return r * r / (1 + r * r); }
real a = 0, b = 3;
limits((a, 0), (b, 1));
draw(graph(l2, a, b), legend="$l_2(r)=r^2/(1+r^2)$", black);
draw(graph(l1, a, b), legend="$l_1(r)=r/(1+r)$", red);
draw(graph(l0, a, b),legend="$l_0(r)=(2/\pi)\arctan(r)$", blue);
pen p = linewidth(0.2bp);
xaxis(
  L="$r$", axis=BottomTop, p=p,
  LeftTicks(format="%.0f", Step=1, extend=true));
yaxis(
  L="$l(r)$", axis=LeftRight, p=p,
  LeftTicks(format="%.1f", Step=0.5, extend=true));
add(
  legend(p=invisible, linelength=0.6cm),
  (b, 0), align=NW, FillDraw(white + opacity(0.9)));
```

$$
\begin{align*}
l_2(r) &= \frac{r^2}{1 + r^2} &
r_2(l) &= l^{-1}_2(l) = \sqrt{\frac{l}{1 - l}} \\[6pt]
l_1(r) &= \frac{r}{1 + r} &
r_1(l) &= l^{-1}_1(l) = \frac{l}{1 - l}\\[6pt]
l_0(r) &= \frac{2}{\pi}\arctan(r) &
r_0(l) &= l^{-1}_0(l) = \tan\left(\frac{\pi}{2}l\right) \\[12pt]
l_\alpha(r) &= \frac{r^\alpha}{1 + r^\alpha} &
r_\alpha(l) &= l^{-1}_\alpha(l) = \left(\frac{l}{1 - l}\right)^{1/\alpha} & (0 < \alpha)\\[6pt]
\end{align*}
$$

You can use $l_2$ with `set_lfn(2)` and $l_0$ with `set_lfn(0)`. The default of a lightness function is $l_1$
```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

set_lfn(2);
// set_lfn(0);

pair a = (-5, -5), b = (5, 5);
image(f, a, b);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
rtpalette(pa, pb);
```

#### Stereographic projection
The function $l_2$ is related to the projection of a unit sphere from the South Pole to the equatorial plane.
```cpp {cmd=env args=[asyco -render 0] output=html .hide}
import solids;

currentprojection = orthographic(dir(72, 30 - 90));
unitsize(2cm);
draw(Label("$X$", EndPoint), -3.5X -- 3.5X, Arrow3);
draw(Label("$Y$", EndPoint), -3.5Y -- 3.5Y, Arrow3);
draw(Label("$Z$", EndPoint), -2Z -- 2Z, Arrow3);

triple p = (2, -0.5, 0);
triple P = (2p.x, 2p.y, 1 - p.x^2 - p.y^2) / (1 + p.x^2 + p.y^2);
dot("$S$", -Z, red, align=NW);
draw(-Z -- P, red+dashed);
triple pp = (sqrt(1-p.y**2), p.y, 0);
draw((0, p.y, 0) -- pp, dashed);

revolution r = sphere(1, 5);
draw(surface(r), rgb(1,1,0.5)+opacity(0.5), nolight);
skeleton s = r.skeleton(m=1, P=currentprojection);
draw(s.transverse.front);
draw(s.transverse.back, grey+dashed);
draw(r.silhouette());

draw(pp -- p -- (p.x, 0, 0), grey);
draw(P -- p, red);
dot("$N$", Z, align=SW);
dot("$p(x, y, 0)$", p, red, align=SE);
dot("$P(X,Y,Z)$", P, red, align=1.5SE);
```

```cpp {cmd=env args=[asyco] output=html .hide}
void draw_xz(picture pic=currentpicture, real t) {
  draw(pic, (-2.5, 0) -- (2.5, 0), Arrow);
  draw(pic, Label("$Z$", EndPoint), (0, -2) -- (0, 2), Arrow);
  draw(pic, unitcircle);
  dot(pic, "$N (0,0,1)$",  N, NW);
  dot(pic, "$S (0,0,-1)$", S, SW);

  pair P = (Cos(t), Sin(t)), Q = (0, P.y);
  dot(pic, P);
  label(pic, "$Z$", Q, W);
  draw(pic, Label("$P$", EndPoint), Q -- P, ((0 < P.y) ? NE : SE));
  pair p = P / (1 + P.y);
  p = (p.x, 0);
  dot(pic, "$p$", p, SE);
  draw(pic, S -- ((0 < P.y) ? P : p));
}

picture pic;
unitsize(pic, 1.5cm);

erase(pic);
draw_xz(pic, 50);
add(pic, (0, 0));

erase(pic);
draw_xz(pic, -30);
add(pic, (8cm, 0));
```

$$
\begin{gather*}
x = \frac{X}{1+Z},\quad y = \frac{Y}{1+Z} \\[5pt]
x^2+y^2=\frac{X^2+Y^2}{(1+Z)^2}=\frac{1-Z^2}{(1+Z)^2}=\frac{1-Z}{1+Z} \\[15pt]
r = (x^2+y^2)^{1/2} \in [0, \infty)\\[5pt]
Z = \frac{1-r^2}{1+r^2} \in (-1, 1] \\[5pt]
l_2 (r) = \frac{1 - Z}{2} = \frac{r^2}{1+r^2}\in [0, 1) \\
\end{gather*}
$$

---
