#import "frame-styles.typ": *
#import "@preview/frame-it:2.0.0": frame, styles

// Not overly exaggerated calligraphy for math script letters
#let scr(it) = text(font: "New Computer Modern Math", $cal(it)$)

// Notation for double-struck letters
#let AA = $bb(A)$
#let BB = $bb(B)$
#let CC = $bb(C)$
#let DD = $bb(D)$
#let EE = $bb(E)$
#let FF = $bb(F)$
#let GG = $bb(G)$
#let HH = $bb(H)$
#let II = $bb(I)$
#let JJ = $bb(J)$
#let KK = $bb(K)$
#let LL = $bb(L)$
#let MM = $bb(M)$
#let NN = $bb(N)$
#let OO = $bb(O)$
#let PP = $bb(P)$
#let QQ = $bb(Q)$
#let RR = $bb(R)$
#let SS = $bb(S)$
#let TT = $bb(T)$
#let UU = $bb(U)$
#let VV = $bb(V)$
#let WW = $bb(W)$
#let XX = $bb(X)$
#let YY = $bb(Y)$
#let ZZ = $bb(Z)$

// Add some spaces around some math symbols
#let add_space(it, before, after) = { [#h(before, weak: true) #it #h(after, weak: true)] }

// Custom "such that" symbol
#let suchthat = add_space(sym.slash.big, 0.5em, 0.5em)

// Skewed fractions
#let sfrac(expr) = {
    set math.frac(style: "skewed")
    expr
}

// Horizontal fractions
#let hfrac(expr) = {
    set math.frac(style: "horizontal")
    expr
}

// Math frame definitions
#let def = frame("Definition", green, kind: "definition")
#let example = frame("Example", gray, kind: "example")
#let theorem = frame("Theorem", blue, kind: "theorem")
#let lemma = frame("Lemma", teal, kind: "lemma")
#let notation = frame("Notation", purple, kind: "notation")
#let remark = frame("Remark", orange, kind: "remark")
#let proof = frame("Proof", black, kind: "proof")

#let math-conf(doc, opts) = {
    show math.equation: set text(font: opts.math-font)

    // Breakable equations
    show math.equation: set block(breakable: true)

    // Common math symbol tweaks
    show sym.supset: sym.supset.eq
    show sym.supset.not: sym.supset.not.eq
    show sym.subset: sym.subset.eq
    show sym.subset.not: sym.subset.not.eq
    show sym.forall: add_space(sym.forall, 0.5em, 0.0em)
    show sym.exists: add_space(sym.exists, 0.5em, 0.0em)
    show sym.arrow.r.double.long: add_space(sym.arrow.r.double.long, 0.6em, 0.6em)
    set math.stretch(size: 150%)

    // Math frame styles
    show: doc => setup-frame-environment(
        doc,
        "definition",
        styles.thmbox,
        numbering: opts.math-numbering,
        levels: opts.math-counter-levels,
        breakable: false,
    )
    show: doc => setup-frame-environment(
        doc,
        "example",
        styles.thmbox,
        numbering: opts.math-numbering,
        levels: opts.math-counter-levels,
        breakable: true,
    )
    show: doc => setup-frame-environment(
        doc,
        "theorem",
        styles.thmbox,
        numbering: opts.math-numbering,
        levels: opts.math-counter-levels,
        breakable: true,
    )
    show: doc => setup-frame-environment(
        doc,
        "lemma",
        styles.thmbox,
        numbering: opts.math-numbering,
        levels: opts.math-counter-levels,
        breakable: true,
    )
    show: doc => setup-frame-environment(
        doc,
        "notation",
        hidden-sup-only,
        numbering: none,
        levels: opts.math-counter-levels,
        breakable: false,
        alignment: left,
    )
    show: doc => setup-frame-environment(
        doc,
        "remark",
        hidden-no-title,
        numbering: opts.math-numbering,
        levels: opts.math-counter-levels,
        breakable: true,
        alignment: left,
    )
    show: doc => setup-frame-environment(
        doc,
        "proof",
        (title, tags, body, supplement, number, arg) => {
            body = body + [#h(1fr) $square$]
            (styles.thmbox)(title, tags, body, supplement, number, arg)
        },
        numbering: none,
        levels: opts.math-counter-levels,
        breakable: true,
    )

    doc
}
