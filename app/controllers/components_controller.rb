class ComponentsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  def index
    @components =  Component.find_each
    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
    @component =  Component.find(params[:id])
    respond_to do |format|
      format.js {}
    end
  end

  def new
    @type = params[:type]
    @component = Component.new

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def edit
    @component = Component.find(params[:id])

    respond_to do |format|
      format.html { render "new" }
    end
  end

  def create
    validate_slider
    validate_map
    @component = Component.new(component_params)

    if @component.save
      if @component.is_map? || @component.is_slider?
        @component.update({:is_editable => false})
      end
      respond_to do |format|
        @components = Component.all
        format.html { render "index"}
        format.js {}
      end
    else
      @type = params[:type]
      respond_to do |format|
        format.html { render 'new' }
        format.js { render action: 'new' }
      end
    end
  end

  def update
    @component = Component.find(params[:id])

    if @component.update(component_params) == false
      respond_to do |format|
        format.html { render 'form' }
      end
    end

    @components = Component.all
    redirect_to components_url
  end

  def destroy
   @component = Component.find(params[:id])
   @component.destroy

   respond_to do |format|
      format.html { redirect_to components_url }
      format.json { head :no_component }
      format.js   { render :layout => false }
    end
  end

  private
  def validate_slider
    if params[:component][:is_slider] == "true"
      d = File.join('public', params[:component][:collection_directory])

      html = '<div class="carousel-wrapper"><div class="owl-carousel owl-theme">'

      if File.directory?(d)
        Dir[d + "/*"].each do |file|
          img = File.join(d, File.basename(file))
          img.slice!(/(public)/)
          x = request.domain
          html = html + '<div><img src="' + img + '"></div>'
        end
      end
      params[:component][:content] = html + '</div></div>'
    end
  end

  def validate_map
    if params[:component][:is_map] == "true"

      #if params[:component][:api_key] == ""
      #  api_key = "AIzaSyDj8_VpVBBXOUlaPdU_atAQhqJPeWitru4"
      #end

      api_key = params[:component][:api_key]
      zoom = params[:component][:zoom]

      if params[:component][:place_id] != ""
        q_param = params[:component][:place_id].to_s
      else
        if params[:component][:place] != "" && params[:component][:city] != ""
          q_param = params[:component][:place].downcase.gsub(' ','+').to_s + "," + params[:component][:city].downcase.gsub(' ','+').to_s
        else
          return false
        end
      end

      params[:component][:content] = '<iframe ' +
        'frameborder="0" style="border:0" class="google-map"' +
        'src="https://www.google.com/maps/embed/v1/place?key=' + api_key +
        '&q=' + q_param +
        '&zoom=' + zoom.to_s + '" allowfullscreen>' +
      '</iframe>'
    end
  end

  def component_params
    params.require(:component).permit(:title, :content, :position, :collection_directory, :is_map, :is_slider, :is_social_link, :is_editable, :place, :city, :place_id, :zoom, :api_key)
  end
end
