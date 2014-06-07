colog = require 'colog'
yukari = require './connect'
# vid main page
exports.index = (req, res) ->
  res.render 'vid', { title: 'vid' }
  colog.info 'Vid index accessed'
# load a video
exports.load = (req, res) ->
  console.log 'loaded vid.load'
  arg = req.params.id
  yukari.mediaById arg, (data) ->
    if data?
      if typeof data is 'string'
        res.render 'error', {title: 'an error occured', error: 'Error', info: data}
      else
        res.render 'video', { title: data.title, data: data }