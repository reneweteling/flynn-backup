ActiveAdmin.register AcmeCert do
  include ActiveAdminHelper
  belongs_to_app
  permit!

  controller do
    def build_new_resource
      record = super
      record.app = app
      record
    end
  end
  
  permit_params :route_id, :email
  
  action_item :show, only: :show do
    link_to("Activate cert", activate_admin_app_acme_cert_path(app, resource), method: :put)
    
    # .html_safe +
    # link_to("Request status", get_status_admin_app_acme_cert_path(app, resource), method: :put).html_safe +
    # link_to("Request certificate", get_certificate_admin_app_acme_cert_path(app, resource), method: :put).html_safe +
    # link_to("Update route with certificate", update_route_admin_app_acme_cert_path(app, resource), method: :put).html_safe
  end

  member_action :activate, method: :put do 
    resource.activate_certificate
    redirect_to resource_path, notice: "Activated"
  end

  member_action :get_challenge, method: :put do
    AcmeClient.new(resource).get_challenge!
    redirect_to resource_path, notice: "Requested challenge!"
  end

  member_action :get_status, method: :put do
    AcmeClient.new(resource).get_status!
    redirect_to resource_path, notice: "Requested challenge status!"
  end

  member_action :get_certificate, method: :put do
    AcmeClient.new(resource).get_certificate!
    redirect_to resource_path, notice: "Requested certificates!"
  end

  member_action :update_route, method: :put do 
    output = Flynn.new(resource.app.name).update_ssl_route(resource)
    redirect_to resource_path, notice: "Route added #{output}".html_safe
  end

  filter :app
  filter :common_name

  index do
    selectable_column
    id_column
    column :app
    column :common_name
    column :status
    column :auth_verify_status
    actions
  end

  show do
    attributes_table "Artist details" do
      row :common_name
      list_row :domains
      row :app
      row :route
      row :ssl_route
      row :email
      row :status
      row :auth_uri
      row :filename
      row :file_content
      row :challenge_verify_status
      row :auth_verify_status
      row :error
      bool_row :private_pem do |r|
        r.private_pem.present?
      end
      bool_row :cert_pem do |r|
        r.cert_pem.present?
      end
      bool_row :chain_pem do |r|
        r.chain_pem.present?
      end
      bool_row :fullchain_pem do |r|
        r.fullchain_pem.present?
      end
      row :issued_at
      row :expires_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    panel "App details" do
      attributes_table_for f.object do
        row :status
        row :auth_uri
        row :filename
        row :file_content
        row :challenge_verify_status
        row :auth_verify_status
        row :error
        bool_row :private_pem do |r|
          r.private_pem.present?
        end
        bool_row :cert_pem do |r|
          r.cert_pem.present?
        end
        bool_row :chain_pem do |r|
          r.chain_pem.present?
        end
        bool_row :fullchain_pem do |r|
          r.fullchain_pem.present?
        end
        row :issued_at
        row :expires_at
      end
    end

    f.object.email ||= current_admin_user.email

    f.inputs "Attributes" do 
      f.input :app
      f.input :route, collection: app.routes
      f.input :email
    end

    f.actions
  end


end