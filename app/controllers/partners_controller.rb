class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /partners
  def index
    @partners = Partner.all
  end

  # GET /partners/1
  def show
  end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1/edit
  def edit
  end

  # POST /partners
  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      redirect_to partners_url, notice: 'Partner was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /partners/1
  def update
    if @partner.update(partner_params)
      redirect_to partners_url, notice: 'Partner was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /partners/1
  def destroy
    @partner.destroy
    redirect_to partners_url, notice: 'Partner was successfully destroyed.'
  end

  def dashboard
    @emails = Email.all
    @shops  = Shop.all
  end

  def save_template
    template = params[:template]
    current_user.template = template
    if current_user.save
      redirect_to partners_url, notice: 'Template was successfully updated.'
    else
      redirect_to partners_url, error: 'There is error to save template.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
      @partner = Partner.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def partner_params
      params.require(:partner).permit(:email, :name)
    end
end
