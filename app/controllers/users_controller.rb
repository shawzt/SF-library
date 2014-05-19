# encoding: utf-8
class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index]
  
  def index
    @users = User.order('name').
    paginate(page: params[:page])
    # if params[:tag] != nil
    #   @users = User.search_by_tag(params[:tag], params[:page]||1)
    # else
    #   @users = User.search(params[:page]||1)
    # end
    
    respond_to do |format|
      format.html
      #format.js { render 'index.js.erb' }
    end
    
  end
  
  def login
    user = User.find_by(email: params[:user][:email].downcase)
    respond_to do |format|
      if user && user.authenticate(params[:user][:password])
        sign_in user
        format.html { redirect_to library_path }
      else
        flash[:error] = 'Email或密码有误!'
        format.html { redirect_to root_path }
      end
    end  
  end
  
  def create
    user = User.new
    user.name = params[:user][:name]
    user.email = params[:user][:email]
    user.team = params[:user][:team]
    user.cate = params[:user][:cate]
    user.password = User::DEFAULT_PASSWORD
    user.password_confirmation = User::DEFAULT_PASSWORD

    user_temp = User.find_by(email: params[:user][:email])
    if user_temp
      flash[:error] = '用户已存在！'
    else
      if user.save
        flash[:success] = '用户创建成功!'
      else
        flash[:error] = '用户创建失败!'
      end
    end

    respond_to do |format|
      format.html { redirect_to users_path }
    end   
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html 
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:user][:id])
    if @user.update(user_params)
      flash[:success] = "更新成功!"
    else
      flash[:error] = '更新失败!'
    end
    respond_to do |format|
      format.html { redirect_to edit_user_path(@user.id) }
    end
    
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = '删除成功。'  
    else
      flash[:error] = '用户删除失败!'
    end
    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end
  
  def logout
    sign_out
    redirect_to root_path
  end

  def reset
    @user = User.find(params[:id])
    @user.password = User::DEFAULT_PASSWORD
    @user.password_confirmation = User::DEFAULT_PASSWORD
    if @user.save 
      flash[:success] = '密码重置成功'
    else
      flash[:error] = '密码重置失败'
    end
    respond_to do |format|
      format.html { redirect_to edit_user_path(@user.id) }
    end
  end
  
  private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def user_params
      params.require(:user).permit(:email, :name, :cate, :team)
    end
end