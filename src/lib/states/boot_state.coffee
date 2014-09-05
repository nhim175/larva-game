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
    for imageName, image of config.images
      @game.load.image imageName, image.src
    
    # Preload all spritesheets
    for spriteName, sprite of config.sprites
      @game.load.spritesheet spriteName, sprite.src, sprite.width, sprite.height, sprite.frames

    # Preload all bitmap fonts
    for fontName, font of config.bitmap_fonts
      @game.load.bitmapFont fontName, font.src, font.map

    # Preload all atlasXML sprites
    for atlasName, atlas of config.atlasXML
      @game.load.atlasXML atlasName, atlas.src, atlas.xml

    # Preload all sounds
    for soundName, sound of config.sounds
      @game.load.audio soundName, sound.src

  create: ->
    @game.state.start 'menu'

module.exports = BootState
