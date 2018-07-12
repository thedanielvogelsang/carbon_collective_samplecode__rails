class UserBehaviorsController < ApplicationController

  def presses_button
    #give id, name={button name} and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      page = params[:user_behavior][:pageName]
      name = params[:user_behavior][:buttonName]
      UserLogHelper.user_presses_button(id, name, page)
      render json: {}, status: 202
    else
      render json: {}, status: 404
    end
  end

  def page_land
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      page = params[:user_behavior][:pageName]
      UserLogHelper.user_lands_on_page(id, page)
      render json: {}, status: 202
    else
      render json: {}, status: 404
    end
  end

  def page_leave
    #give id and pageName={currentPageName} and nextPage={nextpage's name}
    id = params[:user_id]
    if User.exists?(id)
      prev_page = params[:user_behavior][:prevPage]
      new_page = params[:user_behavior][:nextPage]
      UserLogHelper.user_leaves_page(id, prev_page, new_page)
      render json: {}, status: 202
    else
      render json: {}, status: 404
    end
  end

  def presses_navbar_button
    #give id and pageName={currentPageName}
    id = params[:user_id]
    if User.exists?(id)
      name = params[:user_behavior][:buttonName]
      prev_page = params[:user_behavior][:pageName]
      UserLogHelper.user_hits_nav_button(id, name, prev_page)
      render json: {}, status: 202
    else
      render json: {}, status: 404
    end
  end

  def logs_in
    id = params[:user_id]
    if User.exists?(id)
      UserLogHelper.user_logs_in(id)
      render json: {}, status: 202
    else
      render json: {}, status: 404
    end
  end

end
