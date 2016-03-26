ANIMATION_OPTIONS =
  NONE:
    in: { from: {}, to: {}, duration: 0, easing: "linear" }
    out: { from: {}, to: {}, duration: 0, easing: "linear" }
  FADE:
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

m.route.animate = (options = {}) ->
  (el, isInitialized, context) ->
    el.addEventListener "click", (e) ->
      e.preventDefault()
      m.route.animate.options = ANIMATION_OPTIONS.FADE
      m.route(el.getAttribute("href"))
      document.getElementById("show-sidebar").checked = false

mountWithoutAnimation = m.mount

m.mount = (root, component) ->
  if root == document.querySelector("main")
    outgoing = $(root).children()
    ani = m.route.animate.options || ANIMATION_OPTIONS.NONE

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
