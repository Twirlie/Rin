colog = require 'colog'
# main page
exports.index = (req, res)->
  res.render 'index', { title: 'Expresso' }
  colog.info 'Main index accessed'