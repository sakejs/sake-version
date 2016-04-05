exec   = require 'executive'
semver = require 'semver'

module.exports = ->
  new Promise (resolve, reject) ->
    exec.quiet 'npm outdated --json'
      .then ({stdout}) ->
        return resolve null if stdout == ''

        deps     = JSON.parse stdout
        outdated = []

        for k,v of deps
          continue if v.wanted == v.latest == 'linked'

          if semver.gt v.current, v.wanted
            outdated.push
              name:    k
              current: v.current
              wanted:  v.wanted

        if outdated.length
          resolve outdated
        else
          resolve null

      .catch (err) ->
        reject (err)
