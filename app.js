const D = window.CAMPAIGN;
const app = document.querySelector('#app');
const nav = document.querySelector('#nav');
const menu = document.querySelector('#menuBtn');
const model = createCampaignModel(D);
const collections = model.collections;
const labels = { people: 'People', places: 'Places', threads: 'Active threads', organizations: 'Organizations', clans: 'Clans', schemes: 'Schemes', events: 'Events', chronicle: 'Chronicle', disciplines: 'Disciplines', powers: 'Abilities' };
const areaKinds = new Set(['City', 'Community', 'District', 'Suburb', 'Territory']);
let state = { route: 'home', id: null, filter: 'All', query: '' };
const escapeHTML = value => String(value ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const by = model.by;
const name = record => record.name || record.title;
const url = (type, id) => `#${type}${id ? '/' + encodeURIComponent(id) : ''}`;
function link(type, record) { return `<a href="${url(type, record.id)}">${escapeHTML(name(record))}</a>`; }
function card(record, type) {
  if (!record) return '';
  return `<a class="card" href="${url(type, record.id)}"><div class="meta">${escapeHTML(record.type || record.kind || record.date || labels[type])}${record.clan ? ' · ' + escapeHTML(by('clans', record.clan)?.name || 'Unknown') : ''}</div><h3>${escapeHTML(name(record))}</h3><p>${escapeHTML(record.summary || (['clans', 'organizations'].includes(type) ? 'View recorded connections.' : 'No summary recorded.'))}</p></a>`;
}
function section(title, records, type) {
  return records.length ? `<section class="related"><h2 class="section-title">${escapeHTML(title)}</h2><div class="grid two">${records.map(x => card(x, type)).join('')}</div></section>` : '';
}
function relations(type, record) {
  const titles = type === 'people' ? {clans:'Clan', organizations:'Organizations & affiliations'} : {people: type === 'clans' ? 'Recorded clan members' : type === 'organizations' ? 'Recorded members & associates' : 'Related people'};
  const displayedLinks = new Set();
  if (type === 'people') {
    if (record.clan) displayedLinks.add(by('clans', record.clan)?.recordId);
    for (const entry of [...record.memberships, ...record.affiliations]) displayedLinks.add(entry.organizationId);
    for (const id of record.places) displayedLinks.add(by('places', id)?.recordId);
    for (const entry of model.itemsFor(record.recordId)) {
      if (entry.titleRecordId) displayedLinks.add(entry.titleRecordId);
      if(entry.value?.referenceRecordId)displayedLinks.add(entry.value.referenceRecordId);
      for(const ability of entry.value?.abilities||[])if(ability.recordId)displayedLinks.add(ability.recordId);
      for (const reference of entry.links || []) displayedLinks.add(reference.recordId);
    }
    for (const relationship of model.personalRelationships(record.recordId)) {
      displayedLinks.add(by('people', relationship.from === record.id ? relationship.to : relationship.from)?.recordId);
    }
  }
  return Object.entries(model.related(type, record)).map(([key, records]) => [key, records.filter(target => !displayedLinks.has(target.recordId))]).map(([key, records]) => {
    if (!records.length) return '';
    const title = titles[key] || `Related ${labels[key].toLowerCase()}`;
    return `<section class="related"><h2 class="section-title">${escapeHTML(title)}</h2><ul class="record-links">${records.map(target => `<li><a class="record-link" href="${url(key, target.id)}">${escapeHTML(name(target))}<span aria-hidden="true">↗</span></a></li>`).join('')}</ul></section>`;
  }).join('');
}
function membershipFacts(entries) {
  return entries?.length ? entries.map(entry => {
    const target = by('organizations', entry.organizationId);
    const via = entry.paths.filter(path => path.implicationIds.length).map(path => 'via ' + path.organizationIds.slice(0, -1).map(id => model.byId(id).name).join(' → '));
    const directLabel = entry.connectionTypes.includes('associate_of') ? 'Association' : entry.connectionTypes.includes('member_of') ? 'Membership' : 'Affiliation';
    const description = [entry.direct ? directLabel : null, ...via].filter(Boolean).join('; ');
    return `${target ? link('organizations', target) : 'Unknown'} <span class="meta">— ${escapeHTML(description)} · Role: ${escapeHTML(entry.role || 'Unknown')}</span>`;
  }).join('<br>') : 'Unknown';
}
function referenceLink(id, label) {
  const target = model.byId(id);
  return target ? `<a href="${url(model.routeFor(target), target.id)}">${escapeHTML(label || name(target))}</a>` : escapeHTML(label || 'Unknown');
}
function textWithLinks(text, links = []) {
  let remaining = String(text ?? ''), html = '';
  const references = links.filter(x => x.text && model.byId(x.recordId));
  while (remaining) {
    const candidates = references.map(x => ({...x, index: remaining.indexOf(x.text)})).filter(x => x.index >= 0).sort((a,b) => a.index - b.index || b.text.length - a.text.length);
    if (!candidates.length) return html + escapeHTML(remaining);
    const next = candidates[0];
    html += escapeHTML(remaining.slice(0, next.index)) + referenceLink(next.recordId, next.text);
    remaining = remaining.slice(next.index + next.text.length);
  }
  return html;
}
function panel(title, html, extraClass = '') {
  return html ? `<section class="npc-panel ${extraClass}"><h2>${escapeHTML(title)}</h2>${html}</section>` : '';
}
function flexibleSections(record, mechanicOnly = false) {
  const items = model.itemsFor(record.recordId);
  return model.sectionsFor(record.recordId).map(section => {
    if (['facts','overview'].includes(section.templateKey)) return '';
    const entries = items.filter(x => x.sectionId === section.id && x.fieldKey !== 'relationship.role' && (x.body || x.title || x.itemKind === 'mechanic'));
    if (!entries.length) return '';
    const isMechanic = entries.every(x => x.itemKind === 'mechanic');
    if (record.recordType === 'person' && isMechanic !== mechanicOnly) return '';
    if (isMechanic) {
      return panel(section.heading, `<div class="mechanic-grid">${entries.map(entry => {
        const title = entry.value.referenceRecordId ? referenceLink(entry.value.referenceRecordId, entry.title) : escapeHTML(entry.title);
        const specialties = entry.value.specialties?.length ? `<p class="mechanic-notes">Specialties: ${entry.value.specialties.map(escapeHTML).join(', ')}</p>` : '';
        const abilities = entry.fieldKey === 'mechanics.discipline' ? entry.value.abilities?.length ? `<ul class="ability-list">${entry.value.abilities.map(ability => `<li>${ability.recordId ? referenceLink(ability.recordId, ability.name).replace('<a ', '<a data-ability-popup="'+escapeHTML(ability.recordId)+'" aria-haspopup="dialog" ') : escapeHTML(ability.name)}${ability.notes ? `<p>${escapeHTML(ability.notes)}</p>` : ''}</li>`).join('')}</ul>` : '<p class="mechanic-notes">Selected abilities not recorded.</p>' : '';
        return `<div class="mechanic-entry"><div class="mechanic-heading"><h3>${title}</h3><span class="rating" aria-label="Rating ${escapeHTML(entry.value.rating)}">${escapeHTML(entry.value.rating)}</span></div>${specialties}${abilities}</div>`;
      }).join('')}</div>`, `mechanics-panel ${section.templateKey === 'disciplines' ? 'disciplines-panel' : ''}`);
    }
    function renderEntry(entry) {
      const children = entries.filter(x => x.parentItemId === entry.id);
      const title = entry.title ? `<h3>${entry.titleRecordId ? referenceLink(entry.titleRecordId, entry.title) : escapeHTML(entry.title)}</h3>` : '';
      const structural = entry.titleRecordId && record.recordType === 'person' ? model.personalRelationships(record.recordId).filter(x => x.kind !== 'association' && by('people', x.from === record.id ? x.to : x.from)?.recordId === entry.titleRecordId) : [];
      const context = structural.length ? `<p class="connection-context">${structural.map(x => escapeHTML(x.label)).join(' · ')}</p>` : '';
      return `<li>${title}${context}${entry.body ? `<p>${textWithLinks(entry.body, entry.links)}</p>` : ''}${children.length ? `<ul>${children.map(renderEntry).join('')}</ul>` : ''}</li>`;
    }
    return panel(section.heading, `<ul class="note-list">${entries.filter(x => !x.parentItemId).map(renderEntry).join('')}</ul>`);
  }).join('');
}
function personSections(record) {
  const connectionBoxes = [];
  if (record.memberships.length) connectionBoxes.push(panel('Groups & associates', membershipFacts(record.memberships)));
  if (record.affiliations.length) connectionBoxes.push(panel('Political affiliations', membershipFacts(record.affiliations)));
  const relationships = model.personalRelationships(record.recordId);
  const covered = new Set(model.itemsFor(record.recordId).filter(x => x.titleRecordId).map(x => x.titleRecordId));
  const additional = relationships.filter(x => !covered.has(by('people', x.from === record.id ? x.to : x.from)?.recordId));
  if (additional.length) connectionBoxes.push(panel('Personal connections', `<ul class="note-list">${additional.map(x => {
    const target = by('people', x.from === record.id ? x.to : x.from);
    return `<li>${target ? link('people', target) : 'Unknown'} — ${escapeHTML(x.label || 'Association; specific relationship unknown')}</li>`;
  }).join('')}</ul>`));
  if (record.places.length && !model.sectionsFor(record.recordId).some(x => x.templateKey === 'domain-and-haven')) connectionBoxes.push(panel('Associated places', `<ul class="record-links">${record.places.map(id => `<li>${link('places', by('places', id))}</li>`).join('')}</ul>`));
  return `${flexibleSections(record, true)}<div class="npc-sections">${connectionBoxes.join('')}${flexibleSections(record)}</div>`;
}
function organizationHierarchy(type, record) {
  const ancestors = [], seen = new Set([record.id]);
  let parent = by(type, record.parent);
  while (parent && !seen.has(parent.id)) { ancestors.unshift(parent); seen.add(parent.id); parent = by(type, parent.parent); }
  return `${ancestors.length ? `<nav class="crumbs" aria-label="Organization hierarchy">${ancestors.map(x => link(type, x)).join(' / ')} / ${escapeHTML(record.name)}</nav>` : ''}${section('Subgroups', collections[type].filter(x => x.parent === record.id), type)}`;
}
function breadcrumbs(record) {
  const ancestors = [], seen = new Set([record.id]);
  let parent = by('places', record.parent);
  while (parent && !seen.has(parent.id)) { ancestors.unshift(parent); seen.add(parent.id); parent = by('places', parent.parent); }
  return `<nav class="crumbs" aria-label="Place hierarchy"><a href="#places">Places</a>${ancestors.map(x => ' / ' + link('places', x)).join('')} / <span>${escapeHTML(name(record))}</span></nav>`;
}
function placeChildren(record) {
  const children = collections.places.filter(x => x.parent === record.id);
  return section('Geographic areas', children.filter(x => areaKinds.has(x.kind)), 'places') + section('Individual locations', children.filter(x => !areaKinds.has(x.kind)), 'places');
}
function detail(type, id) {
  const record = by(type, id);
  if (!record) return missing();
  if(type === 'disciplines' || type === 'powers')return disciplineDetail(type,record);
  const facts = [];
  if (type === 'people') {
    const clan = by('clans', record.clan);
    if (record.type) facts.push(['Nature / type', escapeHTML(record.type)]);
    if (clan || record.type) facts.push(['Clan', clan ? link('clans', clan) : record.type === 'Mortal' ? 'Not applicable' : 'Unknown']);
    const fields = [['person.ambition','Ambition'],['person.humanity','Humanity'],['person.generation','Generation'],['person.bloodPotency','Blood Potency'],['person.health','Health'],['person.willpower','Willpower']];
    for (const [key,label] of fields) {
      const item = model.itemsFor(record.recordId).find(x => x.fieldKey === key);
      if (item) facts.push([label, textWithLinks(String(item.value), item.links)]);
    }
    if (record.affiliationStatus) facts.push(['Affiliation status', escapeHTML(record.affiliationStatus)]);
  }
  if (type === 'organizations') facts.push(['Organization type', escapeHTML(record.kind || 'Unknown')], ['Parent organization', by('organizations', record.parent) ? link('organizations', by('organizations', record.parent)) : 'Unknown']);
  if (type === 'places') {
    facts.push(['Place type', escapeHTML(record.kind)]);
    if (record.reviewIssues?.some(x => x.displayMessage)) facts.push(['Geography', escapeHTML(record.reviewIssues.filter(x => x.displayMessage).map(x => x.displayMessage).join(' '))]);
    if (record.domain) {
      facts.push(['Domain', 'Recorded claim'], ['Claimant', escapeHTML(record.domain.claimant || 'Unknown')]);
    }
  }
  if (type === 'chronicle') facts.push(['Session date', escapeHTML(record.date || 'Unknown')]);
  return `<article class="detail ${type === 'people' ? 'npc-detail' : ''}"><a class="back" href="#${type}">← ${labels[type]}</a>${type === 'places' ? breadcrumbs(record) : `<div class="crumbs">${escapeHTML(labels[type])}</div>`}<h1>${escapeHTML(name(record))}</h1>${record.summary ? `<p>${escapeHTML(record.summary)}</p>` : ''}${facts.length ? `<dl class="facts">${facts.map(([label, value], index) => `<div class="${label === 'Ambition' || (index === facts.length - 1 && (facts.length - facts.filter(([key]) => key === 'Ambition').length) % 2 === 1) ? 'fact-wide' : ''}"><dt>${label}</dt><dd>${value}</dd></div>`).join('')}</dl>` : ''}${type === 'people' ? personSections(record) : flexibleSections(record)}${type === 'places' ? placeChildren(record) : ''}${type === 'organizations' ? organizationHierarchy(type, record) : ''}${relations(type, record)}</article>`;
}

function disciplineDetail(type, record) {
  if(type === 'disciplines') {
    const abilities=collections.powers.filter(x=>x.disciplineId===record.recordId);
    return `<article class="detail"><a class="back" href="#disciplines">← Disciplines</a><h1>${escapeHTML(record.name)}</h1>${record.summary ? `<p>${escapeHTML(record.summary)}</p>` : ''}${abilities.length ? [1,2,3,4,5].map(level=>{
      const entries=abilities.filter(x=>x.level===level);
      return entries.length ? panel('Level '+level, `<ul class="record-links">${entries.map(x=>`<li><a class="record-link" href="${url('powers',x.id)}">${escapeHTML(x.name)}<span aria-hidden="true">↗</span></a>${x.summary ? `<p>${escapeHTML(x.summary)}</p>` : '<p class="mechanic-notes">Rules not yet recorded.</p>'}</li>`).join('')}</ul>`) : '';
    }).join('') : '<p class="empty">No abilities recorded yet.</p>'}</article>`;
  }
  const discipline=model.byId(record.disciplineId), items=model.itemsFor(record.recordId);
  const get=key=>items.find(x=>x.fieldKey===key);
  const facts=[['Level',String(record.level)],...['cost','dicePools','duration'].map(key=>[({cost:'Cost',dicePools:'Dice pools',duration:'Duration'})[key],get('power.'+key)?.body]).filter(([,value])=>value)];
  return `<article class="detail power-detail"><nav class="crumbs" aria-label="Discipline hierarchy"><a href="#disciplines">Disciplines</a> / ${referenceLink(discipline.recordId)} / Level ${record.level}</nav><h1>${escapeHTML(record.name)}</h1>${record.summary ? `<p>${escapeHTML(record.summary)}</p>` : '<p class="empty">Rules not yet recorded.</p>'}<dl class="facts">${facts.map(([label,value])=>`<div><dt>${label}</dt><dd>${escapeHTML(value)}</dd></div>`).join('')}</dl>${['system','notes'].map(key=>get('power.'+key)?.body ? panel(key==='system'?'System':'Notes',`<p class="rules-text">${escapeHTML(get('power.'+key).body)}</p>`) : '').join('')}</article>`;
}

function home() {
  const tonight = model.tonight;
  return `<section class="hero">${tonight.heroImage ? `<img class="hero-image" src="${escapeHTML(tonight.heroImage.src)}" alt="${escapeHTML(tonight.heroImage.alt)}" fetchpriority="high" decoding="async">` : ''}<div class="eyebrow">VAMPIRE: THE MASQUERADE // LAKE SUPERIOR</div><h1>DULUTH<br>BY NIGHT</h1><p>The lake is black. The harbor never sleeps. Every favor leaves a mark.</p></section><section class="status">${tonight.status.map(([label, value]) => `<div><small>${escapeHTML(label)}</small>${escapeHTML(value)}</div>`).join('')}</section><h2 class="section-title">Tonight in Duluth</h2><section class="card recap"><div class="eyebrow">WHERE WE LEFT OFF // ${escapeHTML(collections.chronicle[0].date)}</div><h2>${link('places', by('places', tonight.place))}</h2><p>${escapeHTML(tonight.summary)}</p><p>${escapeHTML(tonight.followup)}</p><div class="badges">${['portia', 'spokes'].map(id => link('people', by('people', id))).join(' ')} ${['chantry', 'bliss'].map(id => link('places', by('places', id))).join(' ')}</div></section>${section('Active threads', collections.threads, 'threads')}${section('Latest chronicle', collections.chronicle.slice(0, 1), 'chronicle')}${section('Faces to remember', tonight.faces.map(id => by('people', id)), 'people')}`;
}
function listing(type) {
  if(type === 'disciplines')return `<h1>Disciplines</h1><p class="intro">Browse a discipline, then its abilities by level. NPC ratings and selected abilities link here for use during play.</p><div class="grid three">${collections.disciplines.map(record=>`<a class="card" href="${url(type,record.id)}"><h2>${escapeHTML(record.name)}</h2><p>${collections.powers.filter(x=>x.disciplineId===record.recordId).length} abilities recorded</p></a>`).join('')}</div>`;
  if (type === 'places') return `<h1>Places</h1><p class="intro">Choose a city or community, then explore its districts, suburbs, and individual locations. Locations with no recorded district remain directly under their city.</p>${section('Cities, communities & regions', collections.places.filter(x => !x.parent && areaKinds.has(x.kind)), 'places')}${section('Locations without recorded geography', collections.places.filter(x => !x.parent && !areaKinds.has(x.kind)), 'places')}`;
  let records = collections[type];
  if(type === 'people') records = [...records].sort((a,b)=>name(a).localeCompare(name(b),'en',{sensitivity:'base',numeric:true}));
  if (type === 'organizations' && state.category) records = records.filter(x => x.category === state.category);
  let filters = '';
  if (type === 'people') {
    filters = `<div class="filters" aria-label="Filter people">${['All', ...new Set(collections.people.map(x => x.type).filter(Boolean))].map(value => `<button class="chip ${state.filter === value ? 'active' : ''}" aria-pressed="${state.filter === value}" data-filter="${escapeHTML(value)}">${escapeHTML(value)}</button>`).join('')}</div>`;
    if (state.filter !== 'All') records = records.filter(x => x.type === state.filter);
  }
  return `<h1>${labels[type]}</h1>${['clans', 'organizations'].includes(type) ? '<p class="intro">Recorded connections only. Unknown roles, lineage, and organizational hierarchy remain unknown.</p>' : ''}${type === 'people' ? '<div class="filters"><a class="chip" href="#clans">Browse clans</a><a class="chip" href="#organizations?category=group">Browse groups</a><a class="chip" href="#organizations?category=political">Political affiliations</a></div>' : ''}${filters}<div class="grid three">${records.map(x => card(x, type)).join('')}</div>`;
}
function searchResults() {
  const query = state.query.trim().toLocaleLowerCase();
  if (!query) return '<p class="empty">Search names, summaries, clans, and affiliations across the campaign.</p>';
  const matches = Object.entries(collections).map(([type, records]) => [type, records.filter(record => model.searchText(type, record).includes(query))]);
  const count = matches.reduce((sum, [, records]) => sum + records.length, 0);
  return `<p role="status">${count} ${count === 1 ? 'record' : 'records'} found.</p>${count ? matches.map(([type, records]) => section(labels[type], records, type)).join('') : '<p class="empty">No records match. Try another name or keyword.</p>'}`;
}
function search() { return `<h1>Campaign search</h1><form id="searchForm" role="search"><label for="campaignSearch">Search all campaign records</label><div class="search-row"><input id="campaignSearch" name="q" type="search" value="${escapeHTML(state.query)}" placeholder="Name, place, or keyword…" autocomplete="off"><button class="chip" type="submit">Search</button></div></form><div id="searchResults">${searchResults()}</div>`; }
function missing() { return '<h1>Record not found</h1><p class="empty">This campaign link does not match a recorded page.</p><a href="#home">Return to Tonight</a> · <a href="#search">Search the campaign</a>'; }
function closeMenu() { nav.classList.remove('open'); menu.setAttribute('aria-expanded', 'false'); menu.setAttribute('aria-label', 'Open navigation'); }
function render() {
  if(abilityDialog.open)abilityDialog.close();
  for (const item of nav.querySelectorAll('a')) {
    const active = item.getAttribute('href').split('?')[0] === '#' + state.route;
    item.classList.toggle('active', active);
    if (active) item.setAttribute('aria-current', 'page'); else item.removeAttribute('aria-current');
  }
  app.innerHTML = state.id ? detail(state.route, state.id) : state.route === 'home' ? home() : state.route === 'search' ? search() : collections[state.route] ? listing(state.route) : missing();
  document.title = `${state.id ? (by(state.route, state.id) ? name(by(state.route, state.id)) : 'Record not found') : labels[state.route] || (state.route === 'search' ? 'Campaign search' : state.route === 'home' ? 'Tonight' : 'Page not found')} · Duluth by Night`;
}
function boot(focus = false) {
  let hash = location.hash.slice(1) || 'home';
  const canonical = model.resolveRoute(hash);
  if (canonical !== hash) { hash = canonical; history.replaceState(null, '', '#' + hash); }
  if (hash === 'app') { if (!app.children.length) render(); app.focus(); return; }
  const [path, query = ''] = hash.split('?');
  const parts = path.split('/');
  let id;
  try { id = parts[1] ? decodeURIComponent(parts[1]) : null; } catch { id = '__invalid__'; }
  state = { ...state, route: parts.length > 2 ? '__invalid__' : parts[0], id, query: new URLSearchParams(query).get('q') || '', category: new URLSearchParams(query).get('category') || null };
  closeMenu(); render();
  if (focus) { app.focus({ preventScroll: true }); window.scrollTo(0, 0); }
}
const abilityDialog=document.createElement('dialog');
abilityDialog.className='ability-dialog';
abilityDialog.setAttribute('aria-label','Ability reference');
document.body.append(abilityDialog);
let abilityTrigger=null;
abilityDialog.addEventListener('close',()=>{
  document.body.classList.remove('ability-open');
  if(abilityTrigger?.isConnected)abilityTrigger.focus({preventScroll:true});
});
abilityDialog.addEventListener('click',event=>{
  const box=abilityDialog.getBoundingClientRect();
  if(event.target.closest('[data-close-ability]') || (event.target===abilityDialog && (event.clientX<box.left||event.clientX>box.right||event.clientY<box.top||event.clientY>box.bottom)))abilityDialog.close();
});
app.addEventListener('click',event=>{
  const trigger=event.target.closest('[data-ability-popup]');
  if(!trigger||event.ctrlKey||event.metaKey||event.shiftKey||event.altKey||event.button!==0)return;
  const power=model.byId(trigger.dataset.abilityPopup);
  if(!power||power.recordType!=='power')return;
  event.preventDefault();abilityTrigger=trigger;
  abilityDialog.innerHTML=`<button class="ability-close" data-close-ability aria-label="Close ability reference" autofocus>Close ×</button>${disciplineDetail('powers',power)}<p><a href="${url('powers',power.id)}">Open full ability page</a></p>`;
  abilityDialog.querySelector('h1').id='ability-dialog-title';
  abilityDialog.setAttribute('aria-labelledby','ability-dialog-title');
  abilityDialog.showModal();abilityDialog.scrollTop=0;
  document.body.classList.add('ability-open');
});
menu.addEventListener('click', () => { const open = nav.classList.toggle('open'); menu.setAttribute('aria-expanded', String(open)); menu.setAttribute('aria-label', open ? 'Close navigation' : 'Open navigation'); });
document.addEventListener('keydown', event => { if (event.key === 'Escape' && !abilityDialog.open) { closeMenu(); menu.focus(); } });
document.addEventListener('click', event => { const filter = event.target.closest('[data-filter]'); if (filter) { state.filter = filter.dataset.filter; render(); app.querySelector(`[data-filter="${state.filter}"]`)?.focus(); } });
app.addEventListener('input', event => {
  if (event.target.id !== 'campaignSearch') return;
  state.query = event.target.value;
  history.replaceState(null, '', '#search' + (state.query ? '?q=' + encodeURIComponent(state.query) : ''));
  document.querySelector('#searchResults').innerHTML = searchResults();
});
app.addEventListener('submit', event => { if (event.target.id === 'searchForm') { event.preventDefault(); document.querySelector('#searchResults').innerHTML = searchResults(); } });
window.addEventListener('hashchange', () => boot(true));
boot();
