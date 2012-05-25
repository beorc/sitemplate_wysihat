module SitemplateWysihat
  class ::SimpleForm::FormBuilder
    def input_with_rich_editor(attribute_name, options = {}, &block)
      if options[:as] == :sitemplate_rich_editor
        options[:as] = :text
        options[:input_html] = {class: 'sitemplate-rich-editor'}
      end

      input_without_rich_editor(attribute_name, options, &block)
    end
  end

  class Engine < ::Rails::Engine
    config.to_prepare do
      ::SimpleForm::FormBuilder.alias_method_chain :input, :rich_editor
    end
  end
end
