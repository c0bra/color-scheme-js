# color-scheme.js

Generate pleasant color schemes.

This library is based on the perl module [Color::Scheme](http://search.cpan.org/~rjbs/Color-Scheme-1.04/lib/Color/Scheme.pm), which is in turn based on the [Color Scheme Designer website](http://colorschemedesigner.com/).

Check out [examples](http://c0bra.github.com/color-scheme-js/) of how it works.

## Description

This module is a JavaScript implementation of the Perl implementation of Color Schemes
2 ([http://wellstyled.com/tools/colorscheme2](http://wellstyled.com/tools/colorscheme2)), a color scheme generator.
Start by visitng the Color Schemes 2 web site and playing with the colors.
When you want to generate those schemes on the fly, begin using this modoule.
The descriptions herein don't make too much sense without actually seeing the
colorful results.

Henceforth, paragraphs in quotes denote documentation copied from Color Schemes 2.

"Important note: This tool *doesn't use the standard HSV or HSB model* (the
same HSV/HSB values ie. in Photoshop describe different colors!). The color
wheel used here differs from the RGB spectre used on computer screens, it's
more in accordance with the classical color theory. This is also why some
colors (especially shades of blue) make less bright shades than the basic
colors of the RGB-model. In plus, the RGB-model uses red-green-blue as primary
colors, but the red-yellow-blue combination is used here. This deformation also
causes incompatibility in color conversions from RGB-values. Therefore, the RGB
input (eg. the HTML hex values like #F854A9) is not exact, the conversion is
rough and sometimes may produce slightly different color."