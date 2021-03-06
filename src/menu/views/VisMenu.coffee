MenuBuilder = require "../menubuilder"
dom = require "dom-helper"

module.exports = VisMenu = MenuBuilder.extend

  initialize: (data) ->
    @g = data.g
    @el.style.display = "inline-block"
    @listenTo @g.vis, "change", @render

  render: ->
    @removeAllNodes()
    @setName("Vis.elements")

    visElements = @getVisElements()
    for visEl in visElements
      @_addVisEl visEl

    # other
    @addNode "Reset", =>
      @g.vis.set "labels", true
      @g.vis.set "sequences", true
      @g.vis.set "metacell", true
      @g.vis.set "conserv", true
      @g.vis.set "labelId", true
      @g.vis.set "labelName", true
      @g.vis.set "labelCheckbox", false
      @g.vis.set "seqlogo", false
      @g.vis.set "gapHeader", false
      @g.vis.set "leftHeader", true
      @g.vis.set "metaGaps", true
      @g.vis.set "metaIdentity", true
      @g.vis.set "metaLinks", true

    # TODO: make more efficient
    dom.removeAllChilds @el
    @el.appendChild @buildDOM()
    @

  _addVisEl: (visEl) ->
    style = {}

    if @g.vis.get visEl.id
      pre = "Hide "
      style.color = "red"
    else
      pre = "Show "
      style.color = "green"

    @addNode (pre + visEl.name), =>
      @g.vis.set visEl.id, ! @g.vis.get visEl.id
    ,
      style: style

  getVisElements: ->
    vis = []
    vis.push name: "Markers", id: "markers"
    vis.push name: "Labels", id: "labels"
    #vis.push name: "Sequences", id: "sequences"
    vis.push name: "Meta info", id: "metacell"
    vis.push name: "Overviewbox", id: "overviewbox"
    vis.push name: "Conserv", id: "conserv"
    vis.push name: "Seq. logo", id: "seqlogo"
    vis.push name: "Gap Header", id: "gapHeader"
    vis.push name: "Left header", id: "leftHeader"
    vis.push name: "Label name", id: "labelName"
    vis.push name: "Label id", id: "labelId"
    vis.push name: "Label checkbox", id: "labelCheckbox"
    vis.push name: "Meta gaps", id: "metaGaps"
    vis.push name: "Meta identity", id: "metaIdentity"
    vis.push name: "Meta links", id: "metaLinks"
    return vis
