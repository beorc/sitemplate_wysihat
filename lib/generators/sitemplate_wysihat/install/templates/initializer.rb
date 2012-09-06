class ::SimpleForm::FormBuilder
  def sitemplate_wysihat(attribute_name, options = {}, &block)
    options[:as] = :text
    options[:input_html] = {class: 'sitemplate-rich-editor'}

    input(attribute_name, options, &block)
  end
end

