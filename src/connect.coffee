# require module
net = require 'net'
cfg = require '../config'
colog = require 'colog'

connectionStatus = false
exports.connectionStatus = connectionStatus

yukari = new net.Socket()

exports.mediaById = (arg, callback) ->
  connect -> 
    yukari.write '{"callType": "mediaById", "args": {"mediaId": ' + arg + '}}\r\n', -> # ask yukari for data
    colog.info 'query video ' + arg 
    yukari.on 'data', (data) -> # get the data
      colog.info 'data recieved:\n' + data.toString()
      data = JSON.parse data # parse returned data
      if data.result != 'nomatch'
        callback data.resource # run the callback
        yukari.end
      else
        callback 'failure'
        yukari.end

connect = (callback) ->
  yukari = new net.Socket()
  yukari.connect cfg.connect, ->
    colog.headerSuccess 'connected to ' + cfg.connect.host + ' on port ' + cfg.connect.port
    connectionStatus = true
    yukari.on 'error', (err)->
      colog.error err
    yukari.on 'close', ->
      colog.warning 'connection closed'
      connectionStatus = false
    callback()