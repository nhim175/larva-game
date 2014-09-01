# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Duck = require './duck.coffee'
Logger = require '../mixins/logger.coffee'

class RedDuck extends Duck

  logPrefix: 'RedDuck'

  sprite: 'red_duck'

module.exports = RedDuck