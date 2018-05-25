const ColorScheme = require('./lib/color-scheme');

const mainColor = '000000';

let scheme = new ColorScheme();
        scheme.from_hex(mainColor)
            .scheme('triade')
            .distance(0.7)
            .variation('pastel');
