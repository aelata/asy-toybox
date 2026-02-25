---
presentation:
  theme: simple.css
  center: false # disable vertical centering
  slideNumber: "c/t"
  transition: none
---

![](style.less)

<!-- .slide data-background-image="ex-domcol.svg" data-background-size=60% data-background-opacity=0.1 data-background-transition="none" -->

# 複素関数の可視化 {.r-stretch}

```cpp {cmd=env args=[asyco -n] output=none #center .hide}
void center(picture pic=currentpicture, pair O=(0, 0), bool vertical=false) {
  pair sw = truepoint(SW, false), ne = truepoint(NE, false);
  O = pic.calculateTransform() * O;
  sw = O - sw;
  ne = ne - O;
  if (vertical)
    ne = ((ne.x < sw.x) ? sw.x : ne.x, (ne.y < sw.y) ? sw.y : ne.y);
  else
    ne = ((ne.x < sw.x) ? sw.x : ne.x, 0);
  frame f;
  draw(f, O - ne);
  draw(f, O + ne);
  add(pic, f);
}
```

#### aelata {.r}

<!-- .slide -->

## 実関数のグラフ

```cpp {cmd=env args=[asyco -M 1mm -o fig-1a] output=html .hide}
import flowchart;

usepackage("amsmath");
usepackage("amssymb");
block n0 = block(-3cm, 0), n1 = block(3cm, 0);
block f = rectangle("$f$", (0, 0), minwidth=2cm, minheight=1.5cm);
draw(f);
label("$\mathbb{R}$", n0.center, W);
label("$\mathbb{R}$", n1.center, E);
add(new void(picture pic, transform t) {
  blockconnector operator --  = blockconnector(pic, t);
  n0 -- Label("$x$", 0.5, N) -- Arrow -- f --
    Label("$f(x)$", 0.5, N) -- Arrow -- n1;
    f -- Label("$y$", 0.5, S) -- Arrow -- n1;
});
```

![](fig-1a.svg){height=120 .C}

$$
f(x) = x^2 + 1
$$

```cpp {cmd=env args=[asyco -o fig-1b] continue=center output=html .hide}
import graph;

unitsize(8cm / 10, 8cm / 30);
defaultpen(fontsize(20pt));
pair a = (-5, 0), b = (5, 30);
real f(real x) { return x * x + 1; }
draw(graph(f=f, a.x, b.x), linewidth(1));
xaxis(Label("$x$", MidPoint), a.x, b.x, RightTicks(N=2, n=5));
yaxis(Label("$y$", MidPoint), XEquals(a.x), a.y, b.y, LeftTicks(N=3));
draw(box(a, b));
center((0, 15));
```

![](fig-1b.svg){width=40% .C}

### {.r-stretch}

### $\{(x, y)\} \subset \mathbb{R}^2$（二次元のグラフ）{.c}

<!-- .slide -->

## 複素関数のグラフ

```cpp {cmd=env args=[asyco -M 1mm -o fig-2a] continue=center output=html .hide}
import flowchart;

usepackage("amsmath");
usepackage("amssymb");
block n0 = block(-3cm, 0), n1 = block(3cm, 0);
block f = rectangle("$f$", (0, 0), minwidth=2cm, minheight=1.5cm);
draw(f);
label("$\mathbb{C}$", n0.center, W);
label("$\mathbb{C} \cong \mathbb{R}^2$", n1.center, E);
add(new void(picture pic, transform t) {
  blockconnector operator --  = blockconnector(pic, t);
  n0 -- Label("$z$", 0.5, N) -- Arrow -- f --
    Label("$f(z)$", 0.5, N) -- Arrow -- n1;
  n0 -- Label("$x+i\,y$", 0.5, S) -- f -- Label("$u+i\,v$", 0.5, S) -- n1;
});
center();
```

![](fig-2a.svg){height=120 .C}

$$
f(z) = z^2 + 1
$$

```cpp {cmd=env args=[asyco -o fig-2b] continue=center output=html .hide}
import graph;

unitsize(8cm / 10);
defaultpen(fontsize(20pt));
pair a = (-5, -5), b = (5, 5);
xaxis(Label("$x$", MidPoint), YEquals(a.y), a.x, b.x, RightTicks(N=2, n=5));
yaxis(Label("$y$", MidPoint), XEquals(a.x), a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));
label("?", (a.x + b.x, a.y + b.y) / 2, AvantGarde() + fontsize(60pt));

center();
```

