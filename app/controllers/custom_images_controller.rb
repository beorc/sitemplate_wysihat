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

  protected

  # FIXME: Remotipart::RenderOverrides по какой-то причине не включается в
  # ApplicationController. Или же включается, но render перетирается кем-то еще.
  # Вобщем смысл в том, что remotipart не обеспечивает нас актуальной версией
  # этого метода, который необходим для его правильной работы.
  # Поэтому -- копипаст из remotipart сюда, чтобы все точно получилось.
  def render(*args)
    super
    if remotipart_submitted?
      response.body = %{<textarea data-type=\"#{content_type}\" response-code=\"#{response.response_code}\">#{escape_once(response.body)}</textarea>}
      response.content_type = Mime::HTML
    end
    response_body
  end

end

