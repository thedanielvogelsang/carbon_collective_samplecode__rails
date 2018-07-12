class UserBehaviorsController < ApplicationController

  def button_press
    #give id, name={button name} and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      name = params[:buttonName]
      page = params[:pageName]
      UserLogHelper.user_presses_button(id, name, page)
      return status: 202
    else
      return status: 404
    end
  end

  def page_land
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      page = params[:pageName]
      UserLogHelper.user_lands_on_page(id, page)
      return status: 202
    else
      return status: 404
    end
  end

  def page_leave
    #give id and pageName={currentPageName} and nextPage={nextpage's name}
    id = params[:user_id]
    if User.exists?(id)
      prev_page = params[:pageName]
      new_page = params[:nextPage]
      UserLogHelper.user_leaves_page(id, prev_page, new_page)
      return status: 202
    else
      return status: 404
    end
  end

  def back_button
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      prev_page = params[:pageName]
      UserLogHelper.user_hits_nav_button(id, 'back', prev_page)
      return status: 202
    else
      return status: 404
    end
  end
  def dash_button
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      prev_page = params[:pageName]
      UserLogHelper.user_hits_nav_button(id, 'dashboard', prev_page)
      return status: 202
    else
      return status: 404
    end
  end
  def invite_someone_button
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      prev_page = params[:pageName]
      UserLogHelper.user_hits_nav_button(id, 'inviteSomeone', prev_page)
      return status: 202
    else
      return status: 404
    end
  end
  def settings_button
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      prev_page = params[:pageName]
      UserLogHelper.user_hits_nav_button(id, 'settings', prev_page)
      return status: 202
    else
      return status: 404
    end
  end

end
