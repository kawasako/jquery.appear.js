###  AppearHandlar
##############################

class AppearHandlar
  constructor: ->
    @$window = $ window
    @nodeList = []
    @flag = true
    @setEvent()
    @windowSizeUpdate()

  windowSizeUpdate: ->
    @wh = @$window.height() * 0.66

  setAnimation: (node, before, after, opt)->
    $node = $ node
    opt = opt || { duration: 500, easing: 'linear'}

    $node.css before
    $node.on
      'scroll::appear': (e)->
        $node.stop().animate after
        , opt
        e.stopPropagation()
      'scroll::disappear': (e)->
        $node.stop().animate before
        , opt
        e.stopPropagation()
    @nodeList.push
      node: $node
      offset: $node.offset()
      isAppeared: false

  setFunction: (node, before, after)->
    $node = $ node
    before?($node)
    $node.on
      'scroll::appear': (e)->
        after?($node)
        e.stopPropagation()
      'scroll::disappear': (e)->
        before?($node)
        e.stopPropagation()
    @nodeList.push
      node: $node
      offset: $node.offset()
      isAppeared: false

  setEvent: ->
    @$window.on
      scroll: =>
        if @flag
          @flag = false
          setTimeout =>
            st = @$window.scrollTop()
            if @nodeList.length > 0
              for item in @nodeList
                if st > item.offset.top - @wh
                  if !item.isAppeared
                    item.isAppeared = true
                    item.node.trigger 'scroll::appear'
                else if item.isAppeared
                  item.isAppeared = false
                  item.node.trigger 'scroll::disappear'

            @flag = true
          ,500
      resize: =>
        @windowSizeUpdate()

$ ->
  window.AppearHandlar = new AppearHandlar()
  $.fn.extend
    appearAnimate: (before, after, opt)->
      @each ->
        window.AppearHandlar.setAnimation this, before, after, opt

    appearFunction: (before, after)->
      @each ->
        window.AppearHandlar.setFunction this, before, after


  # $('.appear-top').appearAnimate { opacity: 0, top: -10, position: 'relative' }, { opacity: 1, top: 0 }, { duration: 600, easing: 'easeOutQuint' }
  # $('.appear-left').appearAnimate { opacity: 0, left: -10, position: 'relative' }, { opacity: 1, left: 0 }, { duration: 1000, easing: 'easeOutQuint' }
  # $('.appear-right').appearAnimate { opacity: 0, right: -10, position: 'relative' }, { opacity: 1, right: 0 }, { duration: 1000, easing: 'easeOutQuint' }
  # $('.appear-bottom').appearAnimate { opacity: 0, bottom: -10, position: 'relative' }, { opacity: 1, bottom: 0 }, { duration: 900, easing: 'easeInOutQuint' }

  # $('.appear-fn').appearFunction ->
  #   console.log 'before'
  # , ->
  #   console.log 'after'

