ActiveAdmin.register App do
  include ActiveAdminHelper
  
  permit_params backup_schemas_attributes: [:resource_id, :days, :hours, :retention, :enabled, :_destroy, :id]
  
  actions :index, :update, :edit
  
  filter :name
  filter :f_id

  collection_action :sync, method: :post do
    FlynnSync.sync
    redirect_to collection_path, notice: "Flynn is synced"
  end

  action_item :sync, only: :index do
    link_to 'Sync apps with cluster', sync_admin_apps_path, method: :post
  end

  
  index do
    selectable_column
    id_column
    column :f_id
    column :name
    column :jobs do |row|
      row.backup_schemas.enabled.count
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    panel "App details" do
      attributes_table_for f.object do
        row :name
        row :f_id
      end
    end

    columns do
      column do
        panel "Resources" do
          attributes_table_for f.object.resources, 'provider_name' do
            row :f_id
            row :provider_id
          end
        end
        
      end
      column do 
        panel "Routes" do
          attributes_table_for f.object.routes, 'route' do
            row :f_id
            row :service
            row :sticky
            row :leader
            row :path
          end
        end
      end
    end

    f.inputs "Backup schema" do 
      f.has_many :backup_schemas, heading: false, allow_create: true, allow_destroy: true do |b|
        b.input :resource, hint: "Leave blank for full app backup", collection: f.object.resources
        b.input :days, hint: "Number of days between backups"
        b.input :hours, hint: "Number of hours between backups"
        b.input :retention, hint: "Amount of backups that need to be kept"
        b.input :enabled, hint: "Last run at: #{b.object.run_at}"
      end
    end

    f.actions
  end

end
