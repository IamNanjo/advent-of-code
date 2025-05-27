const std = @import("std");

const stdout = std.io.getStdOut().writer();
const print = std.debug.print;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const gpa_allocator = gpa.allocator();

const cwd = std.fs.cwd();

pub fn main() !void {
    defer _ = gpa.deinit();
    const input_file = try cwd.openFile("input.txt", .{ .mode = .read_only });
    defer input_file.close();
    const input_reader = input_file.reader();

    const output_file = try cwd.createFile("output.txt", .{ .truncate = true });
    defer output_file.close();
    const output_writer = output_file.writer();

    // Read input in 4kB chunks
    var input_buffer: [4096]u8 = undefined;

    var floor: i64 = 0;
    var basement_entered: bool = false;

    var partial_output: []u8 = try gpa_allocator.alloc(u8, 0);

    var total_bytes_processed: usize = 0;
    while (true) {
        const bytes_read = try input_reader.read(&input_buffer);
        if (bytes_read == 0) break;

        // Process chunk
        for (input_buffer[0..bytes_read], 0..) |byte, i| {
            floor += switch (byte) {
                '(' => 1,
                ')' => -1,
                else => break,
            };

            if (!basement_entered and floor == -1) {
                basement_entered = true;
                const out = try std.fmt.allocPrint(gpa_allocator, "Basement entered at position {d}\n", .{total_bytes_processed + i + 1});
                defer gpa_allocator.free(out);
                partial_output = try std.fmt.allocPrint(gpa_allocator, "{s}{s}", .{ partial_output, out });
                try stdout.writeAll(out);
            }
        }

        total_bytes_processed += bytes_read;
    }

    const out = try std.fmt.allocPrint(gpa_allocator, "Ended at floor {d}\n", .{floor});
    defer gpa_allocator.free(out);

    try stdout.writeAll(out);
    const final_output = try std.fmt.allocPrint(gpa_allocator, "{s}{s}", .{ partial_output, out });
    defer gpa_allocator.free(final_output);
    gpa_allocator.free(partial_output);
    try output_writer.writeAll(final_output);
}

test "input file exists and is not empty" {
    const file = try cwd.openFile("input.txt", .{ .mode = .read_only });
    const size = (try file.stat()).size;
    try std.testing.expect(size != 0);
}
