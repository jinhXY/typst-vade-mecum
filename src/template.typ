#import "@preview/big-todo:0.2.0": *
#import "@preview/itemize:0.2.0" as itemize
#import "settings.typ": *
#import "coding.typ": *
#import "math.typ": *
#import "utils.typ": *

#let default-conf(doc, opts) = {
    set text(
        font: opts.font,
        lang: opts.lang,
        size: opts.font-size,
    )

    set par(justify: opts.justify)
    set heading(numbering: opts.heading-numbering)
    set page(
        numbering: opts.page-numbering,
        number-align: opts.page-number-alignment,
    )
    set list(indent: opts.bullet-point-indent)
    set enum(indent: opts.bullet-point-indent)

    // Tracks whether we're currently in an outline, to prevent
    // our styling to affect outlines too
    let in-outline = state("in-outline", false)
    show outline: it => {
        in-outline.update(true)
        it
        in-outline.update(false)
    }

    // Hydra settings
    set page(
        margin: opts.hydra-margins,
        header: context {
            import "@preview/hydra:0.6.3": hydra
            let h1 = hydra(1)
            let h2 = hydra(2)

            // Check if empty to avoid random lines appearing when hydra is not used
            if not is-content-empty(h1) or not is-content-empty(h2) {
                [#h1 #h(1fr) #h2]
                line(length: 100%)
            }
        },
    ) if opts.use-hydra

    show heading.where(level: 1): it => if opts.use-hydra {
        pagebreak(weak: true) + it
    } else { it }

    // Link styling (both the web and internally)
    show link: it => {
        // We use the default one in outline
        if in-outline.get() { return it }

        if type(it.dest) != str {
            text(it, fill: red)
        } else {
            set text(blue)
            underline(it)
        }
    }

    // Attach each figure with its numbering pattern. This allows it
    // to be recovered in other places (like the outline) when the
    // numbering function depends on the location (like dependent-numbering).
    // Otherwise, the numbering could evaluate to an incorrect value if the
    // access to the numbering is not in the same location as when it was numbered.
    show figure: it => {
        context [
            #metadata(
                if it.numbering != none {
                    numbering(
                        it.numbering,
                        ..it.counter.at(it.location()),
                    )
                } else { none },
            ) <rendered-figure-number>
        ]
        it
    }

    // Reference styling
    show ref: it => {
        let elem = it.element
        if elem == none { return it }

        if elem.func() == metadata or elem.func() == math.equation {
            // Numbered math equations. Display the equation number
            link(elem.location(), numbering(
                elem.numbering,
                ..counter(math.equation).at(elem.location()),
            ))
        } else {
            // Default behavior
            link(elem.location(), it)
        }
    }

    // Fixes from Itemize
    show: itemize.default-enum-list
    show: itemize.config.ref

    doc
}

#let template-conf(doc, opts) = {
    show: doc => default-conf(doc, opts)
    show: doc => code-conf(doc, opts)
    show: doc => math-conf(doc, opts)

    doc
}

// Main template function that is called by the user.
//
// Usage: `#show: template`
#let template(doc) = e.get(
    get => template-conf(doc, get(settings)),
)
