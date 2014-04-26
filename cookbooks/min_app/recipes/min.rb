require 'chef_metal'
require 'chef_metal_docker'

with_provisioner ChefMetalDocker::DockerProvisioner.new

# with_provisioner_options 'base_image' => 'ubuntu:precise'
# with_provisioner_options 'base_image' => 'ubuntu:precise',  'create_container' => { 'command' =>  'ls -l /opt'}
with_provisioner_options 'base_image' => 'min_image:latest',  'create_container' => { 'command' =>  'ls -l /opt'}

# execute 'docker pull ubuntu:precise'

machine 'min' do
  recipe 'apt'
end

