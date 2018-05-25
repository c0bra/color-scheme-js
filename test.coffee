cs = require './src/lib/color-scheme'

scheme = new cs().from_hex '00ff00'

console.log scheme.col[0].hue
