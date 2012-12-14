SitemplateWysihat.setup do |config|
end

class ::SimpleForm::FormBuilder
  def sitemplate_wysihat(attribute_name, options = {}, &block)
    options[:as] = :text
    options[:input_html] ||= {}
    options[:input_html].merge!(class: 'sitemplate-rich-editor')

    input(attribute_name, options, &block)
  end
end

module ::SimpleForm::ActionViewExtensions::FormHelper
  def simple_form_for_with_wysihat(record, options={}, &block)
    content = render_image_selector
    content << render_link_selector
    content << simple_form_for(record, options, &block)
  end
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

