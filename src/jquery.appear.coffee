###  AppearHandlar
##############################

class AppearHandlar
  timing: 0.5

  constructor: ->
    @$window = $ window
    @nodeList = []
    @flag = true
    @setEvent()
    @windowSizeUpdate()

  windowSizeUpdate: ->
    @wh = @$window.height() * @timing

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
          ,200
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

  # $('.anm-appear').appearAnimate { scale: 0 }, { scale: 1 }, { duration: 400, easing: 'easeOutQuint' }
  # $('.anm-line').appearFunction ($target)->
  #   $target.css
  #     background: "url(/images/bg-line.png) 0 50% no-repeat"
  #     backgroundSize: "0 20px"
  # , ($target)->
  #   $target.transit
  #     backgroundSize: "100% 20px"

  $('.append-trigger').appearFunction ($target)->
    $(".mod-float_menu").transit
      left: -300
    $(".mod-float_banner").transit
      right: -300
  , ($target)->
    $(".mod-float_menu").transit
      left: 0
    $(".mod-float_banner").transit
      right: -20


  totalDelay = 500
  $('.append-sec-trigger').appearFunction ($target)->
    # appear
    $target.find('.anm-appear').stop().animate
      scale: 0
    ,
      duration: 400
      easing: 'easeOutQuint'
    # fadein
    $target.find('.anm-fadein').stop().animate
      opacity: 0
    ,
      duration: 400
      easing: 'easeOutQuint'
    # line
    $target.find('.anm-line').css
      background: "url(/images/bg-line.png) 0 50% no-repeat"
      backgroundSize: "0 20px"
  , ($target)->
    # appear
    $target.find('.anm-appear').stop().animate
      scale: 1
    ,
      duration: 400
      easing: 'easeOutQuint'
    # fadein
    $target.find('.anm-fadein').stop().delay(totalDelay*0.5).animate
      opacity: 1
    ,
      duration: 600
      easing: 'easeOutQuint'
    # line
    $target.find('.anm-line').stop().delay(totalDelay).transit
      backgroundSize: "100% 20px"

  $('.appear-top').appearAnimate { opacity: 0, top: -10, position: 'relative' }, { opacity: 1, top: 0 }, { duration: 600, easing: 'easeOutQuint' }
  $('.appear-left').appearAnimate { opacity: 0, left: -10, position: 'relative' }, { opacity: 1, left: 0 }, { duration: 1000, easing: 'easeOutQuint' }
  $('.appear-right').appearAnimate { opacity: 0, right: -10, position: 'relative' }, { opacity: 1, right: 0 }, { duration: 1000, easing: 'easeOutQuint' }
  $('.appear-bottom').appearAnimate { opacity: 0, bottom: -10, position: 'relative' }, { opacity: 1, bottom: 0 }, { duration: 900, easing: 'easeInOutQuint' }

  # $('.appear-fn').appearFunction ->
  #   console.log 'before'
  # , ->
  #   console.log 'after'