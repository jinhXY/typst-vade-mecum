#import "@preview/frame-it:2.0.0": *
#import "@preview/headcount:0.1.0": dependent-numbering, reset-counter
#import "/src/template.typ": *

// Avoids warnings because of unknown fonts
#show: e.set_(
    settings,
    math-font: "New Computer Modern Math",
    code-font: "DejaVu Sans Mono",
    font: "Libertinus Serif",
)

#show: template

#set heading(numbering: "1.")

#let test = frame("Test", green, kind: "test")

#show: doc => setup-frame-environment(
    doc,
    "test",
    styles.thmbox,
    numbering: "1.1",
    levels: 2,
)

#advanced-outline(
    targets: (heading, figure.where(kind: "test"), figure.where(kind: image)),
)

#advanced-outline(
    targets: (figure.where(kind: "test"), figure.where(kind: image)),
    title: "Outline of image and test figures",
)

#advanced-outline(
    targets: (figure.where(kind: image),),
    title: "Outline of image figures",
)

#advanced-outline(
    targets: (figure.where(kind: "test"),),
    title: "Outline of test figures",
)

#pagebreak()
#let pixels(size) = {
    range(size)
        .map(y => range(size).map(x => if (calc.rem(x + y, 2) == 0) { 255 } else { 0 }))
        .flatten()
}
#let stock-image = {
    let size = 16
    image(
        bytes(pixels(size)),
        format: (encoding: "luma8", width: size, height: size),
        width: 10%,
    )
}
= The heading
== The subheading
#test[This is a frame][#lorem(10)]
#figure(stock-image, caption: [A curious figure.])
#test[This is a frame][#lorem(10)]
#test[This is a frame][#lorem(10)]

= The heading
== The subheading
#test[This is a frame][#lorem(10)]
#test[This is a frame][#lorem(10)]

=== The subsubheading
#test[This is a frame][#lorem(10)]
#figure(stock-image, caption: [A curious figure.])
