#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'nodejs::install_from_source'
include_recipe 'nodejs::npm'

execute "upgrade npm" do
  command "npm update npm -g"
end

execute "install brunch" do
  command "npm install -g brunch"
end

#execute "install bower" do
#  command "npm install -g bower"
#end

