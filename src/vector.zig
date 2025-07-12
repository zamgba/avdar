pub fn Vector3(comptime T: type) type {
    return struct {
        x: T,
        y: T,
        z: T,
    };
}

const std = @import("std");

test "TypedVector3" {
    const vector3i = Vector3(i32);
    const v = vector3i{ .x = 10, .y = 20, .z = 30 };
    std.debug.assert(v.x == 10);
    std.debug.assert(v.y == 20);
    std.debug.assert(v.z == 30);
}
