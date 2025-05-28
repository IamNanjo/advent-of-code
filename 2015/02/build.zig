const std = @import("std");

const aoc_common_path = "../../common/src/root.zig";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });

    const exe = b.addExecutable(.{
        .name = "aoc_2015_02",
        .root_source_file = b.path("./src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const aoc_common = b.addModule("aoc_common", .{
        .root_source_file = b.path(aoc_common_path),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("aoc_common", aoc_common);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const aoc_common_tests = b.addTest(.{
        .root_module = aoc_common,
        .target = target,
        .optimize = optimize,
    });

    const run_aoc_common_tests = b.addRunArtifact(aoc_common_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_aoc_common_tests.step);
}
