fs     = require 'fs'
path   = require 'path'
semver = require 'semver'

outdated = require './outdated'

module.exports = ->
  task 'major', ['version'], ->
  task 'minor', ['version'], ->
  task 'patch', ['version'], ->
  task 'version', 'change version of project', (opts) ->
    {stdout, stderr} = yield exec.quiet 'git status --porcelain'
    if stderr or stdout
      console.log 'working directory not clean'
      return

    # Check for outdated deps
    deps = yield outdated()

    for k,v of deps
      if semver.gt v.current, v.wanted
        console.log "'#{k}' #{v.current} is installed but #{v.wanted} is referenced in your package.json"
        return

    # Run build process
    yield invoke 'build:min' if tasks.has 'build:min'

    dir        = process.cwd()
    pkgPath    = path.join dir, 'package.json'
    readmePath = path.join dir, 'README.md'

    pkg        = require pkgPath
    version    = pkg.version

    level = (opts.arguments.filter (v) -> v isnt 'version')[0]
    [major, minor, patch] = (parseInt n for n in version.split '.')

    switch level
      when 'major'
        newVersion = "#{major + 1}.0.0"
      when 'minor'
        newVersion = "#{major}.#{minor + 1}.0"
      when 'patch'
        newVersion = "#{major}.#{minor}.#{patch + 1}"
      else
        console.log 'Unable to parse versioning'
        process.exit 1

    console.log "v#{version} -> v#{newVersion}"
    console.log

    data = fs.readFileSync readmePath, 'utf8'
    data = data.replace (new RegExp version, 'g'), newVersion
    fs.writeFileSync readmePath, data, 'utf8'

    pkg.version = newVersion
    fs.writeFileSync pkgPath, (JSON.stringify pkg, null, 2), 'utf8'

    yield exec """
    git add .
    git commit -m #{newVersion}
    git tag v#{newVersion}
    """
