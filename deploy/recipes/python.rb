#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'python'
    Chef::Log.debug("Skipping deploy::python application #{application} as it is not an python (other) app")
    next
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
end

