class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, :phone_number, :email, presence: true
  validates_uniqueness_of :phone_number
  validates_uniqueness_of :email


  def verify_phone_number(entered_pin)
    update(phone_number_verified: true) if self.pin == entered_pin
  end
  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
  save
  end
  def needs_phone_number_verifying?
    if phone_number_verified
      return false
    end
  #  if phone_number.empty?
#      return false
#    end
    return true
  end
end
