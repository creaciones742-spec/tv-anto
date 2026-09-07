// Vercel Serverless Function - Proxy para evitar CORS y servir streams HLS.
// Maneja:
//  - Páginas HTML de canales (texto).
//  - Playlists HLS (.m3u8): reescribe las URLs de segmentos/playlists a /api/proxy.
//  - Segmentos de video (.ts etc.): los pasa tal cual (binario).
export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, User-Agent, Accept, Referer, Range');
  res.setHeader('Access-Control-Expose-Headers', 'Content-Length, Content-Range');
  res.setHeader('Access-Control-Max-Age', '86400');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    const { url } = req.query;

    if (!url) {
      return res.status(400).json({ error: 'URL parameter is required' });
    }

    const targetUrl = decodeURIComponent(url);

    let origin;
    try {
      origin = new URL(targetUrl).origin + '/';
    } catch (e) {
      origin = 'https://streamtp-golden1.click/';
    }

    const response = await fetch(targetUrl, {
      method: 'GET',
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
        'Accept': '*/*',
        'Accept-Language': 'es-ES,es;q=0.9,en-US;q=0.8,en;q=0.7',
        'Referer': origin,
        'Origin': origin,
        'DNT': '1',
        'Connection': 'keep-alive'
      },
      redirect: 'follow'
    });

    if (!response.ok) {
      console.error(`Proxy error: ${response.status} - ${response.statusText} for URL: ${targetUrl}`);
      return res.status(response.status).json({
        error: `Error fetching URL: ${response.statusText}`,
        statusCode: response.status,
        url: targetUrl
      });
    }

    const ct = (response.headers.get('content-type') || '').toLowerCase();
    const baseUrl = response.url || targetUrl;

    // 1) Playlist HLS (.m3u8): reescribir URLs de segmentos/playlists -> /api/proxy
    if (ct.includes('mpegurl')) {
      const text = await response.text();
      const rewritten = text
        .split('\n')
        .map((line) => {
          const t = line.trim();
          if (t && !t.startsWith('#')) {
            let abs;
            try {
              abs = new URL(t, baseUrl).toString();
            } catch (e) {
              abs = t;
            }
            return '/api/proxy?url=' + encodeURIComponent(abs);
          }
          return line;
        })
        .join('\n');
      res.setHeader('Content-Type', 'application/vnd.apple.mpegurl');
      res.setHeader('Cache-Control', 'no-store');
      return res.status(200).send(rewritten);
    }

    // 2) Segmentos de video (binario): pasar tal cual
    if (
      ct.includes('mp2t') ||
      ct.includes('video/') ||
      ct.includes('octet-stream') ||
      targetUrl.includes('.ts')
    ) {
      const buf = Buffer.from(await response.arrayBuffer());
      res.setHeader('Content-Type', ct || 'application/octet-stream');
      return res.status(200).send(buf);
    }

    // 3) Página HTML (canales)
    const text = await response.text();
    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.setHeader('Cache-Control', 'public, max-age=60');
    return res.status(200).send(text);

  } catch (error) {
    console.error('Proxy error:', error);
    return res.status(500).json({
      error: 'Internal server error',
      details: error.message
    });
  }
}
