MenuBuilder = require "../menubuilder"
dom = require "dom-helper"
_ = require('underscore')

module.exports = OrderingMenu = MenuBuilder.extend

  initialize: (data) ->
    @g = data.g
    @order = "ID"
    @el.style.display = "inline-block"

  setOrder: (order) ->
    @order = order
    @render()

  # TODO: make more generic
  render: ->
    @setName("Ordering")
    @removeAllNodes()

    comps = @getComparators()
    for m in comps
      @_addNode m

    el = @buildDOM()

    # TODO: make more efficient
    dom.removeAllChilds @el
    @el.appendChild el
    @

  _addNode: (m) ->
    text = m.text
    style = {}
    if text is @order
      style.backgroundColor = "#77ED80"
    @addNode text, =>
      m.precode() if m.precode?
      @model.comparator = m.comparator
      @model.sort()
      @setOrder m.text
    ,
      style: style

  getComparators: ->
    models = []


    models.push text: "ID", comparator: "id"

    models.push text: "ID Desc", comparator: (a, b) ->
      # auto converts to string for localeCompare
        - ("" + a.get("id")).localeCompare("" + b.get("id"), [], numeric: true )

    models.push text: "Label", comparator: "name"

    models.push text: "Label Desc", comparator: (a, b) ->
        - a.get("name").localeCompare(b.get("name"))

    models.push text: "Seq", comparator: "seq"

    models.push text: "Seq Desc", comparator: (a,b) ->
        - a.get("seq").localeCompare(b.get("seq"))

    setIdent = =>
      @ident = @g.stats.identity()

    models.push text: "Identity", comparator: (a,b) =>
      val = @ident[a.id] - @ident[b.id]
      return 1 if val > 0
      return -1 if val < 0
      0
    , precode: setIdent

    models.push text: "Identity Desc", comparator: (a,b) =>
      val = @ident[a.id] - @ident[b.id]
      return -1 if val > 0
      return 1 if val < 0
      0
    , precode: setIdent

    models.push text: "Reference", comparator: (seq) ->
        not seq.get "ref"

    models.push text: "Partition codes", comparator: "partition", precode: =>
      # set partitions random
      @g.vis.set('labelPartition', true)
      @model.each (el) ->
        el.set('partition', _.random(1,3))


    return models
