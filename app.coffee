crypto = require 'crypto'
Buffer = require('buffer').Buffer
zlib = require 'zlib'
Blowfish = require 'blowfish-node'
fs = require 'fs'

@blowfish={}

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

#/**
# * Generates a SHA256 hash of a given string.
# * @param {string} _in The string to hash.
# * @returns {string} The SHA256 hash in hexadecimal format.
# */
@sha256=(_in)->
  crypto.createHash 'sha256'
    .update _in
    .digest 'hex'

@compress=(_in)->
  zlib.deflateSync _in

@uncompress=(_in)->
  zlib.inflateSync _in

@zip=(_in,cb)->
  zlib.gzip _in,cb

@unzip=(_in,cb)->
  zlib.gunzip _in,cb

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

