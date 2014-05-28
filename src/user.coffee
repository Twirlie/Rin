colog = require 'colog'
# user main page
exports.index = (req, res)->
  res.render 'user', { title: 'user' }
  colog.info 'User index accessed'
# load a user
exports.load = (req, res)->
  console.log 'loaded user.load'