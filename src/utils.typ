/// Checks if a Content is empty (i.e., has no text)
///
/// - h (content): The content to check.
/// -> bool Whether the content is empty or not.
#let is-content-empty(h) = {
    [#h].at("children", default: ()) == ()
}

/// Checks if a content is non-empty (i.e., has text)
///
/// - it (content | str): The content to check.
/// -> bool Whether the content is non-empty or not.
#let is-content-non-empty(it) = {
    return it != none and it != [] and it != ""
}

/// Creates a table from a list of columns, as opposed to a list of rows.
///
/// - kwargs (arguments): Additional keyword arguments to pass to the table function.
/// - columns (arguments): The columns to use for the table. Each column should be a list of cells.
/// -> content The resulting table content.
#let table_from_columns(kwargs, ..columns) = {
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
///
/// - value (number): The number to round.
/// - precision (int): The number of decimal places to round to. Defaults to 3.
/// -> str The rounded number as a string.
#let int_round(value, precision: 3) = {
    import "@preview/oxifmt:1.0.0": strfmt
    strfmt("{0:." + str(precision) + "}", float(value))
}

/// Creates a table from a 2D array of data, with optional headers for the rows and columns.
///
/// - header_up (list): The header for the columns (top row).
/// - header_side (list): The header for the rows (first column).
/// - data (list): The 2D array of data to populate the table.
/// - kwargs (arguments | none): Additional keyword arguments to pass to the table function.
//    If `none`, defaults to center alignment and equal column widths.
/// - precision (int): The number of decimal places to round the data to. Defaults to 3.
/// ->
#let float_table_from_2d-array(header_up, header_side, data, kwargs: none, precision: 3) = {
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
