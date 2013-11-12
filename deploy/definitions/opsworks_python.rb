define :opsworks_python do
  deploy = params[:deploy_data]
  application = params[:app]

  uwsgi_service application do
    home_path "#{deploy[:deploy_to]}/current"
    uwsgi_path "#{deploy[:deploy_to]}/current/bin/uwsgi"
    pid_path "/var/run/uwsgi-app.pid"
    host "127.0.0.1"
    port 8080
    worker_processes deploy[:cpus]
    enable_threads true
    ini "#{deploy[:deploy_to]}/current/uwsgi.ini"
  end

end
