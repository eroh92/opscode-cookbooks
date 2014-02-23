#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'deploy'
include_recipe 'nginx'
include_recipe 'rsyslog'

service 'nginx' do
  provider Chef::Provider::Service::Upstart   
  supports :status => true, :restart => true, :reload => true
  action   :nothing
end

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'python'
    Chef::Log.debug("Skipping deploy::python application #{application} as it is not an python (other) app")
    next
  end

  opsworks_nginx_maint do
    deploy_data deploy
    app application
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

  execute "begin python deploy" do
    action :run
    command "echo 'begin python deploy...'"
    notifies :stop, "service[uwsgi-#{application}]", :immediately
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  opsworks_python do
    deploy_data deploy
    app application
  end

  execute "finished python deploy" do
    action :run
    command "echo 'finished python deploy!'"
    notifies :start, "service[uwsgi-#{application}]", :immediately
    notifies :reload, "service[nginx]", :delayed
  end

  nginx_site 'maintenance-signal' do
    enable false
  end

  execute "nginx-reload" do
    command "service nginx reload"
  end

end

