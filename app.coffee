crypto = require 'crypto'
Buffer = require('buffer').Buffer
zlib = require 'zlib'
Blowfish = require 'blowfish-node'

@testBlowFish1=(o)->
  bf = new Blowfish o.secret,Blowfish.MODE.ECB,Blowfish.PADDING.NULL  #// only key isn't optional
  bf.setIv o.iv #// optional for ECB mode; bytes length should be equal 8
  encoded = bf.encode o.text||'input text even with emoji 🎅'
  res=bf.decode encoded,Blowfish.TYPE.STRING # // type is optional
  
  #// encode the object to base64
  #encoded = bf.encodeToBase64(JSON.stringify({message: 'super secret response api'}));
  #bf.decode(encoded, Blowfish.TYPE.JSON_OBJECT); // type is required to JSON_OBJECT
  # // only for typescript
  #const response = bf.decode<{message: string}>(encoded, Blowfish.TYPE.JSON_OBJECT); // type is required to JSON_OBJECT
  res

#/**
# * Generates a encrypted hash of a given string then generate decrypted message.
# * @param {object} o option object.
# * @param {string} o.secret secret for encryption.
# * @param {string} o.iv  iv for encryption.
# * @param {string} o.text  message to encrypt.
# * @returns {string} The original text in utf8 format.
# */
@testBlowFish2=(o)->
  key = Buffer.from o.secret||'your-secret-key-here','utf8' #// Ensure key length is within Blowfish limits
  iv = Buffer.from o.iv||'8byteIV!','utf8' # // 8-byte IV for CBC mode
  plaintext = o.text||'This is a secret message.'
  # encrypt
  cipher = crypto.createCipheriv('bf-cbc',key,iv)
  encrypted = cipher.update(plaintext,'utf8','base64')
  encrypted += cipher.final('base64')
  #console.log 'Encrypted:',encrypted
  # decrypt
  decipher = crypto.createDecipheriv('bf-cbc',key,iv)
  decrypted = decipher.update(encrypted,'base64','utf8')
  decrypted += decipher.final('utf8')
  #console.log 'Decrypted:',decrypted
  # return
  decrypted

#/**
# * Generates a encrypted hash of a given string.
# * @param {object} o option object.
# * @param {string} o.secret secret for encryption.
# * @param {string} o.iv  iv for encryption.
# * @param {string} o.text  message to encrypt.
# * @returns {string} The encrypted hash in base64 format.
# */
@blowfishEncrypt=(o)->
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
# * @param {string} o.encrypted encrypted string to decrypt.
# * @returns {string} The decrypted text in utf8 format.
# */
@blowfishDecrypt=(o)->
  key = Buffer.from o.secret||'your-secret-key-here','utf8' #// Ensure key length is within Blowfish limits
  iv = Buffer.from o.iv||'8byteIV!','utf8' # // 8-byte IV for CBC mode
  # decrypt
  decipher = crypto.createDecipheriv('bf-cbc',key,iv)
  decrypted = decipher.update(o.encrypted,'base64','utf8')
  decrypted += decipher.final('utf8')


#/**
# * Generates a SHA256 hash of a given string.
# * @param {string} _in The string to hash.
# * @returns {string} The SHA256 hash in hexadecimal format.
# */
@generateSha256Hash=(_in)->
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
# * Generates a zlib deflat and inflate hash of a given string.
# * @param {string} _in The string to hash.
# * @returns {string} The original string.
# */
@zlibTest=(_in)->
  input = _in || new Buffer('lorem ipsum dolor sit amet')
  compressed = zlib.deflate input
  zlib.inflate compressed

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
  #(res+"************").substring 0,12

#/**
# * Generates a string from salt.
# * @param {string} _in The options.
# * @returns {string} The resulting string.
# */
@silible=(_o)->
  null
