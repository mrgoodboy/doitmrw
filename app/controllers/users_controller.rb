class UsersController < ApplicationController

	def show
		@user = User.joins(:edges).where(id: params[:id])
		@uploads = User.joins(:content).where(id: params[:id])
	end

end