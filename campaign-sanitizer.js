// Central HTML boundary for campaign renderers. DOMPurify removes executable markup,
// unsafe URLs and event-handler attributes before generated fragments enter the page.
(function (root) {
  const options = Object.freeze({ RETURN_DOM_FRAGMENT: true });
  const retainedControlNames = new Set(['body', 'title']);

  // DOMPurify removes names that can shadow DOM properties. These two names are
  // fixed by our own form templates and are read through form.elements; retain
  // them only on controls, without weakening named-property checks elsewhere.
  root.DOMPurify?.addHook('uponSanitizeAttribute', (node, data) => {
    if (data.attrName === 'name' && retainedControlNames.has(data.attrValue) && node.matches?.('input, textarea, select, button')) {
      data.forceKeepAttr = true;
    }
  });

  function renderCampaignHTML(target, html) {
    if (!target) return;
    if (!root.DOMPurify) throw new Error('Campaign HTML sanitizer is unavailable.');
    const fragment = root.DOMPurify.sanitize(String(html ?? ''), options);
    target.replaceChildren(fragment);
  }

  root.renderCampaignHTML = renderCampaignHTML;
})(globalThis);
