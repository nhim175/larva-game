# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Duck = require './duck.coffee'
Logger = require '../mixins/logger.coffee'

class GreenDuck extends Duck

  logPrefix: 'GreenDuck'

  sprite: 'green_duck'

module.exports = GreenDuck