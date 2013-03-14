
chai = require 'chai'
chai.should()

ColorScheme = require '../src/lib/color-scheme'

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