const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "avdar",
        .root_module = lib_mod,
    });

    b.installArtifact(lib);

    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    const test_step = b.step("test", "Run unit tests");
    addTest(allocator, b, test_step, target, optimize) catch |err| {
        std.debug.print("Error on adding test from files: {}", .{err});
    };
}

fn addTest(
    allocator: std.mem.Allocator,
    b: *std.Build,
    test_step: *std.Build.Step,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) !void {
    const src_dir = try std.fs.cwd().openDir("src", .{ .iterate = true });
    var walker = try src_dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (entry.kind == .file and std.mem.endsWith(u8, entry.basename, ".zig")) {
            const path = try std.fs.path.join(allocator, &.{ "src/", entry.basename });
            defer allocator.free(path);

            const unit_tests = b.addTest(.{
                .root_source_file = b.path(path),
                .target = target,
                .optimize = optimize,
            });
            const run_unit_tests = b.addRunArtifact(unit_tests);
            test_step.dependOn(&run_unit_tests.step);
        }
    }
}
