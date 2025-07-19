const std = @import("std");
const linux = std.os.linux;
const log = std.log;

pub const Socket = struct {
    opened_socket: usize = undefined,
    socket_address: linux.sockaddr.in = .{
        .family = linux.AF.INET,
        .port = std.mem.nativeToBig(u16, 40050), // Port number.
        .addr = std.mem.nativeToBig(u32, 0),     // Address to listen on, 0 being all interfaces.
    },
    sock_len: linux.socklen_t = @sizeOf(linux.sockaddr.in),
    queue_len: u32 = undefined,
        
    pub fn init() Socket {
        return .{};
    }
    pub fn initSocket(self: *Socket) void {
        self.createSocket();
        self.bindSocket();
        self.listenOnSocket();
    }
    pub fn closeSocket(self: *Socket) void {
        if (linux.close(@intCast(self.opened_socket)) != 0) {
            log.debug("Failed to close the socket!", .{});
        }
        log.debug("Socket closed!", .{});
    }
    fn createSocket(self: *Socket) void {
        self.opened_socket = linux.socket(linux.AF.INET, linux.SOCK.STREAM , 0);
        log.debug("Socket: {d}.", .{self.opened_socket});
    }
    fn bindSocket(self: *Socket) void {
        const result = linux.bind(@intCast(self.opened_socket), @ptrCast(&self.socket_address), self.sock_len);
        if (@as(isize, @bitCast(result)) == -1) {
            log.err("Cannot bind socket!", .{});
        }
        log.debug("Bind Result: {d}.", .{result});
    }
    fn listenOnSocket(self: *Socket) void {
        if (linux.listen(@intCast(self.opened_socket), self.queue_len) != 0) {
            std.log.err("Could not listen on socket!", .{});
        }
    }
    pub fn acceptConnection(self: *Socket) usize {
        const client_fd = linux.accept(@intCast(self.opened_socket), @ptrCast(&self.socket_address), &self.sock_len); 
        if (@as(isize, @bitCast(client_fd)) == -1) {
            log.err("Cannot accept socket {d}.", .{client_fd});
        }    
        return client_fd;
    }
};
