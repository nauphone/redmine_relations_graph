require 'redmine'
require 'graphviz'

require_dependency 'issues_controller_patch'
require_dependency 'issue_relation_chart'
require_dependency 'view_hook'

ActionDispatch::Callbacks.to_prepare  do
  IssuesController.send(:include, ::Plugin::RelationsGraph::IssuesControllerPatch)
end

Redmine::Plugin.register :redmine_relations_graph do
  name 'Redmine Relations Graph'
  author '-'
  description 'Displays issues relations graph'
  version '0.0.1'
end
