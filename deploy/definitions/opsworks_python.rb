define :opsworks_python do
  deploy = params[:deploy_data]
  application = params[:app]

  template "/etc/rsyslog.d/uwsgi.deploy.conf" do
    source 'rsyslog.conf'
    owner 'root'
    group 'root'
    mode '0644'
    variables({
      :name => application,
    })
    notifies :restart, 'service[rsyslog]'
  end

  uwsgi_service application do
    home_path "#{deploy[:deploy_to]}/current"
    pid_path "/var/run/uwsgi-app.pid"
    uid deploy[:user]
    gid deploy[:group]
    master true
    newrelic deploy[:newrelic]
    worker_processes deploy[:cpus]
    buffer_size 50000
    enable_threads true
    ini "#{deploy[:deploy_to]}/current/uwsgi.ini"
  end

  template "#{node['nginx']['dir']}/sites-available/#{application}" do
    source 'uwsgi-nginx-site.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables({
      :home_path => "#{deploy[:deploy_to]}/current",
      :name => application,
      :static => deploy[:static],
      :fonts => deploy[:fonts],
      :robots => deploy[:robots],
      :favicon => deploy[:favicon],
      :force_https => deploy[:force_https]
    })
    notifies :reload, 'service[nginx]'
  end

  nginx_site application do
    enable true
    notifies :reload, 'service[nginx]'
  end

end
