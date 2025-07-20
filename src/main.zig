const std = @import("std");
const log = std.log;
const socket_t = @import("socket.zig").Socket;
const to_client_t = @import("write-to-client.zig").ToClient;

pub fn main() !void {
    var current_socket = socket_t.init();
    defer current_socket.closeSocket();
    current_socket.initSocket();
    
    while (true) {
        const client_fd = current_socket.acceptConnection();
        defer std.os.linux.close(client_fd);
        log.debug("client_fd: {d}.", .{client_fd});
        try to_client_t.sendLoginMessage(&client_fd);
    }
}

