fs = require 'fs'
sys = require 'sys'
path = require 'path'
{exec} = require 'child_process'
UglifyJS = require 'uglify-js'

task 'test', 'Test this module', ->
  test()

task 'build', 'Build this module', ->
  build()

task 'minify', 'Minify the compiled javascript source', ->
  minify()


test = (callback) ->
  console.log "Testing..."

  child = exec '"node_modules/.bin/mocha" --compilers coffee:coffee-script test', (err, stdout, stderr) ->
    # console.log stdout
    # console.log stderr

    if err?
      process.exit()
    else
      callback() if callback?

  # Redirect the child process' output to our stdout
  child.stdout.on 'data', (data) -> sys.print data
  child.stderr.on 'data', (data) -> sys.print data

build = (callback) ->
  test () ->
    console.log "Building..."

    # Create the lib directory if it doesn't exist
    if !fs.existsSync("lib")
      fs.mkdirSync "lib"

    # Compile the library
    child = exec '"node_modules/.bin/coffee" -o lib ./src/lib/color-scheme.coffee', (err, stdout, stderr) ->
      if err?
        throw err

      # invoke 'minify'
      minify () ->
        console.log "Done!"
        callback() if callback?

    # Redirect the child process' output to our stdout
    child.stdout.on 'data', (data) -> sys.print data
    child.stderr.on 'data', (data) -> sys.print data

minify = (callback) ->
  console.log "Minifying..."

  compiled = UglifyJS.minify('lib/color-scheme.js')
  fs.writeFileSync 'lib/color-scheme.min.js', compiled.code.toString()

  callback() if callback?