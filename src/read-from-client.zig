const std = @import("std");
const linux = std.os.linux;
const log = std.log;

pub const AvailableInputs = enum {
    unknown,
    help,
    cpu,
    exit,
};

pub const Reader = struct {
    pub fn readMessageFromClient(client_fd: *const usize, buffer: []u8) usize {
       const bytes_read: usize = linux.read(@intCast(client_fd.*), buffer.ptr, buffer.len); 
       return bytes_read;
    }
    pub fn identifyCommand(buffer: []const u8) AvailableInputs {
        if (std.mem.eql(u8, buffer, "help")) {
            log.debug("(identifyCommand) help command hit.", .{});
            return .help;
        }
        if (std.mem.eql(u8, buffer, "cpu")) {
            log.debug("(identifyCommand) cpu command hit.", .{});
            return .cpu;
        }
        if (std.mem.eql(u8, buffer, "exit")) {
            log.debug("(identifyCommand) cpu command hit.", .{});
            return .exit;
        }
        else {
            log.debug("(identifyCommand) none command hit.", .{});
            return .unknown;
        }

    }
};
