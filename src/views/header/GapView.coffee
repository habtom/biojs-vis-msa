view = require("backbone-viewj")
dom = require("dom-helper")
svg = require("../../utils/svg")

# TODO: merge this with the conservation view
ConservationView = view.extend

  className: "biojs_msa_gapview"

  initialize: (data) ->
    @g = data.g
    @listenTo @g.zoomer,"change:stepSize change:labelWidth change:columnWidth", @render
    @listenTo @g.vis,"change:labels change:metacell", @render
    @listenTo @g.columns, "change:scaling", @render
    # we need to wait until stats gives us the ok
    @listenTo @model, "reset",@render
    @manageEvents()

  render: ->
    gaps = @g.stats.gaps()

    dom.removeAllChilds @el

    nMax = @model.getMaxLength()
    cellWidth = @g.zoomer.get "columnWidth"
    maxHeight = 20
    width = cellWidth * (nMax - @g.columns.get('hidden').length)

    s = svg.base height: maxHeight, width: width
    s.style.display = "inline-block"
    s.style.cursor = "pointer"

    stepSize = @g.zoomer.get "stepSize"
    hidden = @g.columns.get "hidden"
    x = 0
    n = 0
    while n < nMax
      if hidden.indexOf(n) >= 0
        n += stepSize
        continue
      width = cellWidth * stepSize
      avgHeight = 0
      for i in [0 .. stepSize - 1]
        avgHeight += gaps[n]
      height = maxHeight *  (avgHeight / stepSize)

      rect =  svg.rect x:x,y: maxHeight - height,width:width - cellWidth / 4,height:height,style:
        "stroke:red;stroke-width:1;"
      rect.rowPos = n
      s.appendChild rect
      x += width
      n += stepSize

    @el.appendChild s
    @

  #TODO: make more general with HeaderView
  _onclick: (evt) ->
    rowPos = evt.target.rowPos
    stepSize = @g.zoomer.get("stepSize")
    # simulate hidden columns
    for i in [0..stepSize - 1] by 1
      @g.trigger "gap:click", {rowPos: rowPos + i, evt:evt}

  manageEvents: ->
    events = {}
    if @g.config.get "registerMouseClicks"
      events.click = "_onclick"
    if @g.config.get "registerMouseHover"
      events.mousein = "_onmousein"
      events.mouseout = "_onmouseout"
    @delegateEvents events
    @listenTo @g.config, "change:registerMouseHover", @manageEvents
    @listenTo @g.config, "change:registerMouseClick", @manageEvents

  _onmousein: (evt) ->
    rowPos = @g.zoomer.get "stepSize" * evt.rowPos
    @g.trigger "gap:mousein", {rowPos: rowPos, evt:evt}

  _onmouseout: (evt) ->
    rowPos = @g.zoomer.get "stepSize" * evt.rowPos
    @g.trigger "gap:mouseout", {rowPos: rowPos, evt:evt}

module.exports = ConservationView
