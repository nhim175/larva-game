config = require '../config.coffee'
RedDuck = require '../red_duck.coffee'
Platform = require '../platform.coffee'
Logger = require '../../mixins/logger.coffee'
Module = require '../module.coffee'

LOGO_WIDTH = 368
LOGO_HEIGHT = 144
START_BTN_WIDTH = 212

class MenuState extends Module
  @include Logger

  logPrefix: 'MenuState'

  constructor: (game)->

  preload: ->
    # Preload Stage
    @game.stage = $.extend @game.stage, config.stage

    # Preload all images
    for imageName, image of config.images
      @game.load.image imageName, image.src
    
    # Preload all spritesheets
    for spriteName, sprite of config.sprites
      @game.load.spritesheet spriteName, sprite.src, sprite.width, sprite.height, sprite.frames

    # Preload all bitmap fonts
    for fontName, font of config.bitmap_fonts
      @game.load.bitmapFont fontName, font.src, font.map

  create: ->

    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @game.scale.setScreenSize true

    @game.physics.startSystem Phaser.Physics.ARCADE

    # set background
    @game.add.sprite 0, 0, 'background'
    @platform = new Platform @game
    @redDuck = new RedDuck @game

    @logo = @game.add.sprite @game.world.centerX, 168, 'logo'
    @logo.anchor.setTo 0.5, 0.5
    @game.add.tween(@logo).to {y: 200}, 1000, Phaser.Easing.Cubic.InOut, true, 0, Number.MAX_VALUE, true 

    @startBtn = @game.add.sprite @game.world.centerX, 372, 'start_btn'
    @startBtn.anchor.setTo 0.5, 0.5
    @startBtn.inputEnabled = true
    @startBtn.events.onInputDown.add @onStartBtnClickListener

  onStartBtnClickListener: =>
    @debug 'start btn click listener'
    @game.state.start 'play'

  update: ->
    @redDuck.update()
    @game.physics.arcade.collide @redDuck.me, @platform.me

module.exports = MenuState
