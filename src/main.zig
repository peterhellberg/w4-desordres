const std = @import("std");
const w4 = @import("w4");

var prng = std.rand.DefaultPrng.init(0);
const random = prng.random();

const Cart = struct {
    button: w4.Button = .{},

    palettes: [18][4]u32 = .{
        .{ 0x332c50, 0x46878f, 0x94e344, 0xe2f3e4 }, // kirokaze-gameboy
        .{ 0x7c3f58, 0xeb6b6f, 0xf9a875, 0xfff6d3 }, // ice-cream-gb
        .{ 0x211e20, 0x555568, 0xa0a08b, 0xe9efec }, // 2-bit-demichrome
        .{ 0x2d1b00, 0x1e606e, 0x5ab9a8, 0xc4f0c2 }, // mist-gb
        .{ 0x2c2137, 0x764462, 0xedb4a1, 0xa96868 }, // rustic-gb
        .{ 0x000000, 0x676767, 0xb6b6b6, 0xffffff }, // 2-bit-grayscale
        .{ 0x0f0f1b, 0x565a75, 0xc6b7be, 0xfafbf6 }, // hollow
        .{ 0x00303b, 0xff7777, 0xffce96, 0xf1f2da }, // ayy4
        .{ 0x081820, 0x346856, 0x88c070, 0xe0f8d0 }, // nintendo-gameboy-bgb
        .{ 0xeff9d6, 0xba5044, 0x7a1c4b, 0x1b0326 }, // crimson
        .{ 0xd0d058, 0xa0a840, 0x708028, 0x405010 }, // nostalgia
        .{ 0xf8e3c4, 0xcc3495, 0x6b1fb1, 0x0b0630 }, // spacehaze
        .{ 0x0f052d, 0x203671, 0x36868f, 0x5fc75d }, // moonlight-gb
        .{ 0x5a3921, 0x6b8c42, 0x7bc67b, 0xffffb5 }, // links-awakening-sgb
        .{ 0xffffff, 0x6772a9, 0x3a3277, 0x000000 }, // arq4
        .{ 0x002b59, 0x005f8c, 0x00b9be, 0x9ff4e5 }, // blk-aqu4
        .{ 0x181010, 0x84739c, 0xf7b58c, 0xffefff }, // pokemon-sgb
        .{ 0x331e50, 0xa63725, 0xd68e49, 0xf7e7c6 }, // nintendo-super-gameboy
    },

    colors: [20]u16 = .{ 0x01, 0x11, 0x21, 0x31, 0x41, 0x02, 0x12, 0x22, 0x32, 0x42, 0x03, 0x13, 0x23, 0x33, 0x43, 0x04, 0x14, 0x24, 0x34, 0x44 },

    squares: [256][2]u16 = [_][2]u16{.{ 0, 0 }} ** 256,

    fn start(c: *Cart) void {
        c.updatePalette();
        c.updateSquares();
    }

    fn update(c: *Cart) void {
        c.button.update();

        if (c.button.pressed(0, w4.BUTTON_2)) {
            c.updatePalette();
        }

        if (c.button.pressed(0, w4.BUTTON_1)) {
            c.updateSquares();
        }
    }

    fn draw(c: *Cart) void {
        c.drawSquares();
    }

    fn randomPalette(c: *Cart) [4]u32 {
        return c.palettes[random.intRangeAtMost(usize, 0, c.palettes.len - 1)];
    }

    fn randomColor(c: *Cart) u16 {
        return c.colors[random.intRangeAtMost(usize, 0, c.colors.len - 1)];
    }

    fn updatePalette(c: *Cart) void {
        w4.palette(c.randomPalette());
    }

    fn updateSquares(c: *Cart) void {
        for (&c.squares) |*s| {
            s[0] = c.randomColor();
            s[1] = c.randomColor();
        }
    }

    fn drawSquares(c: *Cart) void {
        for (0.., c.squares) |i, s| {
            const n: i32 = @intCast(i);
            const x: i32 = @mod(n, 16);
            const y: i32 = @divTrunc(n, 16);

            w4.color(s[0]);
            w4.rect(x * 10, y * 10, 10, 10);
            w4.color(s[1]);
            w4.rect(x * 10 + 2, y * 10 + 2, 6, 6);
        }
    }
};

var cart = Cart{};

export fn start() void {
    cart.start();
}

export fn update() void {
    cart.update();
    cart.draw();
}
