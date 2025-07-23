const http = require("http");
const fs = require("fs");
const path = require("path");
const { spawn } = require("child_process");

const PORT = 8080;
const LOG_DIR = process.env.LOG_DIR ?? "/data/.logs";
const BG_IMAGE = path.join(__dirname, "bg.png");
const INDEX_HTML = path.join(__dirname, "index.html");

function handleIndex(req, res) {
  fs.readFile(INDEX_HTML, (err, data) => {
    res.writeHead(err ? 500 : 200, { "Content-Type": "text/html" });
    res.end(err ? "Server Error" : data);
  });
}

function handleImage(req, res) {
  fs.readFile(BG_IMAGE, (err, data) => {
    res.writeHead(err ? 404 : 200, { "Content-Type": "image/png" });
    res.end(err ? "" : data);
  });
}

function handleDownload(req, res) {
  if (!fs.existsSync(LOG_DIR)) {
    res.writeHead(404);
    return res.end("Log directory does not exist");
  }

  // busybox tar: -a 自动gzip，-c 创建，-f 输出到stdout，-C 进入目录，. 打包全部内容
  const tar = spawn("tar", ["-caf", "-", "-C", LOG_DIR, "."]);

  let closed = false;
  function closeOnce(status, msg) {
    if (!closed) {
      closed = true;
      try {
        res.writeHead(status);
      } catch {}
      res.end(msg);
      tar.kill("SIGKILL");
    }
  }

  res.writeHead(200, {
    "Content-Type": "application/gzip",
    "Content-Disposition": 'attachment; filename="logs.tar.gz"',
  });

  tar.stdout.pipe(res);

  tar.on("error", () => closeOnce(500, "Failed to spawn tar"));
  tar.stderr.on("data", () => {}); // 可以调试时打印
  tar.stdout.on("error", () => closeOnce(500, "Stream error"));
  res.on("close", () => {
    closed = true;
    tar.kill("SIGKILL");
  });
  tar.on("close", (code) => {
    if (code !== 0 && !closed) {
      closeOnce(500, "Failed to archive logs");
    }
  });
}

// 路由分发
http
  .createServer((req, res) => {
    if (req.method === "GET" && req.url === "/") return handleIndex(req, res);
    if (req.method === "GET" && req.url === "/bg.png")
      return handleImage(req, res);
    if (req.method === "POST" && req.url === "/download")
      return handleDownload(req, res);
    res.writeHead(404);
    res.end("Not Found");
  })
  .listen(PORT, () => {
    console.log("Server running: http://localhost:" + PORT);
  });
