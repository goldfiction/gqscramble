scramble=require '../app.coffee'
assert=require 'assert'

it "should be able to run",(done)->
  done()

it "should be able to blowfish1",(done)->
  o=
    "secret":"your-secret-key-here"
    "iv":"8byteIV!"
    "text":"this is a test message"
  res=scramble.testBlowFish1 o
  #console.log res
  assert.equal res,o.text
  done()


it "should be able to blowfish2",(done)->
  o=
    "secret":"your-secret-key-here"
    "iv":"8byteIV!"
    "text":"this is a test message"
  res=scramble.testBlowFish2 o
  #console.log res
  assert.equal res,o.text
  done()

it "should be able to blowfish with 2 steps",(done)->
  o=
    "secret":"your-secret-key-here"
    "iv":"8byteIV!"
    "text":"this is a test message"
  res1=scramble.blowfishEncrypt o
  #console.log res
  o.encrypted=res1
  res2=scramble.blowfishDecrypt o
  assert.equal res2,o.text
  done()

it "should be able to sha256",(done)->
  res=scramble.generateSha256Hash('test')
  assert.equal res,"9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
  done()

it "should be able to zlib deflate",(done)->
  text='lorem ipsum dolor sit amet'
  buf=Buffer.from(text)
  #console.log scramble.compress(buf).toString().length+"/"+text.length
  assert.equal scramble.uncompress(scramble.compress buf).toString(),text
  done()

it "should be able to zlib gzip",(done)->
  text='lorem ipsum dolor sit amet'
  buf=Buffer.from(text)
  scramble.zip buf,(e1,buf2)->
    #console.log buf2.toString('utf8')
    #console.log buf2.toString('utf8').length+"/"+text.length
    scramble.unzip buf2,(e2,buf3)->
      assert.equal buf3.toString('utf8'),text
      done e1||e2
  