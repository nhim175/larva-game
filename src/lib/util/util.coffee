Util =
  resize: (input, w, h, callback) -> # input can be data url, canvas...
    canvas = document.createElement "canvas"
    canvas.width = w
    canvas.height = h
    if typeof input is "string"
      sourceImage = new Image()
      sourceImage.onload = ->
        canvas.getContext('2d').drawImage sourceImage, 0, 0, w, h
        callback canvas.toDataURL()

      sourceImage.src = input

module.exports = Util