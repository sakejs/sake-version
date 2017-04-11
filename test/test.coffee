exec = require 'executive'

describe 'sake-version', ->
  it 'should add tasks', ->
    {stdout} = yield exec 'sake', cwd: __dirname
    stdout.should.contain 'version:patch'
    stdout.should.contain 'version:minor'
    stdout.should.contain 'version:major'
