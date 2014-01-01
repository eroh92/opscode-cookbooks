#
# Cookbook Name:: deploy
# Recipe:: python
#

include_recipe 'deploy'
include_recipe 'nginx'
include_recipe 'rsyslog'

node[:deploy].each do |application, deploy|
  cron_jobs = deploy[:cron]

  cron_jobs.each do |cron_job|
    cron cron_job[:name] do
      minute (cron_job[:minute] or '*')
      hour (cron_job[:hour] or '*')
      day (cron_job[:day] or '*')
      weekday (cron_job[:weekday] or '*')
      month (cron_job[:month] or '*')
      command cron_job[:command]
      user (cron_job[:user] or deploy[:user])
      mailto cron_job[:mailto]
    end
  end
end

