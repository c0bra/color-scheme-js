
class ColorScheme

  # Helper
  typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

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
    colors = []
    colors.push(new ColorScheme.mutablecolor(60)) for [1..4]

    @col = colors
    @_scheme = 'mono'
    @_distance = 0.5
    @_web_safe = false
    @_add_complement = false


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
      mono     : () =>
      contrast : () =>
        used_colors = 2;
        @col[1].set_hue h
        @col[1].rotate(180)

      triade : () =>
        used_colors = 3
        dif = 60 * @_distance
        @col[1].set_hue h
        @col[1].rotate 180 - dif
        @col[2].set_hue h
        @col[2].rotate 180 + dif

      tetrade : () =>
        used_colors = 4
        dif = 90 * @_distance
        @col[1].set_hue h
        @col[1].rotate 180
        @col[2].set_hue h
        @col[2].rotate 180 + dif
        @col[3].set_hue h
        @col[3].rotate dif

      analogic : () =>
        used_colors = if @_add_complement then 4 else 3
        dif = 60 * @_distance

        # console.log "@col", @col

        @col[1].set_hue h
        @col[1].rotate dif
        @col[2].set_hue h
        @col[2].rotate 360 - dif
        @col[3].set_hue h
        @col[3].rotate 180

    # Alias for monochromatic
    dispatch['monochromatic'] = dispatch['mono']

    if dispatch[@_scheme]?
        dispatch[@_scheme]()
    else
        throw "Unknown color scheme name: #{@_scheme}"

    output = []

    for i in [0 .. used_colors - 1]
      for j in [0..3]
        output[i * 4 + j] = @col[i].get_hex(@_web_safe, j)

    return output

  ###

  colorset()

  Returns a list of lists of the colors in groups of four. This method simply
  allows you to reference a color in the scheme by its group isntead of its
  absolute index in the list of colors.  I am assuming that "colorset()"
  will make it easier to use this module with the templating systems that are
  out there.

  For example, if you were to follow the synopsis, say you wanted to retrieve
  the two darkest colors from the first two groups of the scheme, which is
  typically the second color in the group. You could retrieve them with
  "colors()"

      first_background  = (scheme.colors())[1];
      second_background = (scheme.colors())[5];

  Or, with this method,

      first_background  = (scheme.colorset())[0][1]
      second_background = (scheme.colorset())[1][1]

  ###

  colorset: () ->
    flat_colors = clone @colors()
    grouped_colors = []
    grouped_colors.push(flat_colors.splice(0, 4)) while flat_colors.length > 0
    return grouped_colors


  ###

  from_hue( degrees )

  Sets the base color hue, where 'degrees' is an integer. (Values greater than
  359 and less than 0 wrap back around the wheel.)

  The default base hue is 0, or bright red.

  ###

  from_hue: (h) ->
      throw "from_hue needs an argument" if !h?

      @col[0].set_hue h
      return this # chaining

  rgb2ryb: (rgb...) ->
    rgb = rgb[0] if rgb[0]? and typeIsArray(rgb[0])

    [red, green, blue] = rgb

    # Remove the white from the color
    white = Math.min(red, green, blue)
    red -= white
    green -= white
    blue -= white
    maxgreen = Math.max(red, green, blue)

    # Get the yellow out of the red+green
    yellow = Math.min(red, green)
    red -= yellow
    green -= yellow

    # If this unfortunate conversion combines blue and green, then cut each in half to
    # preserve the value's maximum range.
    if blue > 0 and green > 0
      blue /= 2
      green /= 2

    # Redistribute the remaining green.
    yellow += green
    blue += green

    # Normalize to values.
    maxyellow = Math.max(red, yellow, blue)
    if maxyellow > 0
      iN = maxgreen / maxyellow
      red *= iN
      yellow *= iN
      blue *= iN

    # Add the white back in.
    red += white
    yellow += white
    blue += white

    return [
      Math.floor(red)
      Math.floor(yellow)
      Math.floor(blue)
    ]

