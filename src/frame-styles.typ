#import "@preview/frame-it:2.0.0": frame-style
#import "@preview/headcount:0.1.0": dependent-numbering, reset-counter

/// Frame style that adds pre and post content around the given style.
#let pre-post-style(
    /// The content to add before the frame.
    /// It can be either a fixed content or a function with the same
    /// signature as the style function:
    /// `(title, tags, body, supplement, number, arg) => content` -> content | function | none
    pre_content,
    /// The frame style to wrap. It should have the signature
    /// `(title, tags, body, supplement, number, arg) => content` -> function
    style,
    /// The content to add after the frame.
    /// It can be either a fixed content or a function with the same
    /// signature as the style function:
    /// `(title, tags, body, supplement, number, arg) => content` -> content | function | none
    post_content,
) = {
    (title, tags, body, supplement, number, arg) => [
        #if type(pre_content) == function {
            pre_content(title, tags, body, supplement, number, arg)
        } else {
            pre_content
        }

        #style(title, tags, body, supplement, number, arg)

        #if type(post_content) == function {
            post_content(title, tags, body, supplement, number, arg)
        } else {
            post_content
        }
    ]
}

/// No-frame style that omits the title.
#let hidden-no-title(title, tags, body, supplement, number, arg) = {
    align(left)[*#supplement #number:* #body]
}

/// No-frame style that only shows the supplement
#let hidden-sup-only(title, tags, body, supplement, number, arg) = {
    align(left)[*#supplement:* #body]
}

/// No-frame style that shows all attributes
#let hidden(title, tags, body, supplement, number, arg) = {
    align(left)[
        *#supplement #number: #title*

        #body
    ]
}

/// Setup environment for figures using frame-it
///
/// -> none
#let setup-frame-environment(
    /// The document content to configure. -> content
    doc,
    /// The kind of figure to configure. -> str
    kind,
    /// The frame style to apply.
    /// It should have the signature `(title, tags, body, supplement, number, arg) -> content`.
    /// -> function
    style,
    /// The numbering scheme to use for the figure.
    /// If `none`, no numbering is applied. -> function | none
    numbering: "1.1",
    /// The number of levels to use for dependent numbering.
    /// If `numbering` is `none`, this is ignored. -> int
    levels: 0,
    /// Whether the figure should be breakable across pages. -> bool
    breakable: true,
    /// The alignment of the figure content. Options are `left`, `center`, `right`. -> enum
    alignment: left,
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
