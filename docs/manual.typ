#import "/src/template.typ": *
#import "@preview/tidy:0.4.3" as tidy

#show: e.set_(
    settings,
    use-hydra: true,
)

#show: template

#align(center, text(20pt)[*Vade Mecum User Guide*])

#advanced-outline(
    title: none,
    max_bold_headings_level: 1,
    targets: (heading, figure.where(kind: "setting")),
)

#pagebreak()
= Getting started
== Setting up
To get started, you can use the following snippet in your document:

```typ
#import "@local/vade-mecum:0.1.0": *

#show: e.set_(
    settings,
    // Configuration options are set here
    font: "Fira Sans",
    heading-numbering: "1.",
    code-font-size: 12pt,
    justify: false,
    // etc.
)

#show: template
```

== Features

This package is a personal all-in-one Typst template, with the following features:
- Configurable basic settings. See @settings for a list of available settings.
- Opinionated Hydra integration for section headings in page headers.
- Styling for certain Typst elements, including links, outlines, math symbols and references.
- Includes #link("https://typst.app/universe/package/itemize")[Itemize]'s list/enum fixes and
    referencing (which is #link("https://github.com/typst/typst/issues/779")[still not possible in
        Typst])
- Includes #link("https://typst.app/universe/package/big-todo/")[big-todo] for #todo(
        inline: true,
    )[notes] in the document.
- Uses #link("https://typst.app/universe/package/codly/")[Codly] with opinionated defaults for code
    blocks.
- A bunch of utility functions. See @utilities for a list of available functions.
- A bunch of shorthand math symbols. See @math-symbols for a list of available symbols.
- Environments for math use cases, using #link(
        "https://typst.app/universe/package/frame-it/",
    )[frame-it] See @math-environments for more information.
- Utilities for building custom #link(
        "https://typst.app/universe/package/frame-it/",
    )[frame-it] frames. See @custom-environments for an example, and see @frame-styles for the
    reference.
- A function `advanced-outline` for building more advanced outlines that are better integrated with
    the other features of this package.

= Available settings <settings>

#let setting = frame("", blue, kind: "setting")
#show: doc => setup-frame-environment(
    doc,
    "setting",
    styles.thmbox,
    numbering: "1.1",
    levels: 1,
    breakable: false,
)

#let data = e.data(settings)
#let boxes = data.fields.optional-named-fields.map(f => setting[#raw(f.name)][
    *Type:* #f.typeinfo.name \
    #f.doc \
    *Default value:* #f.default
])
#for box in boxes { box }

= Utilities <utilities>

This section acts as a reference for the utility functions provided by this package.

== Functions
#[
    // Headings for function names should be level 3 here
    #show selector.or(
        heading.where(level: 4),
        heading.where(level: 5),
    ): set heading(numbering: none, outlined: false)
    #let util_docs = tidy.parse-module(read("../src/utils.typ"))

    #tidy.show-module(
        util_docs,
        style: tidy.styles.default,
        show-outline: false,
    )
]


#pagebreak(weak: true)
== Custom frame utilities <frame-styles>

#[
    // Headings for function names should be level 3 here
    #show selector.or(
        heading.where(level: 4),
        heading.where(level: 5),
    ): set heading(numbering: none, outlined: false)
    #let util_docs = tidy.parse-module(read("../src/frame-styles.typ"))

    #tidy.show-module(
        util_docs,
        style: tidy.styles.default,
        show-outline: false,
    )
]


== Math symbols <math-symbols>

The following shorthands are provided for common math environments:
- `AA, BB, ..., ZZ` for the corresponding blackboard bold letters.
- `scr` for script (roundhand) font style. I need this one because my default font has no support
    for it, so I just fallback to another font.
- `suchthat` for a custom "such that" slash symbol.
- `sfrac, hfrac` for skewed and horizontal fractions, respectively.
- Other symbols have also been tweaked.

= Environments

== Math Environments <math-environments>

