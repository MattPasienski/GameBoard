Board = require "./board"

module.exports = class Game
  constructor: (canvas) ->
    @board = new Board
    @canvas = canvas
    @ctx = @canvas.getContext("2d")
    console.log "Game initialized"

    @canvas.onclick = (evt) =>
      @board.infectNeighbors(@board.positionToHex(evt.offsetX, evt.offsetY))
      @draw()

  draw: ->
    @ctx.setTransform(1, 0, 0, 1, 0, 0)
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @board.draw(@ctx)
 