ActiveAdmin.register Backup do
  actions :index, :destroy
  filter :app
  filter :resource
  filter :created_at

  index do 
    #selectable_column
    id_column
    column :app
    column :resource
    column :file do |r|
      link_to 'backup', r.file.url, target: '_blank'
    end
    column :file_size do |r|
      number_to_human_size(r.file_size)  
    end
    column :created_at
    actions
  end

end