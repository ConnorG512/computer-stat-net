const std = @import("std");
const log = std.log;
const linux = std.os.linux;

const available_commands_enum = @import("read-from-client.zig").AvailableInputs;

pub const CommandParser = struct {
    pub fn parseCommand(chosen_command: available_commands_enum, client_fd: *const usize) !void {
        switch (chosen_command) {
            .unknown => {
                unknownCommand(client_fd);
            },
            .cpu => {
                try cpuCommand(client_fd);
            },
            .help => {
                helpCommand(client_fd);
            },
        }
    }
    fn unknownCommand(_: *const usize) void {
        // TODO
        log.debug("(unknownCommand) Called!", .{});
    }
    fn helpCommand(_: *const usize) void {
        // TODO
        log.debug("(helpCommand) Called!", .{});
    }
    fn cpuCommand(client_fd: *const usize) !void {
        log.debug("(cpuCommand) Called!", .{});
        
        const of_buffer_size: u16 = comptime 1024;
        var of_buffer: [of_buffer_size]u8 = undefined;
        const of_fba = std.heap.FixedBufferAllocator.init(&of_buffer);

        const file_id: usize = linux.open("/proc/cpuinfo", .{}, 0);
        defer _ = linux.close(@intCast(file_id));
        log.debug("(cpuCommand)File: {d}", .{file_id});

        _ = linux.read(@intCast(file_id), of_fba.buffer.ptr, of_fba.buffer.len);

        var cpu_token = std.mem.tokenizeAny(u8, of_fba.buffer, "\n");
        var index: u8 = 0;
        while (cpu_token.next()) |current_token| {
            if (index == 4) {
                _ = linux.write(@intCast(client_fd.*), current_token.ptr, current_token.len);
                return;
            }
            index += 1;
        }
    }
};

test "print-cpuinfo-token" {
    const buffer = try std.heap.page_allocator.alloc(u8, 4096);
    defer std.heap.page_allocator.free(buffer);

    const file_id: usize = linux.open("/proc/cpuinfo", .{}, 0);
    defer _ = linux.close(@intCast(file_id));
    _ = linux.read(@intCast(file_id), buffer.ptr, buffer.len);

    var cpu_token = std.mem.tokenizeAny(u8, buffer, "\n"); 
    var index: u16 = 0;
    while (cpu_token.next()) |current_token| {
        std.debug.print("Token: {d}\n{s}\n\n", .{index, current_token});
        index += 1;
    }
}
