class DynamicPagesController < ApplicationController
	def home
	end

	def view
		@category = params[:category]
	end

  def next
    # called via ajax
    @category = params[:category]
    if params[:like]
      # now, session[:edges] should be set
      connect(current_user.id, params[:content_id])
      if session[:edges]
        adjust_edge_weights(session[:edges], params[:like])
      end
        # else do nothing, we lost the edges
    end
    @next = next_random_content(@category)
    render json: @next
  end

	def upload
    if params[:submit]
      type = Type.find_by_name(params[:type])
      category = Category.find_by_slug(params[:category])
      Content.create(type: type, text: params[:text], title: params[:title], category: category)
      @submitted = true
    end
	end

	def leaderboard
	end

end
