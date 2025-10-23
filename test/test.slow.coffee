scramble=require '../app.coffee'
assert=require 'assert'
tests=require 'gqtest'
it=tests.it
run=tests.doRun

# dont modify these
salt=
  secret:"your-secret-key-here"
  iv:"8byteIV!"
  text:"this is a test message"
  file:"./test/testfile.txt"
  big1mfile:"./test/Big_Buck_Bunny_360_10s_1MB.mp4"
  sha256:"9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
  md5:"0add241c7230a0eec1d1d516b0c52264"

# dummy test for code integrity
it "should be able to run",(done)->
  done()

it "should be able to compress a large file and uncompress and md5 check",(done)->
  o=salt
  file=scramble.fs.readFileSync(o.big1mfile)
  md5_1=scramble.md5 
    text:file
  #console.log md5_1
  scramble.lzma.compress 
    text:file
    ,(e1,r1)->
      scramble.lzma.uncompress
        text:r1
        ,(e2,r2)->
          md5_2=scramble.md5
            text:r2
          #console.log r2
          console.log Buffer.from(r1,'hex').toString("utf8").length+"/"+file.toString("utf8").length
          assert.equal md5_1,md5_2
          done e1||e2
  null

run()