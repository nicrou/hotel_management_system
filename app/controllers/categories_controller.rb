class CategoriesController < ApplicationController
  before_action :authenticate_user!
  include CategoriesHelper
  layout 'admin'

  def index
    # Resets the room counters on each category row.
    # Category.find_each { |category| Category.reset_counters(category.id, :rooms) }
    @categories = Category.all

    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @category = Category.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def create
    @category = Category.new(category_params)

    for i in 1..@category.rooms_count.to_i
      @category.rooms.build()
    end

    respond_to do |format|
      if @category.save
        Category.find_each { |category| Category.reset_counters(category.id, :rooms) }
        @categories = Category.all
        format.js {}
      else
        format.js { render action: 'new' }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    @categories = Category.all

    respond_to do |format|
      if @category.update(category_params)
        format.js {}
      else
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
   @category = Category.find(params[:id])
   @category.destroy

   respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  def upload
    uploaded_files = params.permit(:file) # Take the files which are sent by HTTP POST request.
    params.permit(:file_category)
    title = params[:file_category]
    location = create_directory(title)

    Category.where(title: title).update(:file_pathname => set_name(title))

    time_footprint = Time.now.to_i.to_s # Generate a unique number to rename the files to prevent duplication.
    uploaded_files.each do |key, file|
      File.open(Rails.root.join(location, file.original_filename), 'wb') do |f|
        f.write(file.read)
        File.rename(f, File.join(location, title.squish.downcase.tr(" ", "_") + "_" + time_footprint + File.extname(file.original_filename)))
      end
    end
  end

  private
  def category_params
    params.require(:category).permit(:title, :subtitle, :description, :price, :discount, :tags, :file_pathname, :rooms_count)
  end
end
