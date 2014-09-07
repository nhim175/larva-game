# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

PlayState = require './lib/states/play_state.coffee'
MenuState = require './lib/states/menu_state.coffee'
LoadState = require './lib/states/load_state.coffee'
BootState = require './lib/states/boot_state.coffee'
config = require './lib/config.coffee'

init = ->
  window.fbAsyncInit = ->
    FB.init
      appId      : '752923004768642',
      xfbml      : true,
      version    : 'v2.0'

    game = new Phaser.Game config.width, config.height, Phaser.CANVAS
    game.state.add 'boot', BootState, yes
    game.state.add 'load', LoadState
    game.state.add 'menu', MenuState
    game.state.add 'play', PlayState

    console.log game

  ((d, s, id) ->
    fjs = d.getElementsByTagName(s)[0]
    if (d.getElementById(id)) then return
    js = d.createElement(s)
    js.id = id
    js.src = "https://connect.facebook.net/en_US/sdk.js"
    fjs.parentNode.insertBefore(js, fjs)
  )(document, 'script', 'facebook-jssdk')

if cordova?
  $(document).on 'deviceready', init
else
  $(document).ready init


