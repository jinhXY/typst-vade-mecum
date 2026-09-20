#import "/src/utils.typ": float_table_from_2d-array, table_from_columns

// --- table_from_columns -----------------------------------------------------

// Columns are interleaved into rows, one `auto` column per input column.
#let t = table_from_columns(none, ([a], [b]), ([c], [d]))
#assert.eq(t.func(), table, message: "should build a table element")
#assert.eq(t.columns, (auto, auto), message: "one auto column per input column")
#assert.eq(t.children.map(c => c.body), ([a], [c], [b], [d]), message: "row-major order")

// A non-`arguments` first parameter is ignored and replaced by defaults.
#assert.eq(table_from_columns("not arguments", ([a],), ([b],)).columns, (auto, auto))

// Explicit `columns:` in kwargs wins over the default.
#let t-fixed = table_from_columns(arguments(columns: (2cm, 1fr)), ([a], [b]), ([c], [d]))
#assert.eq(t-fixed.columns, (2cm, 1fr))

// Other kwargs are forwarded untouched.
#assert.eq(table_from_columns(arguments(align: right), ([a],), ([b],)).align, right)

// Three columns of two cells each.
#assert.eq(
    table_from_columns(none, ([1], [2]), ([3], [4]), ([5], [6])).children.len(),
    6,
)

// --- float_table_from_2d-array ----------------------------------------------

#let ft = float_table_from_2d-array(
    ([], [A], [B]),
    ([r1], [r2]),
    ((1.23456, 2.0), (3.5, 4.25)),
)

#assert.eq(ft.func(), table)
#assert.eq(ft.columns, (1fr, 1fr, 1fr), message: "one column per header entry")
// 3 header cells + 2 rows x 3 cells
#assert.eq(ft.children.len(), 9)

// Precision is applied to the data cells.
#assert.eq(
    float_table_from_2d-array(([], [A]), ([r],), ((1.23456,),), precision: 2).children.last().body,
    [#"1.23"],
)

// Both builders render without error.
#t
#ft
#float_table_from_2d-array(([], [A]), ([r],), ((1.0,),), kwargs: arguments(
    columns: 2,
    stroke: none,
))
