class Content < ActiveRecord::Base
  include GraphNode
  include Rails.application.routes.url_helpers

  attr_accessible :title, :text, :submit, :category_id, :type_id, :user_id, :new

  set_table_name 'content'

  has_many :edges
  has_many :users, through: :edges

  belongs_to :category
  belongs_to :type

  def self.edge_column
    'content_id'
  end

  def self.only_new
    where(new: true)
  end

  def likes
    edges.count
  end

  def to_html
    case type.name
    when 'text'
      text
    when 'image'
      "<img src=\"#{text}\" alt=\"#{title}\" />"
    when 'video'
      youtube_token = text.split('v=').last
      "<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/#{youtube_token}\" frameborder=\"0\" allowfullscreen></iframe>"
    end
  end

  def permalink
    url_for(controller: :dynamic_pages, action: :view, category: category.name, content_id: id)
  end

  def as_json(options = {})
    super(options.merge({methods: [:permalink, :to_html]}))
  end

end
