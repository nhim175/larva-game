# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Module = require './module.coffee'
Logger = require '../mixins/logger.coffee'

class Axe extends Module
  @include Logger

  logPrefix: 'Axe'

  constructor: (game) ->
    @game = game
    @me = @game.add.sprite -100, -100, 'axe'

  dropFrom: (x,y) ->
    @game.physics.enable @me, Phaser.Physics.ARCADE
    @me.x = x
    @me.y = y
    @me.body.velocity.setTo 0, -350
    @me.body.gravity.set 0, 480

  flyTo: (x,y, callback) ->
    @me.body.gravity.set 0, 0
    @flyTween = @game.tweens.create(@me).to {x: x, y: y }, 1000, Phaser.Easing.Cubic.Out
    @flyTween.start()
    @flyTween.onComplete.add callback

  isTweening: ->
    @flyTween?.isRunning

module.exports = Axe