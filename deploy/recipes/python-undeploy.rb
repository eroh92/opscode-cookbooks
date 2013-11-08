#
# Cookbook Name:: deploy
# Recipe:: python-undeploy

include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  case node[:opsworks][:python_stack][:name]
  when 'uwsgi'
    if node[:opsworks][:rails_stack][:service]
      include_recipe "#{node[:opsworks][:rails_stack][:service]}::service"
    end

    link "#{node[:apache][:dir]}/sites-enabled/#{application}.conf" do
      action :delete
      only_if do
        ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application}.conf")
      end
      notifies :restart, "service[#{node[:opsworks][:rails_stack][:service]}]"
    end

    file "#{node[:apache][:dir]}/sites-available/#{application}.conf" do
      action :delete
      only_if do
        ::File.exists?("#{node[:apache][:dir]}/sites-available/#{application}.conf")
      end
      notifies :restart, "service[#{node[:opsworks][:rails_stack][:service]}]"
    end

    file "/etc/nginx/sites-available/#{application}" do
      action :delete
      only_if do
        ::File.exists?("/etc/nginx/sites-available/#{application}")
      end
    end

    execute 'stop unicorn and restart nginx' do
      command "sleep #{deploy[:sleep_before_restart]} && \
               /srv/www/#{application}/shared/scripts/unicorn stop"
      notifies :restart, "service[nginx]"
      action :run
    end

  else
    raise 'Unsupported Rails stack'
  end

  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete
    only_if do
      File.exists?("#{deploy[:deploy_to]}")
    end
  end
end
