module Btemplater
  module NewHelper
    def do_new(args)
      raise Pundit::NotAuthorizedError unless "#{args[:model]}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), args[:item]).new?

      args.merge(
        title: [],
        columns: [],
        items: [],
        model: nil,
        url: nil,
        method: :get,
        form_params: { class: 'form-horizontal' }
      )
      capture do
        concat do_title(args[:title])
        concat(simple_form_for(args[:item], html: args[:form_params], url: args[:url], post: args[:method]) do |f|
                concat(content_tag(:div, class: 'inputs') do
                                  args[:columns].each do |column|
                                    if column.instance_of? Btemplater::NewDecorator
                                      concat column.decorator.call(f, column)
                                    else
                                      concat f.input column
                                    end
                                  end
                                end)
                    concat(render(args[:form_bottom], f: f)) if args[:form_bottom]
                    concat(content_tag(:div, class: 'actions') do
                                          concat f.submit class: 'btn btn-primary'
                                          concat link_to t('cancel', scope: :btemplater), args[:back_url], class: 'btn btn-default'
                                        end)
                end)
      end
    end
  end
end
