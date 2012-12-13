module SitemplateWysihatHelper
  def render_image_selector
    render partial: 'shared/sitemplate_select_image_dialog/markup', formats: [:html]
  end

  def render_link_selector
    render partial: 'shared/insert_link_dialog', formats: [:html]
  end
end

