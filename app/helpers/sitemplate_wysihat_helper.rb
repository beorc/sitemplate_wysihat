module SitemplateWysihatHelper
  def render_image_selector
    render partial: 'shared/sitemplate_select_image_dialog/markup', formats: [:html]
  end
end

