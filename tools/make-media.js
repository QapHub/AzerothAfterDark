// Builds the addon's fixed textures (Media/logo.tga, dot.tga, placeholder.tga).
//   node tools/make-media.js [path/to/logo.png]
// News pictures (Media/news/*.tga) are written by the newsroom export, not here.
// TGAs are 32-bit, uncompressed, top-left origin (the format PartyBeacon's textures proved in Forever).
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const OUT = path.join(__dirname, '..', 'Media');
const LOGO = process.argv[2] || path.join(__dirname, '..', '..', 'wow-podcast', 'site', 'public', 'img', 'logo.png');
fs.mkdirSync(OUT, { recursive: true });

function tga(w, h, rgba) {
  const buf = Buffer.alloc(18 + w * h * 4);
  buf[2] = 2;
  buf.writeUInt16LE(w, 12);
  buf.writeUInt16LE(h, 14);
  buf[16] = 32;
  buf[17] = 0x28;
  for (let i = 0, o = 18; i < w * h; i++, o += 4) {
    buf[o] = rgba[i * 4 + 2];
    buf[o + 1] = rgba[i * 4 + 1];
    buf[o + 2] = rgba[i * 4];
    buf[o + 3] = rgba[i * 4 + 3];
  }
  return buf;
}

function rgbaOf(file, vf) {
  return execFileSync('ffmpeg', ['-v', 'error', '-i', file, '-vf', vf, '-frames:v', '1', '-f', 'rawvideo', '-pix_fmt', 'rgba', '-'], { maxBuffer: 64 << 20 });
}

function write(name, w, h, rgba) {
  fs.writeFileSync(path.join(OUT, name), tga(w, h, rgba));
  console.log('wrote', name, `${w}x${h}`);
}

// logo: the round After Dark badge, transparent outside the gold ring (the source has a dark square behind it)
{
  const S = 128;
  const px = Buffer.from(rgbaOf(LOGO, `scale=${S}:${S}:flags=lanczos`));
  const c = S / 2, R = S * 0.392; // ring outer radius in the 512px source is ~200px
  for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
    const d = Math.hypot(x + 0.5 - c, y + 0.5 - c);
    const a = Math.max(0, Math.min(1, R + 0.5 - d));
    px[(y * S + x) * 4 + 3] = Math.round(a * 255);
  }
  // scale the badge up so the ring fills the texture
  const big = Buffer.alloc(S * S * 4);
  const k = R / c;
  for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
    const sx = Math.min(S - 1, Math.max(0, Math.round(c + (x + 0.5 - c) * k - 0.5)));
    const sy = Math.min(S - 1, Math.max(0, Math.round(c + (y + 0.5 - c) * k - 0.5)));
    px.copy(big, (y * S + x) * 4, (sy * S + sx) * 4, (sy * S + sx) * 4 + 4);
  }
  write('logo.tga', S, S, big);
}

// dot: a soft white disc (tinted in game)
{
  const S = 32, px = Buffer.alloc(S * S * 4);
  for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
    const d = Math.hypot(x + 0.5 - S / 2, y + 0.5 - S / 2);
    const a = Math.max(0, Math.min(1, S / 2 - 1 - d + 0.5));
    px.set([255, 255, 255, Math.round(a * 255)], (y * S + x) * 4);
  }
  write('dot.tga', S, S, px);
}

// placeholder: night-sky gradient with the badge in the middle (stories without a picture)
{
  const W = 512, H = 256, px = Buffer.alloc(W * H * 4);
  for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
    const t = y / H, g = Math.hypot((x - W / 2) / W, (y - H / 2) / H);
    const r = 34 - 22 * t - 18 * g, gg = 22 - 14 * t - 12 * g, b = 58 - 30 * t - 24 * g;
    px.set([Math.max(6, r), Math.max(5, gg), Math.max(12, b), 255], (y * W + x) * 4);
  }
  const L = 96, logo = Buffer.from(rgbaOf(LOGO, `scale=${L}:${L}:flags=lanczos`));
  const ox = (W - L) / 2, oy = (H - L) / 2, c = L / 2, R = L * 0.392;
  for (let y = 0; y < L; y++) for (let x = 0; x < L; x++) {
    const d = Math.hypot(x + 0.5 - c, y + 0.5 - c);
    const a = Math.max(0, Math.min(1, R + 0.5 - d)) * 0.85;
    const i = ((oy + y) * W + ox + x) * 4, j = (y * L + x) * 4;
    for (let k = 0; k < 3; k++) px[i + k] = Math.round(px[i + k] * (1 - a) + logo[j + k] * a);
  }
  write('placeholder.tga', W, H, px);
}
