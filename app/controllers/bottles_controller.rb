class BottlesController < ApplicationController
  before_action :set_bottle, only: [:show, :edit, :update, :destroy]

  # GET /bottles
  # GET /bottles.json
  def index
    @bottles = Bottle.order('LOWER(name), release_year')
    @filter = params[:filter].try(:downcase)

    case @filter
    when "open"
      @bottles = @bottles.open
    when "finished"
      @bottles = @bottles.finished
    else
      @bottles = @bottles.current
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

  # GET /bottles/1/edit
  def edit
  end

  # POST /bottles
  # POST /bottles.json
  def create
    @bottle = Bottle.new(bottle_params)

    if @bottle.quantity == 1
      saved_successfully = @bottle.save
    else
      # Try and create #{quantity} records
      saved_successfully = false

      if @bottle.valid?
        Bottle.transaction do
          begin
            @bottle.quantity.to_i.times do
              new_bottle = @bottle.dup
              new_bottle.save!
            end
          else
            saved_successfully = true
          end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bottle
      @bottle = Bottle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bottle_params
      params.require(:bottle).permit(
        :name,
        :producer,
        :spirit,
        :volume,
        :proof,
        :release_year,
        :price,
        :acquired_on,
        :notes,
        :acquired,
        :open,
        :finished,
        :location,
        :quantity
      )
    end
end
