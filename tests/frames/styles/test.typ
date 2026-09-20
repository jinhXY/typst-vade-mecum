#import "/src/frame-styles.typ": hidden, hidden-no-title, hidden-sup-only, pre-post-style
#import "@preview/frame-it:2.0.0": frame

// --- the style functions can be called directly -----------------------------
// Every style has the signature (title, tags, body, supplement, number, arg).

#let call(style) = style([Title], (), [Body], [Lemma], [1.2], none)

#assert.eq(type(call(hidden)), content)
#assert.eq(type(call(hidden-no-title)), content)
#assert.eq(type(call(hidden-sup-only)), content)

// All of them are left-aligned.
#assert.eq(call(hidden).func(), align)
#assert.eq(call(hidden).alignment, left)
#assert.eq(call(hidden-no-title).alignment, left)
#assert.eq(call(hidden-sup-only).alignment, left)

// --- pre-post-style ---------------------------------------------------------
// It wraps an existing style and returns a new style with the same signature.

#let wrapped = pre-post-style([PRE], hidden-sup-only, [POST])
#assert.eq(type(wrapped), function)
#assert.eq(type(call(wrapped)), content)

// --- rendering --------------------------------------------------------------

#import "/src/frame-styles.typ": setup-frame-environment

#let note = frame("Note", blue, kind: "note")
#let hint = frame("Hint", orange, kind: "hint")
#let tip = frame("Tip", green, kind: "tip")

#show: doc => setup-frame-environment(doc, "note", hidden, alignment: left)
#show: doc => setup-frame-environment(doc, "hint", hidden-no-title, alignment: left)
#show: doc => setup-frame-environment(
    doc,
    "tip",
    pre-post-style([-- before --], hidden-sup-only, [-- after --]),
    alignment: left,
)

= Section

#note[With title][Shows supplement, number and title.]

#hint[Ignored title][Shows supplement and number only.]

#tip[Wrapped in pre/post content.]

// No tag support for these
#note("Titled", [tag-a], [tag-b])[Body with tags.]

#note[][Body without a title.]
