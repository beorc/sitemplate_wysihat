module SitemplateWysihat
  module ApplicationControllerExtensions
    extend ActiveSupport::Concern

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
end

