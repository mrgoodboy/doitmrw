class DynamicPagesController < ApplicationController
	def home
	end

	def view
		@category = params[:category]
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
