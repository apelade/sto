# Cakefile

{exec} = require "child_process"

REPORTER = "min"

task "test", "run tests", ->
  exec "NODE_ENV=test 
    ./node_modules/.bin/mocha 
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script 
    --colors
  ", (err, output) ->
    throw err if err
    console.log output

# Currently have to ps -ef | grep coffee to see which one to kill
task "server", "start the server", ->
  exec "./node_modules/.bin/coffee app.coffee", (err, output) ->
    throw err if err
    console.log output