![](fig-2b.svg){width=41% .C}

### {.r-stretch}

### $\{(x, y, u, v)\}\subset\mathbb{R}^4$（四次元のグラフ）{.c}

<!-- .slide -->

## 実部と虚部のグラフ

$$
f(z) = z^2 + 1 = u + i\,v
$$

```gnuplot {cmd args=["-e", "set term svg size 600, 240; set output 'fig-3.svg';"] output=none .hide}
I = {0, 1}
f(z) = z**2+1
unset key
set tics out nomirror
set ztics 30 offset 1.5
set isosamples 16, 16
set hidden3d
set contour
set xlabel "x" offset 6, 0.5
set ylabel "y" offset -9.5, 0.25
set multiplot layout 1, 2
set title "u"
splot [-5:5][-5:5][-60:60] real(f(x + I * y))
set title "v"
splot [-5:5][-5:5][-60:60] imag(f(x + I * y))
```

![](fig-3.svg){width=100% .C}

### { .r-stretch}

### 零点や極の直観的な把握が困難 {.c}

<!-- .slide -->

## 絶対値と偏角のグラフ

$$
f(z) = z^2 + 1 = r\,e^{i\,\theta}
$$

```gnuplot {cmd args=["-e", "set term svg size 600, 240; set output 'fig-4.svg';"] output=none .hide}
I = {0, 1}
f(z) = z**2+1
unset key
set tics out nomirror
set isosamples 32, 32
set hidden3d
set contour
set xlabel "x" offset 6, 0.5
set ylabel "y" offset -9.5, 0.25
set multiplot layout 1, 2
set title "r"
set ztics 30 offset 1.5
splot [-5:5][-5:5][0:60] abs(f(x + I * y))
set title "θ"
set ztics ("-π" -pi, "0" 0, "π" pi) offset 1.5
splot [-5:5][-5:5][-pi:pi] arg(f(x + I * y))
```

![](fig-4.svg){width=100% .C}

### {.r-stretch}

### 高さでは偏角 $\theta$ が $-\pi$ と $\pi$ で不連続 {.c}

<!-- .slide -->

## 明るさと色相によるグラフ

$$
f(z) = z^2 + 1 = r\,e^{i\,\theta}
$$

```gnuplot {cmd args=["-e", "set term svg size 600, 300; set output 'fig-5.svg';"] output=html .hide}
I = {0, 1}
f(z) = z**2+1
pal(z) = hsv2rgb((arg(z) / pi + 1) / 2, 1, 1)
unset key
set tics scale 0.5 out nomirror
set xtics offset 0, 1
set ytics offset 1, 0
set size ratio -1
set samples 64
set isosamples 64
set pm3d map
set xlabel "x" offset 0, 1.5
set ylabel "y" offset 1, 0
set multiplot layout 1, 2
set title "r"
set cbrange [0:60]
set cbtics 30
set palette gray negative
splot [-5:5][-5:5][0:60] abs(f(x + I * y))
set title "θ"
set cbrange [-pi:pi]
set cbtics ("-π" -pi, "0" 0, "π" pi)
set palette model HSV start 0.5 defined (0 0 1 1, 1 1 1 1)
splot [-5:5][-5:5] '++' using 1:2:(pal(f($1 + I * $2))) lc rgb variable
```

![](fig-5.svg){width=100% .C}

### {.r-stretch}

### 色相では偏角 $\theta$ が $-\pi$ と $\pi$ で連続 {.c}

<!-- .slide vertical=true -->

## 複素数を色で表現

$$
f(z) = z^2 + 1
$$

```tcl {cmd=gnuplot args=["-e", "set term svg size 600, 480; set output 'fig-6.svg';"] output=none .hide}
I = {0, 1}
f(z) = z * z + 1
l(r) = 1 - 1 / (1 + r)
pal(z) = hsv2rgb((arg(z) / pi + 1) / 2, l(abs(z)), 1 - l(abs(z))**16)
set pm3d map
set palette model HSV start 0.5 defined (0 0 1 1, 1 1 1 1)
set size ratio -1
set samples 200 # along Re(z)
set isosamples 200 # along Im(z)
unset key
set tics out nomirror
set xtics 5 offset 0, 1
set ytics 5 offset 1, 0
set mxtics 5
set mytics 5
set xlabel "x" offset 0, 1.5
set ylabel "y" offset 0, 0
set title "f(z)"
set cbtics ("-π" -pi, "0" 0, "π" pi)
set cblabel "arg"
set cbrange [-pi:pi]
splot [-5:5][-5:5] '++' using 1:2:(pal(f($1 + I * $2))) lc rgb variable
```

