#import "@preview/frame-it:2.0.0": frame-style
#import "@preview/headcount:0.1.0": dependent-numbering, reset-counter

// Frame style that adds pre and post content around the given style.
#let pre-post-style(pre_content, style, post_content) = {
    (title, tags, body, supplement, number, arg) => {
        [
            #pre_content

            #style(title, tags, body, supplement, number, arg)

            #post_content
        ]
    }
}

// No-frame style that omits the title.
#let hidden-no-title(title, tags, body, supplement, number, arg) = {
    align(left)[*#supplement #number:* #body]
}

// No-frame style that only shows the supplement
#let hidden-sup-only(title, tags, body, supplement, number, arg) = {
    align(left)[*#supplement:* #body]
}

// No-frame style that shows all attributes
#let hidden(title, tags, body, supplement, number, arg) = {
    align(left)[
        *#supplement #number: #title*

        #body
    ]
}

/// Setup environment for figures using frame-it
///
/// - doc (content): The document content to configure.
/// - kind (str): The kind of figure to configure.
/// - style (function): The frame style to apply.
/// 	It should have the signature `(title, tags, body, supplement, number, arg) -> content`.
/// - numbering (function | none): The numbering scheme to use for the figure.
/// 	If `none`, no numbering is applied.
/// - levels (int): The number of levels to use for dependent numbering.
/// 	If `numbering` is `none`, this is ignored.
/// - breakable (bool): Whether the figure should be breakable across pages.
/// - alignment (enum): The alignment of the figure content. Options are `left`, `center`, `right`.
/// ->
#let setup-frame-environment(
    doc,
    kind,
    style,
    numbering: "1.1",
    levels: 1,
    breakable: true,
    alignment: center,
) = {
    show: frame-style(kind: kind, style)
    show figure.where(kind: kind): set align(alignment)
    show figure.where(kind: kind): set block(breakable: breakable)

    if numbering != none {
        show figure.where(kind: kind): set figure(
            numbering: dependent-numbering(
                numbering,
                levels: levels,
            ),
        )
        show heading: reset-counter(counter(figure.where(kind: kind)))

        doc
    } else {
        show figure.where(kind: kind): set figure(numbering: none)
        doc
    }
}
