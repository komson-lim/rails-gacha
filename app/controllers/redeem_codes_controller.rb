class RedeemCodesController < ApplicationController
  before_action :set_redeem_code, only: %i[ show edit update destroy ]

  # GET /redeem_codes or /redeem_codes.json
  def index
    @redeem_codes = RedeemCode.all
  end

  # GET /redeem_codes/1 or /redeem_codes/1.json
  def show
  end

  # GET /redeem_codes/new
  def new
    @redeem_code = RedeemCode.new
  end

  # GET /redeem_codes/1/edit
  def edit
  end

  # POST /redeem_codes or /redeem_codes.json
  def create
    @redeem_code = RedeemCode.new(redeem_code_params)

    respond_to do |format|
      if @redeem_code.save
        format.html { redirect_to @redeem_code, notice: "Redeem code was successfully created." }
        format.json { render :show, status: :created, location: @redeem_code }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @redeem_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem_codes/1 or /redeem_codes/1.json
  def update
    respond_to do |format|
      if @redeem_code.update(redeem_code_params)
        format.html { redirect_to @redeem_code, notice: "Redeem code was successfully updated." }
        format.json { render :show, status: :ok, location: @redeem_code }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @redeem_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem_codes/1 or /redeem_codes/1.json
  def destroy
    @redeem_code.destroy
    respond_to do |format|
      format.html { redirect_to redeem_codes_url, notice: "Redeem code was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redeem_code
      @redeem_code = RedeemCode.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def redeem_code_params
      params.require(:redeem_code).permit(:code, :amount, :status)
    end
end
