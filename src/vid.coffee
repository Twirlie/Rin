colog = require 'colog'
yukari = require './connect'
# vid main page
exports.index = (req, res)->
  res.render 'vid', { title: 'vid' }
  colog.info 'Vid index accessed'
# load a video
exports.load = (req, res)->
  console.log 'loaded vid.load'
  yukari.video req.params, (data)->
    if data?
      colog.success 'we have data!'
      # res.render 'video', { title: data.title }