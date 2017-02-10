# frozen_string_literal: true
class FakeInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    template.text_area_tag(attribute_name, nil, merged_input_options)
  end
end