The following shows an example usage of the math environments provided by this package.

#let math_example = ````typ
#import "@local/vade-mecum:0.1.0": *

#show: e.set_(
	settings,
	heading-numbering: "A.1.",
	math-numbering: "A.1",
	math-counter-levels: 2,
	font-size: 10pt,
)
#show: template

== Definitions and notation

#notation[
    We write $NN = {0, 1, 2, dots}$ for the natural numbers, $ZZ$ for the integers, $QQ$ for the rationals, $RR$ for the reals and $CC$ for the complex numbers.
]

#def[Metric space][
    A *metric space* is a pair $(X, d)$ where $X$ is a set and $d: X times X -> RR$ satisfies, for all $x, y, z in X$:
    + $d(x, y) >= 0$, with equality iff $x = y$,
    + $d(x, y) = d(y, x)$,
    + $d(x, z) <= d(x, y) + d(y, z)$.
] <def:metric>

#def[Open ball][
    For $x in X$ and $r > 0$, the *open ball* is $ B_r (x) = {y in X suchthat d(x, y) < r}. $
]

== Results

#lemma[Balls are open][
    Every open ball $B_r (x)$ in a metric space $(X, d)$ is open.
	#proof[][
	    Let $y in B_r (x)$ and set $epsilon = r - d(x, y) > 0$. For $z in B_epsilon (y)$, the triangle inequality gives
	    $ d(x, z) <= d(x, y) + d(y, z) < d(x, y) + epsilon = r, $
	    so $B_epsilon (y) subset B_r (x)$.
	]
] <lem:ball-open>


#theorem[Cauchy--Schwarz][
    For all $u, v$ in an inner product space,
    $ |chevron.l u, v chevron.r|^2 <= chevron.l u, u chevron.r chevron.l v, v chevron.r. $
	#proof[][
	    If $v = 0$ the claim is trivial. Otherwise, for any scalar $t$,
	    $ 0 <= norm(u - t v)^2 = norm(u)^2 - 2 t chevron.l u, v chevron.r + t^2 norm(v)^2, $
	    and choosing $t = sfrac((chevron.l u, v chevron.r) / norm(v)^2)$ yields the result.
	]
] <thm:cs>


== Examples and remarks

#example[Discrete metric][
    On any set $X$, define $d(x, y) = 0$ if $x = y$ and $d(x, y) = 1$ otherwise. Then $(X, d)$ is a metric space in which $B_1 (x) = {x}$ for every $x$.
]

#remark[
    By @lem:ball-open, the open balls form a basis for a topology on $X$. Compare this with @def:metric and @thm:cs.
]

#remark[Calligraphic and blackboard letters][
    Script letters: $scr(F), scr(G), scr(P)(X)$. Blackboard letters: $AA, BB, PP, EE, RR^n$.
    Fractions: $sfrac(1 / 2)$ (skewed) and $hfrac(1 / 2)$ (horizontal).
]
````

#math_example
#[
    #set heading(outlined: false)
    #eval(math_example.text, mode: "markup")
]


== Custom Environments <custom-environments>
Custom environments can be defined too.

#let custom_frame_example = ````typ
#import "@local/vade-mecum:0.1.0": *
//...
#let exercise = frame("Exercise", red, kind: "exercise")
#show: doc => setup-frame-environment(doc,
    "exercise", styles.thmbox,
    numbering: "1", levels: 0, breakable: true,
)

#let solution = frame("Solution", green, kind: "solution")
#show: doc => setup-frame-environment(doc,
    "solution", hidden-sup-only,
    numbering: none, levels: 0, breakable: true,
)

#exercise[][
    Given a list of numbers, write a function that returns the sum of the squares of the even numbers in the list.

    #solution[][
        ```py
        def sum_of_even_squares(numbers):
            return sum(number ** 2 for number in numbers if number % 2 == 0)
        ```
    ]
]
````

#custom_frame_example
*Output:*
#eval(custom_frame_example.text, mode: "markup")
