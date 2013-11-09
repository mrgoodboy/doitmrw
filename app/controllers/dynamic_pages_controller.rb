require 'net/http'
class DynamicPagesController < ApplicationController
	include DynamicPagesHelper

  before_filter :force_user_account, except: [:home]

  INITIAL_EDGE_WEIGHT = 1

	def home
	end

	def view
		@category = params[:category]
    if (params[:content_id])
      @content = Content.find_by_id(params[:content_id])
    end
	end

	def next
    # called via ajax
    @category = params[:category]
    category_id = Category.find_by_slug(@category).id
    if params[:like]
        # now, session[:edges] should be set
        edge = connect(current_user.id, params[:content_id])
      	adjust_edge_weights(params[:like], category_id, edge)
    end
    @next = next_content(category_id)
    render json: @next
	end

  def upload
  	if params[:submit]
  		type = Type.find_by_name(params[:type])
  		category = Category.find_by_slug(params[:category])

      if (params[:type] == 'image')
        unless uri?(params[:text])
          flash[:error] = "Please specify a valid URL."
          redirect_to upload_path and return
        end
        url = URI.parse(params[:text])
        req = Net::HTTP::Get.new(url.path)
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        logger.debug res.content_type
        unless (res.content_type =~ /^image\//)
          flash["error"] = "It looks like that wasn't an image. Double-check the URL."
          redirect_to upload_path and return
        end
      elsif (params[:type] == 'video')
        unless uri?(params[:text])
          flash[:error] = "Please specify a valid URL."
          redirect_to upload_path and return
        end
        url = URI.parse(params[:text])
        unless (url.host =~ /^([a-z]+.)?youtube.com$/ &&
                url.query =~ /v=[a-zA-Z0-9]+$/)
          flash["error"] = "It looks like that wasn't a valid youtube URL."
          redirect_to upload_path and return
        end
      end

  		@content = Content.new(type_id: type.id,
                             text: params[:text],
                             title: params[:title],
                             category_id: category.id,
                             user_id: current_user.id,
                             new: true)
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


  protected

  def force_user_account
    redirect_path = request.url
    unless user_signed_in?
      redirect_to create_user_path(redirect_to: redirect_path)
    end
  end

  def connect(user_id, content_id)
    Edge.create(user_id: user_id, content_id: content_id)
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

end
