class CustomImagesController < InheritedResources::Base
  respond_to :json
  actions :create, :update

  authorize_resource

  def create
    @custom_image  = CustomImage.new

    @custom_image.width = params[:custom_image][:width].to_i
    @custom_image.height = params[:custom_image][:height].to_i

    begin
      @custom_image.uploaded_file = params[:custom_image][:uploaded_file]
    rescue => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end

    unless @custom_image.save
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

