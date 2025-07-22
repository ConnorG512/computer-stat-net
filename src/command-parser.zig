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
    fn cpuCommand(_: *const usize) !void {
        // TODO
        log.debug("(cpuCommand) Called!", .{});
        
        const buffer = try std.heap.page_allocator.alloc(u8, 4096);
        defer std.heap.page_allocator.free(buffer);

        const file_id: usize = linux.open("/proc/stat", .{}, 0);
        defer _ = linux.close(@intCast(file_id));
        log.debug("(cpuCommand)File: {d}", .{file_id});

        _ = linux.read(@intCast(file_id), buffer.ptr, buffer.len);
        log.debug("{s}", .{buffer});
    }
};
