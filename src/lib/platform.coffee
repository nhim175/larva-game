# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Module = require './module.coffee'
Logger = require '../mixins/logger.coffee'

WIDTH = 1136
HEIGHT = 71

class Platform extends Module
  @include Logger

  logPrefix: 'Platform'

  constructor: (game) ->
    @game = game
    @me = @game.add.sprite 0, @game.height - HEIGHT, 'ground'
    @game.physics.enable @me, Phaser.Physics.ARCADE
    @me.enableBody = true
    @me.body.immovable = true

module.exports = Platform