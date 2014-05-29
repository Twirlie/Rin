colog = require 'colog'
yukari = require './connect'
# vid main page
exports.index = (req, res)->
  res.render 'vid', { title: 'vid' }
  colog.info 'Vid index accessed'
# load a video
exports.load = (req, res)->
  console.log 'loaded vid.load'
  arg = req.params.id
  yukari.mediaById arg, (data)->
    if data?
      if data == 'failure'
        res.render 'error', {title: 'error', error: 'no data', info: 'server returned no data'}
      else
        colog.success 'we have data!'
        colog.error JSON.stringify(data)
        res.render 'video', { title: data.title, data: data }