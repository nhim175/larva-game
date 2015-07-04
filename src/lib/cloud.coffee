# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Module = require './module.coffee'
Logger = require '../mixins/logger.coffee'

class Cloud extends Module
  @include Logger

  logPrefix: 'Cloud'

  flyingTime: 5000

  constructor: (game) ->
    @game = game
    @me = @game.add.sprite -64, 64, 'cloud'
    @me.animations.add 'fly', [1], null, false
    @me.animations.add 'shoot', [0, 1], 3, false
    @velocity = 6
    @runTween = @game.add.tween(@me).to {x: @game.width}, @flyingTime, Phaser.Easing.Linear.None
    @game.add.tween(@me).to {y: 34}, 1000, Phaser.Easing.Cubic.InOut, true, 0, Number.MAX_VALUE, true 
    @start()

  reset: ->
    @me.x = -64
    @start()

  start: ->
    @me.animations.play 'fly'
    @runTween.start()

    axeTimer = @game.time.create(true)
    axeTimer.add Math.random()*@flyingTime, (=> @shoot()), @
    axeTimer.start()

  shoot: ->
    @me.animations.play 'shoot'
    $(@).trigger 'ShootEvent'

module.exports = Cloud
