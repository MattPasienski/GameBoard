Hex = require "./hex"

module.exports = class Board
  @HEX_RADIUS = 30
  @COLUMNS = 17
  @ROWS = 15
  @COLUMN_SEPARATION = Math.floor(3 * Board.HEX_RADIUS / 2)
  @ROW_SEPARATION = Math.floor(Board.HEX_RADIUS * Math.sqrt(3))
  @COLUMN_OFFSET = Math.floor(Board.HEX_RADIUS * Math.sqrt(3) / 2)
  @MARGIN = 35

  constructor: ->
    # initialize all the hexes
    @hexes = []
    for i in [0...Board.COLUMNS]
      @hexes.push []
      for j in [0...Board.ROWS]
        @hexes[i].push( new Hex([i, j], @getHexPosition([i,j])) )

  positionToHex: (x, y) ->
    #TODO: Make this more efficient, right now, its finding the closest cells and doing a distance check
    # to every center.
    i = Math.floor( (x - Board.MARGIN) / Board.COLUMN_SEPARATION)
    j = Math.floor( (y - Board.MARGIN) / Board.ROW_SEPARATION)
    return null if i >= Board.COLUMNS || j >= Board.ROWS || i < -1 || j < -1

    testHexes = []
    for coord in [[i,j], [i+1,j], [i,j+1], [i+1,j+1]]
      [r, c] = coord
      testHexes.push @hexes[r][c] if r >= 0 && r < Board.COLUMNS && c >= 0 && c < Board.ROWS

    minDist = 99999999
    closest = null
    for hex in testHexes
      [cx, cy] = hex.position
      dist = (x - cx) * (x - cx) + (y - cy) * (y - cy)
      if minDist > dist
        minDist = dist
        closest = hex

    closest
  infectNeighbors: (hex) ->
    hex.setState(1 + hex.state) if hex
    coord = hex.coordinate
    newCoord0 = coord[0] + 1
    neighbor = @hexes[newCoord0][coord[1]]
    neighbor.setState(hex.state) if hex && neighbor && neighbor.state != 1

  draw: (ctx) ->
    column = 0
    for column in @hexes
      for hex in column
        @drawHexagon ctx, hex

    # testing position to hex translation
    @drawHexagon ctx, @positionToHex(200, 200)

  getHexPosition: (coord) ->
    x = coord[0] * Board.COLUMN_SEPARATION + Board.MARGIN
    y = coord[1] * Board.ROW_SEPARATION + Board.MARGIN
    y += Board.COLUMN_OFFSET if coord[0] % 2 == 1
    [x, y]

  drawHexagon: (ctx, hex) ->
    ctx.save()

    [cx, cy] = hex.position
    ctx.translate(cx, cy)
    ctx.strokeStyle = "#CCCCCC"
    ctx.beginPath()
    ctx.moveTo(Board.HEX_RADIUS, 0)
    for i in [0..5]
      ctx.rotate(Math.PI / 3)
      ctx.lineTo(Board.HEX_RADIUS, 0)
    ctx.closePath()
    ctx.stroke()
    ctx.fillStyle = hex.getColor()
    ctx.fill()

    # debug text for cellIndex
    if true
      ctx.fillStyle = "#888888"
      ctx.font = "italic 8px"
      ctx.textBaseline = "middle"
      ctx.textAlign = "center"
      [row, column] = hex.coordinate
      ctx.fillText("#{row},#{column}", 0, 0)

    ctx.restore()
