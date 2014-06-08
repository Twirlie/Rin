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
  yukari.mediaById arg, (videoData) ->
    data = {}
    if videoData?
      if typeof videoData is 'string' # if we get an error
          res.render 'error', {title: 'an error occured', error: 'Error', info: videoData}
      else # if we get actual data
        colog.log 'we have data'
        data.video = videoData
        yukari.usersByMediaId arg, (userData) ->
          data.users = userData
          res.render 'video', { title: data.title, data: data }