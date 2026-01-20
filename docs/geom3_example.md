### geom3
```cpp {cmd=env args=[asyco -n] #prep output=none}
import settings;
settings.tex = "pdflatex";
settings.render = 0;

import geom3;
usepackage("amsmath");
texpreamble("\let\bm=\boldsymbol");

currentlight = nolight;
currentprojection = orthographic(dir(60, 30 - 90), center=false);

unitsize(1.8cm);
pen axispen = 0.5white;
draw(Label("$x$", EndPoint), -3X -- 3X, axispen, Arrow3);
draw(Label("$y$", EndPoint), -3Y -- 3Y, axispen, Arrow3);
draw(Label("$z$", EndPoint), -2Z -- 3Z, axispen, Arrow3);
```

#### Plane
$$
\varPi: \ev{\bm{n}, \bm{x} - \bm{x}_\varPi} = 0
$$

$$
\bm{n} = \frac{(\bm{x}_2 - \bm{x}_1)\times(\bm{x}_3 - \bm{x}_1)}{\L{(\bm{x}_2 - \bm{x}_1)\times(\bm{x}_3 - \bm{x}_1)}}
$$

$$
\bm{x}_\varPi = \ev{\bm{n}, \bm{x}_1}\bm{n}
$$

```cpp {cmd=env args=[asyco] continue=prep output=html output_first}
label("$O$", O, 2dir(305), axispen);

transform3 T = //identity4;
  rotate(-35, Z) * rotate(35, Y) * shift(0, 0, 2) * scale3(0.8);
path3 p = (-2, -2, 0) -- (2, -2, 0) -- (2, 2, 0) -- (-2, 2, 0) -- cycle;
p = T * p;
triple x1 = T * (-1.2, -0.8, 0), x2 = T * (1.1, -1.8, 0), x3 = T * (-0.4, 1, 0);
plane3 P = plane3(p);
draw(O -- x1);
draw(O -- P.xH);
draw(
  Label("$\bm{n}$", EndPoint, NW),
  O -- unit(P.xH), linewidth(1), Arrow3(8));
mark_right_angle(O, P.xH, x1);
draw(surface(p), yellow + opacity(0.6), black);
draw(P.xH -- x1);
draw(x1 -- x2);
draw(x1 -- x3);
dot("$\bm{x}_1$", x1, NW);
dot("$\bm{x}_2$", x2, NE);
dot("$\bm{x}_3$", x3, NE);
dot("$\bm{x}_\varPi$", P.xH, NNE);
label("$\varPi$", point(p, 0), 3ESE);

dot("$\bm{x}$", P.intersect(line3.z(1.5, -0.75)));
```

#### Projection and reflection
$$
\bm{a}_{\parallel\varPi}
  = \bm{a} + (\bm{x}_\varPi - \bm{a})_{\parallel\bm{n}}
  = \bm{x}_\varPi + \bm{a} - \ev{\bm{n}, \bm{a}}\bm{n}
$$

$$
\bm{a}_{\top\varPi}
  = \bm{a} + 2(\bm{x}_\varPi - \bm{a})_{\parallel\bm{n}}
  = 2\bm{x}_\varPi + \bm{a} - 2\ev{\bm{n}, \bm{a}}\bm{n}
$$

$$
d = \ev{\bm{n}, \bm{a} - \bm{x}_\varPi}
$$

```cpp {cmd=env args=[asyco] continue=prep output=html output_first}
label("$O$", O, 2dir(305), axispen);

transform3 T = rotate(5, Y) * shift(1.4Z);
path3 rect = T * scale3(3.5) * shift(-0.5, -0.5, 0) * unitsquare3;
plane3 P = plane3(rect);
triple a = (1.6, -0.5, 3.25);
triple p = P.project(a);
triple q = P.reflect(a);
triple r = P.intersect(line3(O, a));
draw(O -- P.xH);
draw(
  Label("$\bm{n}$", MidPoint, E),
  O -- P.n, linewidth(1), Arrow3(8));
dot("$\bm{a}_{\top\varPi}$", q, S);
draw(P.xH -- q -- p);
draw(surface(rect), yellow+opacity(0.6), black);
dot("$\bm{x}_\varPi$", P.xH, 2W);
dot("$\bm{a}$", a, N);
dot("$\bm{a}_{\parallel\varPi}$", p, E);
draw(Label("$d$", MidPoint, E), a -- p);
draw(a -- P.xH -- p);
mark_right_angle(P.xH, p, a);
draw("$\varPi$", point(rect, 0), 3dir(15));
```

#### Nearest points
$$
\bm{p} = \bm{x}_l + \frac{\ev{\bm{m},\bm{x}'_l}+\ev{\bm{m}',\bm{m}}\ev{\bm{m}',\bm{x}_l}}{\L{\bm{m}\times\bm{m}'}^2} \bm{m}
$$

$$
\bm{p}' = \bm{x}'_l - \frac{\ev{\bm{m}',\bm{x}_l}+\ev{\bm{m},\bm{m}'}\ev{\bm{m},\bm{x}'_l}}{\L{\bm{m}\times\bm{m}'}^2} \bm{m}'
$$

$$
d = \ev{\frac{\bm{m}\times\bm{m}'}{\L{\bm{m}\times\bm{m}'}},\bm{x}'_l - \bm{x}_l}
$$

```cpp {cmd=env args=[asyco] continue=prep output=html output_first}
draw("$O$", O, 2dir(125), axispen);

line3 l0 = line3(1.75Z, 2.5X+1.4Z);
draw(Label("$l$", BeginPoint), l0, 0.05);
dot("$\bm{x}_l$", l0.xH, NNE);
draw(
  Label("$\bm{m}$", MidPoint, NNE),
  l0.xH -- l0.xH + l0.m, linewidth(1), Arrow3(8));
draw(O -- l0.xH);
mark_right_angle(O, l0.xH, l0.xH - l0.m);

line3 l1 = line3(-1.6Y, 1.7X);
draw(Label("$l'$", BeginPoint), l1, 0.05);
dot("$\bm{x}'_l$", l1.xH, S);
draw(
  Label("$\bm{m}'$", MidPoint, S),
  l1.xH -- l1.xH + l1.m, linewidth(1), Arrow3(8));
draw(O -- l1.xH);
mark_right_angle(O, l1.xH, l1.xH - l1.m);

triple p0 = l0.nearest(l1), p1 = l1.nearest(l0);
dot("$\bm{p}$", p0, 2WSW);
dot("$\bm{p}'$", p1, NW);
draw(p0 -- p1);
mark_right_angle(p1, p0, p0 + l0.m);
mark_right_angle(p0, p1, p1 + l1.m);

draw(
  Label("$\bm{m}\times\bm{m}'$", MidPoint, E),
  p0 -- p0 + cross(l0.m, l1.m), linewidth(1), Arrow3(8));
draw(Label("$d$", MidPoint, E), p0 -- p1);
```

---
