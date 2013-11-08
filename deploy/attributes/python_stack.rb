default[:opsworks][:python_stack][:name] = "uwsgi"
case node[:opsworks][:python_stack][:name]
when "uwsgi"
  default[:opsworks][:python_stack][:recipe] = "passenger_apache2::rails"
  default[:opsworks][:python_stack][:needs_reload] = true
  default[:opsworks][:python_stack][:service] = 'apache2'
  default[:opsworks][:python_stack][:restart_command] = 'touch tmp/restart.txt'
else
  raise "Unknown stack: #{node[:opsworks][:python_stack][:name].inspect}"
end
