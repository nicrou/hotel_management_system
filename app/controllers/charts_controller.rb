class ChartsController < ApplicationController
  before_action :authenticate_user!
  include ChartsHelper
  layout 'admin'

  def index
    @control = ChartControl.new

    @category_options = Category.find_each.pluck(:title)
    @category_options.unshift('All')
    @category_options.unshift('Total')
    setup_controls
  end

  def show_annual
    @control = ChartControl.new(params[:data_action], params[:type], params[:date], params[:mode], params[:category])
    setup_controls

    case @control.data_action
    when 1
      @labels = set_months
      @data = bookings_count_per_year_data(@control.date.year, @control.category)
    when 2
      @labels = set_months
      @data = bookings_income_per_year_data(@control.date.year, @control.category)
    when 3
      @labels = set_months
      @data = invoices_count_per_year_data(@control.date.year)
      if @control.type == "pie" || @control.type == "doughnut"
        @control.type = "bar"
      end
    else
      @labels = set_months
      @data = invoices_income_per_year_data(@control.date.year)
      if @control.type == "pie" || @control.type == "doughnut"
        @control.type = "bar"
      end
    end

    respond_to do |format|
      format.js { render "show.js.erb" }
    end
  end

  def show_monthly
    @control = ChartControl.new(params[:data_action], params[:type], params[:date], params[:mode], params[:category])
    setup_controls

    case @control.data_action
    when 1
      @labels = set_categories
      @data = bookings_count_per_month_data(@control.date)
    when 2
      @labels = set_categories
      @data = bookings_income_per_month_data(@control.date)
    when 3
      @labels = ["Unpaid", "Paid"]
      @data = invoices_count_per_month_data(@control.date)
      if @control.type == "line"
        @control.type = "bar"
      end
    else
      @labels = ["Unpaid", "Paid"]
      @data = invoices_income_per_month_data(@control.date)
      if @control.type == "line"
        @control.type = "bar"
      end
    end

    respond_to do |format|
      format.js { render "show.js.erb" }
    end
  end

  private

  def setup_controls
    # Fixes bug where you can change graph while having selecting "All" from another category.
    if  @control.type == "pie" || @control.type == "doughnut"
      if @control.category == "All"
        @control.category = "Total"
      end
    end
  end
end
