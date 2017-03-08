class ThemesController < ApplicationController
  before_action :authenticate_user!
  include ThemesHelper
  layout 'admin'
  def index
    @themes = Theme.find_each
  end

  def new
  end

  def create
    theme = Theme.new(:title => params[:title], :navbar => "#828282",  :module => "#ccc" , :footer => "#000", :content => "#fff", :selected => 0)
    respond_to do |format|
      if theme.save
        @themes = Theme.find_each
        format.js { render "refresh.js.erb" }
      end
    end
  end

  def update
    @theme = Theme.find(params[:id])
    theme_params

    if params[:selected].present? && params[:selected].to_i == 1
      Theme.transaction do
        Theme.where.not(id: @theme.id).update_all(selected: 0)
        @theme.selected = true
        @theme.save
        # update_selected_theme_scss(@theme)
      end
    else
      @theme.save
    end

    respond_to do |format|
      if @theme.save
        @themes = Theme.find_each
        format.js { render "refresh.js.erb" }
      end
    end
  end

  def destroy
   theme = Theme.find(params[:id])
   theme.destroy

   respond_to do |format|
      @themes = Theme.find_each
      format.js { render "refresh.js.erb" }
    end
  end

  private
  def theme_params
    params.permit(:title, :navbar, :module, :footer, :content, :selected)
    if params[:title].present?
      @theme.title = params[:title]
    end
    if params[:navbar].present? && params[:navbar][0] == "#"
      @theme.navbar = params[:navbar]
    end
    if params[:module].present? && params[:module][0] == "#"
      @theme.module = params[:module]
    end
    if params[:footer].present? && params[:footer][0] == "#"
      @theme.footer = params[:footer]
    end
    if params[:content].present? && params[:content][0] == "#"
      @theme.content = params[:content]
    end
  end

end
