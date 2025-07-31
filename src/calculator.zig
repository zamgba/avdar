//! Calculator is a generic abstract to expose numeric calculations.

const std = @import("std");

fn NumericZero(comptime Num: type) Num {
    return @as(Num, 0);
}

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

        pub inline fn add3(data1: Num, data2: Num, data3: Num) Num {
            // It's useful for our library as Vector3 is the most
            // common data structure for 3D calculations.
            return data1 + data2 + data3;
        }

        pub inline fn addN(args: anytype) Num {
            // TODO: Will addN(.{1,2,3}} and add3(1,2,3) run with
            // the same performance?
            var result: Num = NumericZero(Num);
            inline for (std.meta.fields(@TypeOf(args))) |field| {
                const value = @field(args, field.name);
                result += value;
            }
            return result;
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

test "Numeric.addN" {
    const i32Calc = I32Calculator.addN(.{ 10, 20, 30 });
    try std.testing.expect(i32Calc == 60);
}

test "Numeric.add" {
    const i32Calc = I32Calculator.add(10, 20);
    try std.testing.expect(i32Calc == 30);
}

test "Numeric.add3" {
    const i32Calc = I32Calculator.add3(10, 20, 30);
    try std.testing.expect(i32Calc == 60);
}
