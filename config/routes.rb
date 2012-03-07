ActionController::Routing::Routes.draw do |map|
  map.issue_relations_graph '/projects/:project_id/issues/graph', :controller => 'issues', :action => 'graph'
end

