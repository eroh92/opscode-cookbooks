define :opsworks_deploy_key do
  application = params[:app]
  deploy = params[:deploy_data]

  if deploy[:scm]
    ensure_scm_package_installed(deploy[:scm][:scm_type])
    prepare_git_checkouts(
      :user => deploy[:user],
      :group => deploy[:group],
      :home => deploy[:home],
      :ssh_key => deploy[:scm][:ssh_key]
    ) if deploy[:scm][:scm_type].to_s == 'git'
  end
end
