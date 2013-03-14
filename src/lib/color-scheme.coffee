
_ = require 'lodash'

splitwords = (words) ->
  words.split /\s+/


# List of possible schemes
SCHEMES = _.map splitwords "mono monochromatic contrast triade tetrade analogic", (w) ->
  w = 1;



class ColorScheme
  constructor: () ->



# root = exports ? window
# root.ColorScheme = ColorScheme
module.exports = ColorScheme