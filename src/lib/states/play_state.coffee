config = require '../config.coffee'
Logger = require '../../mixins/logger.coffee'
Bean = require '../bean.coffee'
GreenDuck = require '../green_duck.coffee'
RedDuck = require '../red_duck.coffee'
Platform = require '../platform.coffee'
Cloud = require '../cloud.coffee'
Axe = require '../axe.coffee'
Module = require '../module.coffee'
Button = require '../button.coffee'

GUIAxes = require '../gui/axes.coffee'
GUIClock = require '../gui/clock.coffee'
GUIPauseButton = require '../gui/pause_btn.coffee'

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
    @enemiesLayer = @game.add.group()
    @enemiesLayer.z = 5

    @platform = new Platform @game
    @bean = new Bean @game
    @enemies = []
    @addDuck()
    @cloud = new Cloud @game
    @axe = new Axe @game

    $(@cloud).on 'ShootEvent', @handle_cloud_shoot_event

    @duckTimer = @game.time.create(false)
    @duckTimer.loop 5000, (=> @addDuck()), @
    @duckTimer.start()

    @cloudTimer = @game.time.create(false) 
    @cloudTimer.loop 10000, (=> @cloud.reset()), @
    @cloudTimer.start()

    # set GUI
    @GUIAxes = new GUIAxes @game
    @GUIClock = new GUIClock @game
    @GUIGameOver = @game.add.group()

    @gameOverText = new Phaser.Sprite @game, @game.world.centerX, -120, 'game_over'
    @gameOverText.anchor.setTo 0.5, 0.5
    @gameOverTextInTween = @game.tweens.create(@gameOverText).to {y: 120 }, 1000, Phaser.Easing.Cubic.Out 
    @gameOverTextOutTween = @game.tweens.create(@gameOverText).to {y: -120 }, 1000, Phaser.Easing.Cubic.Out 

    @scoreBoard = new Phaser.Sprite @game, @game.world.centerX, -200, 'score_board'
    @scoreBoard.anchor.setTo 0.5, 0.5
    @scoreBoardInTween = @game.tweens.create(@scoreBoard).to {y: 300 }, 1000, Phaser.Easing.Cubic.Out 
    @scoreBoardOutTween = @game.tweens.create(@scoreBoard).to {y: -200 }, 1000, Phaser.Easing.Cubic.Out 

    @result = new Phaser.BitmapText @game, @game.world.centerX, -100, '8bit_wonder', '', 60
    @resultInTween = @game.tweens.create(@result).to {y: @game.world.centerY - 60}, 1000, Phaser.Easing.Cubic.Out
    @resultOutTween = @game.tweens.create(@result).to {y: -100}, 1000, Phaser.Easing.Cubic.Out

    @startBtn = new Button @game, -200, 450, 'start_btn', @onStartBtnClickListener
    @startBtn.anchor.setTo 1, 0
    @startBtnInTween = @game.tweens.create(@startBtn).to {x: @game.world.centerX - 20}, 1000, Phaser.Easing.Cubic.Out 

    @shareBtn = new Button @game, @game.width + 200, 450, 'exit_btn', @onShareBtnClickListener
    @shareBtnInTween = @game.tweens.create(@shareBtn).to {x: @game.world.centerX + 20}, 1000, Phaser.Easing.Cubic.Out 

    @GUIGameOver.z = 100
    @GUIGameOver.add @gameOverText
    @GUIGameOver.add @scoreBoard
    @GUIGameOver.add @startBtn
    @GUIGameOver.add @shareBtn
    @GUIGameOver.add @result

    pause_btn = new GUIPauseButton @game

    $('.resume-btn').on 'click', @onResumeBtnClicked

  onResumeBtnClicked: =>
    @game.paused = false
    $('body').removeClass 'paused'

  reset: ->
    @GUIClock.reset()
    @game.isOver = false

  onStartBtnClickListener: =>
    @reset()
    @game.state.restart 'play'

  onShareBtnClickListener: =>
    @share_result()

  addDuck: ->
    return if @game.paused
    if Math.random() > 0.5
      duck = new GreenDuck @game
    else
      duck = new RedDuck @game
    duck.me.inputEnabled = true
    @enemiesLayer.add duck.me
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
    @axeTimeout = @game.time.create(true)
    @axeTimeout.add @axe.lifeTime, (=> @axe.disappear()), @
    @axeTimeout.start()

  bean_eat_axe: ->
    @debug 'bean ate an axe'
    @axeTimeout.destroy()
    @axe.flyTo @GUIAxes.axe.getBounds().x, @GUIAxes.axe.getBounds().y, =>
      @GUIAxes.addAxe()
      @axe.me.destroy()

  gameOver: ->
    @result.text = @GUIClock.getTime()
    @gameOverTextInTween.start()
    @scoreBoardInTween.start()
    @startBtnInTween.start()
    @shareBtnInTween.start()
    @resultInTween.start()
    @duckTimer.destroy()
    @cloudTimer.destroy()
    @game.isOver = true
    $(@game).trigger 'GameOverEvent'

  share_result: ->
    $.post config.upload_url, {data: @game.canvas.toDataURL()}, (data) =>
      @debug data
      url = config.media_url + '/?result=' + data.file
      @debug url
      FB.ui
        method: 'share',
        href: url
        , (response) ->
          if response && !response.error_code
            alert 'Posting completed.'
          else
            alert 'Error while posting.'

  update: ->
    @bean.update()
    @GUIAxes.update()
    @GUIClock.update()
    @game.physics.arcade.collide @bean.me, @platform.me
    @game.physics.arcade.collide @axe.me, @platform.me
    for duck in @enemies
      duck.update()
      @game.physics.arcade.collide duck.me, @platform.me
      if @bean.me.overlap duck.me
        @bean.die()
        @gameOver()

    if @axe.isVisible() and not @axe.isTweening() and @bean.me.overlap @axe.me
      @bean_eat_axe()

module.exports = PlayState
