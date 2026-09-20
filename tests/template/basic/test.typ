#import "/src/template.typ": *

// Avoids warnings because of unknown fonts
#show: e.set_(
    settings,
    math-font: "New Computer Modern Math",
    code-font: "DejaVu Sans Mono",
    font: "Libertinus Serif",
)

#show: template

= Introduction

Ordinary paragraph text with *bold*, _emphasis_, `inline code`, a #link("https://typst.app")[web
    link] and an #link(<target>)[internal link].

- a bullet
- another bullet
    - nested

+ first
+ second

== A subsection <target>

#def[Group][A set with an associative operation.]

#theorem[Lagrange][
    The order of a subgroup divides the order of the group.

    #proof[][Partition into cosets.]
]


#notation[][We write $e$ for the identity.]

#remark[][Abelian is the commutative case.]

$ sum_(i = 1)^n i = (n (n + 1)) / 2 $

$ forall x in RR, exists n in NN quad suchthat quad n > x $

```rust
fn main() {
    println!("hello");
}
```

#figure(
    table(
        columns: 2,
        [a], [b],
        [c], [d],
    ),
    caption: [A plain table],
) <tab>

= Second section

#lorem(30)

// --- the document-level settings really took effect -------------------------
#context {
    let headings = query(heading)
    assert(headings.len() >= 3)
    assert.eq(
        headings.first().numbering,
        "1.1.",
        message: "heading numbering should come from the settings",
    )
    assert.eq(headings.first().level, 1)
}

// Both the built-in and the frame figures are present.
#context {
    assert.eq(query(<tab>).first().func(), figure)
    assert.eq(query(figure.where(kind: "definition")).len(), 1)
    assert.eq(query(figure.where(kind: "theorem")).len(), 1)
    assert.eq(query(figure.where(kind: "proof")).len(), 1)
}
