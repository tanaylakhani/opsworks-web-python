node[:deploy].each do |application, deploy|
  if deploy[:custom_type] != 'django'
    next
  end

  enable_gunicorn= Helpers.buildout_setting(deploy, 'enable_gunicorn', node)
    supervisor_service application do
      action :restart
    end
  end

  execute "supervisorctl reload" do
    cwd ::File.join(deploy[:deploy_to], 'current')
    user 'root'
    group deploy[:group]
    environment 'HOME' => ::File.join(deploy[:deploy_to], 'shared')
  end
end
