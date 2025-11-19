class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :add_channel, :remove_channel]
  before_action :authorize_collection, only: [:show, :edit, :update, :destroy, :add_channel, :remove_channel]

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def show
    @channels = @collection.channels.includes(:posts)
  end

  def new
    @collection = current_user.collections.build
  end

  def create
    @collection = current_user.collections.build(collection_params)
    
    if @collection.save
      redirect_to @collection, notice: "Collection created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @collection.update(collection_params)
      redirect_to @collection, notice: "Collection updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: "Collection deleted successfully."
  end

  def add_channel
    channel = Channel.find(params[:channel_id])
    
    unless @collection.channels.include?(channel)
      position = @collection.collection_channels.maximum(:position).to_i + 1
      @collection.collection_channels.create!(
        channel: channel,
        position: position,
        notes: params[:notes]
      )
      flash[:notice] = "Channel added to collection."
    else
      flash[:alert] = "Channel already in collection."
    end
    
    redirect_back(fallback_location: @collection)
  end

  def remove_channel
    channel = Channel.find(params[:channel_id])
    collection_channel = @collection.collection_channels.find_by(channel: channel)
    
    if collection_channel
      collection_channel.destroy
      flash[:notice] = "Channel removed from collection."
    end
    
    redirect_to @collection
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def authorize_collection
    unless @collection.user == current_user
      redirect_to collections_path, alert: "You don't have access to this collection."
    end
  end

  def collection_params
    params.require(:collection).permit(:name, :description)
  end
end
