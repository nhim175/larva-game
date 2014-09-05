# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

class Button extends Phaser.Button
  constructor: (game, x, y, key, callback) ->
    super(game, x, y, key, callback)
    @onDownSound = new Phaser.Sound game, 'click', 1

module.exports = Button
