define :opsworks_nginx_maint do
  deploy = params[:deploy_data]
  application = params[:app]

  template "#{node['nginx']['dir']}/sites-available/maintenance-signal" do
    source "nginx-maintenance-signal.erb"
    owner 'root'
    group 'root'
    mode '0644'
  end 

end
