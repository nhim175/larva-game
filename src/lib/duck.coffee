# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Module = require './module.coffee'
Logger = require '../mixins/logger.coffee'

WIDTH = 79
HEIGHT = 96
LEFT_DIRECTION = 0
RIGHT_DIRECTION = 1
JUMP_HEIGHT = 320

class GreenDuck extends Module
  @include Logger

  logPrefix: 'Duck'

  sprite: 'green_duck'

  constructor: (game) ->
    @game = game
    @me = @game.add.sprite 0, game.world.height - HEIGHT - Math.random()*JUMP_HEIGHT, @sprite
    @me.animations.add 'leftfly', [2, 3], 6, yes
    @me.animations.add 'rightfly', [0, 1], 6, yes
    @me.animations.add 'die', [4], 6, no
    @me.animations.play 'rightfly'

    @game.physics.enable @me, Phaser.Physics.ARCADE
    @me.body.velocity.setTo 100, -350
    @me.body.collideWorldBounds = true
    @me.body.bounce.set 1
    @me.body.gravity.set 0, 280

    @dieSound = new Phaser.Sound @game, 'chicken_die', 1

  kill: ->
    if window.plugins?.NativeAudio
      window.plugins.NativeAudio.play 'chicken_die'
    else
      @dieSound.play()
    @me.animations.play 'die'
    @me.body.collideWorldBounds = false
    @me.body.velocity.setTo 0, 350
    @me.body.bounce.set 0
    @died = true
    setTimeout =>
      @me.destroy()
    , 2000

  update: ->
    if @died then return
    if @me.deltaX > 0
      @me.animations.play 'rightfly'
    else
      @me.animations.play 'leftfly'

    if @me.body.bottom is @game.world.height
      @me.body.velocity.setTo @me.body.velocity.x, -350

module.exports = GreenDuck