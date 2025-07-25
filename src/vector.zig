//! Vector3 supports both 2D and 3D computation. The .z field can
//! be used to compute z-order in 2D games. 2D computation is computed
//! with optimizations to fit our main target: GBA Gaming.

pub fn Vector3(comptime T: type, Calculator: type) type {
    const _V3 = struct {
        x: T,
        y: T,
        z: T,

        const Self = @This();
        const C = Calculator;

        pub inline fn init(x: T, y: T, z: T) Self {
            return Self{ .x = x, .y = y, .z = z };
        }

        pub inline fn invertInplace(self: *Self) void {
            self.x = C.invert(self.x);
            self.y = C.invert(self.y);
            self.z = C.invert(self.z);
        }

        pub inline fn componentProduct(self: Self, rhs: Self) Self {
            // [x1,y1,z1] * [x1,y1,z1] = [x1*x1, y1*y2, z1*z2]
            return Vector3(T, Calculator).init(
                C.mul(self.x, rhs.x),
                C.mul(self.y, rhs.y),
                C.mul(self.z, rhs.z),
            );
        }

        pub inline fn componentProductInplace(self: *Self, rhs: Self) void {
            self.x = C.mul(self.x, rhs.x);
            self.y = C.mul(self.y, rhs.y);
            self.z = C.mul(self.z, rhs.z);
        }

        pub inline fn scalarProduct(self: Self, rhs: Self) T {
            // [x1,y1,z1] * [x1,y1,z1] = x1*x1+y1*y2+z1*z2
            return C.add(
                C.add(
                    C.mul(self.x, rhs.x),
                    C.mul(self.y, rhs.y),
                ),
                C.mul(self.z, rhs.z),
            );
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

test "Vector3.componentProduct" {
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

test "Vector3.scalarProduct" {
    const std = @import("std");
    const op = @import("calculator.zig");
    const vector3i = Vector3(i64, op.I64Calculator);
    const v1 = vector3i.init(10, 20, 30);
    const v2 = vector3i.init(2, 3, 4);
    const v3 = v1.scalarProduct(v2);

    try std.testing.expectEqual(v3, 10 * 2 + 20 * 3 + 30 * 4);

    // Scalar product does not have inline version as the output is
    // not matrix anymore.
}
