class EtemplatesController < ApplicationController
  before_action :set_etemplate, only: [:show, :edit, :update, :destroy]

  # GET /Etemplates
  def index
    @templates = Etemplate.all
  end

  # GET /Etemplates/1
  def show
  end

  # GET /Etemplates/new
  def new
    @template = Etemplate.new
  end

  # GET /Etemplates/1/edit
  def edit
  end

  # POST /Etemplates
  def create
    @template = Etemplate.new(etemplate_params)

    if @template.save
      redirect_to @template, notice: 'Etemplate was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /Etemplates/1
  def update
    if @template.update(etemplate_params)
      redirect_to @template, notice: 'Etemplate was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /Etemplates/1
  def destroy
    @template.destroy
    redirect_to etemplates_url, notice: 'Etemplate was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_etemplate
      @template = Etemplate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def etemplate_params
      params.require(:etemplate).permit(:template_id, :template_name)
    end
end
