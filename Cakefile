use 'cake-outdated'
use 'cake-bundle'
use 'sake-publish'

use require './'

task 'clean', 'clean project', ->
  exec 'rm -rf lib'

task 'build', 'build project', ->
  bundle.write entry: 'src/index.coffee'

task 'test', 'Run tests', (opts, cb) ->
  grep    = opts.grep             ? ''
  test    = opts.test             ? 'test/'
  verbose = opts.verbose          ? ''

  grep    = "--grep #{opts.grep}" if grep
  verbose = "VERBOSE=true" if verbose

  exec "NODE_ENV=test #{verbose}
        node_modules/.bin/mocha
        --colors
        --reporter spec
        --timeout 100000
        --compilers coffee:coffee-script/register
        --require co-mocha
        --require postmortem/register
        #{grep}
        #{test}", (err) ->
    if err
      process.exit 1
    else
      process.exit 0

task 'watch', 'watch for changes and recompile project', ->
  b = yield bundle
    entry:    'src/index.coffee'
    external: true

  build = (filename) ->
    console.log filename
    b.write
      invalidate: [filename]
      formats:    ['cjs', 'es']

  watch 'src/*', build
