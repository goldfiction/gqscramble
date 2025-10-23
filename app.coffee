crypto = require 'crypto'
Buffer = require('buffer').Buffer
fs = require 'fs'

lzmalib = require 'lzma-native'
zliblib = require 'zlib'
Blowfish = require 'blowfish-node'
seedrandom = require 'seedrandom'

@fs=fs
@Buffer=Buffer
@crypto=crypto

@blowfish={}
@blowfish.blowfish=Blowfish

#/**
# * Generates a encrypted hash of a given string.
# * @param {object} o option object.
# * @param {string} o.secret secret for encryption.
# * @param {string} o.iv  iv for encryption.
# * @param {string} o.text  message to encrypt.
# * @returns {string} The encrypted hash in base64 format.
# */
@blowfish.encrypt=(o)->
  key = Buffer.from o.secret||'your-secret-key-here','utf8' #// Ensure key length is within Blowfish limits
  iv = Buffer.from o.iv||'8byteIV!','utf8' # // 8-byte IV for CBC mode
  plaintext = o.text||'This is a secret message.'
  # encrypt
  cipher = crypto.createCipheriv('bf-cbc',key,iv)
  encrypted = cipher.update(plaintext,'utf8','base64')
  encrypted += cipher.final('base64')

#/**
# * Generates decrypted text of a given encryption.
# * @param {object} o option object.
# * @param {string} o.secret secret for encryption.
# * @param {string} o.iv  iv for encryption.
# * @param {string} o.text encrypted string to decrypt.
# * @returns {string} The decrypted text in utf8 format.
# */
@blowfish.decrypt=(o)->
  key = Buffer.from o.secret||'your-secret-key-here','utf8' #// Ensure key length is within Blowfish limits
  iv = Buffer.from o.iv||'8byteIV!','utf8' # // 8-byte IV for CBC mode
  # decrypt
  decipher = crypto.createDecipheriv('bf-cbc',key,iv)
  decrypted = decipher.update(o.text,'base64','utf8')
  decrypted += decipher.final('utf8')

@blowfish.v1={}

@blowfish.v1.encrypt=(o)->
  bf = new Blowfish o.secret,Blowfish.MODE.ECB,Blowfish.PADDING.NULL  #// only key isn't optional
  bf.setIv o.iv #// optional for ECB mode; bytes length should be equal 8
  encoded = bf.encode o.text||'input text even with emoji 🎅'

@blowfish.v1.decrypt=(o)->
  bf = new Blowfish o.secret,Blowfish.MODE.ECB,Blowfish.PADDING.NULL  #// only key isn't optional
  bf.setIv o.iv #// optional for ECB mode; bytes length should be equal 8
  bf.decode o.text,Blowfish.TYPE.STRING # // type is optional

@blowfish.b64={}

@blowfish.b64.encrypt=(o)->
  bf = new Blowfish o.secret,Blowfish.MODE.ECB,Blowfish.PADDING.NULL  #// only key isn't optional
  bf.setIv o.iv #// optional for ECB mode; bytes length should be equal 8
  encoded = bf.encodeToBase64 o.text

@blowfish.b64.decrypt=(o)->
  bf.decode o.text,Blowfish.TYPE.JSON_OBJECT # type is required to JSON_OBJECT

@md5=(o)->
  crypto.createHash('md5').update(o.text||"tada").digest("hex")

@md5File=(o)->
  @md5
    text:fs.readFileSync(o.file,'utf8')

@lzma={}
@lzma.lib=lzmalib
@lzma.compress=(o,cb)->
  inputData = Buffer.from(o.text);
  lzmalib.compress inputData,9,(result)->
    #console.log 'Compressed data (Buffer):',result.toString('hex')
    cb null,result

@lzma.uncompress=(o,cb)->
  compressedData = Buffer.from o.text,'hex'
  lzmalib.decompress compressedData,(result)->
    #console.log 'Decompressed data (Buffer):',result
    #console.log 'Decompressed text:',result.toString('utf8')
    cb null,result

#/**
# * Generates a SHA256 hash of a given string.
# * @param {string} _in The string to hash.
# * @returns {string} The SHA256 hash in hexadecimal format.
# */
@sha256=(_in)->
  crypto.createHash 'sha256'
    .update _in
    .digest 'hex'

@zlib={}
@zlib.zlib=zliblib

@zlib.compress=(_in)->
  zliblib.deflateSync _in

@zlib.uncompress=(_in)->
  zliblib.inflateSync _in

@zlib.zip=(_in,cb)->
  zliblib.gzip _in,cb

@zlib.unzip=(_in,cb)->
  zliblib.gunzip _in,cb

#/**
# * Generates a string from o.username, o.password and o.salt.
# * @param {object} _o The options.
# * @param {string} _o.username
# * @param {string} _o.password
# * @param {string} _o.salt
# * @returns {string} The resulting string with all things considered.
# */
@sstring=(_o)->
  res=_o.username+":"+_o.password+"@"+_o.salt

#/**
# * Generates a string from salt.
# * @param {string} _in The options.
# * @returns {string} The resulting string.
# */
@silible=(_o)->
  null

@switcher=(o)->
  # o.str
  # o.index
  hay=o.str
  stack=o.str
  for i,key in o.index
    stack[key]=hay[i]
  return stack

@unswitcher=(o)->
  # o.str
  # o.index
  hay=o.str
  stack=o.str
  for i,key in o.index
    stack[i]=hay[key]
  return stack

@shuffle = (array) ->
  currentIndex = array.length
  temporaryValue = undefined
  randomIndex = undefined

  # While there remain elements to shuffle...
  while currentIndex isnt 0
    # Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex)
    currentIndex--

    # And swap it with the current element.
    temporaryValue = array[currentIndex]
    array[currentIndex] = array[randomIndex]
    array[randomIndex] = temporaryValue

  array

# Define a function to shuffle an array using the Fisher-Yates algorithm
# and a seeded PRNG
@shuffleArraySeeded = (array, seed) ->
  # Create a seeded random number generator
  rng = seedrandom seed

  # Create a copy of the array to avoid modifying the original
  shuffled = array.slice()

  currentIndex = shuffled.length
  temporaryValue = undefined
  randomIndex = undefined

  # While there remain elements to shuffle...
  while currentIndex isnt 0
    # Pick a remaining element...
    randomIndex = Math.floor(rng() * currentIndex)
    currentIndex -= 1

    # And swap it with the current element.
    temporaryValue = shuffled[currentIndex]
    shuffled[currentIndex] = shuffled[randomIndex]
    shuffled[randomIndex] = temporaryValue

  shuffled

@sVeryUnique = ()->
  (performance.now()*Math.random() + '').replace('.','');

@seedFromString=(str)->
  Math.Floor(seedrandom(str).quick()*10000000000000000)