![](fig-6.svg){.C width=60%}

#### 白は零点に対応 {.c}

<!-- .slide -->

## 定義域の彩色 (Domain coloring)

入力 $z$ を複素平面の位置で、出力 $f(z)$ を色で表す

[　　Wikipedia の Domain coloring のページ](https://en.wikipedia.org/wiki/Domain_coloring)

<br>

ここでは次の 4 つのツールを紹介：

* gnuplot
* viscomplexr (R 言語)
* cplot (Python 言語)
* domcol.asy (Asymptote 言語)

他に [MATLAB](https://mathworks.com/products/matlab.html) なども利用可能

<!-- .slide -->

## 複素関数の例
$$
f(z) = \frac{(z^2 - 1)(z - 2 - i)^2}{z^2 + 2 + 2i}
$$

```cpp {cmd=env args=[asyco -o fig-7] continue=center output=html .hide}
import graph;
import markers;

unitsize(8cm / 10);
defaultpen(fontsize(20pt));
pair a = (-5, -5), b = (5, 5);
xaxis(Label("$x$", MidPoint), YEquals(a.y), a.x, b.x, RightTicks(N=2, n=5));
yaxis(Label("$y$", MidPoint), XEquals(a.x), a.y, b.y, LeftTicks(N=2, n=5));
draw(box(a, b));
draw(( 1, 0), scale(6) * Mark[0]);
draw((-1, 0), scale(6) * Mark[0]);
draw(( 2, 1), scale(6) * Mark[0]);
draw(-sqrt((-2, -2)), scale(6) * Mark[5]);
draw( sqrt((-2, -2)), scale(6) * Mark[5]);
```

![](fig-7.svg){width=40% .C}

#### 零点：$1,\ -1,\ 2+i\!\!$（重複度 2） <br> 極：$\sqrt{-2-2\,i}\approx0.643-1.553\,i,\ -\sqrt{-2-2\,i}$ {.c}

<!-- .slide -->

## gnuplot

[gnuplot](http://www.gnuplot.info) は広く用いられ複素数に対応するグラフ作成ソフトウェア

![](ex-gnuplot.svg){.C width=60%}

#### 白は零点、黒は極に対応 {.c}

<!-- .slide vertical=true -->

## gnuplot

```tcl {cmd=gnuplot args=["-e", "set term svg size 600, 480; set output 'ex-gnuplot.svg';"] output=none}
I = {0, 1}
f(z) = (z * z - 1) * (z - {2, 1})**2 / (z * z + {2, 2})
l(r) = 1 - 1 / (1 + r)
pal(z) = hsv2rgb((arg(z) / pi + 1) / 2, l(abs(z)), 1 - l(abs(z))**16)
set pm3d map
set palette model HSV start 0.5 defined (0 0 1 1, 1 1 1 1)
set size ratio -1
set samples 200 # along Re(z)
set isosamples 200 # along Im(z)
unset key
set tics out nomirror
set xtics 5 offset 0, 1
set ytics 5 offset 1, 0
set mxtics 5
set mytics 5
set xlabel "Re(z)" offset 0, 1.5
set ylabel "Im(z)" offset 0, 0
set cbtics ("-π" -pi, "0" 0, "π" pi)
set cblabel "arg"
set cbrange [-pi:pi]
set contour
set cntrparam levels discrete 0.5, 1, 2, 4, 8, 16, 32
set cntrlabel onecolor
splot [-5:5][-5:5] '++' using 1:2:(pal(f($1 + I * $2))) lc rgb variable nocontours, \
  '++' using 1:2:(abs(f($1 + I * $2))) with lines lc "black" nosurface
```

* 軽量で高速なツール
* HSV 色空間が均等色空間でないため色の筋が目立つ
* 偏角の等値線を描く方法は見つけられていない

<!-- .slide -->

## viscomplexr

[viscomplexr](https://github.com/PeterBiber/viscomplexr/) は [R 言語](https://www.r-project.org) による複素関数の相図を描くパッケージ

![](ex-viscomplexr.svg){.C width=64%}

<!-- .slide vertical=true -->

## viscomplexr

```R {cmd=Rscript args=["--no-save", "$input_file"] output=none}
library(viscomplexr)
library(svglite)
svglite("ex-viscomplexr.svg") # svg() may be not preferable
f <- function(z) { (z * z - 1) * (z - (2 + 1i))^2 / (z * z + (2 + 2i)); }
phasePortrait(f, xlim = c(-5, 5), ylim = c(-5, 5))
dev.off()
```
<br>

* 美しい可視化（[Wegret の本](https://link.springer.com/book/10.1007/978-3-0348-0180-5)に準拠）
* 絶対値を等値線で表すため極と零点の区別が難しい

<!-- .slide -->

## cplot

[cplot](https://github.com/nschloe/cplot) は [Python 言語](https://www.python.org) による複素関数プロットのためのパッケージ

![](ex-cplot.svg){.C}

#### 黒は零点、白は極に対応 {.c}

<!-- .slide vertical=true -->

## cplot

```py {cmd=python3 output=text}
import cplot
def f(z):
    return (z * z - 1) * (z - (2 + 1j))**2 / (z * z + (2 + 2j))
p = cplot.plot(f, (-5.0, +5.0, 400), (-5.0, +5.0, 400))
p.savefig("ex-cplot.svg", format="svg")
```
<br>

* 均等（OKLab）色空間を用いるため色の筋が目立たない
* 絶対値のスケーリング（高彩度での可視化）に慣れが必要

<!-- .slide -->

## domcol.asy

[domcol.asy](https://github.com/aelata/asy-toybox/blob/main/domcol.asy) は [Asymptote 言語](https://asymptote.sourceforge.io) による定義域の彩色モジュール

![](ex-domcol.svg){.C}

#### 白は零点、黒は極に対応 {.c}

<!-- .slide vertical=true -->

## domcol.asy

```cpp {cmd=env args=[asyco -o ex-domcol] output=none}
size(15cm);
import domcol;
pair f(pair z) { return (z * z - 1) * (z - (2, 1))**2 / (z * z + (2, 2)); }
pen pal(real l, real t) { return palHSY(l, t, a=0.8, b=-0.5); }
// pen pal(real l, real t) { return palOKLab(l, t, b=-0.5); }
domcol(
  f, (-5, -5), (5, 5), pal,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5));
```
<br>

* 絶対値の軸の自動縮尺（自動露出）
* 様々な色空間（HSY, Lab, OKLab など）での色調整
* 少し遅い描画速度
* TeX Live 環境の構築に手間

<!-- .slide -->

## まとめ

### 定義域の彩色
* 入力 $z$ を複素平面の位置で、出力 $f(z)$ を色で表すことで<br>複素関数を可視化
<br>

### ツール
* gnuplot、R 言語、Python 言語、Asymptote 言語などで<br>定義域の彩色を利用可能

<!-- .slide data-visibility="uncounted" data-background-color="lightgray" data-background-transition="none" -->

<!-- .slide data-visibility="uncounted" -->

## 恒等関数

$$
f(z)=z
$$

```cpp {cmd=env args=[asyco -o fig-a1] output=none .hide}
import domcol;

size(15cm);

pen pal(real l, real t) { return palHSY(l, t, a=0.8, b=-0.5); }

pair f(pair z) { return z; }

domcol(
  f, (-5, -5), (5, 5), c=0, pal,
  xticks=RightTicks(N=2, n=5), yticks=LeftTicks(N=2, n=5));
```

![](fig-a1.svg){.C width=60%}

<!-- .slide data-visibility="uncounted" -->

## 興味深い見た目の関数

$$
f(z)=\frac{(iz)^{-8} - (iz)^{-1}}{(iz)^{-1} - 1}
$$

```cpp {cmd=env args=[asyco -o fig-a2] continue=center output=none .hide}
import domcol;

size(15cm);

pen pal(real l, real t) { return palHSY(l, t, a=0.8, b=0.4); }

pair f(pair z) { z *= (0, 1); return (z**(-8) - 1 / z) / (1 / z - 1); }

domcol(
  f, (-2, -2), (2, 2), c=0, pal,
  xticks=RightTicks(N=2, n=2), yticks=LeftTicks(N=2, n=2),
  colbar=false, isoabs=false,
  xlabel="", ylabel="", rlabel="", tlabel="");
center();
```

![](fig-a2.svg){.C width=50%}

