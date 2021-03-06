require "utils/i18n"

class Admin::DictionariesController < Admin::ApplicationController
  load_and_authorize_resource

  # GET /admin/dictionaries
  # GET /admin/dictionaries.json
  def index
    @dictionaries = @dictionaries.page(params[:page])
  end

  # GET /admin/dictionaries/1
  # GET /admin/dictionaries/1.json
  def show
    @descriptions = Utils::I18n.sort_descriptions(@dictionary.dictionary_descriptions)
  end

  # GET /admin/dictionaries/new
  # GET /admin/dictionaries/new.json
  def new
    @dictionary = Dictionary.new
    @dictionary.suid = Dictionary.next_suid
    Language.all.each do |language|
      @dictionary.dictionary_descriptions.build(lang: language.code3)
    end
    @descriptions = Utils::I18n.sort_descriptions(@dictionary.dictionary_descriptions)
  end

  # GET /admin/dictionaries/1/edit
  def edit
    @dictionary = Dictionary.find(params[:id])
    authorize! :edit, @dictionary

    @descriptions = Utils::I18n.sort_descriptions(@dictionary.dictionary_descriptions)
  end

  # POST /admin/dictionaries
  # POST /admin/dictionaries.json
  def create
    @dictionary = Dictionary.new(params[:dictionary])
    authorize! :create, @dictionary

    if @dictionary.save
      redirect_to admin_dictionary_path(@dictionary), notice: 'Successfully created dictionary.'
    else
      render :action => 'new'
    end
  end

  # PUT /admin/dictionaries/1
  # PUT /admin/dictionaries/1.json
  def update
    @descriptions = Utils::I18n.sort_descriptions(@dictionary.dictionary_descriptions)

    if @dictionary.update_attributes(params[:dictionary])
      redirect_to admin_dictionary_path(@dictionary), notice: 'Dictionary was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/dictionaries/1
  # DELETE /admin/dictionaries/1.json
  def destroy
    @dictionary.destroy
    redirect_to admin_dictionaries_url, notice: 'Successfully destroyed dictionary.'
  end

  def existing_suids
    existing_dictionaries = Dictionary.suid_starts_with(params[:suid])
    render json: existing_dictionaries.map{|dict| dict.suid }.to_json
  end

end
