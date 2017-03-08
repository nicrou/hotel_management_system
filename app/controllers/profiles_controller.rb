class ProfilesController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js
  layout 'admin'

  def index
    @profiles = Profile.all

    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

=begin
  # Passing json object for bootstrap table
  def index
    @profiles = Profile.find_each
    @profiles = @profiles.to_json
    render layout: "settings"
  end
=end

  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def destroy
   @profile = Profile.find(params[:id])
   @profile.destroy

   respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end
end
