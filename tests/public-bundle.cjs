const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),{execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),output=path.join(root,'dist');
execFileSync(process.execPath,[path.join(root,'scripts/build-static-site.cjs')],{stdio:'inherit'});

const forbidden=['AGENTS.md','README.md','docs','migration','previews','scripts','supabase','tests','data.js','campaign-additions.js','discipline-data.js','source-notes.js','watchtower-data.js','wrangler.jsonc','package.json'];
for(const relative of forbidden)assert(!fs.existsSync(path.join(output,relative)),`${relative} must not be published`);

const required=['index.html','campaign.html','_headers','vendor/dompurify.min.js','assets/duluth night.jpg'];
for(const relative of required)assert(fs.existsSync(path.join(output,relative)),`Missing published runtime file: ${relative}`);

const sandbox={window:{}};
vm.runInNewContext(fs.readFileSync(path.join(output,'supabase-config.js'),'utf8'),sandbox,{filename:'supabase-config.js'});
const config=sandbox.window.SUPABASE_CONFIG;
assert(config&&/^https:\/\/[a-z0-9-]+\.supabase\.co$/.test(config.url),'Supabase URL must be an HTTPS project URL');
assert(typeof config.publishableKey==='string'&&config.publishableKey.length>20,'A browser publishable key is required');
assert(!/^sb_secret_/i.test(config.publishableKey),'Secret Supabase keys must never enter the public bundle');
if(!/^sb_publishable_/i.test(config.publishableKey)){
  const parts=config.publishableKey.split('.');
  assert.equal(parts.length,3,'Legacy Supabase browser keys must be JWTs');
  const payload=JSON.parse(Buffer.from(parts[1],'base64url').toString('utf8'));
  assert.equal(payload.role,'anon','Only the legacy anon key is browser-safe');
}

const headers=fs.readFileSync(path.join(output,'_headers'),'utf8');
for(const directive of ["default-src 'self'","connect-src 'self' https://xrkvbbmilgdubbwuffhu.supabase.co","frame-ancestors 'none'","object-src 'none'","script-src 'self'","style-src 'self'"])assert(headers.includes(directive),`Missing CSP directive: ${directive}`);
assert(!/\sstyle=|\son(?:click|error|load)=/i.test(fs.readFileSync(path.join(output,'index.html'),'utf8')),'Public entry point must not require unsafe inline CSP');

function files(directory){return fs.readdirSync(directory,{withFileTypes:true}).flatMap(entry=>entry.isDirectory()?files(path.join(directory,entry.name)):[path.join(directory,entry.name)]);}
for(const file of files(output).filter(file=>/\.(?:html|js|css|json|webmanifest|txt)$/i.test(file))){
  const text=fs.readFileSync(file,'utf8');
  assert(!/-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|\bsb_secret_[A-Za-z0-9_-]+|\bgithub_pat_[A-Za-z0-9_]+|\bghp_[A-Za-z0-9]{20,}/.test(text),`Credential-shaped value found in ${path.relative(output,file)}`);
}
console.log('PASS: production bundle contains only runtime assets, a browser-safe Supabase key, and restrictive Cloudflare headers.');
