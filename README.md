# color-scheme.js

Generate pleasant color schemes (sets of colors).

This library is based on the perl module [Color::Scheme](http://search.cpan.org/~rjbs/Color-Scheme-1.04/lib/Color/Scheme.pm), which is in turn based on the [Color Scheme Designer website](http://colorschemedesigner.com/).

Check out [how it works](http://c0bra.github.com/color-scheme-js/).

Get the [minified file](https://raw.github.com/c0bra/color-scheme-js/master/lib/color-scheme.min.js) (8kb).

Or for some reason, you could use the [full file](https://raw.github.com/c0bra/color-scheme-js/master/lib/color-scheme.js) (18kb).

## Table of Contents

- [Description](#description)
- [Usage](#usage)
- [Schemes](#schemes)
  - [mono](#mono-monochromatic)
  - [contrast](#contrast)
  - [triade](#triade)
  - [tetrade](#tetrade)
  - [analogic](#analogic)
- [Variations](#variations)
  - [pastel](#pastel)
  - [soft](#soft)
  - [light](#light)
  - [hard](#hard)
  - [pale](#pale)
- [Methods](#methods)

## Description

This module is a JavaScript implementation of the Perl implementation of Color Schemes
2 ([http://wellstyled.com/tools/colorscheme2](http://wellstyled.com/tools/colorscheme2)), a color scheme generator.
Start by visitng the Color Schemes 2 web site and playing with the colors.
When you want to generate those schemes on the fly, begin using this modoule.
The descriptions herein don't make too much sense without actually seeing the
colorful results.

Henceforth, paragraphs in quotes denote documentation copied from Color Schemes 2.

*"Important note: **This tool doesn't use the standard HSV or HSB model** (the
same HSV/HSB values ie. in Photoshop describe different colors!). The color
wheel used here differs from the RGB spectre used on computer screens, it's
more in accordance with the classical color theory. This is also why some
colors (especially shades of blue) make less bright shades than the basic
colors of the RGB-model. In plus, the RGB-model uses red-green-blue as primary
colors, but the red-yellow-blue combination is used here. This deformation also
causes incompatibility in color conversions from RGB-values. Therefore, the RGB
input (eg. the HTML hex values like #F854A9) is not exact, the conversion is
rough and sometimes may produce slightly different color."*

## Usage

### In node.js

Gotta install it first:

```
npm install color-scheme
```

```javascript
var ColorScheme = require('color-scheme');

var scheme = new ColorScheme;
scheme.from_hue(21)         // Start the scheme 
      .scheme('triade')     // Use the 'triade' scheme, that is, colors
                            // selected from 3 points equidistant around
                            // the color wheel.
      .variation('soft');   // Use the 'soft' color variation

var colors = scheme.colors();

/*
  colors = [ "e69373", "805240", "e6d5cf", "bf5830" ,
             "77d36a", "488040", "d2e6cf", "43bf30" ,
             "557aaa", "405c80", "cfd9e6", "306ebf" ]
*/
```

### In the browser

```html
<script src="wherever/your/installed/color-scheme.js"></script>

<script>
  // Pretty much the same exact syntax!
  var scheme = new ColorScheme;
  scheme.from_hue(21)         
        .scheme('triade')   
        .variation('soft');


  var colors = scheme.colors();

  /*
    colors = [ "e69373", "805240", "e6d5cf", "bf5830" ,
               "77d36a", "488040", "d2e6cf", "43bf30" ,
               "557aaa", "405c80", "cfd9e6", "306ebf" ]
  */
<script>
```

## Schemes

There are five color schemes.

### mono (monochromatic)

The monochromatic scheme is based on selecting a single hue on the color wheel, then adding more colors by varying the source color's saturation and brightness.

Four colors will be produced.

### contrast

Contrast supplements the selected hue with its complement (the color opposite it on the color wheel) as another source color.

8 colors will be produced.

### triade

Triade takes the selected hue and adds two more source colors that are both a certain distance from the initial hue.

The [distance()](#distancefloat) method can be used to specify how far additional source colors will be from the initial hue.

12 colors will be produced.

### tetrade

Tetrade adds another yet source color, meaning four total sources.

16 colors will be produced.

### analogic

Analogic produces colors that are "analogous", or next to each other on the color wheel.

Increasing the distance [distance()](#distancefloat) will push the colors away from each other. *"Values between 0.25 and 0.5 (15-30 degrees on the wheel) are optimal."*

12 colors will be produced.

Additionally, the [complement()](#complementbool) method can be used to add complementary colors (i.e. those that are opposite the source colors on the color wheel). This will result in 16 colors. *"It must be treated only as a complement - it adds tension to the palette, and it's too aggressive when overused. However, used in details and as accent of main colors, it can be very effective and elegant."*

## Variations

These variations will alter the produced colors. They basically work exactly like filters would in any image editing program.

### default

The default variation. No change to the colors.

```javascript
s.variation('default');
```

### pastel

Produces pastel colors, which have in HSV high value and low-intermediate saturation.

```javascript
s.variation('pastel');
```

### soft

Produces darker pastel colors.

```javascript
s.variation('soft');
```

### light

Very light, almost washed-out colors.

```javascript
s.variation('light');
```

### hard

Deeper, very saturated colors.

```javascript
s.variation('hard');
```

### pale

Colors with more gray; less saturated.

```javascript
s.variation('pale');
```

## Methods

ColorScheme instances use method chaining to alter settings.

### scheme([scheme_name])

Set the scheme to [scheme_name]. The possible values are 'mono', 'contrast', 'triade', 'tetrade', and 'analogic'.

```javascript
var s = new ColorScheme

// Set the scheme to analogic
s.scheme('analogic');
```

### distance([float])

**Note:** Only works with the schemes 'triade', 'tetrade', and 'analogic'. (Because 'mono' only has one source color, and with 'contrast' the two source colors are always 180 degrees away from each other.)

This method sets the distance of the additional source colors from the initial hue. The value must be a float from 0 to 1.

```javascript
var s = new ColorScheme;
var colors = s.scheme('triade')
 .distance(0.75)
 .colors();

/*
  colors = [ "ff9900", "b36b00", "ffe6bf", "ffcc80",
             "00b366", "007d48", "bfffe4", "80ffc9",
             "400099", "2d006b", "dabfff", "b580ff" ]
*/
```

### complement([bool])

Add complementary colors to the ```analogic``` scheme. Does not work with any other scheme.

### colors()

Returns the array of generated colors as hex values.

**Note:** Because this method returns the colors, it obviously *cannot* be chained afterwards.

```javascript
var colors = s.colors()
```
