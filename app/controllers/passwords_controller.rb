class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password,    except: [:index, :new, :create]
  before_action :authorize_user!, only:   [:edit, :update, :destroy]

  def index
    @passwords = current_user.passwords
  end

  def show
  end

  def new
    @password = Password.new
  end

  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: "owner")
    if @password.save
      redirect_to @password, notice: "Password created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @password.update(password_params)
      redirect_to @password, notice: "Password updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password.destroy
    redirect_to root_path, notice: "Password deleted successfully."
  end

  private

  def password_params
    params.require(:password).permit(:url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
  end

  def authorize_user!
    redirect_to @password unless @password.editable?(current_user)
  end
end
