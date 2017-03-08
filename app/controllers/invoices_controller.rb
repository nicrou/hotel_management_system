class InvoicesController < ApplicationController
  before_action :authenticate_user!, :except => [:new, :create]
  respond_to :html, :js
  layout 'admin'

  def index
    @invoices = Invoice.all

    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def new
    if params.has_key?(:invoice)
      if params[:invoice][:bookings_attributes].present?
        params[:invoice][:bookings_attributes].each do |rel|
          unless params[:invoice][:bookings_attributes][rel][:is_selected].present?
            params[:invoice][:bookings_attributes].delete rel
          end
        end
      end
      @invoice = Invoice.new(validate_invoice)
      set_prices
      @invoice.customer = Customer.new
    else
      @invoice = Invoice.new
    end

    respond_to do |format|
      format.js {}
    end
  end

  def create

    @invoice = Invoice.new(validate_invoice)
    set_prices

    if @invoice.init_transaction == true
      respond_to do |format|
        @start_date = @invoice.bookings.first.start_date
        @nights = @invoice.bookings.first.nights
        @available_rooms = Booking.find_available_rooms(@start_date, @nights)
        @categories = Category.find_each
        @count = @available_rooms.group(:category_id).count
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render action: 'new' }
      end
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def update
    invoice_params
    @invoice = Invoice.find(params[:id])
    @invoice.is_paid = params[:invoice][:is_paid]
    @invoices = Invoice.all

    respond_to do |format|
      if @invoice.save
        format.js {}
      else
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
   @invoice = Invoice.find(params[:id])
   @invoice.destroy

   respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
  def invoice_params
      params.permit(invoice: [:is_paid])
  end

  def validate_invoice
    params.require(:invoice).permit(
                       :is_paid, bookings_attributes: [ :room_id, :qty, :start_date, :nights, :is_selected, :_destroy ],
                                 customer_attributes: [ :title, :forename, :surname, :v_title, :v_forename, :v_surname, :email, :mobile_phone, :notes, :reason, :_destroy ] )

    # params.permit(:category_ids => [], :invoice => [ { bookings_attributes: [ :room_id, :qty, :start_date, :nights ] } ] )
  end

  def set_prices
    @invoice.bookings.each do |booking|
      category = Category.find(booking.room_id)

      booking.price = category.price
      booking.discount = category.discount
    end
  end
end
