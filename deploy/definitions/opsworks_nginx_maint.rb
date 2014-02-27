define :opsworks_nginx_maint do
  deploy = params[:deploy_data]
  application = params[:app]

  template "#{node['nginx']['dir']}/sites-available/maintenance-signal" do
    source "nginx-maintenance-signal.erb"
    owner 'root'
    group 'root'
    mode '0644'
    variables({
      :home_path => "#{deploy[:deploy_to]}/current",
      :name => application,
      :static => deploy[:static],
      :fonts => deploy[:fonts],
      :favicon => deploy[:favicon],
      :force_https => deploy[:force_https]
    })
  end 

end
