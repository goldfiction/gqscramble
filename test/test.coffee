scramble=require '../app.coffee'
assert=require 'assert'

salt=
  secret:"your-secret-key-here"
  iv:"8byteIV!"
  text:"this is a test message"

it "should be able to run",(done)->
  done()

it "should be able to blowfish1",(done)->
  o=salt
  res=scramble.blowfish.v1.decrypt
    iv:o.iv
    secret:o.secret
    text:scramble.blowfish.v1.encrypt o
  #console.log res
  assert.equal res,o.text
  done()

it "should be able to blowfish2",(done)->
  o=salt
  res=scramble.blowfish.decrypt
    secret:o.secret
    iv:o.iv
    text:scramble.blowfish.encrypt o
  #console.log res
  assert.equal res,o.text
  done()

it "should be able to sha256",(done)->
  res=scramble.sha256 'test'
  assert.equal res,"9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
  done()

it "should be able to zlib deflate",(done)->
  text='lorem ipsum dolor sit amet'
  buf=Buffer.from text
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

it "should be able to md5 check",(done)->
  md5=scramble.md5File
    file:"./test/testfile.txt"
  assert.equal md5,"0add241c7230a0eec1d1d516b0c52264"
  done()

it "should be able to lzma compress",(done)->
  o=salt
  scramble.lzma.compress o,(e1,r)->
    scramble.lzma.uncompress 
      text:r
      ,(e2,r2)->
        assert.equal r2,o.text
        done e1||e2
  null