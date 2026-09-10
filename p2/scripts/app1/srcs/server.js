import { createServer } from "node:http";

createServer((req, res) => {
    res.writeHead(200, {"Content-Type": "text/html"});
    res.end(`<h1>Hello from APP 1</h1>pod name: ${process.env.POD_NAME}\n`);
}).listen(3000);