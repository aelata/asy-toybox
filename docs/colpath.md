### colpath.asy

#### 2D path
```cpp {cmd=env args=[asyco] output=html}
import colpath;
unitsize(2cm);
draw(
  (1, 0) -- (-1/2, -sqrt(3/4)), red+5pt, blue);
```

```cpp {cmd=asyco continue=prep output=html}
import colpath;
unitsize(2cm);
draw_colpath(
  subpath(polygon(6), 5, 7), new pen[] {blue+5bp, magenta, red});
```

```cpp {cmd=asyco continue=prep output=html}
import colpath;
unitsize(2cm);
draw_colpath(
  subpath(polygon(6), 1, 5), new pen[] {red+5bp, yellow, green, cyan, blue});
```

```cpp {cmd=asyco continue=prep output=html}
import colpath;
unitsize(2cm);
draw_colpath(
  polygon(6), new pen[] {magenta+5bp, red, yellow, green, cyan, blue});
```

```cpp {cmd=env args=[asyco] output=html}
import colpath;
unitsize(2cm);
draw_colpath(
  unitcircle, new pen[] {red+5pt, yellow, green, cyan, blue, magenta});
```


#### 3D path
```cpp {cmd=env args=[asyco -render 0] output=html}
import colpath;

currentlight = nolight;
currentprojection = orthographic(dir(64, 56 - 90), center=false);

unitsize(3cm);
draw(-2X -- 2X, Arrow3);
draw(-2Y -- 2Y, Arrow3);

path3 hex = path3(polygon(6));
triple p1 = point(hex, 1), p5 = point(hex, 5);
draw_colpath(
  shift(-1.5Z) * unitcircle3,
  new pen[] {magenta+5bp, red, yellow, green, cyan, blue});
draw(-1.5Z -- O);
draw_colpath(
  hex,
  new pen[] {magenta+5bp, red, yellow, green, cyan, blue});
draw_colpath(
  shift(0.5Z) * subpath(hex, 1, 5),
  new pen[] {red+5bp, yellow, green, cyan, blue});
draw(O -- 1.5Z, Arrow3);
draw_colpath(
  shift(Z) * subpath(hex, 5, 7),
  new pen[] {blue+5bp, magenta, red});
draw(shift(1.5Z) * (p1 -- p5), red+5pt, blue);
draw((p1 - 1.5Z) -- (p1 + 1.5Z), dashed);
draw((p5 - 1.5Z) -- (p5 + 1.5Z), dashed);
```
