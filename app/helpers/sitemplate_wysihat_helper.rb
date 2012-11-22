module SitemplateWysihatHelper
  def render_image_selector
    render partial: 'shared/select_image_dialog/markup', formats: [:html]
  end
end

