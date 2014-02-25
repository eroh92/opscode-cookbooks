#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'nginx'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'python'
    Chef::Log.debug("Skipping deploy::python application #{application} as it is not an python (other) app")
    next
  end

  nginx_site 'maintenance-signal' do
    enable true
  end

  execute "nginx-reload" do
    command "service nginx reload"
  end

  execute "wait for server to be taken out of lb" do
    action :run
    command "sleep 60"
    timeout 70
  end

end

