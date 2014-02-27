#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'nodejs::install_from_source'
include_recipe 'nodejs::npm'

execute "install brunch" do
  command "npm install -g brunch"
end

