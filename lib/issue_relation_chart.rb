require 'graphviz'

module Plugin
  module RelationsGraph

    class RelationGraph
      attr_accessor :clusters
      def initialize issues, max_depth
        @max_depth = max_depth
        @issues = issues

        @nodes = {}
        @edges = {}
        @clusters = []
        @result = []
        @in_clusters = []

        @issues.each { |issue|
          unless @in_clusters.include? issue
            cluster = get_related_issues(issue)
            @in_clusters += cluster
            @clusters.push cluster
          end
        }
        @svgs = []
        @clusters.sort! { |a, b|
          b.length <=> a.length
        }
        number = 0
        @clusters.each { |cluster|
          g = Plugin::RelationsGraph::RelationsGraphBuilder.new(cluster, issues)
          @result.push({
            :png => g.get_graph(number, :png),
            :map => g.get_graph(number, :cmapx),
            :number => number
            })
          number += 1
        }
        self
      end

      def get_related_issues(issue, path=[], level=0)
        unless level >= @max_depth
          unless path.include? issue
            level += 1
            path.push issue
            issue.relations.each do |relation|
              child_node = relation.issue_from == issue ? relation.issue_to : relation.issue_from
              get_related_issues(child_node, path, level)
            end
            issue.children.each do |child|
              get_related_issues(child, path, level)
            end
            unless issue.parent.nil?
              get_related_issues(issue.parent, path, level)
            end
          end
        end
        path
      end

      def get_graphs
        @result
      end
    end

    class RelationsGraphBuilder
      attr_accessor :nodes, :edges, :issues, :issues_without_relations
      def initialize issues, hl_issues
        @issues = Array.wrap(issues)
        @hl_issues = Array.wrap(hl_issues)
        @nodes = {}
        @edges = {}
        @issues_without_relations = []
        @builded = false
      end

      def get_graph number = 0, format = :svg
        unless @builded
          @g = GraphViz.new("issuerelationsgraph#{number}", :type => :digraph )
          @g[:id] = "issuerelationsgraph#{number}"
          @g[:size] = 10

          path = []
          @issues.each { |issue|
            add_node issue
          }
          @issues.each { |issue|
            #@issues_without_relations << issue if issue.relations.length == 0
            issue.relations.each { |relation|
              add_edge relation unless path.include? relation.id
              path << relation.id
            }
            add_edge_subtask issue
          }
          @builded = true
        end
        output = @g.output format => String
        if format == :cmapx
          output.gsub! /title="#(\d+)"/ do
            title = Issue.find($1.to_i).subject.gsub(/"/, "&quot;")
            "title=\"#{title}\""
          end
        end
        output
      end

      protected

      def add_node issue
        if @nodes.key? issue.id
          node = @nodes[issue.id]
        else
          node = @g.add_nodes "##{issue.id.to_s}"
          if @hl_issues.include? issue
            node[:style] = 'filled,bold'
          else
            node[:style] = 'filled'
          end
          if issue.closed?
            node[:fillcolor] = '#333333'
            node[:color] = '#333333'
            node[:fontcolor] = '#FFFFFF'
          else
            node[:fillcolor] = '#EEEEEE'
          end
          node[:id] = "issue-node-#{issue.id.to_s}"
          node[:URL] = "##{issue.id}"
          @nodes[issue.id] = node
        end
        node
      end

      def add_edge_subtask issue_to
        return if issue_to.parent_issue_id.nil?
        issue_from = Issue.find(issue_to.parent_issue_id)
        if @edges.key? [ issue_from.id, issue_to.id ]
          edge = @edges[ [issue_from.id, issue_to.id] ]
        else
          edge = @g.add_edges add_node(issue_from), add_node(issue_to)
          edge[:id] = "edge-#{issue_from.id}-#{issue_to.id}"
          edge[:color] = "#00FF00"
          @edges[ [issue_from.id, issue_to.id] ] = edge
        end
        edge
      end

      def add_edge relation
        if @edges.key? [ relation.issue_from.id, relation.issue_to.id ]
          edge = @edges[ [relation.issue_from.id, relation.issue_to.id] ]
        else
          if relation.relation_type == 'blocks'
            edge = @g.add_edges add_node(relation.issue_to), add_node(relation.issue_from)
          else
            edge = @g.add_edges add_node(relation.issue_from), add_node(relation.issue_to)
          end
          if relation.relation_type == 'relates'
            edge[:dir]='both'
          end
          edge[:id] = "edge-#{relation.issue_from.id}-#{relation.issue_to.id}"
          edge[:color] = relation.relation_type == 'blocks' ? ( relation.issue_from.closed? ? '#00AAFF' : '#FF0000') : '#000000'
          @edges[ [relation.issue_from.id, relation.issue_to.id] ] = edge
        end
        edge
      end
    end
  end
end
