class CustomImagesController < InheritedResources::Base
  respond_to :json
  actions :create, :update

  authorize_resource

  def create
    @custom_image  = CustomImage.new

    @custom_image.width = params[:custom_image][:width]
    @custom_image.height = params[:custom_image][:height]

    @custom_image.uploaded_file = params[:custom_image][:uploaded_file]
    @custom_image.save!
  end

  # TODO: remove this method after https://github.com/svenfuchs/globalize3/issues/55 fix
  def update
    update! do
      set_resource_ivar(resource.class.find(params[:id]))
    end
  end
end