# ---
# generated by js2coffee 2.2.0

  rgb2hsv: (rgb...) ->
    # Handle being passed either a list of arguments, or an array
    rgb = rgb[0] if rgb[0]? and typeIsArray(rgb[0])

    [r, g, b] = rgb

    r /= 255
    g /= 255
    b /= 255

    min = Math.min [r, g, b]...
    max = Math.max [r, g, b]...
    d = max - min
    v = max

    # console. "minmax", min, max, d, v

    s
    if ( d > 0 )
      s = d / max
    else
      return [ 0, 0, v ]

    h = (
      if (r is max) then ((g - b) / d)
      else (
        if (g is max) then (2 + (b - r) / d)
        else (4 + (r - g) / d)
      )
    )

    h *= 60
    h %= 360

    # if (h < 0)
    #   h = 360 - h

    [h, s, v]

  rgbToHsv: (rgb...) ->
    rgb = rgb[0] if rgb[0]? and typeIsArray(rgb[0])
    [r, g, b] = rgb

    # [r, g, b] = @rgb2ryb [r, g, b]

    r /= 255
    g /= 255
    b /= 255

    max = Math.max(r, g, b)
    min = Math.min(r, g, b)

    h = undefined
    s = undefined
    v = max
    d = max - min
    s = if max == 0 then 0 else d / max

    if max == min
      h = 0
      # achromatic
    else
      switch max
        when r
          h = (g - b) / d + (if g < b then 6 else 0)
        when g
          h = (b - r) / d + 2
        when b
          h = (r - g) / d + 4
      h /= 6

    [h, s, v]

  ###

  from_hex( color )

  Sets the base color to the given color, where 'color' is in the hexidecimal
  form RRGGBB. 'color' should not be preceded with a hash (#).

  The default base color is the equivalent of #ff0000, or bright red.

  ###

  from_hex: (hex) ->
    throw "from_hex needs an argument" if !hex?
    throw "from_hex(#{hex}) - argument must be in the form of RRGGBB" unless /// ^ ( [0-9A-F]{2} ) {3} $ ///im.test(hex)

    rgbcap = /(..)(..)(..)/.exec(hex)[1..3]
    [r, g, b] = (parseInt(num, 16) for num in rgbcap)

    [r, g, b] = @rgb2ryb [r, g, b]

    hsv = @rgbToHsv(r, g, b)

    h0  = hsv[0]
    h1  = 0
    h2  = 1000
    i1 = null
    i2 = null
    h = null
    s = null
    v = null

    # NOTE: I honestly have no idea what this code was doing but it seems to work fine without it...
    # wheelKeys = []; wheelKeys.push i for own i of ColorScheme.COLOR_WHEEL
    # for i of wheelKeys.sort( (a, b) -> a - b )
    #   c = ColorScheme.COLOR_WHEEL[ wheelKeys[i] ]
    #
    #   hsv1 = @rgbToHsv( i for i in c[ 0 .. 2 ] )
    #   h = hsv1[0]
    #   if h >= h1 and h <= h0
    #       h1 = h
    #       i1 = i
    #   if h <= h2 and h >= h0
    #       h2 = h
    #       i2 = i
    #
    # if h2 == 0 or h2 > 360
    #   h2 = 360
    #   i2 = 360
    #
    # k = if ( h2 != h1 ) then ( h0 - h1 ) / ( h2 - h1 ) else 0
    # h = Math.round( i1 + k * ( i2 - i1 ) )
    # h %= 360

    h = hsv[0]
    s = hsv[1]
    v = hsv[2]

    @from_hue h * 360
    @_set_variant_preset( [ s, v, s, v * 0.7, s * 0.25, 1, s * 0.5, 1 ] )

    return this

  ###

  add_complement( BOOLEAN )

  If BOOLEAN is true, an extra set of colors will be produced using the
  complement of the selected color.

  This only works with the analogic color scheme. The default is false.

  ###

  add_complement: (b) ->
    throw "add_complement needs an argument" if !b?
    @_add_complement = b
    return this

  ###

  web_safe( BOOL )

  Sets whether the colors returned by L<"colors()"> or L<"colorset()"> will be
  web-safe.

  The default is false.

  ###

  web_safe: (b) ->
    throw "web_safe needs an argument" if !b?
    @_web_safe = b
    return this

  ###

  distance( FLOAT )

  'FLOAT'> must be a value from 0 to 1. You might use this with the "triade"
  "tetrade" or "analogic" color schemes.

  The default is 0.5.

  ###

  distance: (d) ->
      throw "distance needs an argument" if !d?
      throw "distance(#{d}) - argument must be >= 0" if d < 0
      throw "distance(#{d}) - argument must be <= 1" if d > 1
      @_distance = d
      return this

  ###

  scheme( name )

  'name' must be a valid color scheme name. See "Color Schemes". The default
  is "mono"

  ###

  scheme: (name) ->
    if !name?
      return @_scheme
    else
      throw "'#{name}' isn't a valid scheme name" unless ColorScheme.SCHEMES[name]?
      @_scheme = name
      return this

  ###

  variation( name )

  'name' must be a valid color variation name. See "Color Variations"

  ###

  variation: (v) ->
    throw "variation needs an argument"       unless v?
    throw "'$v' isn't a valid variation name" unless ColorScheme.PRESETS[v]?
    @_set_variant_preset ColorScheme.PRESETS[v]
    return this

  _set_variant_preset: (p) ->
    @col[i].set_variant_preset(p) for i in [0 .. 3]

  clone = (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj

    if obj instanceof Date
      return new Date(obj.getTime())

    if obj instanceof RegExp
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags)

    newInstance = new obj.constructor()

    for key of obj
      newInstance[key] = clone obj[key]

    return newInstance

  # End ColorScheme class #



  # Subclass for mutable colors #
  class @mutablecolor
    hue             : 0
    saturation      : []
    value           : []
    base_red        : 0
    base_green      : 0
    base_saturation : 0
    base_value      : 0

    constructor: (hue) ->
      throw "No hue specified" if !hue?

      @saturation      = []
      @value           = []
      @base_red        = 0
      @base_green      = 0
      @base_blue       = 0
      @base_saturation = 0
      @base_value      = 0
      @set_hue hue

      @set_variant_preset ColorScheme.PRESETS['default']

    get_hue: () ->
      @hue

    set_hue: (h) ->
      avrg = (a, b, k) ->
        a + Math.round( ( b - a ) * k )

      @hue = Math.round h % 360
      d = @hue % 15 + ( @hue - Math.floor( @hue ) );
      k = d / 15;

      derivative1 = @hue - Math.floor(d)
      derivative2 = ( derivative1 + 15 ) % 360

      if derivative1 == 360
        derivative1 = 0

      if derivative2 == 360
        derivative2 = 0

      colorset1 = ColorScheme.COLOR_WHEEL[derivative1]
      colorset2 = ColorScheme.COLOR_WHEEL[derivative2]

      en =
        red: 0
        green: 1
        blue: 2
        value: 3

      # while ( my ( $color, $i ) = each %enum ) {
      for color, i of en
          this["base_#{color}"] = avrg( colorset1[i], colorset2[i], k )

      @base_saturation = avrg( 100, 100, k ) / 100
      @base_value /= 100

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
      # console.log "set_variant(#{variation}, #{s}, #{v}) on #{this}"
      @saturation[variation] = s
      @value[variation]      = v

    set_variant_preset: (p) ->
      # console.log "set_variant_preset(#{p})"
      @set_variant( i, p[ 2 * i ], p[ 2 * i + 1 ] ) for i in [0 .. 3]

    get_hex: (web_safe, variation) ->
      max = Math.max ( this["base_#{color}"] for color in ['red', 'green', 'blue'] )...
      min = Math.min ( this["base_#{color}"] for color in ['red', 'green', 'blue'] )...

      v = ( if variation < 0 then @base_value else @get_value(variation) ) * 255

      s = if variation < 0 then @base_saturation else @get_saturation(variation)
      k = if max > 0 then v / max else 0

      rgb = []
      for color in ['red', 'green', 'blue']
        rgbVal = Math.min [ 255, Math.round(v - ( v - this["base_#{color}"] * k ) * s) ]...
        rgb.push rgbVal

      if web_safe
        rgb = ( Math.round(c / 51) * 51 for c in rgb )

      formatted = ""
      for i in rgb
        str = i.toString(16)
        if str.length < 2
          str = "0"+str

        formatted += str


      return formatted

if module? and module.exports?
  module.exports = ColorScheme
else
  if typeof define == 'function' and define.amd
    define [], () ->
      return ColorScheme
  else
    self.ColorScheme = ColorScheme
