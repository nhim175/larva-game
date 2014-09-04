# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Module = require './module.coffee'
Logger = require '../mixins/logger.coffee'

WIDTH = 64
HEIGHT = 108
LEFT_DIRECTION = 0
RIGHT_DIRECTION = 1

class Bean extends Module
  @include Logger

  logPrefix: 'Bean'

  constructor: (game) ->
    @game = game
    @me = @game.add.sprite @game.world.width/2, 0, 'bean'
    @me.animations.add 'leftwalk', ['1'], 6, yes
    @me.animations.add 'leftstand', ['2'], 6, yes
    @me.animations.add 'rightstand', ['3'], 6, yes
    @me.animations.add 'rightwalk', ['4'], 6, yes
    @me.animations.add 'die', ['5','6'], 30, no
    @me.animations.play 'rightstand'
    @me.direction = LEFT_DIRECTION
    @game.physics.enable @me, Phaser.Physics.ARCADE
    @me.body.collideWorldBounds = true
    @me.body.gravity.set 0, 380
    @me.body.enable = true
    @velocity = 6

  standLeft: ->
    @me.animations.play 'leftstand'

  standRight: ->
    @me.animations.play 'rightstand'

  moveLeft: ->
    @me.x -= @velocity
    @me.animations.play 'leftwalk'
    @me.direction = LEFT_DIRECTION

  moveRight: ->
    @me.x += @velocity
    @me.animations.play 'rightwalk'
    @me.direction = RIGHT_DIRECTION

  die: ->
    if not @isDead
      @me.body.velocity.setTo 20, -350
      @me.animations.play 'die'
      @isDead = true

  update: ->
    leftKeyIsDown = @game.input.keyboard.isDown(Phaser.Keyboard.LEFT)
    rightKeyIsDown = @game.input.keyboard.isDown(Phaser.Keyboard.RIGHT)
    screenIsTouched = @game.input.activePointer.isDown
    touchOnLeftScreen = Math.floor(@game.input.activePointer.x/(@game.width/2)) is LEFT_DIRECTION
    touchOnRightScreen = Math.floor(@game.input.activePointer.x/(@game.width/2)) is RIGHT_DIRECTION

    if not @isDead
      if leftKeyIsDown or (screenIsTouched and touchOnLeftScreen)
        @moveLeft()
      else if rightKeyIsDown or (screenIsTouched and touchOnRightScreen)
        @moveRight()
      else
        if @me.direction is LEFT_DIRECTION then @standLeft() else @standRight()

module.exports = Bean

