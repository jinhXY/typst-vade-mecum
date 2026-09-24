#import "/src/settings.typ": settings
#import "@preview/elembic:1.1.1" as e

// --- a scoped override only applies inside its block ------------------------
#{
    show: e.set_(settings, font-size: 14pt, lang: "fr")
    e.get(get => {
        let s = get(settings)
        assert.eq(s.font-size, 14pt)
        assert.eq(s.lang, "fr")
        // Untouched fields keep their defaults.
        assert.eq(s.font, ("Linux Libertine O", "Libertinus Serif"))
        assert.eq(s.use-hydra, false)
    })
}

// Outside the block the defaults are back.
#e.get(get => {
    assert.eq(get(settings).font-size, 12pt)
    assert.eq(get(settings).lang, "en")
})

// --- a document-wide override -----------------------------------------------
#show: e.set_(
    settings,
    use-hydra: true,
    justify: false,
    math-numbering: none,
    math-counter-levels: 2,
    codly-config: arguments(zebra-fill: none, number-format: none),
    heading-numbering: "I.1.",
)

#e.get(get => {
    let s = get(settings)
    assert.eq(s.use-hydra, true)
    assert.eq(s.justify, false)
    assert.eq(s.math-counter-levels, 2)
    assert.eq(s.heading-numbering, "I.1.")

    // `math-numbering` is declared as an option, so `none` is a legal value.
    assert.eq(s.math-numbering, none)

    // `arguments` fields are replaced wholesale, not merged.
    assert.eq(s.codly-config.at("number-format", default: auto), none)
})

// --- union-typed fields accept either member --------------------------------
#{
    show: e.set_(settings, heading-numbering: (..n) => "S" + str(n.pos().last()))
    e.get(get => assert.eq(type(get(settings).heading-numbering), function))
}
#{
    show: e.set_(settings, hydra-margins: (top: 4em, bottom: 2em))
    e.get(get => assert.eq(get(settings).hydra-margins, (top: 4em, bottom: 2em)))
}
