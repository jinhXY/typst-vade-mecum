/// Checks if a Content is empty (i.e., has no text)
/// -> bool
#let is-content-empty(
    /// The content to check. -> content
    h,
) = {
    [#h].at("children", default: ()) == ()
}

/// Checks if a content is non-empty (i.e., has text)
/// -> bool
#let is-content-non-empty(
    /// The content to check. -> content | str
    it,
) = {
    return it != none and it != [] and it != ""
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
/// -> content
#let code-block(
    /// The path to the file to read. -> path
    filename,
) = {
    codly(breakable: true, header: [#filename])
    raw(
        read(filename),
        block: true,
        lang: filename.split(".").at(-1),
    )
}
