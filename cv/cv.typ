// PDF CV built from data/cv.yml and data/publications.yml.
// Build (from the repo root):
//   quarto typst compile --root . cv/cv.typ assets/cv/Xingyao_CV.pdf
// `quarto render` runs this automatically (see cv/build-cv.ts).
// Keep the reference formatting in sync with _publications.ejs.

#let cv = yaml("/data/cv.yml")
#let pubs = yaml("/data/publications.yml")
#let me = "Xiao, X."
#let accent = rgb("#1a5276")

#set document(title: cv.name + " - CV", author: cv.name)
#set page(paper: "a4", margin: (x: 2cm, y: 1.8cm), numbering: "1 / 1",
  number-align: right)
#set text(font: ("Charter", "Libertinus Serif"), size: 10pt, lang: "en")
#set par(justify: false, leading: 0.55em, spacing: 0.75em)
#show link: set text(fill: accent)

// ---- helpers ---------------------------------------------------------------

#let str-of(x) = if type(x) == str { x } else { str(x) }
#let has(it, k) = k in it and it.at(k) != none and str-of(it.at(k)) != ""

#let author-list(authors) = {
  for (i, a) in authors.enumerate() {
    if i > 0 {
      if authors.at(i - 1) == "…" { [ ] }
      else if i == authors.len() - 1 { [, & ] }
      else { [, ] }
    }
    if a == me { strong(a) } else { a }
  }
}

#let ends-punct(s) = s.ends-with(".") or s.ends-with("?") or s.ends-with("!")

// One APA reference; same rules as _publications.ejs.
#let reference(it) = {
  author-list(it.authors)
  [ (#str-of(it.year)). ]
  let title = str-of(it.title)
  if it.at("type", default: none) == "preprint" { emph(title) } else { title }
  if not ends-punct(title) { [.] }
  let src = ()
  if has(it, "venue_pre") { src.push(it.venue_pre + " ") }
  if has(it, "venue") {
    let v = if has(it, "volume") { it.venue + ", " + str-of(it.volume) } else { it.venue }
    src.push(if it.at("type", default: none) == "preprint" { v } else { emph(v) })
  }
  if has(it, "issue") { src.push("(" + str-of(it.issue) + ")") }
  if has(it, "pages") { src.push(", " + str-of(it.pages)) }
  if has(it, "venue_post") { src.push(" " + it.venue_post) }
  else if src.len() > 0 { src.push(".") }
  if src.len() > 0 { [ ] + src.join() }
  if has(it, "where") { [ ] + it.where }
  if has(it, "note") { [ ] + it.note }
  if has(it, "doi") {
    let u = "https://doi.org/" + it.doi
    [ ] + link(u, u)
  } else if has(it, "url") { [ ] + link(it.url, it.url) }
}

#let ref-block(it) = block(above: 0pt, below: 0.55em, par(hanging-indent: 1.5em, reference(it)))
#let refs(items) = for it in items { ref-block(it) }

#let section(title) = {
  block(above: 1.4em, below: 0.6em, sticky: true, {
    text(size: 10.5pt, weight: "bold", fill: accent, tracking: 0.06em, upper(title))
    v(-0.55em)
    line(length: 100%, stroke: 0.5pt + accent)
  })
}

#let subsection(title) = block(above: 0.8em, below: 0.5em, sticky: true, text(weight: "bold", title))

#let entry(e) = block(below: 0.75em, breakable: false, {
  grid(columns: (1fr, auto), column-gutter: 1em,
    strong(e.title), text(size: 9pt, e.dates))
  v(-0.35em)
  emph(e.org)
  if "bullets" in e and e.bullets != none {
    set list(indent: 0.6em, body-indent: 0.5em, spacing: 0.4em)
    v(-0.2em)
    for b in e.bullets { list.item(b) }
  }
})

// ---- document --------------------------------------------------------------

#align(center)[
  #text(size: 20pt, weight: "bold", upper(cv.name))
  #v(-0.4em)
  #text(size: 9.5pt, cv.contact.map(c =>
    if "url" in c { link(c.url, c.text) } else { c.text }
  ).join[ #h(0.3em)|#h(0.3em) ])
]

#section("Research Interests")
#cv.interests

#section("Education")
#for e in cv.education { entry(e) }

#section("Research Experience")
#for e in cv.experience { entry(e) }

#section("Publications")
#let pub-groups = (
  ("journal", "Peer-Reviewed Journal Articles"),
  ("chapter", "Book Chapters & Technical Reports"),
  ("preprint", "Preprints"),
  ("review", "Under Review / In Preparation"),
)
#for (t, label) in pub-groups {
  let items = pubs.filter(p => p.type == t)
  if items.len() > 0 {
    subsection(label)
    refs(items)
  }
}

#section("Presentations")
#for g in cv.talks {
  subsection(g.group)
  refs(g.items)
}

#section("Teaching Experience")
#for t in cv.teaching {
  block(below: 0.6em, {
    strong(t.org)
    set list(indent: 0.6em, body-indent: 0.5em, spacing: 0.4em)
    for c in t.courses { list.item(c) }
  })
}

#section("Awards & Grants")
#{
  set list(indent: 0.6em, body-indent: 0.5em, spacing: 0.5em)
  for a in cv.awards { list.item(a) }
}

#section("Professional Service")
#{
  set list(indent: 0.6em, body-indent: 0.5em, spacing: 0.5em)
  for s in cv.service { list.item(s) }
}

#section("Technical Skills")
#for s in cv.skills [
  #strong(s.label + ":") #s.text \
]
