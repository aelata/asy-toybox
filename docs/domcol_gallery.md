### Identity function
$$
f(z)=z
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z; }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

### Linear transform
$$
\def\pmqty#1{\begin{pmatrix}#1\end{pmatrix}}
\begin{gather*}
f: \pmqty{x \\ y} \mapsto \pmqty{a & b \\ c & d} \pmqty{x \\ y} = A \pmqty{x \\ y} \\[8pt]
f(z) = f(x + i\,y) =
\frac{(a+d)+i(c-b)}{2}z+\frac{(a-d)+i(c + b)}{2}\overline{z} \\[12pt]
A = \pmqty{1 & -1 \\ 1 & 3} \\[8pt]
f(z) = (2 + i)z + \overline{z}
\end{gather*}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (0, 0, 1, -1, 1, 3) * z; }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

### Rational function
$$
f(z) = \frac{(z^2 - 1)(z - 2 - i)^2}{z^2 + 2 + 2i}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = {1, 2, 4, 8, 16, 32};
rtpalette(c, H, pa, pb, rs);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

### Exponential function
$$
f(z)=e^z
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return exp(z); }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```
<div style="break-after:page"></div>

### Trigonometric function
$$
f(z)=\cos(z)=\frac{e^{iz} + e^{-iz}}{2}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return cos(z); }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = {0.707, 1, 2, 5, 10, 20};
rtpalette(c, H, pa, pb, rs);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=\sin(z)=\frac{e^{iz} - e^{-iz}}{2i}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return sin(z); }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = {0.707, 1, 2, 5, 10, 20};
rtpalette(c, H, pa, pb, rs);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```
<div style="break-after:page"></div>

### Hyperbolic function
$$
f(z)=\cosh(z) = \frac{e^z + e^{-z}}{2}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (exp(z) + exp(-z)) / 2; }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = {0.707, 1, 2, 5, 10, 20};
rtpalette(c, H, pa, pb, rs);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=\sinh(z) = \frac{e^z - e^{-z}}{2}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (exp(z) - exp(-z)) / 2; }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = {0.707, 1, 2, 5, 10, 20};
rtpalette(c, H, pa, pb, rs);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```
<div style="break-after:page"></div>

### Logarithmic function
$$
f(z)=\log{z}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return log(z); }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=\arctan{z}=\frac{1}{2i}\log{\frac{1+iz}{1-iz}}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { z = (0, 1) * z; return 1 / (0, 0.5) * log((1 + z) / (1 - z)); }

pair a = (-3, -3), b = (3, 3);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.25, a.y);
pair pb = (b.x + 1.25, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=\textrm{arctanh}\,{z}=\frac{1}{2}\log{\frac{1+z}{1-z}}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return 0.5 * log((1 + z) / (1 - z)); }

pair a = (-3, -3), b = (3, 3);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.25, a.y);
pair pb = (b.x + 1.25, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```
### Power function
$$
f(z) = z^\alpha=e^{\alpha\log{z}}
$$

$$
f(z)=z^2
$$
```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z * z; }

pair a = (-3, -3), b = (3, 3);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=3));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=3));

pair pa = (b.x + 0.25, a.y);
pair pb = (b.x + 1.25, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=z^{1/2}=\sqrt{z}
$$
```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return sqrt(z); }

pair a = (-3, -3), b = (3, 3);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=3));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=3));

pair pa = (b.x + 0.25, a.y);
pair pb = (b.x + 1.25, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=z^i
$$
```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z**(0,1); }

pair a = (-3, -3), b = (3, 3);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=3));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=3));

pair pa = (b.x + 0.25, a.y);
pair pb = (b.x + 1.25, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

$$
f(z)=z^{2+i}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z^(2, 1); }

pair a = (-3, -3), b = (3, 3);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=3));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=3));

pair pa = (b.x + 0.25, a.y);
pair pb = (b.x + 1.25, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```

### Gamma function
$$
f(z)=\Gamma(z)
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return gamma(z); }

pair a = (-5, -5), b = (5, 5);
real c = 0;
pair[][] z = seq(f, a, b);
int[] H = image(z, a, b, c, reverse=true);
xaxis(Bottom, a.x, b.x, RightTicks(N=2, n=5));
yaxis(Left, a.y, b.y, LeftTicks(N=2, n=5));

pair pa = (b.x + 0.5, a.y);
pair pb = (b.x + 2, b.y);
real[] rs = rtpalette(c, H, pa, pb);

isomodulus(z, a, b, rs);
isophase(z, a, b);
draw(box(a, b));
```
<div style="break-after:page"></div>

### Intersting looking function
$$
f(z)=\frac{(iz)^{-8} - (iz)^{-1}}{(iz)^{-1} - 1}
$$

```cpp {cmd=env args=[asyco] output=html .hide}
import domcol;

size(15cm);

pen pal(real l, real t) { return palHSY(l, t, a=0.8, b=0.4); }

pair f(pair z) { z *= (0, 1); return (z**(-8) - 1 / z) / (1 / z - 1); }

pair a = (-2, -2), b = (2, 2);
real c = 0;
pair[][] z = seq(f, a, b, 500, 500);
int[] H = image(f, a, b, c, pal);
xaxis(YEquals(a.y), xmin=a.x, xmax=b.x, RightTicks(N=2, n=2));
yaxis(XEquals(a.x), ymin=a.y, ymax=b.y, LeftTicks(N=2, n=2));

pair pa = (b.x + 0.2, a.y);
pair pb = (b.x + 0.7, b.y);
rtpalette(c, H, pa, pb, pal);

isophase(z, a, b);
draw(box(a, b));
```

---
