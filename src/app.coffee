# require modules
express = require 'express'
colog = require 'colog'
cfg = require '../config'
connect = require './connect'
# load the route managers
site = require './site'
vid = require './vid'
user = require './user'
# configure express
app = express()
app.set 'view engine', 'jade'
app.set 'views', './views'
app.use express.static __dirname + '/public'
# routes
# main route
app.get '/', site.index
# vid route
app.all '/vid', vid.index # List of videos
app.all '/vid/:id', vid.load # Individual Video Page
# user route
app.all '/user', user.index # List of users
app.all '/user/:id', user.load # Individual User Page
# start server
app.listen cfg.express.port
colog.success 'Express app started on port ' + cfg.express.port