#import "@preview/elembic:1.1.1" as e

#let settings = e.element.declare(
    "template-settings",
    prefix: "@preview/vade-mecum,v1",
    doc: "Configuration values for the template.",

    display: _ => panic("This element is configuration only and cannot be displayed"),

    fields: (
        // Default conf
        e.field(
            "lang",
            str,
            doc: {
                "Overall language of the document. "
                "This is used by Typst to determine hyphenation and other "
                "language-specific settings."
            },
            default: "en",
        ),
        e.field(
            "font",
            e.types.union(str, array, dictionary),
            doc: "Main font of the document. Does not apply to Math mode nor Raw mode.",
            default: ("Linux Libertine O", "Libertinus Serif"),
        ),
        e.field(
            "font-size",
            length,
            doc: "Font size for the main document.",
            default: 12pt,
        ),
        e.field(
            "heading-numbering",
            e.types.union(function, str),
            doc: "Heading numbering pattern. Uses same pattern as Typst's numbering function.",
            default: "1.1.",
        ),
        e.field(
            "page-numbering",
            e.types.union(function, str),
            doc: "Page numbering pattern. Uses same pattern as Typst's numbering function.",
            default: "1",
        ),
        e.field(
            "page-number-alignment",
            alignment,
            doc: "Alignment of page numbers in the page footer.",
            default: center,
        ),
        e.field(
            "bullet-point-indent",
            length,
            doc: "Default indentation for Typst's enumerations and lists.",
            default: 1em,
        ),
        e.field(
            "use-hydra",
            bool,
            doc: {
                "Whether to use Hydra for section headings in page headers. "
                "By default, the first level heading is shown at the left of the page header, "
                "and the second level heading is shown at the right of the page header. "
                "Note that this option will force each section to start on a new page, and "
                "that Hydra won't show in the first page of each section."
            },
            default: false,
        ),
        e.field(
            "hydra-margins",
            e.types.union(alignment, dictionary),
            doc: {
                "Adapted page margins used when Hydra is enabled. "
                "This is mostly useful for increasing the top margin to make more room "
                "for the header."
            },
            default: (top: 8em),
        ),
        e.field(
            "justify",
            bool,
            doc: "Whether to justify text or not.",
            default: true,
        ),

        // Code conf
        e.field(
            "code-font",
            e.types.union(str, array, dictionary),
            doc: "Font used for code blocks.",
            default: ("FiraCode Nerd Font", "DejaVu Sans Mono"),
        ),
        e.field(
            "code-font-size",
            length,
            doc: "Font size used for code blocks.",
            default: 9pt,
        ),
        e.field(
            "code-bg-color",
            color,
            doc: "Background color for code blocks.",
            default: rgb("#F6F8FA"),
        ),
        e.field(
            "codly-config",
            arguments,
            doc: "Default configuration arguments for Codly code blocks.",
            default: arguments(zebra-fill: none),
        ),
        e.field(
            "syntax-theme",
            path,
            doc: "Syntax theme for code blocks. This should be a path to a .tmtheme file.",
            default: path("themes/Github Light.tmtheme"),
        ),

        // Math conf
        e.field(
            "math-font",
            e.types.union(str, array, dictionary),
            doc: "Font used for mathematical content.",
            default: ("Erewhon Math", "New Computer Modern Math"),
        ),
        e.field(
            "math-counter-levels",
            int,
            doc: {
                "Levels of numbering dependence for math frames. This determines how many levels "
                "of numbering depend on the section hierarchy. For example, if this is set to 2, "
                "the first two counters in the numbering pattern of math frames will use "
                "the section counters, while the rest will increment independently. This last "
                "counter will be reset at the beginning of each section."
            },
            default: 0,
        ),
        e.field(
            "math-numbering",
            e.types.option(str),
            doc: {
                "Numbering pattern for math frames. "
                "Uses the same pattern as Typst's numbering function."
            },
            default: "1.1",
        ),
    ),
)
