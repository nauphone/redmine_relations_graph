module Plugin
  module RelationsGraph
    class Hooks < Redmine::Hook::ViewListener
      render_on :view_issues_index_bottom, :partial => 'graph_link'
      render_on :view_issues_show_action_menu, :partial => 'show_grap_link'
    end
  end
end
