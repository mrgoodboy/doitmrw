class DynamicPagesController < ApplicationController
	def home
	end

	def view
		@category = params[:category]
	end

	def upload
	end

	def leaderboard
	end

end
