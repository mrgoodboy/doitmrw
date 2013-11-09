class UsersController < ApplicationController
  include ApplicationHelper

	def show
		@user = User.find(params[:id], include: :edges)
    @edges = @user.edges
		@uploads = User.find(params[:id]).content
	end

  def create
    user = User.new_guest
    sign_in(:user, user)
    if params[:redirect]
      redirect_to params[:redirect]
    else
      redirect_to root_url
    end
  end   

end