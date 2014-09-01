# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

Module = require '../module.coffee'
Logger = require '../../mixins/logger.coffee'
Axe = require '../axe.coffee'

class GUIAxes extends Module
  @include Logger

  logPrefix: 'GUIAxes'

  axes: 0

  constructor: (game) ->
    @game = game
    @me = @game.add.group()
    @score = new Phaser.BitmapText @game, 120, 10, '8bit_wonder', '' + @axes, 40
    @score.updateText()
    @score.x = 123 - @score.textWidth

    @axe = new Phaser.Image @game, 128, 0, 'axe'
    @axe.inputEnabled = true
    @axe.events.onInputDown.add @onClickAxeEvent

    @me.add @score
    @me.add @axe
    @me.x = @game.width - 64*3 - 50
    @me.y = 50
    @debug @me

  onClickAxeEvent: =>
    if not @game.isUsingAxes and @axes > 0
      @debug 'use AXE'
      @axes--
      @game.isUsingAxes = true

  addAxe: ->
    @axes++

  update: ->
    @score.text = '' + @axes
    @score.x = 123 - @score.width

module.exports = GUIAxes
