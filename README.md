# Zig UDP Echo Server
A Zig implementation of Simple UDP Echo Server

## Usage

server start (set ip address and port)
```bash
zig build run -- 127.0.0.1 8001
```

client test
```bash
nc -u 127.0.0.1 8001
```
