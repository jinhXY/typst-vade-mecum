/// Checks if a Content is empty (i.e., has no text)
/// -> bool
#let is-content-empty(
    /// The content to check. -> content
    h,
) = {
    return h == none or h == [] or h == ""
}

/// Checks if a content is non-empty (i.e., has text)
/// -> bool
#let is-content-non-empty(
    /// The content to check. -> content | str
    h,
) = {
    return not is-content-empty(h)
}

/// Creates a table from a list of columns, as opposed to a list of rows.
/// -> content
#let table_from_columns(
    /// Additional keyword arguments to pass to the table function. -> arguments | none
    kwargs,
    /// The columns to use for the table. Each column should be a list of cells. -> content
    ..columns,
) = {
    columns = columns.pos()
    let first = columns.at(0)
    let others = columns.slice(1)

    if type(kwargs) != arguments {
        kwargs = arguments()
    }
    if kwargs.at("columns", default: none) == none {
        kwargs = kwargs + arguments(columns: (auto,) * columns.len())
    }

    table(
        ..kwargs,
        ..first.zip(..others).flatten(),
    )
}

/// Rounds a number to a specified precision and returns it as a string.
/// -> str
#let int_round(
    /// The number to round. -> number
    value,
    /// The number of decimal places to round to. -> int
    precision: 3,
) = {
    import "@preview/oxifmt:1.0.0": strfmt
    strfmt("{0:." + str(precision) + "}", float(value))
}

/// Creates a table from a 2D array of data, with optional headers for the rows and columns.
/// -> content
#let float_table_from_2d-array(
    /// The header for the columns (top row). -> array<content | string>
    header_up,
    /// The header for the rows (first column). -> array<content | string>
    header_side,
    /// The 2D array of data to populate the table. -> array<content>
    data,
    /// Additional keyword arguments to pass to the table function.
    /// If `none`, defaults to center alignment and equal column widths. -> arguments | none
    kwargs: none,
    /// The number of decimal places to round the data to. -> int
    precision: 3,
) = {
    if kwargs == none {
        kwargs = arguments(
            align: center,
            columns: (1fr,) * header_up.len(),
        )
    }

    table(
        ..kwargs,
        ..header_up,
        ..data
            .enumerate()
            .map(
                ((index, row)) => {
                    (
                        (header_side.at(index),)
                            + row.map(cell => [#int_round(cell, precision: precision)])
                    )
                },
            )
            .flatten()
    )
}

/// Returns a code block with the contents of a file, using the filename
/// as the header and its extension as the language for syntax highlighting.
/// The code block is breakable, allowing it to span multiple pages if necessary.
///
/// NOTE: The language detection based on the file extension currently does NOT
/// work. Prior to Typst 0.15, paths did not exist and thus the user had to pass
/// the raw contents of the file to this function, along with the file name. Now,
/// path support exists, but no operations are allowed with them, including
/// extracting their string representation. For now, the extension will have to
/// be manually specified
/// -> content
#let code-block(
    /// The path to the file to read. -> path
    filename,
    /// Extension of the file to use for syntax highlighting.
    /// If empty, no syntax highlighting will be applied. -> str
    lang: "",
) = {
    import "@preview/codly:1.3.0": *

    let args = arguments(
        block: true,
    )
    if lang != "" {
        args = args + arguments(lang: lang)
    }

    codly(breakable: true, header: [#filename])
    raw(read(filename), ..args)
}

/// Creates an outline of the document with advanced options for formatting and filtering.
/// -> content
#let advanced-outline(
    /// Whether to automatically indent figures in the outline.
    /// Stock Typst always considers figures as top-level elements, which
    /// is undesirable if the outline combines headings and figures.
    /// If set to `auto`, figures will be indented if headings are included in the outline.
    /// -> bool | auto
    indent_figures: auto,
    /// Whether to hide the supplement for figures in the outline.
    /// This is useful if the outline is only for one kind of figure, as the supplement
    /// will be the same for all of them. If set to `auto`, the supplement will be hidden
    /// if the outline is only for one kind of figure.
    /// -> bool | auto
    hide_figure_sup: auto,
    /// The maximum level of headings to be displayed in bold in the outline.
    /// If set to `auto`, only the first level of headings will be bolded
    /// if the outline is only for headings. Otherwise, if other elements
    /// are included in the outline, all headings will be bolded.
    /// -> int | auto
    max_bold_headings_level: auto,
    /// The fill style for the outline entries. -> content
    fill: line(length: 100%, stroke: .2pt + gray),
    /// The target elements to include in the outline. -> array<element>
    targets: (heading,),
    /// Additional keyword arguments to pass to Typst's built-in `outline` function.
    ..kwargs,
) = {
    // Bold headings
    let max_bold_headings_level = if max_bold_headings_level == auto {
        if targets != (heading,) { calc.inf } else { 1 }
    } else { max_bold_headings_level }

    show outline.entry: it => {
        if it.element.func() == heading and it.element.level <= max_bold_headings_level {
            v(1em, weak: true)
            strong(it)
        } else { it }
    }

    // Indent figures
    let indent_figures = if indent_figures == auto {
        heading in targets
    } else { indent_figures }

    show outline.entry: it => if indent_figures {
        if it.element.func() == figure {
            let loc = it.element.location()
            let depth = counter(heading).at(loc).len()
            let bumped = outline.entry(depth + 1, it.element, fill: it.fill)
            link(loc, bumped.indented(bumped.prefix(), bumped.inner()))
        } else {
            it
        }
    } else { it }

    // Hide figure supplement
    let hide_figure_sup = if hide_figure_sup == auto {
        // Hide the supplement for outlines of one figure kind.
        // Unfortunately, there does not seem to be a way to check
        // if targets contains an element function derived from figure,
        // so we just check if the targets list has length 1.
        // For non-figure targets, the show rule should no-op anyway.
        targets.len() == 1
    } else { hide_figure_sup }

    show outline.entry: it => if hide_figure_sup {
        let elem = it.element
        if elem.func() != figure { return it }

        context {
            let all-figs = query(figure)
            let all-numbers = query(<rendered-figure-number>)
            let index = all-figs.position(f => f.location() == elem.location())
            let numbered = all-numbers.at(index).value
            let prefix = if numbered != none { numbered + "." } else { "" }

            link(elem.location(), it.indented(prefix, it.inner()))
        }
    } else { it }

    set outline.entry(fill: fill)
    outline(
        ..kwargs,
        target: selector.or(..targets),
    )
}
