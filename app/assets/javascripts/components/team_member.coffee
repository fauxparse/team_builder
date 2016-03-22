class TeamMember extends App.Components.Section
  constructor: (props) ->
    @member = m.prop()
    App.Models.Member.fetch(m.route.param("id")).then(@member)

  view: ->
    klass = "team-member"
    m("section", { class: klass },
      m.component(App.Components.Header, title: => @member()?.name()),
      m("div", { class: "team-member-inner", config: @setupScrolling.bind(this) }
        m("p", "In the vignettes and other embellishments of some ancient books you will at times meet with very curious touches at the whale, where all manner of spouts, jets d'eau, hot springs and cold, Saratoga and Baden-Baden, come bubbling up from his unexhausted brain. In the title-page of the original edition of the 'Advancement of Learning' you will find some curious whales.")
        m("p", "But quitting all these unprofessional attempts, let us glance at those pictures of leviathan purporting to be sober, scientific delineations, by those who know. In old Harris's collection of voyages there are some plates of whales extracted from a Dutch book of voyages, A.D. 1671, entitled 'A Whaling Voyage to Spitzbergen in the ship Jonas in the Whale, Peter Peterson of Friesland, master.' In one of those plates the whales, like great rafts of logs, are represented lying among ice-isles, with white bears running over their living backs. In another plate, the prodigious blunder is made of representing the whale with perpendicular flukes.")
        m("p", "Then again, there is an imposing quarto, written by one Captain Colnett, a Post Captain in the English navy, entitled 'A Voyage round Cape Horn into the South Seas, for the purpose of extending the Spermaceti Whale Fisheries.' In this book is an outline purporting to be a 'Picture of a Physeter or Spermaceti whale, drawn by scale from one killed on the coast of Mexico, August, 1793, and hoisted on deck.' I doubt not the captain had this veracious picture taken for the benefit of his marines. To mention but one thing about it, let me say that it has an eye which applied, according to the accompanying scale, to a full grown sperm whale, would make the eye of that whale a bow-window some five feet long. Ah, my gallant captain, why did ye not give us Jonah looking out of that eye!")
        m("p", "Nor are the most conscientious compilations of Natural History for the benefit of the young and tender, free from the same heinousness of mistake. Look at that popular work 'Goldsmith's Animated Nature.' In the abridged London edition of 1807, there are plates of an alleged 'whale' and a 'narwhale.' I do not wish to seem inelegant, but this unsightly whale looks much like an amputated sow; and, as for the narwhale, one glimpse at it is enough to amaze one, that in this nineteenth century such a hippogriff could be palmed for genuine upon any intelligent public of schoolboys.")
        m("p", "Then, again, in 1825, Bernard Germain, Count de Lacepede, a great naturalist, published a scientific systemized whale book, wherein are several pictures of the different species of the Leviathan. All these are not only incorrect, but the picture of the Mysticetus or Greenland whale (that is to say, the Right whale), even Scoresby, a long experienced man as touching that species, declares not to have its counterpart in nature.")
        m("p", "But the placing of the cap-sheaf to all this blundering business was reserved for the scientific Frederick Cuvier, brother to the famous Baron. In 1836, he published a Natural History of Whales, in which he gives what he calls a picture of the Sperm Whale. Before showing that picture to any Nantucketer, you had best provide for your summary retreat from Nantucket. In a word, Frederick Cuvier's Sperm Whale is not a Sperm Whale, but a squash. Of course, he never had the benefit of a whaling voyage (such men seldom have), but whence he derived that picture, who can tell? Perhaps he got it as his scientific predecessor in the same field, Desmarest, got one of his authentic abortions; that is, from a Chinese drawing. And what sort of lively lads with the pencil those Chinese are, many queer cups and saucers inform us.")
        m("p", "As for the sign-painters' whales seen in the streets hanging over the shops of oil-dealers, what shall be said of them? They are generally Richard III. whales, with dromedary humps, and very savage; breakfasting on three or four sailor tarts, that is whaleboats full of mariners: their deformities floundering in seas of blood and blue paint.")
        m("p", "But these manifold mistakes in depicting the whale are not so very surprising after all. Consider! Most of the scientific drawings have been taken from the stranded fish; and these are about as correct as a drawing of a wrecked ship, with broken back, would correctly represent the noble animal itself in all its undashed pride of hull and spars. Though elephants have stood for their full-lengths, the living Leviathan has never yet fairly floated himself for his portrait. The living whale, in his full majesty and significance, is only to be seen at sea in unfathomable waters; and afloat the vast bulk of him is out of sight, like a launched line-of-battle ship; and out of that element it is a thing eternally impossible for mortal man to hoist him bodily into the air, so as to preserve all his mighty swells and undulations. And, not to speak of the highly presumable difference of contour between a young sucking whale and a full-grown Platonian Leviathan; yet, even in the case of one of those young sucking whales hoisted to a ship's deck, such is then the outlandish, eel-like, limbered, varying shape of him, that his precise expression the devil himself could not catch.")
      )
    )

  setupScrolling: (el) =>
    @scrollable = el
    @header = $(el).prev("header")
    @headerHeight = @header.outerHeight()
    el.addEventListener("scroll", @onscroll.bind(this), true)

  onscroll: (e) =>
    if e.target == @scrollable
      @header.css("max-height", @headerHeight - e.target.scrollTop)

App.Components.TeamMember =
  controller: (args...) ->
    new TeamMember(args...)

  view: (controller) ->
    controller.view()
