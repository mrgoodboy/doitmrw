class UsersController < ApplicationController
  include ApplicationHelper

	def show
		@user = User.find(params[:id], include: :edges)
    @uploads = @user.content
    sql = %Q(
            SELECT COUNT(e.id) FROM content c
              JOIN edges e ON e.content_id = c.id
                WHERE c.user_id = #{@user.id}
             )
		@distractees = User.connection.select_value(sql)
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