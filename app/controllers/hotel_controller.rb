class HotelController < ApplicationController
  def index
    locale_group = process_request

    if locale_group.where(is_index: true).empty?
      @content = locale_group.first
    else
      @content = locale_group.where(is_index: true).first
    end
    
    render "show"
  end

  def show
    locale_group = process_request
    if params.has_key?(:id)
      @content = locale_group.where(id: params[:id]).first
    else
      @content = locale_group.first
    end

    #if @active_theme.blank?
    #  @active_theme = Theme.first
    #end
  end

  def process_request
    if params.has_key?(:locale)
      locale_group = Content.where(locale: params[:locale])
    else
      locale_group = Content.where(locale: "en")
    end

    @index = locale_group.select(:title, :id).where(is_index: true).first or not_found

    @navbar = locale_group.select(:title, :id).where(is_index: false).order(position: :desc)
    @social_media = Component.select(:title, :content).where(is_social_link: true).group(:title)
    return locale_group
  end
end
