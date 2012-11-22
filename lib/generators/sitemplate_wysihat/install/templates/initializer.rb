class ::SimpleForm::FormBuilder
  def sitemplate_wysihat(attribute_name, options = {}, &block)
    options[:as] = :text
    options[:input_html] ||= {}
    options[:input_html].merge!(class: 'sitemplate-rich-editor')

    input(attribute_name, options, &block)
  end
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

