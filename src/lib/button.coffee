# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

config = require './config.coffee'

class Button extends Phaser.Button
  constructor: (game, x, y, key, callback) ->
    super(game, x, y, key, callback)
    @onDownSound = new Phaser.Sound game, 'click', 1
    if cordova?
      @onInputUp.add @onInputUpListener
      @onDownSound = new Media config.sounds.click.src_mp3

  onInputUpListener: =>
    if cordova?
      @onDownSound.play()

module.exports = Button
