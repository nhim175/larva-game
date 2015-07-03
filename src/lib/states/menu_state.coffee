# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

config = require '../config.coffee'
RedDuck = require '../red_duck.coffee'
Platform = require '../platform.coffee'
Logger = require '../../mixins/logger.coffee'
Module = require '../module.coffee'
Button = require '../button.coffee'

LOGO_WIDTH = 368
LOGO_HEIGHT = 144
START_BTN_WIDTH = 212

class MenuState extends Module
  @include Logger

  logPrefix: 'MenuState'

  constructor: (game)->

  preload: ->

  create: ->

    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @game.scale.setScreenSize true

    @game.physics.startSystem Phaser.Physics.ARCADE

    # set background
    @game.add.sprite 0, 0, 'background'
    @platform = new Platform @game
    @redDuck = new RedDuck @game

    @GUI = @game.add.group()

    @logo = @game.add.sprite @game.world.centerX, 168, 'logo'
    @logo.anchor.setTo 0.5, 0.5
    @game.add.tween(@logo).to {y: 200}, 1000, Phaser.Easing.Cubic.InOut, true, 0, Number.MAX_VALUE, true 

    @startBtn = new Button @game, @game.world.centerX, 372, 'start_btn', @onStartBtnClickListener
    @startBtn.anchor.setTo 0.5, 0.5

    @GUI.add @logo
    @GUI.add @startBtn

    @debug @startBtn

    @introAudio = @game.add.audio 'intro', 1, true
    @introAudio.play '', 0, 0.5, true

    if window.plugins?.NativeAudio
      window.plugins.NativeAudio.loop('intro')

  onMediaStatusChange: (status) =>
    if status is Media.MEDIA_STOPPED
      @_introAudio.play()

  onStartBtnClickListener: =>
    @debug 'start btn click listener'
    @game.state.start 'play'

  update: ->
    @redDuck.update()
    @game.physics.arcade.collide @redDuck.me, @platform.me

module.exports = MenuState
