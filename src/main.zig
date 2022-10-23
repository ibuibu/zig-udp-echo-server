const std = @import("std");
const network = @import("network");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        std.debug.print("Invalid arguments.", .{});
        std.os.exit(1);
    }

    try network.init();
    defer network.deinit();

    var sock = try network.Socket.create(.ipv4, .udp);
    defer sock.close();

    const v4_address = try network.Address.IPv4.parse(args[1]);
    const port: u16 = try std.fmt.parseInt(u16, args[2], 10);

    try sock.bind(.{
        .address = .{ .ipv4 = v4_address },
        .port = port,
    });

    const buflen: usize = 128;
    var msg: [buflen]u8 = undefined;
    while (true) {
        const recv_msg = try sock.receiveFrom(msg[0..buflen]);
        std.debug.print("{s}", .{msg});
        _ = try sock.sendTo(recv_msg.sender, msg[0..buflen]);
    }
}

