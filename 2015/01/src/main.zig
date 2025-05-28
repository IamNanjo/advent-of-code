const std = @import("std");
const aoc_common = @import("aoc_common");

const stdout = std.io.getStdOut().writer();
const print = std.debug.print;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const gpa_allocator = gpa.allocator();

pub fn main() !void {
    defer _ = gpa.deinit();

    const output_file = try std.fs.cwd().createFile("output.txt", .{});
    defer output_file.close();

    const input = try aoc_common.readInput(gpa_allocator);
    defer gpa_allocator.free(input);

    var floor: i64 = 0;
    var basement_entered: bool = false;

    for (input, 0..) |byte, i| {
        floor += switch (byte) {
            '(' => 1,
            ')' => -1,
            else => break,
        };

        if (!basement_entered and floor == -1) {
            basement_entered = true;
            try aoc_common.writeOutput(output_file, "Basement entered at position {d}\n", .{i + 1});
        }
    }

    try aoc_common.writeOutput(output_file, "Ended at floor {d}\n", .{floor});
}
