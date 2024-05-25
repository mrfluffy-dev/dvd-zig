// zig fmt: off
const rl = @import("raylib");
const rm = @import("raylib-math");
const std = @import("std");

pub fn getRandomColor() rl.Color {
    return rl.Color{
        .r = @intCast(rl.getRandomValue(100, 255)),
        .g = @intCast(rl.getRandomValue(100, 255)),
        .b = @intCast(rl.getRandomValue(100, 255)),
        .a = @as(u8, 255)
    };
}

pub fn main() anyerror!void {
    const screenWidth = 1920;
    const screenHeight = 1080;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig dvd animation");
    defer rl.closeWindow();

    rl.setTargetFPS(75);
    rl.toggleFullscreen();
    rl.hideCursor();

    // TODO: embed logo into binary (method below is horribly inefficient)
    // const t = rl.loadImage("logo.png");
    // _ = rl.exportImageAsCode(t,"image.zig");

    const logo = rl.loadTexture("/home/zen/dvd/logo.png");
    defer rl.unloadTexture(logo);

    var playerPos = rl.Vector2{
        .x = @floatFromInt(rl.getRandomValue(0,screenWidth)),
        .y = @floatFromInt(rl.getRandomValue(0,screenHeight))
    };
    var playerVel = rl.Vector2{ .x = 200, .y = 250 };

    var randomColor = getRandomColor();

    const logoWidth: f32 = @floatFromInt(logo.width);
    const logoHeight: f32 = @floatFromInt(logo.height);
    const logoScale: f32 = 0.1;

    while (!rl.windowShouldClose()) {
        // ---- LOGIC ---- //
        const dt = rl.getFrameTime();
        playerPos.x += playerVel.x * dt;
        playerPos.y += playerVel.y * dt;

        if (playerPos.x < 0 or (playerPos.x + (logoWidth * logoScale)) > @as(f32, screenWidth)) {
            playerVel.x *= -1;
            randomColor = getRandomColor();
        }
        if (playerPos.y < 0 or (playerPos.y + (logoHeight * logoScale)) > @as(f32, screenHeight)) {
            playerVel.y *= -1;
            randomColor = getRandomColor();
        }

        // ---- DRAW ---- //
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawTextureEx(logo, playerPos, 0, logoScale, randomColor);
        rl.clearBackground(rl.Color.black);

        // rl.drawFPS(50, 50);
        // rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);
    }
}
