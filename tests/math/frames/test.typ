#import "/src/math.typ": def, example, lemma, math-conf, notation, proof, remark, theorem

#let opts = (
    math-font: "New Computer Modern Math",
    math-numbering: "1.1",
    math-counter-levels: 1,
)

#set heading(numbering: "1.")
#show: doc => math-conf(doc, opts)

= Groups

#def[Group][
    A set $G$ with an associative operation, an identity and inverses.
] <def1>

#notation[][We write $e$ for the identity element.] <not1>

#theorem[Lagrange][
    The order of a subgroup divides the order of the group.

    #proof[][
        Consider the partition into cosets.
    ] <prf1>
] <thm1>


#lemma[][Every subgroup contains the identity.] <lem1>

#example[][$ZZ$ under addition is a group.] <ex1>

#remark[][Abelian groups are the commutative case.] <rem1>

= Rings

#def[Ring][A set with two operations.] <def2>

// --- every environment produces a figure of its own kind --------------------
#context {
    let expected = (
        (<def1>, "definition", [Definition]),
        (<ex1>, "example", [Example]),
        (<thm1>, "theorem", [Theorem]),
        (<lem1>, "lemma", [Lemma]),
        (<not1>, "notation", [Notation]),
        (<rem1>, "remark", [Remark]),
        (<prf1>, "proof", [Proof]),
    )

    for (label, kind, supplement) in expected {
        let it = query(label).first()
        assert.eq(it.func(), figure, message: kind + " should be a figure")
        assert.eq(it.kind, kind)
        assert.eq(it.supplement, supplement)
    }
}

// --- numbering ---------------------------------------------------------------
#context {
    // Notations and proofs are deliberately unnumbered.
    assert.eq(query(<not1>).first().numbering, none)
    assert.eq(query(<prf1>).first().numbering, none)

    // Everything else is numbered.
    for label in (<def1>, <ex1>, <thm1>, <lem1>, <rem1>) {
        assert.ne(query(label).first().numbering, none)
    }
}

// --- each kind has its own counter, reset per section ------------------------
#context {
    let c = counter(figure.where(kind: "definition"))
    assert.eq(c.at(query(<def1>).first().location()), (1,))
    assert.eq(
        c.at(query(<def2>).first().location()),
        (1,),
        message: "definition counter should restart in the second section",
    )

    // Kinds do not share a counter.
    assert.eq(
        counter(figure.where(kind: "theorem")).at(query(<thm1>).first().location()),
        (1,),
    )
}
