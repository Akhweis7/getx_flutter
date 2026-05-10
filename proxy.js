const https = require('https');
const http = require('http');

const TARGET_HOST = '185.140.181.252';
const TARGET_BASE = '/kanban/api';
const PROXY_PORT = 8080;

// Bypass self-signed SSL cert (same as Flutter's HttpOverrides)
process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';

const server = http.createServer((req, res) => {
  // Add CORS headers to every response
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // Handle preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  const options = {
    hostname: TARGET_HOST,
    port: 443,
    path: TARGET_BASE + req.url,
    method: req.method,
    headers: { ...req.headers, host: TARGET_HOST },
  };

  const proxyReq = https.request(options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, {
      'Content-Type': proxyRes.headers['content-type'] || 'application/json',
      'Access-Control-Allow-Origin': '*',
    });
    proxyRes.pipe(res);
  });

  proxyReq.on('error', (e) => {
    console.error('Proxy error:', e.message);
    res.writeHead(500);
    res.end(JSON.stringify({ error: e.message }));
  });

  req.pipe(proxyReq);
});

server.listen(PROXY_PORT, () => {
  console.log('====================================');
  console.log(' CORS Proxy running on port ' + PROXY_PORT);
  console.log(' Forwarding to https://' + TARGET_HOST + TARGET_BASE);
  console.log(' Keep this window open!');
  console.log('====================================');
});
