### geom2
```cpp {cmd=env args=[asyco -n] #prep output=none}
import geom2;
usepackage("amsmath");
texpreamble("\let\bm=\boldsymbol");

Label lbl(
  string s, pair position=MidPoint, align align=NoAlign, embed embed=Shift)
{
  return Label(s, position=position, align=align, embed=embed);
}

pair O = (0, 0);
```

#### Projection, rejection, and reflection
$$
\bm{a} = \bm{a}_{\parallel\bm{m}} + \bm{a}_{\perp\bm{m}}
$$

$$
\bm{a}_{\parallel\bm{m}} = \E{\bm{m},\bm{a}} \bm{m}
$$

$$
\bm{a}_{\perp\bm{m}} = \bm{a} - \bm{a}_{\parallel\bm{m}}
  = \bm{a} - \E{\bm{m},\bm{a}} \bm{m} = (\bm{m}\times\bm{a})\times\bm{m}
$$

$$
\bm{a}_{\top\bm{m}} = \bm{a} - 2\bm{a}_{\perp\bm{m}}
  = -\bm{a} + 2\E{\bm{m},\bm{a}} \bm{m}
$$

```cpp {cmd=env args=[asyco -tex pdflatex] continue=prep output=html output_first}
unitsize(1.5cm);
transform T = rotate(15);
pair m = unit(T * (1, 0)), a = T * (3, 2);
pair p = project(m, a);
pair q = reflect(m, a);
draw(T * ((-1, 0) -- (4, 0)));
draw(lbl("$\bm{m}$", align=S), O -- m, linewidth(1), Arrow(6));
draw(lbl("$\bm{a}$", align=LeftSide), O -- a, linewidth(1), Arrow(6));
draw(lbl("$\bm{a}_{\top\bm{m}}$"), O -- q, linewidth(1), Arrow(6));
draw(lbl("$\bm{a}_{\perp\bm{m}}$"), q -- p, linewidth(1), Arrow(6));
draw(lbl("$\bm{a}_{\perp\bm{m}}$"), p -- a, linewidth(1), Arrow(6));
mark_right_angle(a, p, p + m);
```

#### Line
$$
l: \bm{m}\times(\bm{x} - \bm{x}_l) = 0
$$

$$
\bm{m} = \frac{\bm{x}_2 - \bm{x}_1}{\L{\bm{x}_2 - \bm{x}_1}}
$$

$$
\bm{x}_l = (\bm{x}_1)_{\perp\bm{m}} = {\bm{x}_1} - \E{\bm{m},\bm{x}_1}\bm{m}
$$

```cpp {cmd=env args=[asyco -tex pdflatex] continue=prep output=html output_first}
unitsize(1.5cm);
real xmin = -3, xmax = 3, ymin = -2, ymax = 3;
pen axispen = 0.5white;
draw(lbl("$x$", EndPoint), (xmin, 0) -- (xmax, 0), axispen, Arrow);
draw(lbl("$y$", EndPoint), (0, ymin) -- (0, ymax), axispen, Arrow);
label("$O$", O, dir(235), axispen);

transform T = shift(0, 1.5) * rotate(-15);
line2 l = T * line2((0, 0), (1, 0));
draw(lbl("$l$", EndPoint), l);
dot("$\bm{x}_l$", l.xH, N);
dot("$\bm{x}$", l.y_intercept(1.75), N);
draw(O -- l.xH);
draw(lbl("$\bm{m}$"), l.xH -- l.xH + l.m, linewidth(1), Arrow(6));
mark_right_angle(O, l.xH, l.xH + l.m);

pair x1 = l.y_intercept(-1);
pair x2 = l.y_intercept(2.5);
dot("$\bm{x}_1$", x1, N);
dot("$\bm{x}_2$", x2, N);
draw(O -- x1);
```

#### Intersection
$$
\bm{p}=\bm{x}_l + \frac{\bm{m}'\times(\bm{x}'_l - \bm{x}_l)}{\bm{m}'\times\bm{m}} \bm{m}
$$

```cpp {cmd=env args=[asyco -tex pdflatex] continue=prep output=html output_first}
unitsize(1.5cm);
real xmin = -3, xmax = 3, ymin = -2, ymax = 3;
pen axispen = 0.5white;
draw(Label("$x$", EndPoint), (xmin, 0) -- (xmax, 0), axispen, Arrow);
draw(Label("$y$", EndPoint), (0, ymin) -- (0, ymax), axispen, Arrow);
label("$O$", O, dir(235), axispen);

pair x1 = (-2, 2), x2 = (0, 1.3);
line2 l1 = line2(x1, x2);
draw(Label("$l$", BeginPoint, N), l1);
draw("$\bm{m}$", l1.xH -- l1.xH + l1.m, linewidth(1), Arrow(size=8), align=NE);
dot("$\bm{x}_l$", l1.xH, N);
draw(O -- l1.xH);

pair x3 = (1.25, 0), x4 = (0, -1.5);
line2 l2 = line2(x3, x4);
draw(Label("$l'$", BeginPoint, N), l2);
draw("$\bm{m}'$", l2.xH -- l2.xH + l2.m, linewidth(1), Arrow(size=8), align=SE);
dot("$\bm{x}'_l$", l2.xH, 2E);
draw(O -- l2.xH);

dot("$\bm{p}$", l2.intersect(l1), 2N);
mark_right_angle(O, l1.xH, l1.xH + l1.m);
mark_right_angle(O, l2.xH, l2.xH + l2.m);
```

---
