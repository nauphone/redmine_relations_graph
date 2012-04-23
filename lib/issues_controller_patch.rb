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
          g = Plugin::RelationsGraph::RelationGraph2.new(@query.issues)
          @svgs = g.svgs
          #@image = g.get_graph :png
          #@map = g.get_graph :cmapx
          #@issues = g.issues_without_relations
          render :layout => 'popup'
        end
      end
    end
  end
