
chai = require 'chai'
chai.should()

ColorScheme = require '../src/lib/color-scheme'

# console.log "TYPE", ColorScheme
# scheme = new ColorScheme

describe 'ColorScheme instance', ->
  scheme = null
  it 'should be a ColorScheme object', ->
    scheme = new ColorScheme
    scheme.should.be instanceof ColorScheme
