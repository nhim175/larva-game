# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

config = require '../config.coffee'
Logger = require '../../mixins/logger.coffee'
Module = require '../module.coffee'

class LoadState extends Module
  @include Logger

  logPrefix: 'LoadState'

  constructor: (game)->

  preload: ->

    @loading_sprite = @game.add.sprite 388, 400, 'loading'
    @game.load.setPreloadSprite @loading_sprite

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

      if window.plugins?.NativeAudio
        if soundName is 'intro'
          window.plugins.NativeAudio.preloadComplex(soundName, sound.src_mp3, 0.2, 1, 0
            , (msg) ->
              console.log("Finish loading #{soundName}")
            , (msg) ->
              console.log(msg)
          )
        else
          window.plugins.NativeAudio.preloadSimple(soundName, sound.src_mp3
            , (msg) ->
              console.log(msg)
            , (error) ->
              console.log(error)
          )


  create: ->
    @game.state.start 'menu'

module.exports = LoadState
