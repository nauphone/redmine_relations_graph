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
          @issue = Plugin::RelationsGraph::RelationsGraph.new(@query.issues).get_graph if @query.valid?
          render :layout => 'popup'
        end
      end
    end
  end
