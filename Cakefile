fs = require 'fs'
path = require 'path'
{exec} = require 'child_process'
UglifyJS = require 'uglify-js'

task 'test', 'Test this module', ->
  exec '"node_modules/.bin/mocha" --compilers coffee:coffee-script test', (err, stdout, stderr) ->
    console.log stdout
    console.log stderr

    if err?
      process.exit()

task 'build', 'Build this module', ->
  invoke 'test'

  # Create the lib directory if it doesn't exist
  if !fs.existsSync("lib")
    fs.mkdirSync "lib"

  # Compile the library
  exec '"node_modules/.bin/coffee" -o lib ./src/lib/color-scheme.coffee', (err, stdout, stderr) ->
    if err?
      throw err

    invoke 'minify'

task 'minify', 'Minify the compiled javascript source', ->
  compiled = UglifyJS.minify('lib/color-scheme.js')
  fs.writeFileSync 'lib/color-scheme.min.js', compiled.code.toString()