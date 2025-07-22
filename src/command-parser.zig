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

        const file_id: usize = linux.open("/proc/cpuinfo", .{}, 0);
        defer _ = linux.close(@intCast(file_id));
        log.debug("(cpuCommand)File: {d}", .{file_id});

        _ = linux.read(@intCast(file_id), buffer.ptr, buffer.len);
        
        // const cpu_category = comptime [_][]u8 {
        //     "user", "nice", "system", "idle", "iowait", "irq", "softirq"
        // };
        // var token_by_line = std.mem.tokenizeAny(u8, buffer, " ");
        // var index: u16 = 0;
        // while (token_by_line.next()) |current_token| {
            // _ = linux.write(@intCast(client_fd.*), current_token.ptr, current_token.len);
        //     std.debug.print("Index: {d}\n Token: {s}\n\n", .{index, current_token});
        //     index += 1;
        // }
    }
};
