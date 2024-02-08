package "java-11-openjdk" do
  package_name "java-11-openjdk"
end

package "java-11-openjdk-devel" do
  package_name "java-11-openjdk-devel"
end

directory "/opt/nacos" do
  owner "root"
  group "root"
  action :create
end

remote_file '/opt/nacos/nacos.tar.gz' do
  source "https://github.com/alibaba/nacos/releases/download/#{node['nacos']['version']}/nacos-server-#{node['nacos']['version']}.tar.gz"
  owner 'root'
  group 'root'
  action :create
end

execute 'tar nacos' do
  command "tar -xf /opt/nacos/nacos.tar.gz -C /opt/nacos/"
  action :run
end

template '/opt/nacos/nacos/conf/cluster.conf' do
  source 'cluster.conf.erb'
  action :create
  user 'root'
  group 'root'
end

template '/opt/nacos/nacos/conf/application.properties' do
  source 'application.properties.erb'
  action :create
  user 'root'
  group 'root'
end

cookbook_file '/opt/nacos/nacos/bin/shutdown.sh' do
  source 'shutdown.sh'
  owner  'root'
  group  'root'
  mode   '0755'
end

cookbook_file '/opt/nacos/nacos/bin/startup.sh' do
  source 'startup.sh'
  owner  'root'
  group  'root'
  mode   '0755'
end

cookbook_file '/etc/systemd/system/nacos.service' do
  source 'nacos.service'
  owner  'root'
  group  'root'
  mode   '0755'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
  notifies :restart, "service[nacos]", :delayed
end

execute 'systemctl daemon-reload' do
command 'systemctl daemon-reload'
action :nothing
end

service "nacos" do
action :nothing
end
