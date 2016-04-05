exec = require 'executive'

module.exports = ->
  new Promise (resolve, reject) ->
    exec 'npm outdated --json'
      .then ({stdout}) ->
        return resolve {} if stdout == ''
        deps = JSON.parse stdout
        resolve deps
      .catch (err) ->
        reject (err)
