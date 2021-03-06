						All-CoffeeScript Node.js project in c9.io IDE
                        Multi-platform including c9.io, Linux, Windows
                                Fresh Libs  ~  Freely Hosted

# Sto!
#### Exploring how to structure a node store app.
#### Because this is a learning project, I implement certain things *before* looking at the way others do it or using a package. That shows in project stucture, crud, login, the client, etc. Grappling with these basic problems gives one a good feel for the platform while exercising creative problem solving, but this is not intended to be a recipe of best practices.

---



### Install
__`cake install` or `npm install`__

- Size: Less than 20 MB with libs at this point.
- Node and npm are required: download and install from http://nodejs.org/
- Unzip to a location or checkout from github. You may need to be admin.
- On a command prompt, run this command in the install dir to fetch libraries.
- It should skip optionalDependencies bcrypt and jquery if they fail.
- Node jquery is commented-out, using superagent.
- If bcrypt is installed it is used, defaults to crypto.
- Note that passwords are not compatible/portable between the two.




### Test
__`cake test`__

- Currently requires running server. See below.
- Currently needs model objects in db with "test" for all fields, hardcoded.
- Startup args in the Cakefile configure testing options.



	
### Run
__`cake server` or `coffee app.coffee`__

- Runs on port 3000 or c9.io port by default
- Go to [http://localhost:3000](http://localhost:3000) or [http://sto.apelade.c9.io](http://sto.apelade.c9.io)
- First user has to temporarily disable checkUser to create own account.
- See app.coffee, line 65, which begins "# To skip checkUser". Edit and restart.
- Create user from /index "Add User" link or /user/add.
- Edit app.coffee to restore checkUser, restart. New user should work.
- Query routes are /model/field/match like:
 - /user/login/your_login should find the user you created
 - /item/price/100 would find an item you create with price of 100




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
 - Right now I'm on Windows 7, so Windows OpenSSL 64-bit libs
 - Visual Studio Express
 - Win7 64-bit SDK, uninstalled prev versions of 2010 C++ Redistributable first



	
### Resource ###
- cloudnine: http://sto.apelade.c9.io
- github: http://github.com/apelade/sto
- mongohq: mongodb://sto_user:*******@linus.mongohq.com:10083/mdbt 
	



### File ###

- Cakefile		: [cake](http://jashkenas.github.io/coffee-script/documentation/docs/cake.html) command runner
	  
- app.coffee	: entry point and config for running the [express](http://expressjs.com/) server

- cloudnine-start.js : bootstrap launcher file to run [coffeescript](http://coffeescript.org/) on c9.io  	
	  
- packages.json	: [npm](https://npmjs.org/) dependency file list
		
- README.md		: this  	
	
- /model/		: [mongoose](http://mongoosejs.com/) models directory
	
- /public/		: files to be served, image, script, etc
	
- /route/ 		: routing files (called from app.coffee)
	
- /test/		: [mocha](https://github.com/visionmedia/mocha) and [should](https://github.com/visionmedia/should.js/) test files in tests.coffee
	
- /view/		: [jade](http://jade-lang.com/) view templates directory




### Design ###
#### Server ####
- Express servers work by connecting url paths to execute functions from
  route files that deliver query results in pages, and redirects.
- Multiple routes files handle get and post of common Mongoose model CRUD ops.
- These are standardized toward possible future automation.
- These CRUD routes (and others) enforce login by using the optional checkUser
  middleware function.
- Login form posts action values containing original destination, to redirect
  on successful login.
- Rudimentary login currently has one implied role of admin for all users.
- Loop in route files enumerates query routes per model property.

#### Client ####
- Client application skeleton is defined by layout.jade template includes.
- These includes can be groups of javascript, stylesheets, meta tags, etc.
- There is one called /view/scripts.jade that loads the common scripts in order.
- There are also chunks which define cart, login, and catalog components.
- Cart and catalog components are compiled without the top-level function into
  javascripts for the client side.
- Cart binds it's own event listeners, controls user input, and redraws itself.
- Catalog uses JQuery event selectors and JQuery AJAX request to page the Items.
- Login uses no client-side scripts, instead a login session starts on the
  server when the user sucessfully logs in. Log out by logging in incorrectly.
- Cart currently uses localStorage only.
