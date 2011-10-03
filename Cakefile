# ANSI Terminal Colors.
bold  = '\033[0;1m'
red   = '\033[0;31m'
green = '\033[0;32m'
reset = '\033[0m'

{exec, spawn} = require 'child_process'

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember that you need: coffee-script@0.9.4 and vows@0.5.2\033[0;37m\n"
    console.log err.stack

print = (data) -> console.log data.toString().trim()

##


task 'dev', 'Continuous compilation', ->
  coffee = spawn 'coffee', '-wc --bare --output lib server'.split(' ')

  coffee.stdout.on 'data', print
  coffee.stderr.on 'data', print