const std = @import("std");
const log = std.log;
const socket_t = @import("socket.zig").Socket;
const to_client_t = @import("write-to-client.zig").ToClient;
const read_from_clinet_t = @import("read-from-client.zig").Reader;
const command_parser_t = @import("command-parser.zig").CommandParser;

pub fn main() !void {
    var current_socket = socket_t.init();
    defer current_socket.closeSocket();
    current_socket.initSocket();
    
    while (true) {
        const client_fd = current_socket.acceptConnection();
        defer _ = std.os.linux.close(@intCast(client_fd));
        log.debug("client_fd: {d}.", .{client_fd});
        try to_client_t.sendLoginMessage(&client_fd);
        
        var buffer: [32]u8 = undefined;
        const input_len = read_from_clinet_t.readMessageFromClient(&client_fd, buffer[0..]);
        const client_chosen_command = read_from_clinet_t.identifyCommand(buffer[0..input_len - 1]);
        command_parser_t.parseCommand(client_chosen_command);
    }
}

