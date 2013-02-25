# Cakefile for sto
# Now runs on Win7, c9.io and Debian
# List reporter gets messages even on Windows.
# Still no mocha test results from asynch embedded methods using done()
# in test/routes-test.coffee but it does break when the assertions fail. 

{exec} = require "child_process"

path = require "path"
cs = path.sep
BIN = ".#{cs}node_modules#{cs}.bin#{cs}"
MOCHA  = "#{BIN}mocha"
REPORTER = "list"
COFFEE = "#{BIN}coffee"
RUNFILE = "app.coffee"
process.env["NODE_ENV"] = "test"

task "test", "run tests", ->
  exec "#{MOCHA}
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script 
    --colors
  ", (err, output) ->
    throw err if err
    console.log output

# Currently have to enter "cake server &" or ps -ef | grep coffee to get PIDs
# Then stop with kill. There are two processes.
task "server", "start the server", ->
  exec "#{COFFEE} #{RUNFILE}", (err, output) ->
    throw err if err
    console.log output
