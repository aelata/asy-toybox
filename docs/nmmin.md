## nmmin.asy
Nelder-Mead minimization module

### Rosenbrock function
[Rosenbrock function](https://en.wikipedia.org/wiki/Rosenbrock_function)

$$
f(x, y) = (a - x)^2 + b (y - x^2)^2
$$

```cpp {cmd=env args=[asyco] output=html}
import graph;
import palette;

real rosenbrock(real x, real y, real a=1, real b=100) {
  return (a - x)**2 + b * (y - x * x)**2;
}

real f(real x, real y) { return rosenbrock(x, y); }
pair a = (-2, -1), b = (2, 2);
pen[] pal = BWRainbow();

size(16cm);

scale(Linear, Linear, Log);
bounds range = image(f, a, b, nx=300, pal);
draw(box(a, b));
xaxis(Label("$x$", MidPoint), YEquals(a.y), a.x, b.x, RightTicks(N=4));
yaxis(Label("$y$", MidPoint), XEquals(a.x), a.y, b.y, LeftTicks(N=3));
label("$f(x, y) = (1 - x^2) + 100(y - x^2)^2$", (0.5(a.x + b.x), b.y), 2N);

palette(range, (2.2, a.y), (2.5, b.y), pal, PaletteTicks(ptick=linewidth(0pt)));
```
### Nelder-Mead method
[Nelder-Mead method](https://en.wikipedia.org/wiki/Nelder–Mead_method)

```cpp {cmd=env args=[asyco] output=html}
import nmmin;

real rosenbrock(real x, real y, real a=1, real b=100) {
  return (a - x)**2 + b * (y - x * x)**2;
}

real f(real[] x) { return rosenbrock(x[0], x[1]); }

real[] ini = {0, 0};
cputime();
real[] x = nmmin(f, nmini(ini), tol=array(2, 1e-6), verbose=false);
write("Elapsed: ", cputime().change.clock);

write(x);
write(f(x));
```

---


### Brute force method
Brute force minimization
```cpp {cmd=env args=[asyco] output=html}
real rosenbrock(real x, real y, real a=1, real b=100) {
  return (a - x)**2 + b * (y - x * x)**2;
}

// bfmin - Brute force minimization
real[] bfmin(real f(real[]), real[][] r, int[] m=array(r.length, 101)) {
  int n = r.length;
  int[] i = array(n, 0), mini;
  real[] x = new real[n];
  real v, minv = infinity;
  int j;
  do {
    for (j = 0; j < n; j += 1)
      x[j] = (1 < m[j]) ?
        interp(r[j][0], r[j][1], i[j] / (m[j] - 1)) : r[j][0];
    v = f(x);
    if (v < minv) {
      mini = copy(i);
      minv = v;
    }
    for (j = 0; j < n; j += 1) {
      i[j] += 1;
    if (i[j] < m[j]) break;
      i[j] = 0;
    }
  } while (j < n);
  for (j = 0; j < n; j += 1)
    x[j] = (1 < m[j]) ?
      interp(r[j][0], r[j][1], mini[j] / (m[j] - 1)) : r[j][0];
  return x;
}

real f(real[] x) { return rosenbrock(x[0], x[1]); }
real r[][] = {{-2, 2}, {-1, 2}};
cputime();
real[] x = bfmin(f, r, array(2, 300));
write("Elapsed: ", cputime().change.clock);

write(x);
write(f(x));
```

---
