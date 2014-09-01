config = require '../config.coffee'
Logger = require '../../mixins/logger.coffee'
Bean = require '../bean.coffee'
GreenDuck = require '../green_duck.coffee'
RedDuck = require '../red_duck.coffee'
Platform = require '../platform.coffee'
Cloud = require '../cloud.coffee'
Axe = require '../axe.coffee'
Module = require '../module.coffee'

GUIAxes = require '../gui/axes.coffee'
GUIClock = require '../gui/clock.coffee'

class PlayState extends Module
  @include Logger

  logPrefix: 'PlayState'

  constructor: (game) ->

  preload: ->

  create: ->

    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @game.scale.setScreenSize true

    @game.physics.startSystem Phaser.Physics.ARCADE

    # set background
    @game.add.sprite 0, 0, 'background'

    # set game characters
    @platform = new Platform @game
    @bean = new Bean @game
    @enemies = []
    @addDuck()
    @cloud = new Cloud @game
    @axe = new Axe @game

    $(@cloud).on 'ShootEvent', @handle_cloud_shoot_event

    setInterval (=> @addDuck()), 5000
    setInterval (=> @cloud.reset()), 10000

    # set GUI
    @GUIAxes = new GUIAxes @game
    @GUIClock = new GUIClock @game

  addDuck: ->
    if Math.random() > 0.5
      duck = new GreenDuck @game
    else
      duck = new RedDuck @game
    duck.me.inputEnabled = true
    duck.me.events.onInputDown.add =>
      @handleDuckClickEvent duck
    @enemies.push duck

  handleDuckClickEvent: (duck) ->
    if @game.isUsingAxes
      @debug 'killing a duck'
      duck.kill()
      @enemies.splice @enemies.indexOf(duck), 1
      @game.isUsingAxes = false

  handle_cloud_shoot_event: =>
    @debug 'handling cloud shoot event'
    @axe = new Axe @game
    @axe.dropFrom @cloud.me.x, @cloud.me.y

  bean_eat_axe: ->
    @debug 'bean ate an axe'
    @axe.flyTo @GUIAxes.axe.getBounds().x, @GUIAxes.axe.getBounds().y, =>
      @GUIAxes.addAxe()
      @axe.me.destroy()

  update: ->
    @bean.update()
    @GUIAxes.update()
    @GUIClock.update()
    @game.physics.arcade.collide @bean.me, @platform.me
    @game.physics.arcade.collide @axe.me, @platform.me
    for duck in @enemies
      duck.update()
      @game.physics.arcade.collide duck.me, @platform.me

    if not @axe.isTweening() and @bean.me.overlap @axe.me
      @bean_eat_axe()

module.exports = PlayState
