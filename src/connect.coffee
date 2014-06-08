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

yukari.on 'close', ->
  colog.warning 'connection closed'
  connectionStatus = false

yukari.on 'data', (reply) ->
  data = JSON.parse reply # parse returned data
  colog.info reply

  if currentCallType is 'mediaById' # return data for mediaById
    callback = clientCallback
    if data.result is 'ok'
      colog.info 'MediaById: ok'
      data.resource.meta = data.meta
      callback data.resource # run the callback
    else
      callback 'Data is nomatch' # epic fail
  else if currentCallType is 'usersByMediaId' #return data for usersByMediaId
    callback = clientCallback
    if data.result is 'ok'
      colog.info 'usersByMediaId: ok'
      callback data.resource 
    else 
      log.warning 'usersByMediaId: nomatch'
      callback 'Data is nomatch'
  else
    colog.warning 'currentCallType: ' + currentCallType
    if callback then callback 'System error occurred.'


exports.mediaById = (arg, callback) ->
  colog.warning 'media by Id'
  clientCallback = callback
  changeCallType 'mediaById', () ->
    yukari.write '{"callType": "mediaById", "args": {"mediaId": ' + arg + '}}\r\n', -> # ask yukari for data
      colog.info 'query video ' + arg 

exports.usersByMediaId = (arg, callback) ->
  colog.warning 'users by media Id'
  clientCallback = callback
  changeCallType 'usersByMediaId', () ->
    yukari.write '{"callType": "usersByMediaId", "args": {"mediaId": ' + arg + '}}\r\n', ->
      colog.info 'get users by mediaId ' + arg

changeCallType = (calltype, callback) ->
  if currentCallType != calltype
    colog.info 'changing call type to ' + calltype
    currentCallType = calltype
    colog.info 'current call type: ' + currentCallType + typeof currentCallType
    callback()
  else callback()
