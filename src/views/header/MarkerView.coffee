view = require("backbone-viewj")
dom = require("dom-helper")
svg = require("../../utils/svg")
jbone = require "jbone"

HeaderView = view.extend

  className: "biojs_msa_marker"

  initialize: (data) ->
    @g = data.g
    @listenTo @g.zoomer,"change:stepSize change:labelWidth change:columnWidth change:markerStepSize change:markerFontsize", @render
    @listenTo @g.vis,"change:labels change:metacell", @render
    @manageEvents()

  render: ->
    dom.removeAllChilds @el

    @el.style.fontSize = @g.zoomer.get "markerFontsize"

    container = document.createElement "span"
    n = 0
    cellWidth = @g.zoomer.get "columnWidth"

    nMax = @model.getMaxLength()
    stepSize = @g.zoomer.get("stepSize")
    hidden = @g.columns.get "hidden"

    while n < nMax
      if hidden.indexOf(n) >= 0
        @markerHidden(span,n, stepSize)
        n += stepSize
        continue
      span = document.createElement "span"
      span.style.width = (cellWidth * stepSize) + "px"
      span.style.display = "inline-block"
      # TODO: this doesn't work for a larger stepSize
      if (n + 1) % @g.zoomer.get('markerStepSize') is 0
        span.textContent = (n + 1)
      else
        span.textContent = "."
      span.rowPos = n

      n += stepSize
      container.appendChild span

    @el.appendChild container
    @

  markerHidden: (span,n,stepSize) ->
    hidden = @g.columns.get("hidden").slice 0

    min = Math.max 0, n - stepSize
    prevHidden = true
    for j in  [min .. n] by 1
      prevHidden &= hidden.indexOf(j) >= 0

    # filter duplicates
    return if prevHidden

    nMax = @model.getMaxLength()

    length = 0
    index = -1
    # accumlate multiple rows
    for n in [n..nMax] by 1
      index = hidden.indexOf(n) unless index >= 0# sets the first index
      if hidden.indexOf(n) >= 0
        length++
      else
        break

    s = svg.base height: 10, width: 10
    s.style.position = "relative"
    triangle = svg.polygon points: "0,0 5,5 10,0", style:
      "fill:lime;stroke:purple;stroke-width:1"
    jbone(triangle).on "click", (evt) =>
      hidden.splice index, length
      @g.columns.set "hidden", hidden

    s.appendChild triangle
    span.appendChild s
    return s

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

  _onclick: (evt) ->
    rowPos = evt.target.rowPos
    stepSize = @g.zoomer.get("stepSize")
    @g.trigger "column:click", {rowPos: rowPos,stepSize: stepSize, evt:evt}

  _onmousein: (evt) ->
    rowPos = @g.zoomer.get "stepSize" * evt.rowPos
    stepSize = @g.zoomer.get("stepSize")
    @g.trigger "column:mousein", {rowPos: rowPos,stepSize: stepSize, evt:evt}

  _onmouseout: (evt) ->
    rowPos = @g.zoomer.get "stepSize" * evt.rowPos
    stepSize = @g.zoomer.get("stepSize")
    @g.trigger "column:mouseout", {rowPos: rowPos,stepSize: stepSize, evt:evt}

module.exports = HeaderView
