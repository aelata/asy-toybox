## Domain coloring

With the `domcol` module, you can visualize complex functions by domain coloring. You can also draw isolines of the absolute value (modulus) and the argument (phase) of the complex functions.

`domcol.asy` depends on `colspc.asy`, `colpal.asy`, and `isoline.asy`. To use the `domcol` module, put these files in a directory that is in the search path of Asymptote (`~/.asy` or current directory, for example).

### Minimum example

The `domcol` function plots a complex function `f` over a rectangular domain defined by the lower left point `a` and the upper right point `b`.

$$
f(z) = \frac{(z^2 - 1)(z - 2 - i)^2}{z^2 + 2 + 2i}
$$

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }
pair a = (-5, -5), b = (5, 5);
domcol(f, a, b);
```

The `domcol` function has a large number of arguments, all of which have default values.

```cpp
void domcol(
  picture pic=currentpicture,
  pair f(pair z)=new pair(pair z) { return z; },
  explicit pair a=(-3, -3), explicit pair b=(3, 3),
  real c=0, int nx=_NX, int ny=nx, int nz=_NZ,
  bool autoscale=false, pair r=(0, infinity),
  pen pal(real, real)=_pal, bool3 reverse=default, pen background=white,
  ticks xticks=RightTicks(), ticks yticks=LeftTicks(),
  bool colbar=true,
  pair rlim=(0, 0), int nr=8, real[] rs=new real[],
  pair tlim=(-1, 1), int nt=2, bool flip=false, bool flop=false,
  bool isoabs=true, bool isoarg=true,
  Label title="$f(z)$",
  Label xlabel="$\textrm{Re}(z)$", Label ylabel="$\textrm{Im}(z)$",
  Label rlabel="abs", Label tlabel="arg");
```

### Reversed palette

You can reverse a color palette by setting `reverse=true` for `dommcol`. I prefer a visualization with dark at infinity.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Color space

The palette with Luv color space is used by default. You can use palettes with other color spaces, such as Lab or HSY. A color palette can be reversed with a negative `b` for the palette function. See [colpal.md](colpal.md#cylindrical-color-subspace) for details. The HSL and HSI color spaces are not recommended for noticeable color streaks.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pen pal(real l, real t) { return palHSY(l, t, a=0.6, b=-0.4); }
// pen pal(real l, real t) { return palLab(l, t, b=-0.5); }
// pen pal(real l, real t) { return palOKLab(l, t, b=-0.5); }

domcol(
  f, (-5, -5), (5, 5), pal,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Scaling along modulus-axis

#### Auto exposure

The `domcol` function uses quantiles along the modulus-axis by default (`c=0`).

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

The functions $l(r) = r/(1 + r)$ and $r(l) = l/(1 - l)$ are used by default.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), c=0,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

#### Manual exposure
You can use fixed scaling as well by setting a positive scaling factor `c` for the modulus-axis.

$$
\def\mapstofrom#1{\substack{\raisebox{-0.5pt}{\rule{.4pt}{1ex}}\xrightarrow{\hspace{#1}} \\ \xleftarrow{\hspace{#1}}\raisebox{-0.5pt}{\rule{.4pt}{1ex}}}}
\begin{array}{c}
&\small l(r/c) \\
r \in [0,\infty) &
\mapstofrom{2cm} & l \in [0,1) \\
&\small c\,r(l) \\[12pt]
\end{array}
$$

##### Scaling factor: c = 1

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), c=1,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

##### Scaling factor: c = 3

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), c=3,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Modulus range

You can set a modulus range `r` with the minimum and the maximum value. The default range is `(0, infinity)`.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), c=3, r=(0.3, 30),
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

You can also set an approximate modulus range with `autoscale=true` and `r` with the lower and the upper quantiles.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), c=3,
  autoscale=true, r=(0.01, 0.9), // trim lower 1% and upper 10%
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Combining fuctions

Another code to obtain the same plot as the first one is shown below.

```cpp {cmd=env args=[asyco -n] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }
pair a = (-5, -5), b = (5, 5);
real c = 0; // quantile based modulus (auto exposure)

pair[][] z = map_rect(f, a, b);
int[] H = image(z, a, b, c);
xaxis("$\textrm{Re}(z)$", Bottom, a.x, b.x, RightTicks());
yaxis("$\textrm{Im}(z)$", Left, a.y, b.y, LeftTicks());
label("$f(z)$", ((a.x + b.x) * 0.5, b.y), align=2N);

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(
  c, H, pa, pb, modulus_range(c, H), rlabel="abs", tlabel="arg");

isoabs(z, a, b, rs);
isoarg(z, a, b);
draw(box(a, b));
```

`map_rect` calculates a complex array from a complex function `f` over the rectangular domain defined by a lower left point `a` and an upper right point `b`. `image` visualizes the complex array and returns an integer array (a cummulative weighted histogram), which contains the information of a modulus range. You can get the range from the histogram with `modulus_range`. `rtpalette` draws a color palette and labels. `rtpalette` returns a real array (tick values except $0$ and $\infty$). `isoabs` draws the isolines of the modulus of the complex array. `isoabs` can use the tick values returned by `rtpalette`. `isoabs` draws the isolines of the argument of the complex array.

### Reusing quantiles

`image` can use the previously calculated cumulative weighted histogram.

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

`isoabs` can use the previously calculated tick values.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

picture pic;

erase(pic);
unitsize(pic, 0.75cm);
pair a = (-5, -5), b = (5, 5);
real s = 0;
pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }
pair[][] z = map_rect(f, a, b);
int[] H = image(pic, z, a, b, s, reverse=true);
xaxis(pic, Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(pic, Left, a.y, b.y, LeftTicks(N=2, n=5));
draw(pic, box(a, b));
label(pic, "$f(z)$", ((a.x + b.x) / 2, b.y), 2N);
pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(pic, s, H, pa, pb);
isoabs(pic, z, a, b, rs);
isoarg(pic, z, a, b);
add(pic, (9cm, 0));

erase(pic);
unitsize(pic, 0.75cm / 10);
pair a = (-50, -50), b = (50, 50);
pair f(pair z) { return z; }
pair[][] z = map_rect(f, a, b);
image(pic, z, a, b, s, H); // use previous H
xaxis(pic, Bottom, a.x, b.x, RightTicks(N=2));
yaxis(pic, Left, a.y, b.y, LeftTicks(N=2));
draw(pic, box(a, b));
label(pic, "$z$", ((a.x + b.x) / 2, b.y), 2N);
isoabs(pic, z, a, b, rs); // use previous rs
isoarg(pic, z, a, b);
add(pic, (0, 0));
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

### Circular domain

You can visualize a domain of a circle of radius `rmax` with scaling factor along radius.

```cpp {cmd=env args=[asyco] output=html}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

real rmax = infinity, c_dom = 2;
pair[][] z = map_circ(f, rmax, c_dom);

real c = 3;
int[] H = image(z, c);
real[] rs = rtpalette(c, H);
isoabs(z, rs);
isoarg(z);

raxis(rmax, c_dom);
taxis();
```

---
