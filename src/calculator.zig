//! Calculator is a generic abstract to expose numeric calculations.

fn NumericCalculator(comptime Num: type) type {
    const Numeric = struct {
        pub inline fn invert(v: Num) Num {
            return -v;
        }

        pub inline fn mul(lhs: Num, rhs: Num) Num {
            return lhs * rhs;
        }

        pub inline fn add(lhs: Num, rhs: Num) Num {
            return lhs + rhs;
        }
    };

    return Numeric;
}

// avdar supports only a limited number of calculators:
// * f64:             The most common calculator
// * i32 and i64:     OK for general use.
// * fixed number:    For GBA platform (which does not support float)

pub const F64Calculator = NumericCalculator(f64);
pub const I32Calculator = NumericCalculator(i32);
pub const I64Calculator = NumericCalculator(i64);
