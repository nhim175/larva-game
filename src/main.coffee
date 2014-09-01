PlayState = require './lib/states/play_state.coffee'
MenuState = require './lib/states/menu_state.coffee'
config = require './lib/config.coffee'

$(document).ready ->

  game = new Phaser.Game config.width, config.height, Phaser.CANVAS
  game.state.add 'menu', MenuState, yes
  game.state.add 'play', PlayState

