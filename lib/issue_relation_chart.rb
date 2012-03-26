require 'graphviz'

module Plugin
  module RelationsGraph
    class RelationsGraph
      attr_accessor :nodes, :edges, :issues, :issues_without_relations
      def initialize issues
        @issues = Array.wrap(issues)
        @nodes = {}
        @edges = {}
        @issues_without_relations = []
        @builded = false
      end

      def get_graph format = :svg
        unless @builded
          @g = GraphViz.new( :G, :type => :digraph )
          @g[:id] = 'issue-relations-graph'

          path = []
          @issues.each { |issue|
            @issues_without_relations << issue if issue.relations.count == 0
            issue.relations.each { |relation|
              add_edge relation unless path.include? relation.id
              path << relation.id
            }
          }
          @builded = true
        end
        @g.output format => String
      end

      protected

      def add_node issue
        if @nodes.key? issue.id
          node = @nodes[issue.id]
        else
          node = @g.add_nodes "##{issue.id.to_s}"
          if @issues.include? issue
            node[:style] = 'filled,bold'
          else
            node[:style] = 'filled'
          end
          node[:id] = "issue-node-#{issue.id.to_s}"
#          node[:color] = ( issue.closed? ? '#00AAFF' : '#FFAA00' )
          node[:fillcolor] = '#EEEEEE'
          node[:URL] = '#'
          @nodes[issue.id] = node
        end
        node
      end

      def add_edge relation
        if @edges.key? [ relation.issue_from.id, relation.issue_to.id ]
          edge = @edges[ relation.issue_from.id, relation.issue_to.id ]
        else
          edge = @g.add_edges add_node(relation.issue_from), add_node(relation.issue_to)
          edge[:id] = "edge-#{relation.issue_from.id}-#{relation.issue_to.id}"
          edge[:color] = relation.relation_type == 'blocks' ? ( relation.issue_from.closed? ? '#00AAFF' : '#FF0000') : '#000000'

          @edges[ [relation.issue_from.id, relation.issue_to.id] ] = edge
        end
        edge
      end
    end
  end
end
