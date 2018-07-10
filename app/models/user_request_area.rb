class UserRequestArea < ApplicationRecord
  belongs_to :area, :polymorphic => true
  belongs_to :user, optional: true

  validates_presence_of :area

end
