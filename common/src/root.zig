const std = @import("std");
const testing = std.testing;

const cwd = std.fs.cwd();

const stdout = std.io.getStdOut().writer();

/// Read entire input.txt file in cwd
pub fn readInput(allocator: std.mem.Allocator) ![]u8 {
    const input_file = try cwd.openFile("input.txt", .{ .mode = .read_only });
    defer input_file.close();
    const input_reader = input_file.reader();

    const input = input_reader.readAllAlloc(allocator, std.math.maxInt(usize));

    return input;
}

/// Writes output to stdout and output_file
pub fn writeOutput(output_file: std.fs.File, comptime fmt: [*:0]const u8, args: anytype) !void {
    const output_writer = output_file.writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const output = try std.fmt.allocPrint(arena.allocator(), std.mem.span(fmt), args);

    try stdout.writeAll(output);
    try output_writer.writeAll(output);
}

test "input reading works" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa_allocator = gpa.allocator();

    const input = try readInput(gpa_allocator);
    const input_length = input.len;
    gpa_allocator.free(input);

    try std.testing.expect(input_length != 0);
    try std.testing.expect(gpa.deinit() == std.heap.Check.ok);
}
