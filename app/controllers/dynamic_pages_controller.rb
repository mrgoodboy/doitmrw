class DynamicPagesController < ApplicationController
	include DynamicPagesHelper

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
	    @next = next_content(@category)
	    render json: @next
	end

def upload
	if params[:submit]
		type = Type.find_by_name(params[:type])
		category = Category.find_by_slug(params[:category])

		@content = Content.new(type: type, text: params[:text], title: params[:title], category: category)
		@submitted = true

		if @content.save
			redirect_to "/"
			flash["success"] = "You have successfully contributed to the best procrastination community!"
		else
			redirect_to upload_path
			flash["error"] = "Something went wrong, please try to upload your masterpiece again."
		end

	else
		@content = Content.new
	end

end

def leaderboard
end

end
