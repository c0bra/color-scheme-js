
eyes = require 'eyes'
chai = require 'chai'
chai.should()

ColorScheme = require '../src/lib/color-scheme'
#ColorScheme = require '../lib/color-scheme.min'

describe 'ColorScheme class', ->
  describe 'SCHEMES Object', ->
    it 'should exist', ->
      ColorScheme.SCHEMES.should.exist
    it 'should be an object', ->
      ColorScheme.SCHEMES.should.be.a 'object'
    it 'should have property for "mono"', ->
      ColorScheme.SCHEMES.mono.should.exist
    it 'should have property for "contrast"', ->
      ColorScheme.SCHEMES.contrast.should.exist

  describe 'PRESETS object', ->
    it 'should exist', ->
      ColorScheme.PRESETS.should.exist
    it 'should have a property for "default"', ->
      ColorScheme.PRESETS.default.should.exist

  describe 'COLOR_WHEEL object', ->
    it 'should exist', ->
      ColorScheme.COLOR_WHEEL.should.exist


describe 'ColorScheme instance', ->
  scheme = new ColorScheme
  it 'should be a ColorScheme object', ->
    scheme.should.be instanceof ColorScheme



# scm = new ColorScheme

# scm.from_hue(21)
#   .scheme('triade')
#   .distance(0.1)
#   .add_complement(false)
#   .variation('pastel')
#   .web_safe(true)

# # # console.log eyes.inspect(scm)

# list = scm.colors()
# console.log list