class SettingsController < ApplicationController
  before_action :require_user
  
  def show
    @user = current_user
  end
end
