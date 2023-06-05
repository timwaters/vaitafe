class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :surveys

  def update_contribution_count
    count = 0
    surveys.each do | survey |
      count += (survey.attributes.values.count { |v| !v.blank? } - 7 )
    end if surveys
   
    update(contribution_count: count)
  end

  def calculate_score
    #score contribution count (number of items recorded) and/or number of surveys completed?
  end

end