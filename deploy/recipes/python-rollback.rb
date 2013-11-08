node[:deploy].each do |application, deploy|

  deploy deploy[:deploy_to] do
    user deploy[:user]
    environment "RAILS_ENV" => deploy[:rails_env], "RUBYOPT" => ""
    action "rollback"
    restart_command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    
    only_if do
      File.exists?(deploy[:current_path])
    end
  end
end
