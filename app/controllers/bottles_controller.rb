class BottlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bottle, only: [:show, :edit, :update, :destroy, :stock, :unstock, :crack_open, :finish, :sell]

  # GET /bottles
  # GET /bottles.json
  def index
    @bottles = Bottle.where(user: current_user).order(Arel.sql('LOWER(name), release_year'))
    @filter = params[:filter].try(:downcase)

    case @filter
    when "open"
      @bottles = @bottles.current.open
    when "finished"
      @bottles = @bottles.finished
    when "sell"
      @bottles = @bottles.current.tagged_with("sell")
    when "stocked"
      @bottles = @bottles.current.stocked
    when "unstocked"
      @bottles = @bottles.current.unstocked
    else
      @bottles = @bottles.current
    end

    respond_to do |format|
      format.html
      format.csv { send_data @bottles.to_csv, filename: "bottles-#{Date.today.strftime('%Y-%m-%d')}.csv" }
    end
  end

  def search
    @bottles = Bottle.where(user: current_user).order('LOWER(name), release_year')

    @query = params[:q]
    @bottles = @bottles.search_for(@query)

    @open_bottles = @bottles.current.open
    @unopened_bottles = @bottles.current.unopened
    @finished_bottles = @bottles.finished

    respond_to do |format|
      format.html
      format.csv { send_data @bottles.to_csv, filename: "bottles-#{@query.parameterize}-#{Date.today.strftime('%Y-%m-%d')}.csv" }
    end
  end

  # GET /bottles/1
  # GET /bottles/1.json
  def show
  end

  # GET /bottles/new
  def new
    @bottle = Bottle.new
  end

  def duplicate
    @bottle = Bottle.find(params[:id]).dup
  end

  # GET /bottles/1/edit
  def edit
  end

  # POST /bottles
  # POST /bottles.json
  def create
    @bottle = Bottle.new(bottle_params)
    @bottle.user = current_user

    if @bottle.quantity == 1
      saved_successfully = @bottle.save
    else
      # Try and create #{quantity} records
      saved_successfully = false

      if @bottle.valid?
        Bottle.transaction do
          @bottle.quantity.to_i.times do
            new_bottle = @bottle.dup
            new_bottle.save!
          end

          saved_successfully = true
        end
      end
    end

    respond_to do |format|
      if saved_successfully
        format.html { redirect_to @bottle, notice: 'Bottle was successfully created.' }
        format.json { render :show, status: :created, location: @bottle }
      else
        format.html { render :new }
        format.json { render json: @bottle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bottles/1
  # PATCH/PUT /bottles/1.json
  def update
    respond_to do |format|
      if @bottle.update(bottle_params)
        format.html { redirect_to @bottle, notice: 'Bottle was successfully updated.' }
        format.json { render :show, status: :ok, location: @bottle }
      else
        format.html { render :edit }
        format.json { render json: @bottle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bottles/1
  # DELETE /bottles/1.json
  def destroy
    @bottle.destroy
    respond_to do |format|
      format.html { redirect_to bottles_url, notice: 'Bottle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_inventory
    current_user.toggle(:taking_inventory).save
    redirect_to bottles_path
  end

  def reset_stock
    Bottle.update_all(in_stock: false)
    redirect_to bottles_path
  end

  def stock
    @bottle.update(in_stock: true)
  end

  def unstock
    @bottle.update(in_stock: false)
  end

  def crack_open
    @bottle.update(open: true)
    redirect_to @bottle
  end

  def finish
    @bottle.update(finished_on: Date.today)
    redirect_to @bottle
  end

  def sell
    if @bottle.tag_list.include?("sell")
      @bottle.tag_list.remove("sell")
    else
      @bottle.tag_list.add("sell")
    end

    @bottle.save
    redirect_to @bottle
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bottle
      @bottle = Bottle.find_by(user: current_user, id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bottle_params
      params.require(:bottle).permit(
        :name,
        :details,
        :producer,
        :spirit,
        :volume,
        :proof,
        :abv,
        :release_year,
        :price,
        :source,
        :acquired_on,
        :notes,
        :open,
        :finished_on,
        :location,
        :quantity,
        :in_stock
      )
    end
end
