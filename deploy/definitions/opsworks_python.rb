define :opsworks_python do
  deploy = params[:deploy_data]
  application = params[:app]

  uwsgi_service application do
    home_path "#{deploy[:deploy_to]}/current"
    pid_path "/var/run/uwsgi-app.pid"
    uid deploy[:user]
    gid deploy[:group]
    master true
    worker_processes deploy[:cpus]
    buffer_size 50000
    http "0.0.0.0:8080"
    enable_threads true
    ini "#{deploy[:deploy_to]}/current/uwsgi.ini"
  end

end
