#import "/src/settings.typ": settings
#import "@preview/elembic:1.1.1" as e

#e.get(get => {
    let s = get(settings)

    assert.eq(type(s), dictionary)

    // Default conf
    assert.eq(s.lang, "en")
    assert.eq(s.font, "Linux Libertine O")
    assert.eq(s.font-size, 12pt)
    assert.eq(s.heading-numbering, "1.1.")
    assert.eq(s.page-numbering, "1")
    assert.eq(s.page-number-alignment, center)
    assert.eq(s.bullet-point-indent, 1em)
    assert.eq(s.use-hydra, false)
    assert.eq(s.hydra-margins, (top: 8em))
    assert.eq(s.justify, true)

    // Code conf
    assert.eq(s.code-font, "FiraCode Nerd Font")
    assert.eq(s.code-font-size, 9pt)
    assert.eq(s.code-bg-color, rgb("#F6F8FA"))
    assert.eq(type(s.codly-config), arguments)
    assert.eq(s.codly-config.at("zebra-fill", default: auto), none)
    assert.eq(type(s.syntax-theme), path)

    // Math conf
    assert.eq(s.math-font, "Erewhon Math")
    assert.eq(s.math-counter-levels, 0)
    assert.eq(s.math-numbering, "1.1")

    // Every documented field is present and nothing was silently dropped.
    let expected = (
        "lang",
        "font",
        "font-size",
        "heading-numbering",
        "page-numbering",
        "page-number-alignment",
        "bullet-point-indent",
        "use-hydra",
        "hydra-margins",
        "justify",
        "code-font",
        "code-font-size",
        "code-bg-color",
        "codly-config",
        "syntax-theme",
        "math-font",
        "math-counter-levels",
        "math-numbering",
    )
    for name in expected {
        assert(name in s, message: "missing settings field: " + name)
    }
    assert.eq(s.keys().len(), expected.len(), message: "unexpected extra settings field")
})
