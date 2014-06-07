# require module
net = require 'net'
cfg = require '../config'
colog = require 'colog'

connectionStatus = false
exports.connectionStatus = connectionStatus
currentCallType = null
clientCallback = null

yukari = new net.Socket()
yukari.connect cfg.connect, ->
  colog.headerSuccess 'connected to ' + cfg.connect.host + ' on port ' + cfg.connect.port
  connectionStatus = true

yukari.on 'error', (err) ->
  colog.error err
  if clientCallback is not null
    clientCallback err
    finish err

yukari.on 'close', ->
  colog.warning 'connection closed'
  connectionStatus = false

yukari.on 'data', (reply) ->
  data = JSON.parse reply # parse returned data
  callback = clientCallback
  colog.info reply

  if data.callType is 'mediaById'
    if data.result is 'ok'
      data.resource.meta = data.meta
      callback data.resource # run the callback
      finish()
    else
      callback 'Data is nomatch' # epic fail
      finish 'Data is nomatch'
  else
    colog.warning 'currentCallType: ' + currentCallType
    callback 'System error occurred.'
    finish 'System error occurred.'


exports.mediaById = (arg, callback) ->
  currentCallType = 'mediaById'
  colog.warning 'media by Id'
  clientCallback = callback
  yukari.write '{"callType": "mediaById", "args": {"mediaId": ' + arg + '}}\r\n', -> # ask yukari for data
    colog.info 'query video ' + arg 
   
finish = (err) ->
  currentCallType = null
  clientCallback = null
  if err then colog.error 'data transfer error: ' + err else colog.success 'done!'
