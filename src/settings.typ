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
            doc: "Language of the document.",
            default: "en",
        ),
        e.field(
            "font",
            str,
            doc: "Main document font.",
            default: "Linux Libertine O",
        ),
        e.field(
            "font-size",
            length,
            doc: "Main document font size.",
            default: 12pt,
        ),
        e.field(
            "heading-numbering",
            e.types.union(function, str),
            doc: "Heading numbering pattern.",
            default: "1.1.",
        ),
        e.field(
            "page-numbering",
            e.types.union(function, str),
            doc: "Page numbering pattern.",
            default: "1",
        ),
        e.field(
            "page-number-alignment",
            alignment,
            doc: "Alignment of page numbers in the footer.",
            default: center,
        ),
        e.field(
            "bullet-point-indent",
            length,
            doc: "Indentation for items and lists.",
            default: 1em,
        ),
        e.field(
            "use-hydra",
            bool,
            doc: "Whether to use Hydra for section headings in pages",
            default: false,
        ),
        e.field(
            "hydra-margins",
            e.types.union(alignment, dictionary),
            doc: "Margins for the Hydra header.",
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
            str,
            doc: "Font used for code blocks.",
            default: "FiraCode Nerd Font",
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
            doc: "Configuration for Codly code blocks.",
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
            str,
            doc: "Font used for mathematical content.",
            default: "Erewhon Math",
        ),
        e.field(
            "math-counter-levels",
            int,
            doc: "Number of math frame counter levels.",
            default: 0,
        ),
        e.field(
            "math-numbering",
            e.types.option(str),
            doc: "Math numbering pattern.",
            default: "1.1",
        ),
    ),
)
