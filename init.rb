# Redmine status updates plugin
require 'redmine'

require 'dispatcher'

require_dependency 'issues_controller_patch'
require_dependency 'issue_relation_chart'
require_dependency 'view_hook'

Dispatcher.to_prepare do
  IssuesController.send(:include, ::Plugin::RelationsGraph::IssuesControllerPatch)
end

Redmine::Plugin.register :redmine_relations_graph do
  name 'Redmine Relations Graph'
  author '-'
  description 'Displays issues relations graph'
  version '0.0.1'
end
