//! Vector3 supports both 2D and 3D computation. The .z field can
//! be used to compute z-order in 2D games. 2D computation is computed
//! with optimizations to fit our main target: GBA Gaming.

pub fn Vector3(comptime T: type, Calculator: type) type {
    const _V3 = struct {
        x: T,
        y: T,
        z: T,

        const Self = @This();

        pub inline fn init(x: T, y: T, z: T) Self {
            return Self{ .x = x, .y = y, .z = z };
        }

        pub inline fn inplaceInvert(self: *Self) void {
            self.x = Calculator.invert(self.x);
            self.y = Calculator.invert(self.y);
            self.z = Calculator.invert(self.z);
        }
    };

    return _V3;
}

test "Vector3.Create" {
    const std = @import("std");
    const op = @import("calculator.zig");
    const vector3i = Vector3(i32, op.I32Calculator);
    const v = vector3i{ .x = 10, .y = 20, .z = 30 };
    try std.testing.expectEqual(v.x, 10);
    try std.testing.expectEqual(v.y, 20);
    try std.testing.expectEqual(v.z, 30);
}

test "Vector3.Invert" {
    const std = @import("std");
    const op = @import("calculator.zig");
    const vector3i = Vector3(i64, op.I64Calculator);
    var v = vector3i.init(10, 20, 30);
    v.inplaceInvert();
    try std.testing.expectEqual(v.x, -10);
    try std.testing.expectEqual(v.y, -20);
    try std.testing.expectEqual(v.z, -30);
}
