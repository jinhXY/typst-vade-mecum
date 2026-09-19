#import "@preview/big-todo:0.2.0": *
#import "@preview/itemize:0.2.0" as itemize
#import "settings.typ": *
#import "coding.typ": *
#import "math.typ": *

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
            import "@preview/hydra:0.6.2": hydra
            let h1 = hydra(1)
            let h2 = hydra(2)

            // Check if empty to avoid random lines appearing when hydra is not used
            if not is_content_empty(h1) or not is_content_empty(h2) {
                [#h1 #h(1fr) #h2]
                line(length: 100%)
            }
        },
    ) if opts.use-hydra

    show heading.where(level: 1): it => {
        if opts.use-hydra and not in-outline.get() {
            pagebreak(weak: true) + it
        } else {
            it
        }
    }

    // Link styling (both the web and internally)
    show link: it => {
        if in-outline.get() {
            return it
        }

        if type(it.dest) != str {
            text(it, fill: red)
        } else {
            set text(blue)
            underline(it)
        }
    }

    // Outline styling
    show outline.entry.where(level: 1): it => {
        v(12pt, weak: true)
        strong(it)
    }
    set outline.entry(fill: line(length: 100%, stroke: .2pt + gray))

    // Figure outline styling
    show outline.entry: it => {
        // use native behavior for non-figures
        if it.element.func() != figure { return it }
        // we display just the counter, no supplement
        context {
            let numbers = it.element.counter.at(it.element.location())
            let numbered = numbering(it.element.numbering, ..numbers)

            link(
                it.element.location(),
                it.indented(numbered + ".", it.inner()),
            )
        }
    }

    // Reference styling
    show ref: it => {
        let elem = it.element
        if elem == none { return it }

        if elem.func() == metadata and elem.func() == math.equation {
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
    show: doc => math_conf(doc, opts)

    doc
}

// Main template function that is called by the user.
//
// Usage: `#show: template`
#let template(doc) = e.get(
    get => template-conf(doc, get(settings)),
)
