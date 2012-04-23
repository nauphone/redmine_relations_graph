$$('#issue-relations-graph .node, map area').each(function(node) {
  Event.observe(node, 'click', function(event) {
    console.log('Click');
    var event_id = /issue-node-(\d+)/.exec(this.id)[1];
    if (window.name == 'relationgraphpopup') {
      window.opener.document.location = '/issues/' + event_id;
      self.close();
    } else {
      document.location = '/issues/' + event_id;
    }
  });
});

// $$('#issues-without-relation ul li a').each(function(link) {
//   Event.observe(link, 'click', function(event) {
//     if (window.name == 'relationgraphpopup') {
//       window.opener.document.location = this.attributes['href'].value
//       self.close();
//     }
//   });
// });

