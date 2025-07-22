const std = @import("std");
const log = std.log;

const available_commands_enum = @import("read-from-client.zig").AvailableInputs;

pub const CommandParser = struct {
    pub fn parseCommand(chosen_command: available_commands_enum) void {
        switch (chosen_command) {
            .unknown => {
                unknownCommand();
            },
            .cpu => {
                cpuCommand();
            },
            .help => {
                helpCommand();
            },
        }
    }
    fn unknownCommand() void {
        // TODO
        log.debug("(unknownCommand) Called!", .{});
    }
    fn helpCommand() void {
        // TODO
        log.debug("(helpCommand) Called!", .{});
    }
    fn cpuCommand() void {
        // TODO
        log.debug("(cpuCommand) Called!", .{});
    }
};
