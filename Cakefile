# Cakefile for sto
# Runs on Windows, c9.io and Debian
# list reporter gets messages even on Windows.
# NPM and node are prerequisites


{exec} = require "child_process"

path = require "path"
s = path.sep

NPM = "npm"
bin = ".#{s}node_modules#{s}.bin"
MOCHA  = "#{bin}#{s}mocha"
#REPORTER = "json-cov"
REPORTER = "list"
COFFEE = "#{bin}#{s}coffee"
RUNFILE = "app.coffee"


# reads ./packages.json
task "install", "finish installing dependencies: ./node_modules", ->
  exec "
    #{NPM} install
  ", (err, output) ->
    throw err if err
    console.log output
    
task "test", "run tests", ->
  process.env["NODE_ENV"] = "test"
  exec "
    #{MOCHA}
    --timeout 8000
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --growl
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


    