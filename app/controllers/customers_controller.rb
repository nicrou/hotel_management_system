class CustomersController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js
  layout 'admin'

  def index
    @customers = Customer.all

    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def new
    respond_to do |format|
      format.js {}
    end
  end

  def create
  end

  def edit
    @customer = Customer.find(params[:id])

    respond_to do |format|
        format.js {}
    end
  end

  def update
    @customer = Customer.find(params[:id])
    @customers = Customer.all

    respond_to do |format|
      if @customer.update(customer_params)
        format.js {}
      else
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
   @customer = Customer.find(params[:id])
   @customer.destroy

   respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:title, :forename, :surname, :v_title, :v_forename, :v_surname, :identification_credential, :email, :mobile_phone, :notes, :reason)
  end
end
