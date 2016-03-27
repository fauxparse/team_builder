@ANIMATION_OPTIONS =
  none:
    in: { from: {}, to: {}, duration: 0, easing: "linear" }
    out: { from: {}, to: {}, duration: 0, easing: "linear" }
  fade:
    in:
      from:
        opacity: "0"
      to:
        opacity: "1"
      duration: 500
      easing: "easeOutCubic"
    out:
      from:
        opacity: "1"
      to:
        opacity: "0"
      duration: 500
      easing: "easeOutCubic"
  slide_left:
    in:
      from:
        left: "100%"
      to:
        left: "0%"
      duration: 500
      easing: "easeOutCubic"
    out:
      from:
        left: "0%"
      to:
        left: "-100%"
      duration: 500
      easing: "easeOutCubic"
  slide_right:
    in:
      from:
        left: "-100%"
      to:
        left: "0%"
      duration: 500
      easing: "easeOutCubic"
    out:
      from:
        left: "0%"
      to:
        left: "100%"
      duration: 500
      easing: "easeOutCubic"

splitRoute = (route) ->
  (route || "").replace(/^\//, "").split("/")

animationOptionsFor = (fromRoute, toRoute) ->
  fromParts = splitRoute(fromRoute)
  toParts = splitRoute(toRoute)
  if fromParts.length < toParts.length
    ANIMATION_OPTIONS.slide_left
  else if toParts.length < fromParts.length
    ANIMATION_OPTIONS.slide_right
  else
    ANIMATION_OPTIONS.fade

$(window).on "popstate", ->
  m.route.animate.options = animationOptionsFor(m.route(), location.pathname)

m.route.animate = (options = {}) ->
  (el, isInitialized, context) ->
    el.addEventListener "click", (e) ->
      e.preventDefault()
      oldRoute = m.route()
      newRoute = el.getAttribute("href")
      m.route.animate.options = ANIMATION_OPTIONS[options.animation] ||
        animationOptionsFor(oldRoute, newRoute)
      m.route(newRoute)
      document.getElementById("show-sidebar").checked = false

mountWithoutAnimation = m.mount

m.mount = (root, component) ->
  if root == document.querySelector("main")
    outgoing = $(root).children()
    ani = m.route.animate.options || ANIMATION_OPTIONS.none

    page = $("<div>", { class: "page" })
      .appendTo(root)
      .css(ani.in.from)
    outgoing.css(ani.out.from)

    setTimeout ->
      page.transition(ani.in.to, ani.in.duration, ani.in.easing)
      outgoing.transition(ani.out.to, ani.out.duration, ani.out.easing)
        .each ->
          setTimeout =>
            m.mount(this, null)
            $(this).remove()
          , ani.out.duration
    mountWithoutAnimation(page[0], component)
  else
    mountWithoutAnimation(root, component)
