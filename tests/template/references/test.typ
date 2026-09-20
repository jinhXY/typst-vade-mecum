#import "/src/template.typ": *

// Avoids warnings because of unknown fonts
#show: e.set_(
    settings,
    math-font: "New Computer Modern Math",
    code-font: "DejaVu Sans Mono",
    font: "Libertinus Serif",
)
#show: template
#set math.equation(numbering: "(1)")

= First section <sec>

== A subsection <sub>

#def[Group][A set with an associative operation.] <grp>

#theorem[Lagrange][Subgroup orders divide group orders.] <lag>

#figure(
    table(
        columns: 2,
        [a], [b],
    ),
    caption: [A table],
) <tab>

$ a^2 + b^2 = c^2 $ <pyth>

= References

Heading: @sec and @sub.

Frames: @grp and @lag.

Figure: @tab.

Equation: @pyth.

// --- every reference resolves to the expected element ------------------------
#context {
    assert.eq(query(<sec>).first().func(), heading)
    assert.eq(query(<grp>).first().kind, "definition")
    assert.eq(query(<lag>).first().kind, "theorem")
    assert.eq(query(<tab>).first().func(), figure)
    assert.eq(query(<pyth>).first().func(), math.equation)

    // The equation is numbered, so a reference to it has something to show.
    assert.eq(query(<pyth>).first().numbering, "(1)")
}

// NOTE: the `show ref` rule contains a branch guarded by
//   elem.func() == metadata and elem.func() == math.equation
// which can never be true, so equation references always fall through to the
// default branch. This test only pins down that references keep working; if
// the condition is ever fixed to `or`, the rendered output changes.
