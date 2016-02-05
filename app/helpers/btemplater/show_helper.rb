module Btemplater
  module ShowHelper
    def do_show(args)
      raise Pundit::NotAuthorizedError unless "#{args[:model]}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), args[:item]).show?

      args.merge(
        title: [],
        columns: [],
        item: nil,
        model: nil,
        url: nil
      )
      capture do
        concat do_title(args[:title], args[:titleactions])
        concat(
          show_for(args[:item]) do |s|
            args[:columns].each do |column|
              if column.instance_of? Btemplater::ShowDecorator
                if column.block.nil?
                  concat(s.attribute column.name, column.arguments)
                else
                  concat(s.attribute(column.name, column.arguments) do
                    column.block.call(s.object.send(column.name))
                  end)
                end
              else
                # concat(s.label column)
                concat(s.attribute column)
              end
            end if args[:columns]
          end
        )
        concat(
          if args[:my_content]
            render args[:my_content]
          end
        )
        concat(
          content_tag(:div, class: 'actions') do
            concat link_to(t('actions.back', scope: :btemplater), args[:url] || :back, class: 'btn btn-primary') unless(args[:no_back])
            args[:actions].each do |action|
              if action == :separator
                concat '<span class="btn-separator"></span>'.html_safe
              else
                concat action
              end
            end if args[:actions]
          end
        )
      end
    end
  end
end
