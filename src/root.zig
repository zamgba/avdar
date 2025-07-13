// Vector3I is pre-defined because it's typically used in
// Gameboy Advance. GBA does not have built-in hardware
// support for float, double or 64-bit integers.
//
// When using avdar for desktop game development, please define
// alias like Vector3(f64) or Vector3(i64).
const v = @import("vector.zig");
const op = @import("calculator.zig");
const Vector3 = v.Vector3;
const Vector3I32 = Vector3(i32, op.I32Calculator);
const Vector3I64 = Vector3(i64, op.I64Calculator);
const Vector3F64 = Vector3(i64, op.F64Calculator);

test {
    _ = Vector3I32.init(10, 20, 30);
    _ = Vector3I64.init(10, 20, 30);
    _ = Vector3F64.init(10.0, 20.0, 30.0);
}
