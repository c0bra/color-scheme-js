
chai = require 'chai'
should = chai.should()

ColorScheme = require '../src/lib/color-scheme'

describe 'ColorScheme class', ->
  describe '"mutablecolor" subclass', ->
    it 'should exist', ->
      ColorScheme.mutablecolor.should.exist
    it 'should be a function', ->
      ColorScheme.mutablecolor.should.be.a 'function'
    
describe '"mutablecolor"', ->
  describe 'constructor', ->
    describe 'with no hue specified', ->
      it 'should throw "No hue specified"', ->
        (() ->
          new ColorScheme.mutablecolor()
        ).should.Throw("No hue specified")
    describe 'with a hue specified', ->
      it 'should be a ColorScheme.mutablecolor object', ->
        color = new ColorScheme.mutablecolor(50)
        color.should.be instanceof ColorScheme.mutablecolor