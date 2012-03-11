# Redmine status updates plugin
require 'redmine'

require 'dispatcher'

Dir[File.join(directory,'vendor','plugins','*')].each do |dir|
  path = File.join(dir, 'lib')
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

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
