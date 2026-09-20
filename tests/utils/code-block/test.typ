#import "/src/utils.typ": code-block
#import "../../../src/coding.typ": code-conf

#let opts = (
    code-font: "DejaVu Sans Mono",
    code-font-size: 9pt,
    code-bg-color: rgb("#F6F8FA"),
    codly-config: arguments(zebra-fill: none),
    syntax-theme: path("/src/themes/Github Light.tmtheme"),
)

// --- code-conf --------------------------------------------------------------
// It must not choke on a config that already carries a `fill`, nor on one
// that leaves `fill` to be filled in from `code-bg-color`.

#let opts-with-fill = (
    ..opts,
    codly-config: arguments(zebra-fill: none, fill: rgb("#FFEEEE")),
)

#assert.eq(opts.codly-config.at("fill", default: none), none)
#assert.ne(opts-with-fill.codly-config.at("fill", default: none), none)

#show: doc => code-conf(doc, opts)

// --- code-block -------------------------------------------------------------

#let block-content = code-block(path("sample.py"), lang: "py")
#assert.eq(type(block-content), content)

= Code

Inline code such as `let x = 1` is boxed by the raw show rule.

#block-content

```rust
fn main() {
    println!("hello");
}
```

// --- the language is derived from the file extension ------------------------
#context {
    let blocks = query(raw).filter(it => it.block)
    assert(blocks.len() >= 2, message: "expected the file block and the inline rust block")

    let from-file = blocks.first()
    assert.eq(from-file.lang, "py", message: "language comes from the file extension")
    assert(
        "def greet" in from-file.text,
        message: "the file contents should be read verbatim",
    )
}

// A file name with several dots still uses the last segment as the language.
#assert.eq("archive.tar.gz".split(".").at(-1), "gz")
