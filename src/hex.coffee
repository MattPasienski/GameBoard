Board = require "./board"

module.exports = class Hex
  @NUM_STATES = 5
  @STATE_TO_COLOR = ["#FFFFFF", "#FF9999", "#99FF99", "#FFFF99", "#9999FF"]

  constructor: (coordinate, position) ->
    @coordinate = coordinate
    @position = position
    @state = 0

  getColor: -> Hex.STATE_TO_COLOR[@state]
  setState: (x) -> @state = x % Hex.NUM_STATES
