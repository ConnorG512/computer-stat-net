const std = @import("std");
const linux = std.os.linux;
const log = std.log;

pub const AvailableCommands = enum {
    none,
    help,
};

pub const Reader = struct {
    pub fn readMessageFromClient(client_fd: *const usize, buffer: []u8) usize {
       const bytes_read: usize = linux.read(@intCast(client_fd.*), buffer.ptr, buffer.len); 
       return bytes_read;
    }
    pub fn identifyCommand(buffer: []const u8) AvailableCommands {
        if (std.mem.eql(u8, buffer, "help")) {
            log.debug("(identifyCommand) help command hit.", .{});
            return .help;
        }
        else {
            log.debug("(identifyCommand) none command hit.", .{});
            return .none;
        }

    }
};
