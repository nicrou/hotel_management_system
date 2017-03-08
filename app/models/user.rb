class User < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :lockable, :timeoutable, #:confirmable, #:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :profile, autosave: true
  accepts_nested_attributes_for :profile
  after_validation :build_profile

  validates :email, presence: true

  validate :password_complexity
  def password_complexity
    if password.present?
       if !password.match(/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])/)
         errors.add :password, "Password complexity requirement not met"
       end
    end
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  private
  def build_profile
    if self.profile.blank?
      self.profile = Profile.new
    end
  end
end
