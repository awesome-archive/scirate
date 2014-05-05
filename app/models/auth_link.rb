# == Schema Information
#
# Table name: auth_links
#
#  id               :integer          not null, primary key
#  provider         :string(255)      not null
#  uid              :string(255)      not null
#  oauth_token      :string(255)      not null
#  oauth_expires_at :datetime         not null
#  user_id          :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class AuthLink < ActiveRecord::Base
  belongs_to :user

  def self.from_omniauth(auth, user=nil)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |link|
      link.provider = auth.provider
      link.uid = auth.uid
      link.oauth_token = auth.credentials.token
      link.oauth_expires_at = Time.at(auth.credentials.expires_at)

      if user.nil?
        user = User.new
        user.email = auth.info.email
        user.fullname = auth.info.name
        user.username = User.default_username(auth.info.name)
        user.save!
      end

      link.user = user
      link.save!
    end
  end
end
