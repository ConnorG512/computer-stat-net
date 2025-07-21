const std = @import("std");
const linux = std.os.linux;

pub const Reader = struct {
    pub fn readMessageFromClient(client_fd: *const usize, buffer: []u8) usize {
       const bytes_read: usize = linux.read(@intCast(client_fd.*), buffer.ptr, buffer.len); 
       return bytes_read;
    }
};
