# require module
net = require 'net'
cfg = require '../config'
colog = require 'colog'

connectionStatus = false
exports.connectionStatus = connectionStatus
currentCallType = null
clientCallback = null
isBusy = false
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
  JSONread reply, (data) ->
    colog.info reply

    if currentCallType is 'mediaById' # return data for mediaById
      callback = clientCallback
      if data.result is 'ok'
        colog.info 'MediaById: ok'
        data.resource.meta = data.meta
        isBusy = false
        callback data.resource # run the callback
      else
        isBusy = false
        callback 'Data is nomatch' # epic fail
    else if currentCallType is 'usersByMediaId' #return data for usersByMediaId
      callback = clientCallback
      if data.result is 'ok'
        colog.info 'usersByMediaId: ok'
        isBusy = false
        callback data.resource
      else 
        log.warning 'usersByMediaId: nomatch'
        isBusy = false
        callback 'Data is nomatch'
    else
      colog.warning 'currentCallType: ' + currentCallType
      isBusy = false
      if callback then callback 'System error occurred.'


exports.mediaById = (arg, callback) ->
  colog.warning 'media by Id'
  clientCallback = callback
  changeCallType 'mediaById', () ->
    if isBusy is false
      isBusy = true
      yukari.write '{"callType": "mediaById", "args": {"mediaId": ' + arg + '}}\r\n', -> # ask yukari for data
        colog.info 'query video ' + arg
    else 
      colog.error 'busy'
      callback 'busy'

exports.usersByMediaId = (arg, callback) ->
  colog.warning 'users by media Id'
  clientCallback = callback
  changeCallType 'usersByMediaId', () ->
    if isBusy is false
      isBusy = true
      yukari.write '{"callType": "usersByMediaId", "args": {"mediaId": ' + arg + '}}\r\n', ->
        colog.info 'get users by mediaId ' + arg
    else 
      colog.error 'busy'
      callback 'busy'

changeCallType = (calltype, callback) ->
  if currentCallType != calltype
    colog.info 'changing call type to ' + calltype
    currentCallType = calltype
    colog.info 'current call type: ' + currentCallType + typeof currentCallType
    callback()
  else callback()

JSONread = (input, callback) ->
  output = JSON.parse input
  callback(output)
