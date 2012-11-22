class CustomImagesController < InheritedResources::Base
  respond_to :json
  actions :create, :update

  authorize_resource

  def create
    @custom_image  = CustomImage.new

    @custom_image.width = params[:custom_image][:width]
    @custom_image.height = params[:custom_image][:height]

    if @custom_image.valid?
      @custom_image.uploaded_file = params[:custom_image][:uploaded_file]
      @custom_image.save
    end
    unless @custom_image.valid?
      render json: @custom_image.errors.messages, status: 500
    end
  end

  # TODO: remove this method after https://github.com/svenfuchs/globalize3/issues/55 fix
  def update
    update! do
      set_resource_ivar(resource.class.find(params[:id]))
    end
  end
end

