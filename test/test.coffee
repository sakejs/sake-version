exec = require 'executive'

describe 'cake-version', ->
  it 'should add tasks', ->
    {stdout} = yield exec 'sake', cwd: __dirname
    stdout.should.contain 'version'
    stdout.should.contain 'patch'
    stdout.should.contain 'minor'
    stdout.should.contain 'major'
