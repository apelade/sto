Sto: {


  Install:{
    'cake install' or 'npm install'
    Size: Only about 50 KB at this point, but add 5.22 MB node_modules, plus
    node and npm are required: download and install from http://nodejs.org/
    Unzip to a location or checkout from github. You may need to be admin.
    On a command prompt, cd there, to directory 'sto'.
    Enter 'cake install' or 'npm install' for it to install dependencies in
    packages.json.
  }

  Test:{
    'cake test'
    Startup args in Cakefile configure testing options
  }

  Run:{
    'cake server'
    Can also be started with'coffee app.coffee'
  }

  About:{
    E-commerce site demo, ideally same db for a python-uWSGI version
    All CoffeeScript project in c9.io IDE and using their apis.
    Using netbeans and local mongod if faster server restarts are needed.
    (express reload?) Multi-platform including c9.io, linux, Windows.
  }
   
  Dependency:{
    Node and npm to install packages list in sto/package.json
    CoffeeScript, although it does compile to js so node could run it instead
    Express web server
    Mongoose object modeler
    Jade view templates
    Mocha and Should, some kind of load tester
    Trying a shared mongod, Dharma 2.3 Experimental from http://mongohq.com, 512 MB
  }
  
  Resource:{
    cloudnine : 'sto/apelade/c9.io'
    , github    : 'github.com/apelade/sto'
    , mongohq   : 'mongodb://sto_user:*******@linus.mongohq.com:10083/mdb-test' 
  }
    
  File:{
  
  	Cakefile      : command runner
  	
	app.coffee    : entry point and config for running the (express) server  	
  	
	packages.json : (npm) dependency file list
		
	README.md     : this  	
	
	model/  : (mongoose) models directory
	
	public/ : files to be served, image, script, etc
	
	route/  : routing files (called from app.coffee)
	
	test/   : (mocha and should) test files - all files in dir
	
	view/   : (jade) view templates directory
  }
}