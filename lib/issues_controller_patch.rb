  module Plugin
    module RelationsGraph
      module IssuesControllerPatch
        def self.included base
          base.class_eval do
            skip_before_filter :authorize, :only => [:graph]
          end
        end

        def graph
          params.delete :group_by
          params.delete :available_columns

          retrieve_query

          debugger
          g = Plugin::RelationsGraph::RelationGraph.new(@query.issues)
          @graphs = g.get_graphs
          render :layout => 'popup'
        end
      end
    end
  end
