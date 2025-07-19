const std = @import("std");
const rand = std.Random;

pub const RandomGen = struct {
    pub fn generateValueUpTo(min: i32, max: i32) i32 {
        const seed: u64 = @intCast(std.time.nanoTimestamp());
        var prng = rand.DefaultPrng.init(seed);

        const result = rand.intRangeAtMost(prng.random(), i32, min, max);
        return result;
    }
};
