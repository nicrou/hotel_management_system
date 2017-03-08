class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        @profiles = Profile.all
        format.js {}
      else
        format.js { render action: 'edit' }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :email, :approved, profile_attributes: [:id, :forename, :surname, :date_of_birth, :role,
                             :country, :province, :city, :street, :postal_code,
                             :home_phone, :mobile_phone, :admin])
  end
end
