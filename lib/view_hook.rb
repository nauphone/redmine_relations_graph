module Plugin
  module RelationsGraph
    class Hooks < Redmine::Hook::ViewListener
       render_on :view_issues_index_bottom, :partial => 'graph_link'
    end
  end
end
