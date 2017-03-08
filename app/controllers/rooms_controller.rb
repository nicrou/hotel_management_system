class RoomsController < ApplicationController
  before_action :authenticate_user!
  include CurrencyHelper
  layout 'admin'

  def index
    @rooms = Room.all

    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
      @room = Room.find(params[:id])

      respond_to do |format|
        format.js {}
      end
    end

  def new
    @room = Room.new
    @categories = Category.all

    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @room = Room.find(params[:id])
    @categories = Category.all

    respond_to do |format|
      format.js {}
    end
  end

  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        @rooms = Room.all
        format.js {}
      else
        format.js { render action: 'new' }
      end
    end
  end

  def update
    @room = Room.find(params[:id])
    @rooms = Room.all

    respond_to do |format|
      if @room.update(room_params)
        format.js {}
      else
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
   @room = Room.find(params[:id])
   @room.destroy

   respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
  def room_params
    params.require(:room).permit(:category_id, :building, :floor, :number, :notes)
  end
end
