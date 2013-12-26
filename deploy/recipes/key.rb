#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'key'
    Chef::Log.debug("Skipping deploy::key application #{application} as it is not an key app")
    next
  end

  opsworks_deploy_key do
    deploy_data deploy
    app application
  end

end

