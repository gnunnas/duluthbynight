// Data access and relationship resolution, independent of the DOM and templates.
(function (root) {
  function createCampaignModel(data) {
    const collections = {
      people: data.people, places: data.places, clans: data.clans,
      groups: data.groups, factions: data.factions, threads: data.threads,
      chronicle: data.sessions
    };
    const by = (type, id) => collections[type]?.find(record => record.id === id);
    function outgoing(type, record) {
      const links = [];
      const add = (targetType, id) => { if (by(targetType, id)) links.push({type: targetType, id}); };
      for (const key of Object.keys(collections)) {
        const field = key === 'chronicle' ? 'sessions' : key;
        // A person's clan is singular; relationship arrays are explicitly typed.
        if (Array.isArray(record[field])) for (const id of record[field]) add(key, id);
      }
      if (type === 'people') {
        if (record.clan) add('clans', record.clan);
        for (const membership of record.memberships || []) add('groups', membership.group);
        for (const affiliation of record.affiliations || []) add('factions', affiliation.faction);
        for (const relationship of data.relationships || []) {
          if (relationship.from === record.id) add('people', relationship.to);
          if (relationship.to === record.id) add('people', relationship.from);
        }
      }
      return links;
    }
    function related(type, record) {
      const result = Object.fromEntries(Object.keys(collections).map(key => [key, new Set()]));
      const add = (key, id) => { if (!(key === type && id === record.id)) result[key].add(id); };
      for (const target of outgoing(type, record)) add(target.type, target.id);
      for (const [key, records] of Object.entries(collections)) {
        for (const candidate of records) {
          if (outgoing(key, candidate).some(target => target.type === type && target.id === record.id)) add(key, candidate.id);
        }
      }
      return Object.fromEntries(Object.entries(result).map(([key, ids]) => [key, [...ids].map(id => by(key, id))]));
    }
    function searchText(type, record) {
      const values = [record.name, record.title, record.summary, record.type, record.kind, record.date, record.affiliationStatus];
      for (const target of outgoing(type, record)) values.push(by(target.type, target.id)?.name);
      for (const entry of [...(record.memberships || []), ...(record.affiliations || [])]) if (entry.role) values.push(entry.role);
      return values.filter(Boolean).join(' ').toLocaleLowerCase();
    }
    return {collections, by, related, searchText};
  }
  root.createCampaignModel = createCampaignModel;
  if (typeof module !== 'undefined') module.exports = {createCampaignModel};
})(globalThis);
