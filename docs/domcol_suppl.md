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

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
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
```cpp {cmd=env args=[asyco -render 0 --dothide] output=html .hide}
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

```cpp {cmd=env args=[asyco --dothide] output=html .hide}
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
