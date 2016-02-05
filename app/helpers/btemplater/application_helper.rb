module Btemplater
  module ApplicationHelper
    def do_title(title, titleactions = nil, smalltext = nil)
      set_meta_tags title: title
      content_tag(:div, class: 'page-header') do
        content_tag(:h1) do
          concat title
          concat content_tag(:small, smalltext) unless smalltext.nil?
          concat(content_tag(:div, class: 'btemplater_title_actions') do
            titleactions.each do |action|
              if action == :separator
                concat '<span class="btn-separator"></span>'.html_safe
              else
                concat action
              end
            end if titleactions
          end)
        end
      end
    end
  end
end
