module ActiveAdminHelper
  

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    def class_constant_to_select(klass)
      klass.constants.map{|c| [c, klass.const_get(c)] }
    end

    def belongs_to_app

      belongs_to :app

      controller do
        
        def autoscoped_collection
          relation = self.class.name.split('::').last.gsub('Controller', '').underscore.to_sym
          parent.send(relation)
        end

        def scoped_collection
          autoscoped_collection
        end

        # Provide access to the parent resource record: Site.
        #
        # Without this extra setup the parent record will not be accessible. Any
        # calls to `#parent` will return the Arbre parent element and not the
        # ActiveAdmin resource.
        alias_method :app, :parent

        # Expose the method as a helper making it available to the view
        helper_method :app
      end
    end

    def permit!
      controller do

        def permitted_params
          params.permit!
        end

        def create
          create! do |format|
            format.html { redirect_to "#{request.original_url}/new", :flash => { :success => "Record aangemaakt." } } if resource.valid? and params[:commit] == I18n.t('formtastic.create_again')
          end
        end

      end
    end
  end

end
