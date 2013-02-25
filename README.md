'Project Sto' :{

  Description:{
    E-commerce site demo, ideally same db for a python-uWSGI version
    All Coffeescript project in c9.io IDE and using their apis.
    Using netbeans and local mongod if faster server restarts are needed.
    (express reload?)
  }
  
  , Install:{
    Unzip to a location. You may need to be admin.
    On a command prompt, cd there, to directory 'sto'.
    Enter 'npm install' for it to read packages.json.
    If you don't have npm, it comes with node now: http://nodejs.org/
  }
  
  , Run:{
    It works on Linux or Windows like 'cake test' or 'cake server'
    or, once you have node and the modules installed, in 'sto' directory
    enter 'coffee app.coffee'
  }
  
  , Dependencies:{
    Node and npm are needed to install packages listed in sto/package.json
    Coffeescript, although it does compile to js so node could run it instead
    Express web server
    Mongoose object modeler
    Jade view templates
    Mocha and Should (may try Chai), some kind of load tester
    Trying a shared mongod, Dharma 2.3 Experimental from mongohq, with 512 Mb max
  }
  
  , Resources:{
    url:    { cloudnine : 'sto/apelade/c9.io' }
    , vcs:	{ github    : 'github.com/apelade/sto' }
    , db:    { mongohq   : 'mongodb://sto_user:*******@linus.mongohq.com:10083/mdb-prod' }
  }

}
