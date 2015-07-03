# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com
config = require './config.coffee'

Module = require './module.coffee'
Logger = require '../mixins/logger.coffee'

class Axe extends Module
  @include Logger

  logPrefix: 'Axe'

  lifeTime: 4000

  constructor: (game) ->
    @game = game
    @me = @game.add.sprite -100, -100, 'axe'
    @pickupSound = new Phaser.Sound @game, 'pickup', 1

  dropFrom: (x,y) ->
    @game.physics.enable @me, Phaser.Physics.ARCADE
    @me.x = x
    @me.y = y
    @me.body.velocity.setTo 0, -350
    @me.body.gravity.set 0, 480

  flyTo: (x,y, callback) ->
    @pickupSound.play()

    if window.plugins?.NativeAudio
      window.plugins.NativeAudio.play('pickup'
        , (success) ->
          console.log(success)
        , (error) ->
          console.log(error)
      )
      
    @me.body.gravity.set 0, 0
    @flyTween = @game.tweens.create(@me).to {x: x, y: y }, 1000, Phaser.Easing.Cubic.Out
    @flyTween.start()
    @flyTween.onComplete.add callback

  isTweening: ->
    @flyTween?.isRunning

  disappear: ->
    @me.visible = false

  isVisible: ->
    @me.visible

module.exports = Axe