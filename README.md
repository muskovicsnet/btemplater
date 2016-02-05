# Btemplater

Template helpers.

## Configuration

Set the current_user entity

    module Btemplater
      class Engine < Rails::Engine
        config.current_user_entity = Proc.new do |u|
          u
        end
      end
    end

Get current user:

    Btemplater::Engine.config.current_user_entity.call(self)

## Controller

    helper Btemplater::ApplicationHelper
    helper Btemplater::IndexHelper
    helper Btemplater::ShowHelper
    helper Btemplater::NewHelper
    include Btemplater::Tools

    def index
      @objects = Notifications::Message.all.order('created_at desc').page(params[:page])
    end

    def show
      @obj = Notifications::Message.find(params[:id])
    end

    def new
      @obj = Notifications::Message.new
    end

    def create
      do_create(params, Notifications::Message, notifications.messages_path)
    end

    def edit
      @obj = Conrateblogs::Post.find(params[:id])
    end

    def update
      do_update(params, Conrateblogs::Blog, conrateblogs.blogs_path)
    end

    def destroy
      @obj = Notifications::Message.find(params[:id])
      @obj.destroy
      redirect_to notifications.messages_path
    end

    def count
      render json: Notifications::Message.where.where(unread: true).count
    end

    def before_save_create(obj)
      # before saving the object in create action
    end

    def after_save_create(obj)
      # after saving the object in create action
    end

## View

### index.html.erb

    <%=
      do_index({
        title: t(".#{params[:messagetype]}"),
        rowclass: lambda { |d| d.unread ? 'unread' : 'read' },
        columns: [
          :id,
          :subject,
          Btemplater::IndexDecorator.new(:sender, Proc.new { |d| d.try(:pretty_name) }),
          Btemplater::IndexDecorator.new(:recipient, Proc.new { |d| d.try(:pretty_name) }),
          Btemplater::IndexDecorator.new(:created_at, Proc.new { |d| l(d) })
        ],
        items: @objects,
        model: Notifications::Message,
        actions: [
          Btemplater::ActionDecorator.new(
            :show,
            Proc.new { |objs| notifications.message_path(params[:messagetype], objs) },
            t('actions.show', scope: :btemplater),
            'file'
          )
        ]
      })
    %>

    <%= do_new_button({model: Notifications::Message.new}) %>

### show.html.erb

    <%= do_show({
      title: t(".#{params[:messagetype]}", obj: @obj.subject),
      columns: [
        Btemplater::ShowDecorator.new(:created_at, {}),
        Btemplater::ShowDecorator.new(:pretty_name, {in: :sender}),
        Btemplater::ShowDecorator.new(:pretty_name, {in: :recipient}),
        Btemplater::ShowDecorator.new(:body, {}, lambda { |d| content_tag(:pre, d) })
      ],
      item: @obj,
      model: Notifications::Message,
      url: notifications.messages_path(params[:messagetype]),
      method: :post,
      actions: [
        link_to(notifications.reply_message_path(params[:messagetype], @obj), class: 'btn btn-default') do
          "<span class=\"fa fa-reply\"></span> #{t('actions.reply', scope: :btemplater)}".html_safe
        end
      ]
    })
    %>

### new.html.erb

    <%= do_new({
        title: t(".blogs"),
        columns: [
          :title,
          :description
        ],
        item: @obj,
        model: Conrateblogs::Blog,
        url: conrateblogs.blogs_path,
        back_url: main_app.home_path,
        form_params: {html: {multipart: true}},
        method: :post,
        form_bottom: 'custom_partial'
      })
    %>

### edit.html.erb

    <%= do_edit({
        title: t(".blogs"),
        columns: [
          :title,
          :description
        ],
        item: @obj,
        model: Conrateblogs::Blog,
        url: conrateblogs.blog_path(@obj),
        back_url: @obj,
        method: :post,
        form_bottom: 'custom_partial'
      })
    %>



### Title

do_title 'Header'
do_title 'Header', nil, 'small text'
do_title 'Header', :separator ?????
