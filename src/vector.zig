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

        pub inline fn invertInplace(self: *Self) void {
            self.x = Calculator.invert(self.x);
            self.y = Calculator.invert(self.y);
            self.z = Calculator.invert(self.z);
        }

        pub inline fn componentProduct(self: Self, rhs: Self) Self {
            return Vector3(T, Calculator).init(
                Calculator.mul(self.x, rhs.x),
                Calculator.mul(self.y, rhs.y),
                Calculator.mul(self.z, rhs.z),
            );
        }

        pub inline fn componentProductInplace(self: *Self, rhs: Self) void {
            self.x = Calculator.mul(self.x, rhs.x);
            self.y = Calculator.mul(self.y, rhs.y);
            self.z = Calculator.mul(self.z, rhs.z);
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
    v.invertInplace();
    try std.testing.expectEqual(v.x, -10);
    try std.testing.expectEqual(v.y, -20);
    try std.testing.expectEqual(v.z, -30);
}

test "Vector3.product" {
    const std = @import("std");
    const op = @import("calculator.zig");
    const vector3i = Vector3(i64, op.I64Calculator);
    const v1 = vector3i.init(10, 20, 30);
    const v2 = vector3i.init(2, 3, 4);
    var v3 = v1.componentProduct(v2);

    try std.testing.expectEqual(v3.x, 10 * 2);
    try std.testing.expectEqual(v3.y, 20 * 3);
    try std.testing.expectEqual(v3.z, 30 * 4);

    v3.componentProductInplace(v2);

    try std.testing.expectEqual(v3.x, 20 * 2);
    try std.testing.expectEqual(v3.y, 60 * 3);
    try std.testing.expectEqual(v3.z, 120 * 4);
}
