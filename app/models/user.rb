class User < ActiveRecord::Base
  include GraphNode
  attr_accessible :name, :provider, :uid, :email

  has_many :edges
  has_many :content, through: :edges

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.edge_column
    'user_id'
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email
                        )
    end
    user
  end

end
