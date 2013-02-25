# Cakefile for sto
# Runs on Windows, c9.io and Debian
# List reporter gets messages even on Windows.
# Still no mocha test results from asynch embedded methods using done()
# in test/routes-test.coffee but it does break when the assertions fail. 

{exec} = require "child_process"

path = require "path"
s = path.sep
bin = ".#{s}node_modules#{s}.bin"
MOCHA  = "#{bin}#{s}mocha"
REPORTER = "list"
COFFEE = "#{bin}#{s}coffee"
RUNFILE = "app.coffee"

task "test", "run tests", ->
  process.env["NODE_ENV"] = "test"
  exec "
    #{MOCHA}
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script 
    --colors
  ", (err, output) ->
    throw err if err
    console.log output

# Currently have to enter 'ps -ef | grep coffee' to get PIDs and stop with kill.
# There are two processes. In windows, they are node.exe
task "server", "start the server", ->
  exec "
    #{COFFEE} #{RUNFILE}
  ", (err, output) ->
    throw err if err
    console.log output
