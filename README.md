Project "sto" : {


  Description: {
    E-commerce site demo, ideally same db for a python-uWSGI version
    All Coffeescript project in c9.io IDE and using their apis.
    Using netbeans and local mongod if faster server restarts are needed.
    (express reload?)
  }
  
  
  Install: {
    Unzip to a location.
    On a command prompt, cd there, to directory 'sto'. You may need to be admin.
    Enter 'npm install' for it to read packages.json.
    If you don't have npm, it's part of the node.js download now.
  }
  
  
  Run: {
    The Cakefile doesn't like windows the way it is now.
    It works on Linux like 'cake test' or 'cake server'
    (It launches two server processes so it's harder to kill it
    would use 'cake server &' but it only gave one PID)
    or, once you have node and the modules installed, in 'sto' directory
    enter 'coffee app.coffee'
  }
  
  
  Dependencies:{
    Node and npm are prerequisites, as they are used to read
    and install which packages are listed in /sto/package.json
    Coffeescript, although it does compile to js so node could run it instead
    Express web server
    Mongoose object modeler
    Jade view templates
    Mocha and Should (may try Chai), some kind of load tester
    Trying a shared mongod, Dharma 2.3 Experimental from mongohq, with 512 Mb max
  }
  
  
  Resources: {
    cloudnine : 'sto/apelade/c9.io'
    github    : 'github.com/apelade/sto'
    mongohq   : 'mongodb://sto_user:*******@linus.mongohq.com:10083/mdb-prod'
  }

}
