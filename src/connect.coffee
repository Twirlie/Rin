# require module
net = require 'net'
cfg = require '../config'
colog = require 'colog'

yukari = new net.Socket()
yukari.connect cfg.connect, ->
  colog.success 'connected to ' + cfg.connect.host + ' on port ' + cfg.connect.port

yukari.on 'error', (err)->
  colog.error err

yukari.on 'close', ->
  colog.warning 'connection closed'

exports.mediaById = (arg, callback) ->
  yukari.write '{"callType": "mediaById", "args": { "mediaId": ' + arg + '}"}\r\n', -> # ask yukari for data
    colog.info 'query video ' + arg 
    yukari.on 'data', (data) ->
      colog.info 'data recieved:\n' + data.toString()
      data = JSON.parse data # parse returned data
      callback(data) # run the callback
