# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

PlayState = require './lib/states/play_state.coffee'
MenuState = require './lib/states/menu_state.coffee'
LoadState = require './lib/states/load_state.coffee'
BootState = require './lib/states/boot_state.coffee'
config = require './lib/config.coffee'

APP_VERSION = '1.0'

init = ->

  makeGame = ->
    game = new Phaser.Game config.width, config.height, Phaser.CANVAS
    game.state.add 'boot', BootState, yes
    game.state.add 'load', LoadState
    game.state.add 'menu', MenuState
    game.state.add 'play', PlayState

  # select the right Ad Id according to platform
  adHeight = 30
  if /(android)/i.test(navigator.userAgent)
    admobid = 
      banner: 'ca-app-pub-1445461785188374/4195071643'
      interstitial: 'ca-app-pub-1445461785188374/5671804847'
  else if /(ipod|iphone|ipad)/i.test(navigator.userAgent)
    admobid = 
      banner: 'ca-app-pub-1445461785188374/7140681643'
      interstitial: 'ca-app-pub-1445461785188374/4334672441'

    if screen.width/screen.height == 1.5 #iphone 4 & 4S
      adHeight = 100

  if AdMob? 
    AdMob.createBanner
      adId: admobid.banner
      adSize: 'SMART_BANNER'
      position: AdMob.AD_POSITION.BOTTOM_CENTER
      overlap:true
      autoShow: true

  updateCallback = (data) ->
    if /(ipod|iphone|ipad)/i.test(navigator.userAgent)
      cordova?.exec null, null, 'Browser', 'open', [data.ios_url]

  $.post 'http://larvafun.com/info.php', (data) ->
    if data.version isnt APP_VERSION
      navigator.notification?.alert "Thank you for playing LarvaGame. There's an update available.", ( -> updateCallback(data)), "Update available", "Update now"

  window.fbAsyncInit = ->
    FB.init
      appId      : '752923004768642',
      xfbml      : true,
      version    : 'v2.0'

    if !cordova?
      window.facebookConnectPlugin = FB

    unless /android/i.test(navigator.userAgent)
      makeGame()
    else
      # this is for android because AdMob is not working on Android
      # admob is not AdMob
      if admob?
        admob.createBannerView(publisherId: admobid.banner)
        document.addEventListener admob.events.onAdLoaded, -> makeGame()

  if navigator.connection?.type is 'none' or navigator.connection?.type is 'unknown'
    makeGame()
  else
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


