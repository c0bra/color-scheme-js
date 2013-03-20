# color-scheme.js

Generate pleasant color schemes.

This library is based on the perl module [Color::Scheme](http://search.cpan.org/~rjbs/Color-Scheme-1.04/lib/Color/Scheme.pm), which is in turn based on the [Color Scheme Designer website](http://colorschemedesigner.com/).

Check out [how it works](http://c0bra.github.com/color-scheme-js/).

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

    var ColorScheme = require('color-scheme');

    var scheme = new ColorScheme;
    scheme.from_hue(21)         // Start the scheme 
          .scheme('triade')     // Use the 'triade' scheme, that is, colors
                                // selected from 3 points equidistant around
                                // the color wheel

          .variation('pastel')  // Use the 'soft' color variation


    var colors = scheme.colors();

    # colors = [ "e69373" , "805240" , "e6d5cf" , "bf5830" , "77d36a" , "488040" , "d2e6cf" , "43bf30" , "557aaa" , "405c80" , "cfd9e6" , "306ebf" ]

### In the browser

    <script src="wherever/your/installed/color-scheme.js"></script>

    <script>
      // Pretty much the same exact syntax!
      var scheme = new ColorScheme;
      scheme.from_hue(21)         // Start the scheme 
            .scheme('triade')     // Use the 'triade' scheme, that is, colors
                                  // selected from 3 points equidistant around
                                  // the color wheel

            .variation('pastel')  // Use the 'soft' color variation


      var colors = scheme.colors();

      # colors = [ "e69373" , "805240" , "e6d5cf" , "bf5830" , "77d36a" , "488040" , "d2e6cf" , "43bf30" , "557aaa" , "405c80" , "cfd9e6" , "306ebf" ]
    <script>

## Schemes

There are five color schemes.

### mono (monochromatic)

The monochromatic scheme is based on selecting a single hue on the color wheel, then adding more colors by varying the source color's saturation and brightness.

### contrast

Contrast supplements the selected hue with its complement (the color opposite it on the color wheel) as another source color.

### triade

Triade takes the selected hue and adds two more source colors that are equidistant around the color wheel, i.e. each source color is 120 degrees away from the others.

## Variations

These variations will alter the produced colors. They basically work exactly like filters would in any image editing program.

## Methods

ColorScheme instances use method chaining to alter settings.

### .scheme([scheme_name])

Set the scheme to [scheme_name]. The possible values are 'mono', 'contrast', 'triade', 'tetrade', and 'analogic'.

    var s = new ColorScheme

    // Set the scheme to analogic
    s.scheme('analogic');