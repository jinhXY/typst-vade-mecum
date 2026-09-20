#import "/src/frame-styles.typ": hidden, setup-frame-environment
#import "@preview/frame-it:2.0.0": frame

#let note = frame("Note", blue, kind: "note")
#let plain = frame("Plain", gray, kind: "plain")

#set heading(numbering: "1.")

// Numbered, tied to level-1 headings.
#show: doc => setup-frame-environment(doc, "note", hidden, numbering: "1.1", levels: 1)
// Unnumbered.
#show: doc => setup-frame-environment(doc, "plain", hidden, numbering: none)

= First section

#note[A][first] <n1>
#note[B][second] <n2>

= Second section

#note[C][third] <n3>

#plain[D][unnumbered] <p1>

// --- the frame counter restarts at every heading ----------------------------
#context {
    let c = counter(figure.where(kind: "note"))
    assert.eq(c.at(query(<n1>).first().location()), (1,))
    assert.eq(c.at(query(<n2>).first().location()), (2,))
    assert.eq(
        c.at(query(<n3>).first().location()),
        (1,),
        message: "the counter should reset at each heading",
    )
}

// --- numbering: none really disables numbering ------------------------------
#context {
    assert.eq(
        query(<p1>).first().numbering,
        none,
        message: "frames set up with numbering: none must not be numbered",
    )
    assert.ne(query(<n1>).first().numbering, none)
}

// --- the frames really are figures of the requested kind --------------------
#context {
    assert.eq(query(<n1>).first().func(), figure)
    assert.eq(query(<n1>).first().kind, "note")
    assert.eq(query(<n1>).first().supplement, [Note])
    assert.eq(query(figure.where(kind: "note")).len(), 3)
    assert.eq(query(figure.where(kind: "plain")).len(), 1)
}
