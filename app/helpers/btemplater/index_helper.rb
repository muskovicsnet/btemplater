module Btemplater
  module IndexHelper
    def do_index(args)
      raise Pundit::NotAuthorizedError unless "#{args[:model]}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), args[:model]).index?

      args.merge(
        title: [],
        columns: [],
        items: [],
        model: nil,
        actions: []
      )
      concat do_title(args[:title])
      concat(paginate args[:items])
      concat(custom_table_for(args) do
              args[:columns].each do |c|
                if c.instance_of? Btemplater::IndexDecorator
                  column(c.name, args[:model].human_attribute_name(c.name), &c.decorator)
                else
                  column c, args[:model].human_attribute_name(c)
                end
              end
            end)
      (paginate args[:items])
    end

    def show_action(args, item)
      link_to item, class: 'btn btn-default', title: t('actions.show', scope: :btemplater) do
        content_tag(:span, '', class: 'fa fa-file')
      end.html_safe
    end

    def edit_action(args, item, right = true)
      link_to [:edit, item].flatten, class: 'btn btn-default', title: t('actions.edit', scope: :btemplater) do
        content_tag(:span, '', class: 'fa fa-pencil-square-o')
      end.html_safe if right
    end

    def destroy_action(args, item, right = true)
      link_to item, class: 'btn btn-danger', method: :delete, data: {confirm: I18n.t('actions.are_you_sure', scope: :btemplater)}, title: t('actions.destroy', scope: :btemplater) do
        content_tag(:span, '', class: 'fa fa-trash')
      end.html_safe if right
    end

    def action_decorator(ad, item)
      link_to ad.path.call(item), class: 'btn btn-default', title: ad.title, method: ad.method, data: ad.data do
        if ad.icon.class == Proc
          content_tag(:span, '', class: "fa fa-#{ad.icon.call(item)}")
        else
          content_tag(:span, '', class: "fa fa-#{ad.icon}")
        end
      end.html_safe
    end

    def custom_table_for(args)
      @columns = []
      yield

      content_tag :table, class: "table table-responsive table-hover table-striped #{args[:model].to_s.underscore.gsub('/', '_')}" do
        thead(args) + tbody(args)
      end
    end

    def thead(args)
      content_tag :thead do
        content_tag :tr do
          @columns.each do |c|
            concat(content_tag(:th, c[:value]))
          end
          concat(content_tag(:th, '')) unless args[:actions].empty?
        end
      end
    end

    def tbody(args)
      items = args[:items]
      content_tag :tbody do
        items.each do |item|
          concat(
            content_tag(:tr, class: (args[:rowclass].nil? ? '' : args[:rowclass].call(item))) do
              @columns.each do |column|
                if column[:block]
                  concat(content_tag(:td, column[:block].call(item.send(column[:name]), item)))
                else
                  concat(content_tag(:td, item.send(column[:name])))
                end
              end
              concat(content_tag(:td) do
                args[:actions].each do |action|
                  if action.instance_of? Btemplater::ActionDecorator
                    if "#{item.class}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), item).send("#{action.name}?")
                      concat(content_tag(:div, action_decorator(action, item), style: 'display: inline;'))
                    end
                  else
                    if "#{item.class}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), item).send("#{action}?")
                      concat(content_tag(:div, send("#{action}_action", args, item), style: 'display: inline;'))
                    end
                  end
                end
              end)
            end
          )
        end
      end
    end

    def column(name, value = nil, &block)
      value = name unless value
      @columns << { name: name, value: value, block: block }
    end

    def do_new_button(args)
      content_tag :div do
        link_to t('helpers.submit.create', model: args[:model].class.model_name.human),
                url_for(controller: args[:model].class.to_s.tableize, action: :new),
                class: 'btn btn-primary'
      end if "#{args[:model].class.to_s}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), args[:model]).new?
    end
  end
end
