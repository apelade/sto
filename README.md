Project "sto"

Purpose: High-concurrency site demo, ideally same db for a python-uWSGI version

Built in c9.io

Fork it on github.com/apelade/sto




Dependencies: Going to try and use cloudnine's apis since
              it's a good place to deploy a demo project.

Coffeescript, although it does compile to js so node could run it,
Node
Express
Mongoose
Trying a shared mongod, Dharma 2.3 Experimental from mongohq, with 512 Mb max


Testing:

Mocha and Should, some kind of load tester




Design: High-concurrency site demo

DB:
Large catalog of items, deliver in chunks
Handle fast pace of transactions

Server:


Client:
Javascript, using sessionStorage object, with fail-over to cookies or server



