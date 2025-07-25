const std = @import("std");
const log = std.log;
const socket_t = @import("socket.zig").Socket;
const to_client_t = @import("write-to-client.zig").ToClient;
const read_from_clinet_t = @import("read-from-client.zig").Reader;
const CommandParser = @import("command-parser.zig").CommandParser;

const Allocator = std.mem.Allocator;

pub fn main() !void {
    var current_socket = socket_t.init();
    defer current_socket.closeSocket();
    current_socket.startSocket();

    var client_input_buffer: [32]u8 = undefined;

    while (true) {
        const client_fd = current_socket.acceptConnection();
        defer _ = std.os.linux.close(@intCast(client_fd));
        try to_client_t.sendLoginMessage(&client_fd);

        while (true) {
            const input_len = read_from_clinet_t.readMessageFromClient(&client_fd, client_input_buffer[0..]);
            const client_chosen_command = read_from_clinet_t.identifyCommand(client_input_buffer[0..input_len - 1]);
            try CommandParser.parseCommand(client_chosen_command, &client_fd);
            if (client_chosen_command == .exit) {
                break;
            }
        }
    }
}
