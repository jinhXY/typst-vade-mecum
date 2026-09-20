#import "/src/template.typ": *

// Avoids warnings because of unknown fonts
#show: e.set_(
    settings,
    math-font: "New Computer Modern Math",
    code-font: "DejaVu Sans Mono",
    font: "Libertinus Serif",
    use-hydra: true,
)
#show: template

= Introduction

#lorem(300)

== A subsection

#lorem(300)

= Second section

#lorem(300)

// --- level-1 headings start a new page when hydra is on ----------------------
#context {
    let pages = query(heading.where(level: 1)).map(it => it.location().page())
    assert.eq(
        pages.len(),
        pages.dedup().len(),
        message: "each level-1 heading should start its own page",
    )
    assert(
        counter(page).final().first() > 1,
        message: "the document should span several pages",
    )
}
