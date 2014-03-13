  module Plugin
    module RelationsGraph
      module IssuesControllerPatch
        def self.included base
          base.class_eval do
            skip_before_filter :authorize, :only => [:graph, :graph_issue]
          end
        end

        def graph
          params.delete :group_by
          params.delete :available_columns

          @project = Project.find(params[:project_id])

          retrieve_query

          g = Plugin::RelationsGraph::RelationGraph.new(@query.issues)
          @graphs = g.get_graphs
          render :layout => 'popup'
        end

        def graph_issue
          issue=[Issue.find(params[:id])]
          if issue.any?
            g = Plugin::RelationsGraph::RelationGraph.new(issue)
            @graphs = g.get_graphs
          end
          render "graph", :layout => 'popup'
        end
      end
    end
  end
