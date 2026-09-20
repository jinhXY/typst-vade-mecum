#import "/src/utils.typ": is-content-empty, is-content-non-empty

// --- is-content-empty -------------------------------------------------------

#assert(is-content-empty(none), message: "none has no children")
#assert(is-content-empty([]), message: "empty content has no children")

#assert(not is-content-empty([a *b*]), message: "a sequence of children is not empty")
#assert(not is-content-empty([#h(1fr) tail]), message: "spacing + text is not empty")
#assert(not is-content-empty([one #linebreak() two]))
#assert(not is-content-empty([abc]), message: "single text element has no children field")
#assert(not is-content-empty([*bold*]), message: "single strong element has no children field")

// --- is-content-non-empty ---------------------------------------------------

#assert(not is-content-non-empty(none))
#assert(not is-content-non-empty([]))
#assert(not is-content-non-empty(""))

#assert(is-content-non-empty([abc]))
#assert(is-content-non-empty("abc"))
#assert(is-content-non-empty([ ]), message: "whitespace counts as content")
