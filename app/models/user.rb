class User < ActiveRecord::Base
  include GraphNode
  attr_accessible :name, :provider, :uid, :email, :guest

  has_many :edges
  has_many :content, through: :edges

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.edge_column
    'user_id'
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      if current_user
        # guest user is already signed in
        user = current_user
        user.name = auth.extra.raw_info.name
        user.provider = auth.provider,
        user.uid = auth.uid,
        user.email = auth.info.email
        user.guest = false
        user.save
      else
        user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           guest:false
                          )
      end
    end
    user
  end

  def self.new_guest
    name = 'user' + (rand(900000000) + 100000000).to_s
    User.create(name: name, guest: true)
  end

end
