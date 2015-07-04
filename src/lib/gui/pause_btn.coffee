# Copyright © 2015 All rights reserved
# Author: nhim175@gmail.com

Button = require '../button.coffee' 

class GUIPauseButton extends Button

  constructor: (game) ->
    super(game, 51, 56, 'pause_btn', @onClick)
    @game.add.group().add @

  onClick: =>
    console.log 'pause btn clicked'
    return if @game.isOver
    @game.paused = !@game.paused
    $(@game).trigger 'PausedEvent'
    $('body').addClass('paused')

module.exports = GUIPauseButton
