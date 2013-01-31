module SitemplateWysihatHelper
  def render_image_selector
    render partial: 'shared/sitemplate_select_image_dialog/markup', formats: [:html]
  end

  def render_link_selector
    render partial: 'shared/insert_link_dialog', formats: [:html]
  end

  def simple_form_for(record, options={}, &block)
    return super if options[:wysihat].blank?

    options.delete :wysihat

    content = render_image_selector
    content << render_link_selector
    content << super
  end
end

