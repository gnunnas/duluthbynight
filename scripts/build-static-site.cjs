const fs=require('node:fs'),path=require('node:path');
const root=path.resolve(__dirname,'..'),output=path.join(root,'dist');
const runtimeFiles=[
  '_headers','index.html','forum.css','forum-data.js','forum.js',
  'campaign.html','manifest.webmanifest','styles.css','app.js','coterie.js',
  'campaign-loader.js','campaign-model.js','campaign-sanitizer.js',
  'record-editor.js','supabase-config.js','supabase-data.js','supabase-session.js'
];
const runtimeDirectories=['assets','vendor'];

fs.rmSync(output,{recursive:true,force:true});
fs.mkdirSync(output,{recursive:true});
for(const relative of runtimeFiles){
  const source=path.join(root,relative),destination=path.join(output,relative);
  if(!fs.existsSync(source))throw Error('Missing production file: '+relative);
  fs.mkdirSync(path.dirname(destination),{recursive:true});
  fs.copyFileSync(source,destination);
}
for(const relative of runtimeDirectories){
  const source=path.join(root,relative);
  if(!fs.existsSync(source))throw Error('Missing production directory: '+relative);
  fs.cpSync(source,path.join(output,relative),{recursive:true});
}
console.log(`Built ${runtimeFiles.length} files plus ${runtimeDirectories.join(' and ')} in dist/.`);
