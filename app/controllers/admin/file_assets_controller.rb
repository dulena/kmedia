class Admin::FileAssetsController < Admin::ApplicationController
  before_filter :set_fields, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource

  def index
    @file_assets = @file_assets.page(params[:page])
  end

  def show
    @asset = FileAsset.find(params[:id])
  end

  def new
    @asset = FileAsset.new
  end

  def create
    @asset = FileAsset.new(params[:file])
    if @asset.save
      redirect_to [:admin, @asset], :notice => "Successfully created file."
    else
      render :action => 'new'
    end
  end

  def edit
    @asset = FileAsset.find(params[:id])
  end

  def update
    @asset = FileAsset.find(params[:id])
    if @asset.update_attributes(params[:file_asset])
      redirect_to [:admin, @asset], :notice => "Successfully updated file."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @asset = FileAsset.find(params[:id])
    @asset.destroy
    redirect_to admin_file_assets_url, :notice => "Successfully destroyed file."
  end

  private
  def set_fields
    @languages = Language.order('code3').all
    @servers = Server.order('servername ASC').all
    @security = SECURITY.collect { |s| [s[:name], s[:level]] }
  end
end
