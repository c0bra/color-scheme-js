fs = require 'fs'
sys = require 'sys'
path = require 'path'
{exec} = require 'child_process'
UglifyJS = require 'uglify-js'

task 'compile', 'Compile coffee-script to JavaScript', ->
  compile()

task 'test', 'Test this module', ->
  test()

task 'build', 'Build this module', ->
  build()

task 'minify', 'Minify the compiled javascript source', ->
  minify()

compile = (callback) ->
  console.log "Compiling..."

  # Create the lib directory if it doesn't exist
  if !fs.existsSync("lib")
    fs.mkdirSync "lib"

  # Compile the library
  child = exec '"node_modules/.bin/coffee" -m -o lib ./src/lib/color-scheme.coffee', (err, stdout, stderr) ->
    if err?
      throw err
    else
      callback() if callback?

  # Redirect the child process' output to our stdout
  child.stdout.on 'data', (data) -> sys.print data
  child.stderr.on 'data', (data) -> sys.print data

test = (callback) ->
  console.log "Testing..."

  child = exec '"node_modules/.bin/mocha" --reporter list --compilers coffee:coffee-script/register test', (err, stdout, stderr) ->
    # console.log stdout
    # console.log stderr

    if err?
      process.exit()
    else
      callback() if callback?

  # Redirect the child process' output to our stdout
  child.stdout.on 'data', (data) -> sys.print data
  child.stderr.on 'data', (data) -> sys.print data

minify = (callback) ->
  console.log "Minifying..."

  compiled = UglifyJS.minify('lib/color-scheme.js')
  fs.writeFileSync 'lib/color-scheme.min.js', compiled.code.toString()

  callback() if callback?

# Run all the tasks one after the other!
build = (callback) ->
  test () ->
    compile () ->
      minify () ->
        console.log "Done!"
        callback() if callback?