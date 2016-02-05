module Btemplater
  module Tools
    def do_create(params, model, redirect_root = nil)
      @obj = model.new(obj_params(@obj, model))
      raise Pundit::NotAuthorizedError unless("#{model}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), @obj).create?)
      try(:before_save_create, @obj)
      # before_save_create if method_defined? :before_save_create
      if @obj.save
        if redirect_root.nil?
          try(:after_save_create, @obj)
          redirect_to @obj
        else
          try(:after_save_create, @obj)
          redirect_to redirect_root
        end
      else
        render 'new'
      end
    end

    def do_update(params, model, redirect_root = nil)
      @obj = model.find(params[:id])
      raise Pundit::NotAuthorizedError unless("#{model}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), @obj).update?)
      try(:before_save_update, @obj)
      # before_save_create if method_defined? :before_save_create
      if @obj.update(obj_params(@obj, model))
        if redirect_root.nil?
          redirect_to @obj
        else
          redirect_to redirect_root
        end
      else
        render 'edit'
      end
    end

    def do_destroy(params, model, redirect_root = nil)
      @obj = model.find(params[:id])
      raise Pundit::NotAuthorizedError unless("#{model}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), @obj).destroy?)
      @obj.destroy
      if redirect_root.nil?
        redirect_to @obj
      else
        redirect_to redirect_root
      end
    end

    private

    def obj_params(obj, model)
      policy = "#{model}Policy".constantize.new(Btemplater::Engine.config.current_user_entity.call(self), obj || model)
      params.require(model.to_s.demodulize.underscore.to_sym).permit(policy.permitted_attributes)
    end
  end
end
