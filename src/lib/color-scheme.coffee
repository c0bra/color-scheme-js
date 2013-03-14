
_ = require 'lodash'
sprintf = require('sprintf').sprintf;

class ColorScheme
  # Helper function to split words up
  splitwords = (words) ->
    words.split /\s+/

  # List of possible color scheme types
  @SCHEMES = {};
  @SCHEMES[word] = true for word in "mono monochromatic contrast triade tetrade analogic".split /\s+/
  
  @PRESETS =
    default : [ -1,   -1,    1,   -0.7, 0.25, 1,   0.5,  1 ],
    pastel  : [ 0.5,  -0.9,  0.5, 0.5,  0.1,  0.9, 0.75, 0.75 ]
    soft    : [ 0.3,  -0.8,  0.3, 0.5,  0.1,  0.9, 0.5,  0.75 ]
    light   : [ 0.25, 1,     0.5, 0.75, 0.1,  1,   0.5,  1 ]
    hard    : [ 1,    -1,    1,   -0.6, 0.1,  1,   0.6,  1 ]
    pale    : [ 0.1,  -0.85, 0.1, 0.5,  0.1,  1,   0.1,  0.75 ]

  @COLOR_WHEEL =
    # hue => [ red, green, blue, value ]
    0   : [ 255, 0,   0,   100 ]
    15  : [ 255, 51,  0,   100 ]
    30  : [ 255, 102, 0,   100 ]
    45  : [ 255, 128, 0,   100 ]
    60  : [ 255, 153, 0,   100 ]
    75  : [ 255, 178, 0,   100 ]
    90  : [ 255, 204, 0,   100 ]
    105 : [ 255, 229, 0,   100 ]
    120 : [ 255, 255, 0,   100 ]
    135 : [ 204, 255, 0,   100 ]
    150 : [ 153, 255, 0,   100 ]
    165 : [ 51,  255, 0,   100 ]
    180 : [ 0,   204, 0,   80 ]
    195 : [ 0,   178, 102, 70 ]
    210 : [ 0,   153, 153, 60 ]
    225 : [ 0,   102, 178, 70 ]
    240 : [ 0,   51,  204, 80 ]
    255 : [ 25,  25,  178, 70 ]
    270 : [ 51,  0,   153, 60 ]
    285 : [ 64,  0,   153, 60 ]
    300 : [ 102, 0,   153, 60 ]
    315 : [ 153, 0,   153, 60 ]
    330 : [ 204, 0,   153, 80 ]
    345 : [ 229, 0,   102, 90 ]

  constructor: () ->
    @colors = []
    @colors.push(new ColorScheme.mutablecolor(60)) for [1..4]

    @distance = 0.5
    @web_safe = false
    @add_complement = false


  ###

  colors()

  Returns an array of 4, 8, 12 or 16 colors in RRGGBB hexidecimal notation
  (without a leading "#") depending on the color scheme and addComplement
  parameter. For each set of four, the first is usually the most saturated color,
  the second a darkened version, the third a pale version and fourth
  a less-pale version. 

  For example: With a contrast scheme, "colors()" would return eight colors.
  Indexes 1 and 5 could be background colors, 2 and 6 could be foreground colors.

  Trust me, it's much better if you check out the Color Scheme web site, whose
  URL is listed in "Description"

  ###

  colors: () ->
    used_colors = 1;
    h           = @col[0].get_hue()

    # Should these be fat arrows (=>) so that the @ refers to the right object?
    dispatch =
        mono     : () ->
        contrast : () ->
            used_colors = 2;
            @col[1].set_hue(@h)
            @col[1].rotate(180)
        
        triade : () ->
            used_colors = 3
            dif = 60 * @distance
            @col[1].set_hue h
            @col[1].rotate 180 - dif
            @col[2].set_hue h
            @col[2].rotate 180 + dif
        
        tetrade : () ->
            used_colors = 4
            dif = 90 * @distance
            @col[1].set_hue h
            @col[1].rotate 180
            @col[2].set_hue h
            @col[2].rotate 180 + dif
            @col[3].set_hue h
            @col[3].rotate dif
        
        analogic : () ->
            used_colors = if add_complement then 4 else 3
            dif = 60 * @distance
            @col[1].set_hue h
            @col[1].rotate dif
            @col[2].set_hue h
            @col[2].rotate 360 - dif
            @col[3].set_hue h
            @col[3].rotate 180
    
    # Alias for monochromatic
    dispatch[monochromatic] = dispatch[mono]

    if dispatch[@scheme]?
        dispatch[@scheme]()
    else
        throw "Unknown color scheme name: #{@scheme}"

    output = []

    for i in [0 .. used_colors - 1]
      for j in [0..3]
        output[i * 4 + j] = @col[i].get_hex(@websafe, j)

    return output



  # Class for mutable colors
  class @mutablecolor
    hue             : 0
    saturation      : []
    value           : []
    base_red        : 0
    base_green      : 0
    base_saturation : 0
    base_value      : 0

    constructor: (@hue) ->
      throw "No hue specified" if !@hue?

    set_hue: (h) ->
      avrg = (a, b, k) ->
        a + Math.round( ( b - a ) * k )

      @hue = Math.round h % 360
      d = @hue % 15 + ( @hue - Math.floor( @hue ) );
      k = d / 15;

      derivative1 = @hue - Math.floor(d)
      derivative2 = ( derivative1 + 15 ) % 360
      colorset1   = COLOR_WHEEL[derivative1]
      colorset2   = COLOR_WHEEL[derivative2]

      en =
        red: 0
        green: 1
        blue: 2
        value: 3

      # while ( my ( $color, $i ) = each %enum ) {
      _.each en, (i, color) ->
          this["base_#{color}"] = avrg( colorset1[i], colorset2[i], k )

      @base_saturation = avrg( 100, 100, k ) / 100
      @base_value /= 100;

    # Rotate the hue a certain number of degrees
    rotate: (angle) ->
      newhue = ( @hue + angle ) % 360;
      @set_hue newhue

    get_saturation: (variation) ->
      x = @saturation[variation]
      s = if x < 0 then -x * @base_saturation else x
      s = 1 if s > 1
      s = 0 if s < 0
      return s

    get_value: (variation) ->
      x = @value[variation]
      v = if x < 0 then -x * @base_value else x
      v = 1 if v > 1
      v = 0 if v < 0
      return v

    set_variant: (variation, s, v) ->
        @saturation[variation] = s
        @value[variation]      = v

    set_variant_preset: (p) ->
      @set_variant( i, p[ 2 * i ], p[ 2 * i + 1 ] ) for i in [0 .. 3]

    get_hex: (web_safe, variation) ->
      max = _.max( this["base_#{color}"] for color in ['red', 'green', 'blue'] )
      min = _.min( this["base_#{color}"] for color in ['red', 'green', 'blue'] )

      v = ( if variation < 0 then @base_value else @get_value(variation) ) * 255

      s = if variation < 0 then @base_saturation else @get_saturation(variation)
      k = if max > 0 then v / max else 0

      rgb = _.map ['red', 'green', 'blue'], (color) ->
        return _.min 255, Math.round(v - ( v - this["base_#{color}"] * k ) * s)

      if web_safe
        rgb = _.map rgb, (c) ->
          Math.round(c / 51) * 51

      format = ""
      format += '%02x' for [1..rgb.length]

      return sprintf format, rgb


# root = exports ? window
# root.ColorScheme = ColorScheme
module.exports = ColorScheme