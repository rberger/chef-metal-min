require 'chef_metal'
require 'chef_metal_docker'

with_provisioner ChefMetalDocker::DockerProvisioner.new

# with_provisioner_options 'base_image' => 'ubuntu:precise',  'create_container' => { 'command' =>  'echo "++++++ HELLO ++++"'}
with_provisioner_options 'base_image' => 'ubuntu:precise'

# execute 'docker pull ubuntu:precise'

machine 'min' do
  action :create
end

