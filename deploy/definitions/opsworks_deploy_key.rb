define :opsworks_deploy_key do
  application = params[:app]
  deploy = params[:deploy_data]

  if deploy[:scm] and deploy[:scm][:ssh_key]
    template "#{deploy[:home]}/.ssh/#{application}.pem" do
        action :create
        mode '0400'
        owner deploy[:user]
        group deploy[:group]
        cookbook "scm_helper"
        source 'ssh_key.erb'
        variables :ssh_key => deploy[:scm][:ssh_key]
        not_if do
            deploy[:scm][:ssh_key].blank?
        end
    end
  end
end
