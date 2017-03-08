class ContentsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  def index
    @contents =  Content.find_each
    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
    @content =  Content.find(params[:id])
    respond_to do |format|
      format.js {}
    end
  end

  def new
    @content = Content.new

    respond_to do |format|
      format.html { render "form" }
    end
  end

  def edit
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html { render "form" }
    end
  end

  def create
    @content = Content.new(content_params)

    if init_transaction == false
      respond_to do |format|
        format.html { render 'form' }
      end
    else
      respond_to do |format|
        @contents = Content.all
        format.html { render "index"}
      end
    end

  end

  def update
    @content = Content.find(params[:id])

    if init_transaction == false
      respond_to do |format|
        format.html { render 'form' }
      end
    end

    @contents = Content.all
    redirect_to contents_url
  end

  def destroy
   @content = Content.find(params[:id])
   @content.destroy

   respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private

  def init_transaction
    Content.transaction do
      @content.assign_attributes(content_params)
      bind_modules
      if update_index && @content.save!
        return true
      end
      return false
    end
  end

  def content_params
    params.require(:content).permit(:title, :content, :locale, :position, :is_index, :components)
  end

  def bind_modules
    @content.components.clear
    @content.components << Component.where(id: params[:components])
  end

  def update_index
    if params[:content][:is_index] == "true"
      unless Content.where(locale: params[:content][:locale]).where(is_index: true).where.not(id: @content.id).update_all(is_index: false)
        return false
      end
    end
    return true
  end
end
