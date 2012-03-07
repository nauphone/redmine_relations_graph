$$('#issue-relations-graph .node').each(function(node) {
  Event.observe(node, 'click', function(event) {
    var event_id = /issue-node-(\d+)/.exec(this.id)[1]
    if (window.name == 'relationgraphpopup') {
      window.opener.document.location = '/issues/' + event_id;
      self.close();
    } else {
      document.location = '/issues/' + event_id;
    }
  });
});
