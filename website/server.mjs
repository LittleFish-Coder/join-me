import { createServer } from "node:http";
import { appendFile, mkdir, readFile, stat } from "node:fs/promises";
import { extname, join, normalize } from "node:path";
import { fileURLToPath } from "node:url";

const root = fileURLToPath(new URL("./public", import.meta.url));
const dataDir = fileURLToPath(new URL("./data", import.meta.url));
const port = Number(process.env.PORT || 4173);
const mimeTypes = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".jpeg": "image/jpeg",
  ".jpg": "image/jpeg",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".png": "image/png",
  ".svg": "image/svg+xml",
  ".webp": "image/webp"
};

function sendJson(response, status, body) {
  response.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store"
  });
  response.end(JSON.stringify(body));
}

async function bodyAsJson(request) {
  let raw = "";
  for await (const chunk of request) {
    raw += chunk;
    if (raw.length > 32_000) throw new Error("payload_too_large");
  }
  return JSON.parse(raw || "{}");
}

function validEmail(value) {
  return typeof value === "string" && value.length <= 254 && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
}

async function handleApi(request, response) {
  if (request.method !== "POST") {
    sendJson(response, 405, { ok: false, message: "Method not allowed" });
    return;
  }

  try {
    const body = await bodyAsJson(request);
    await mkdir(dataDir, { recursive: true });

    if (request.url === "/api/waitlist") {
      if (!validEmail(body.email)) {
        sendJson(response, 400, { ok: false, message: "請輸入有效的 Email。" });
        return;
      }
      const record = {
        email: body.email.trim().toLowerCase(),
        source: String(body.source || "website").slice(0, 80),
        createdAt: new Date().toISOString()
      };
      await appendFile(join(dataDir, "waitlist.ndjson"), `${JSON.stringify(record)}\n`, { mode: 0o600 });
      sendJson(response, 201, { ok: true, message: "已加入測試名單。" });
      return;
    }

    if (request.url === "/api/support") {
      if (!validEmail(body.email) || typeof body.message !== "string" || body.message.trim().length < 10) {
        sendJson(response, 400, { ok: false, message: "請留下有效 Email，並至少輸入 10 個字。" });
        return;
      }
      const record = {
        email: body.email.trim().toLowerCase(),
        topic: String(body.topic || "其他問題").slice(0, 80),
        message: body.message.trim().slice(0, 3000),
        createdAt: new Date().toISOString()
      };
      await appendFile(join(dataDir, "support.ndjson"), `${JSON.stringify(record)}\n`, { mode: 0o600 });
      sendJson(response, 201, { ok: true, message: "訊息已送出，我們會盡快回覆。" });
      return;
    }
  } catch (error) {
    const status = error.message === "payload_too_large" ? 413 : 400;
    sendJson(response, status, { ok: false, message: "資料格式有誤，請稍後再試。" });
    return;
  }

  sendJson(response, 404, { ok: false, message: "Not found" });
}

async function serveStatic(request, response) {
  const rawPath = decodeURIComponent((request.url || "/").split("?")[0]);
  const pagePath = rawPath === "/" ? "/index.html" : rawPath.endsWith("/") ? `${rawPath}index.html` : rawPath;
  const safePath = normalize(pagePath).replace(/^(\.\.(\/|\\|$))+/, "");
  let filePath = join(root, safePath);

  try {
    const fileStat = await stat(filePath);
    if (fileStat.isDirectory()) filePath = join(filePath, "index.html");
    const content = await readFile(filePath);
    response.writeHead(200, {
      "Content-Type": mimeTypes[extname(filePath)] || "application/octet-stream",
      "Cache-Control": extname(filePath) === ".html" ? "no-cache" : "public, max-age=86400"
    });
    response.end(content);
  } catch {
    const notFound = await readFile(join(root, "404.html"));
    response.writeHead(404, { "Content-Type": "text/html; charset=utf-8" });
    response.end(notFound);
  }
}

const server = createServer(async (request, response) => {
  response.setHeader("X-Content-Type-Options", "nosniff");
  response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
  response.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
  if (request.url?.startsWith("/api/")) return handleApi(request, response);
  return serveStatic(request, response);
});

server.listen(port, "127.0.0.1", () => {
  console.log(`揪ㄇ網站已啟動：http://127.0.0.1:${port}`);
});
