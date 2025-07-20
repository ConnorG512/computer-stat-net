const std = @import("std");
const linux = std.os.linux;
const log = std.log;
const rand = @import("randomgen-util.zig").RandomGen;

const WriteError = error {
    FailedToWrite,
};

pub const ToClient = struct {
    pub fn sendMessageToClient(client_fd: *const usize, message: []const u8) WriteError!usize {
        const bytes_written: usize = linux.write(@intCast(client_fd.*), message.ptr, message.len);
        if (@as(isize, @bitCast(bytes_written)) < 0) {
            log.err("Could not write to fd!\n", .{});
            return error.FailedToWrite;
        }
        return bytes_written;
    }

    pub fn sendLoginMessage(client_fd: *const usize) !void {
        _ = try sendMessageToClient(client_fd, "Welcome to computer-stat-net\n");
        _ = try sendMessageToClient(client_fd, "Message of the login:\n");
        const login_messages: [5][]const u8 = comptime .{
            "never sudo rm -rf /\n",
            "Don't use sudo for everything!\n",
            "Be careful what you donwload off the AUR!\n",
            "Hosted on TCP 40050!\n",
            "Powered by Zig!\n",
        };
        const rand_result = rand.generateValueUpTo(0, login_messages.len - 1);
        _ = try sendMessageToClient(client_fd, login_messages[@intCast(rand_result)]);
    }
};
