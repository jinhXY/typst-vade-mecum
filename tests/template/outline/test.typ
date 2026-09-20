#import "/src/template.typ": *

// Avoids warnings because of unknown fonts
#show: e.set_(
    settings,
    math-font: "New Computer Modern Math",
    code-font: "DejaVu Sans Mono",
    font: "Libertinus Serif",
)
#show: template

#outline()

#outline(title: [List of tables], target: figure.where(kind: table))

#outline(title: [Definitions], target: figure.where(kind: "definition"))

= First section

#def[Group][A set with an associative operation.]

#figure(
    table(
        columns: 2,
        [a], [b],
    ),
    caption: [First table],
) <t1>

== A subsection

#figure(
    table(
        columns: 1,
        [x],
    ),
    caption: [Second table],
) <t2>

= Second section

#def[Ring][Two operations.]

#lorem(20)

// --- links inside outlines are left alone ------------------------------------
// The link show rule returns early while `in-outline` is set, so outline
// entries must not be underlined/blue like body links.
#context {
    assert(query(heading).len() >= 3)
    assert.eq(query(figure.where(kind: table)).len(), 2)
    assert.eq(query(figure.where(kind: "definition")).len(), 2)
}
