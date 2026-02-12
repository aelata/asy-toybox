### Identity function

$$
f(z)=z
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z; }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
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

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (0, 0, 1, -1, 1, 3) * z; }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Rational function

$$
f(z) = \frac{(z^2 - 1)(z - 2 - i)^2}{z^2 + 2 + 2i}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  rs=new real[] {1, 2, 4, 8, 16, 32},
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Exponential function
$$
f(z)=e^z
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return exp(z); }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```
<div style="break-after:page"></div>

### Trigonometric function
$$
f(z)=\cos(z)=\frac{e^{iz} + e^{-iz}}{2}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return cos(z); }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  rs=new real[] {0.707, 1, 2, 5, 10, 20},
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=\sin(z)=\frac{e^{iz} - e^{-iz}}{2i}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return sin(z); }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  rs=new real[] {0.707, 1, 2, 5, 10, 20},
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```
<div style="break-after:page"></div>

### Hyperbolic function
$$
f(z)=\cosh(z) = \frac{e^z + e^{-z}}{2}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (exp(z) + exp(-z)) / 2; }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  rs=new real[] {0.707, 1, 2, 5, 10, 20},
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=\sinh(z) = \frac{e^z - e^{-z}}{2}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return (exp(z) - exp(-z)) / 2; }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  rs=new real[] {0.707, 1, 2, 5, 10, 20},
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

<div style="break-after:page"></div>

### Logarithmic function

$$
f(z)=\log{z}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return log(z); }

domcol(
  f, (-5, -5), (5, 5), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=\arctan{z}=\frac{1}{2i}\log{\frac{1+iz}{1-iz}}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { z = (0, 1) * z; return 1 / (0, 0.5) * log((1 + z) / (1 - z)); }

domcol(
  f, (-3, -3), (3, 3), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=\textrm{arctanh}\,{z}=\frac{1}{2}\log{\frac{1+z}{1-z}}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return 0.5 * log((1 + z) / (1 - z)); }

domcol(
  f, (-3, -3), (3, 3), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Power function

$$
f(z) = z^\alpha=e^{\alpha\log{z}}
$$

$$
f(z)=z^2
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z * z; }

domcol(
  f, (-3, -3), (3, 3), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=z^{1/2}=\sqrt{z}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return sqrt(z); }

domcol(
  f, (-3, -3), (3, 3), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=z^i
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z**(0,1); }

domcol(
  f, (-3, -3), (3, 3), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

$$
f(z)=z^{2+i}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return z^(2, 1); }

domcol(
  f, (-3, -3), (3, 3), c=0, reverse=true,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Gamma function

$$
f(z)=\Gamma(z)
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair f(pair z) { return gamma(z); }

domcol(
  f, (-5, -5), (5, 5), c=0.5,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5),
  isoabs=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

<div style="break-after:page"></div>

### Mandelbrot set

$$
\begin{cases}
w_0=0 \\
w_{n+1} = w_n^2 + z
\end{cases}
$$

$$
f(z) = w_8
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pair _f(pair c, int n=10) {
  pair z = 0;
  for (int i: sequence(n))
    z = z * z + c;
  return z;
}

pair f(pair z) { return _f(z, 8); }

domcol(
  f, (-2, -1.5), (1, 1.5), c=3,
  xticks=RightTicks(N=6), yticks=LeftTicks(N=6),
  isoabs=false, isoarg=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

### Intersting looking function

$$
f(z)=\frac{(iz)^{-8} - (iz)^{-1}}{(iz)^{-1} - 1}
$$

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
import domcol;

size(15cm);

pen pal(real l, real t) { return palHSY(l, t, a=0.8, b=0.4); }

pair f(pair z) { z *= (0, 1); return (z**(-8) - 1 / z) / (1 / z - 1); }

domcol(
  f, (-2, -2), (2, 2), c=0, pal,
  xticks=RightTicks(N=2, n=2), yticks=LeftTicks(N=2, n=2),
  isoabs=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
```

---
