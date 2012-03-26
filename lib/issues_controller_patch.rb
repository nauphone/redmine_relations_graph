  module Plugin
    module RelationsGraph
      module IssuesControllerPatch
        def self.included base
          base.class_eval do
            skip_before_filter :authorize, :only => [:graph]
          end
        end

        def graph
          retrieve_query
          g = Plugin::RelationsGraph::RelationsGraph.new(@query.issues)
          @image = g.get_graph :png
          @map = g.get_graph :cmapx
          @issues = g.issues_without_relations
          render :layout => 'popup'
        end
      end
    end
  end
