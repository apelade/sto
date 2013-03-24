## Sto!

						All-CoffeeScript Node.js project in c9.io IDE
                        Multi-platform including c9.io, Linux, Windows
                              Fresh Libs  ~  Freely Hosted

### Install
__`cake install` or `npm install`__

- Size: Less than 6 MB with libs at this point.
- Node and npm are required: download and install from http://nodejs.org/
- Unzip to a location or checkout from github. You may need to be admin.
- On a command prompt, run this command in the install dir to fetch libraries.
- If bcrypt is installed it is used, defaults to crypto.
- Note that passwords are not compatible/portable between the two.



### Test
__`cake test`__

- Startup args in the Cakefile configure testing options



	
### Run
__`cake server` or `coffee app.coffee`__

- Runs on port 3000 or c9.io port by default
- Go to [http://localhost:3000](http://localhost:3000)



### Dependency ###
- Node and npm to install packages list in sto/package.json
- CoffeeScript, although it does compile to js so node could run it instead
- Express web server
- Mongoose object modeler
- Jade view templates
- Twitter Boostrap layout
- Mocha and Should, some kind of load tester
- Trying a shared mongod, Dharma 2.3 Experimental from http://mongohq.com, 512 MB
- JQuery for ajax and binding event listeners in catalog component
- Optional bcrypt instead of default crypto requires building native:
 - The bcrypt README at https://github.com/ncb000gt/node.bcrypt.js worked great!
 - It refers you to the node-gyp README https://github.com/TooTallNate/node-gyp
 - python 2.x
 - Right now I'm on windows, so Windows OpenSSL 64-bit libs
 - Visual Studio Express
 - Win7 64-bit SDK, uninstalled prev versions of 2010 C++ Redistributable first



	
### Resource ###
- cloudnine: http://sto.apelade.c9.io
- github: http://github.com/apelade/sto
- mongohq: mongodb://sto_user:*******@linus.mongohq.com:10083/mdbt 
	



### File ###
	
	Cakefile		: command runner
	  
	app.coffee		: entry point and config for running the (express) server

    cloudnine-start.js : bootstrap launcher file to run (coffeescript) on c9.io  	
	  
	packages.json	: (npm) dependency file list
		
	README.md		: this  	
	
	model/			: (mongoose) models directory
	
	public/			: files to be served, image, script, etc
	
	route/ 			: routing files (called from app.coffee)
	
	test/			: (mocha and should) test files in tests.coffee
	
	view/			: (jade) view templates directory

