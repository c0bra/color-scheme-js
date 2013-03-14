fs = require 'fs'
path = require 'path'
{exec} = require 'child_process'

task 'test', 'Test this module', ->
  exec 'mocha --compilers coffee:coffee-script test', (err, stdout, stderr) ->
    console.log stdout
  
  

task 'build', 'Build this module', ->
  # Create the lib directory if it doesn't exist
  if !fs.existsSync("lib")
    fs.mkdirSync "lib"

  # Compile the library
  exec 'coffee -o lib ./src/lib/color-scheme.coffee', (err, stdout, stderr) ->
    if err?
      throw err