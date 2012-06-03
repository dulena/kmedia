class Admin::CatalogsController < Admin::ApplicationController
  load_and_authorize_resource :only => [:show, :new, :destroy, :edit, :update, :create]
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to admin_lessons_path, :alert => "There is no Container with ID=#{params[:id]}."
  end

  def index
    @catalogs = Catalog.
        accessible_by(current_ability, :index).
        order('catalognodename ASC')
    if params[:q]
      @catalogs = @catalogs.where("catalognodename like ?", "%#{params[:q]}%")
    else
      @catalogs = @catalogs.page(params[:page])
    end

    respond_to do |format|
      format.html
      format.json { render :json => @catalogs.map { |c| {:id => c.catalognodeid, :name => c.catalognodename} } }
    end
  end

  def show
  end

  def new
    @languages = Language.order('code3').all
    lang_codes = @catalog.catalog_descriptions.map(&:lang)
    @languages.each{ |l|
      @catalog.catalog_descriptions.build(:lang => l.code3) unless lang_codes.include?(l.code3)
    }
    @catalog_descriptions = sort_descriptions
  end

  def create
    if @catalog.save
      redirect_to [:admin, @catalog], :notice => "Successfully created catalog."
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.order('code3').all
    lang_codes = @catalog.catalog_descriptions.map(&:lang)
    @languages.each{ |l|
      @catalog.catalog_descriptions.build(:lang => l.code3) unless lang_codes.include?(l.code3)
    }
    @catalog_descriptions = sort_descriptions
  end

  def update
    if @catalog.update_attributes(params[:catalog])
      redirect_to admin_catalog_path(@catalog), :notice => "Successfully updated catalog."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @catalog.destroy
    redirect_to admin_catalogs_url, :notice => "Successfully destroyed catalog."
  end

  private
  def sort_descriptions
    catalog_descriptions_main = {}
    catalog_descriptions_all = []
    @catalog.catalog_descriptions.each{|x|
      if MAIN_LANGS.include? x.lang
        catalog_descriptions_main[x.lang] = x
      else
        catalog_descriptions_all << x
      end
    }
    MAIN_LANGS.map{|l| catalog_descriptions_main[l]} + catalog_descriptions_all.sort_by{|x| x.lang }
  end
  
end
