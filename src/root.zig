// Vector3I is pre-defined because it's typically used in
// Gameboy Advance. GBA does not have built-in hardware
// support for float, double or 64-bit integers.
//
// When using avdar for desktop game development, please define
// alias like Vector3(f64) or Vector3(i64).
const v = @import("vector.zig");
const Vector3 = v.Vector3;
const Vector3I = Vector3(i32);
