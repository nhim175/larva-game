# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

config = require './config.coffee'

class Button extends Phaser.Button
  constructor: (game, x, y, key, callback) ->
    super(game, x, y, key, callback)
    @clickSound = new Phaser.Sound game, 'click', 1
    @onInputUp.add @onInputUpListener
    
  onInputUpListener: =>
    if window.plugins?.NativeAudio
      window.plugins.NativeAudio.play('click')
    else
      @clickSound.play()

module.exports = Button
