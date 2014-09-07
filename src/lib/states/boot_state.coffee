# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

config = require '../config.coffee'
Logger = require '../../mixins/logger.coffee'
Module = require '../module.coffee'

class BootState extends Module
  @include Logger

  logPrefix: 'BootState'

  constructor: (game)->

  preload: ->
    # Preload Stage
    @game.stage = $.extend @game.stage, config.stage

    # Preload all images
    for imageName, image of config.boot.images
      @game.load.image imageName, image.src

  create: ->
    @game.state.start 'load'

module.exports = BootState
