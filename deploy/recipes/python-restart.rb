#
# Cookbook Name:: deploy
# Recipe:: python-restart
#


node[:deploy].each do |application, deploy|

  execute "restart server" do
    command "stop uwsgi-#{application} && start uwsgi-#{application} && reload nginx"
    action :run
    
    only_if do 
      File.exists?(deploy[:current_path])
    end
  end
    
end


