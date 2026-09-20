#import "/src/utils.typ": int_round

// Default precision is 3 decimals.
#assert.eq(int_round(1.23456), "1.235")
#assert.eq(int_round(0.5), "0.500")

// Explicit precision.
#assert.eq(int_round(1.23456, precision: 0), "1")
#assert.eq(int_round(1.23456, precision: 1), "1.2")
#assert.eq(int_round(1.23456, precision: 5), "1.23456")

// Integers are accepted and converted to float.
#assert.eq(int_round(2, precision: 2), "2.00")

// Negative numbers keep their sign.
#assert.eq(int_round(-1.005, precision: 2), "-1.00")

// Rounding is half-to-even at the formatting level, not truncation.
#assert.eq(int_round(1 / 3, precision: 4), "0.3333")
#assert.eq(int_round(2 / 3, precision: 4), "0.6667")

// The result is always a string, never content.
#assert.eq(type(int_round(1.0)), str)
