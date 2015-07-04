# Copyright © 2013 All rights reserved
# Author: nhim175@gmail.com

API_URL = 'http://putainmedia.ngrok.com'
MEDIA_URL = 'https://putainstatic.ngrok.com'

module.exports =
  upload_url: API_URL + '/file/public_upload',
  media_url: MEDIA_URL

  width: 1136
  height: 640

  stage:
    backgroundColor: 0x000000

  boot:
    images:
      loading:
        src: 'assets/img/loading.png'

  images:
    background:
      src: 'assets/img/bg.png'
    ground:
      src: 'assets/img/ground.png'
    logo:
      src: 'assets/img/logo.png'
    start_btn:
      src: 'assets/img/start_btn.png'
    exit_btn:
      src: 'assets/img/share_btn.png'
    score_board:
      src: 'assets/img/score_board.png'
    game_over:
      src: 'assets/img/game_over.png'
    axe:
      src: 'assets/img/axe.png'
    pause_btn:
      src: 'assets/img/pause_button.png'

  sprites:
    red_duck:
      src: 'assets/img/enemy1.png'
      width: 79
      height: 96
      frames: 5
    green_duck:
      src: 'assets/img/enemy2.png'
      width: 79
      height: 96
      frames: 5
    cloud:
      src: 'assets/img/cloud2.png'
      width: 64
      height: 96
      frames: 2

  atlasXML:
    bean:
      src: 'assets/atlasXML/character.png'
      xml: 'assets/atlasXML/character.xml'

  bitmap_fonts:
    '8bit_wonder':
      src: 'assets/font/8bit_wonder/font.png'
      map: 'assets/font/8bit_wonder/font.xml'

  sounds:
    intro: 
      src: 'assets/sound/intro.ogg'
      src_mp3: 'assets/sound/intro.mp3'
    click:
      src: 'assets/sound/click.ogg'
      src_mp3: 'assets/sound/click.mp3'
    pickup:
      src: 'assets/sound/pickup.ogg'
      src_mp3: 'assets/sound/pickup.mp3'

