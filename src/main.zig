const std = @import("std");
const log = std.log;
const rand = @import("randomgen-util.zig").RandomGen;
const socket_t = @import("socket.zig").Socket;

pub fn main() !void {
    var current_socket = socket_t.init();
    defer current_socket.closeSocket();
    current_socket.initSocket();
    
    while (true) {
        const client_fd = current_socket.acceptConnection();
        log.debug("client_fd: {d}.", .{client_fd});
        try printWelcome(&client_fd);
    }
}

fn printWelcome(client_fd: *const usize) !void {
    const login_messages: [5][]const u8 = comptime .{
        "never sudo rm -rf /\n",
        "Don't use sudo for everything!\n",
        "Be careful what you donwload off the AUR!\n",
        "Hosted on TCP 40050!\n",
        "Powered by Zig!\n",
    };
    
    const rand_result = rand.generateValueUpTo(0, login_messages.len - 1);

    _ = try std.posix.send(@intCast(client_fd.*), "Welcome to computer-stat-net\n", 0);
    _ = try std.posix.send(@intCast(client_fd.*), "Message of the login:\n", 0);
    _ = try std.posix.send(@intCast(client_fd.*), login_messages[@intCast(rand_result)], 0);
    _ = try std.posix.send(@intCast(client_fd.*), "\n", 0);
}

