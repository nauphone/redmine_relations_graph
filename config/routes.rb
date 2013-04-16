RedmineApp::Application.routes.draw do
    match '/projects/:project_id/issues/graph', :controller => 'issues', :action => 'graph'
    match '/projects/issues/graph', :controller => 'issues', :action => 'graph', :project_id => nil
end

