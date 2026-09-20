#import "@preview/codly:1.3.0": *

#let code-conf(doc, opts) = {
    // code font settings
    show raw: set text(font: opts.code-font, size: opts.code-font-size)

    // Codly settings
    if opts.codly-config.at("fill", default: none) == none {
        opts.codly-config = opts.codly-config + arguments(fill: opts.code-bg-color)
    }

    show: codly-init.with()
    codly(
        ..opts.codly-config,
    )

    // File code block settings
    show raw.where(block: false): box.with(
        fill: opts.code-bg-color,
        inset: (x: 2pt),
        outset: (y: 2pt),
        radius: 1.5pt,
    )

    set raw(theme: opts.syntax-theme)

    doc
}
