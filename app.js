const D = window.CAMPAIGN;
const app = document.querySelector('#app');
const nav = document.querySelector('#nav');
const menu = document.querySelector('#menuBtn');
const model = createCampaignModel(D);
const collections = model.collections;
const labels = { people: 'People', places: 'Places', threads: 'Active threads', organizations: 'Organizations', clans: 'Clans', schemes: 'Schemes', events: 'Events', chronicle: 'Chronicle' };
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
  return Object.entries(model.related(type, record)).map(([key, records]) => section(titles[key] || `Related ${labels[key].toLowerCase()}`, records, key)).join('');
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
  const facts = [];
  if (type === 'people') {
    const clan = by('clans', record.clan);
    facts.push(['Nature / type', escapeHTML(record.type || 'Unknown')], ['Clan', clan ? link('clans', clan) : record.type === 'Mortal' ? 'Not applicable' : 'Unknown']);
    facts.push(['Group memberships', membershipFacts(record.memberships)]);
    facts.push(['Political affiliations', membershipFacts(record.affiliations)]);
    if (record.affiliationStatus) facts.push(['Affiliation status', escapeHTML(record.affiliationStatus)]);
    const relationships = model.personalRelationships(record.recordId);
    if (relationships.length) facts.push(['Personal relationships', relationships.map(x => {
      const target = by('people', x.from === record.id ? x.to : x.from);
      return `${target ? link('people', target) : 'Unknown'} — ${escapeHTML(x.label || (x.kind === 'association' ? 'Association; specific relationship unknown' : 'Specific relationship unknown'))}`;
    }).join('<br>')]);
    facts.push(['Associated places', record.places?.length ? record.places.map(id => by('places', id)).filter(Boolean).map(place => link('places', place)).join(', ') : 'Unknown']);
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
  return `<article class="detail"><a class="back" href="#${type}">← ${labels[type]}</a>${type === 'places' ? breadcrumbs(record) : `<div class="crumbs">${escapeHTML(labels[type])}</div>`}<h1>${escapeHTML(name(record))}</h1><p>${escapeHTML(record.summary || 'No summary recorded.')}</p>${facts.length ? `<dl class="facts">${facts.map(([label, value]) => `<div><dt>${label}</dt><dd>${value}</dd></div>`).join('')}</dl>` : ''}${type === 'places' ? placeChildren(record) : ''}${type === 'organizations' ? organizationHierarchy(type, record) : ''}${relations(type, record)}</article>`;
}
function home() {
  const tonight = model.tonight;
  return `<section class="hero"><div class="eyebrow">VAMPIRE: THE MASQUERADE // LAKE SUPERIOR</div><h1>DULUTH<br>BY NIGHT</h1><p>The lake is black. The harbor never sleeps. Every favor leaves a mark.</p></section><section class="status">${tonight.status.map(([label, value]) => `<div><small>${escapeHTML(label)}</small>${escapeHTML(value)}</div>`).join('')}</section><h2 class="section-title">Tonight in Duluth</h2><section class="card recap"><div class="eyebrow">WHERE WE LEFT OFF // ${escapeHTML(collections.chronicle[0].date)}</div><h2>${link('places', by('places', tonight.place))}</h2><p>${escapeHTML(tonight.summary)}</p><p>${escapeHTML(tonight.followup)}</p><div class="badges">${['portia', 'spokes'].map(id => link('people', by('people', id))).join(' ')} ${['chantry', 'bliss'].map(id => link('places', by('places', id))).join(' ')}</div></section>${section('Active threads', collections.threads, 'threads')}${section('Latest chronicle', collections.chronicle.slice(0, 1), 'chronicle')}${section('Faces to remember', tonight.faces.map(id => by('people', id)), 'people')}`;
}
function listing(type) {
  if (type === 'places') return `<h1>Places</h1><p class="intro">Choose a city or community, then explore its districts, suburbs, and individual locations. Locations with no recorded district remain directly under their city.</p>${section('Cities, communities & regions', collections.places.filter(x => !x.parent && areaKinds.has(x.kind)), 'places')}${section('Locations without recorded geography', collections.places.filter(x => !x.parent && !areaKinds.has(x.kind)), 'places')}`;
  let records = collections[type];
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
menu.addEventListener('click', () => { const open = nav.classList.toggle('open'); menu.setAttribute('aria-expanded', String(open)); menu.setAttribute('aria-label', open ? 'Close navigation' : 'Open navigation'); });
document.addEventListener('keydown', event => { if (event.key === 'Escape') { closeMenu(); menu.focus(); } });
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
