#
# Cookbook Name:: deploy
# Recipe:: python-restart
#

include_recipe "deploy"

node[:deploy].each do |application, deploy|

  execute "restart Server" do
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    action :run
    
    only_if do 
      File.exists?(deploy[:current_path])
    end
  end
    
end


