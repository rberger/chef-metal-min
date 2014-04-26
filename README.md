# Overview

Experiment to figure out how to get chef-metal-docker to start a
container that acts like a normal instance and persists afer the
chef-client run.

At this point I can get it to create a container but not to run a
command.

Its all in `cookbooks/min_app/recipes/min.rb`

I run the command:
```
chef-client -z -o min_app::min -l info
```

If in min.rb I say:
```
with_provisioner_options 'base_image' => 'ubuntu:precise',  'create_container' => { 'command' =>  'echo "++++++ HELLO ++++"'}
```

then the chef-client run fails:

```
Starting Chef Client, version 11.12.2
[2014-04-25T00:41:20-07:00] INFO: *** Chef 11.12.2 ***
[2014-04-25T00:41:20-07:00] INFO: Chef-client pid: 60542
[2014-04-25T00:41:22-07:00] WARN: Run List override has been provided.
[2014-04-25T00:41:22-07:00] WARN: Original Run List: []
[2014-04-25T00:41:22-07:00] WARN: Overridden Run List: [recipe[min_app::min]]
[2014-04-25T00:41:22-07:00] INFO: Run List is [recipe[min_app::min]]
[2014-04-25T00:41:22-07:00] INFO: Run List expands to [min_app::min]
[2014-04-25T00:41:22-07:00] INFO: Starting Chef Run for Cymek.local
[2014-04-25T00:41:22-07:00] INFO: Running start handlers
[2014-04-25T00:41:22-07:00] INFO: Start handlers complete.
[2014-04-25T00:41:22-07:00] INFO: HTTP Request Returned 404 Not Found : Object not found: /reports/nodes/Cymek.local/runs
resolving cookbooks for run list: ["min_app::min"]
[2014-04-25T00:41:22-07:00] INFO: Loading cookbooks [min_app@0.1.0]
Synchronizing Cookbooks:
[2014-04-25T00:41:22-07:00] INFO: Storing updated cookbooks/min_app/recipes/min.rb in the cache.
  - min_app
Compiling Cookbooks...
Converging 2 resources
Recipe: min_app::min
  * execute[docker pull ubuntu:precise] action run[2014-04-25T00:41:22-07:00] INFO: Processing execute[docker pull ubuntu:precise] action run (min_app::min line 8)
[2014-04-25T00:41:38-07:00] INFO: execute[docker pull ubuntu:precise] ran successfully

    - execute docker pull ubuntu:precise

  * machine[min] action create[2014-04-25T00:41:38-07:00] INFO: Processing machine[min] action create (min_app::min line 10)
[2014-04-25T00:41:38-07:00] INFO: HTTP Request Returned 404 Not Found : Object not found: http://127.0.0.1:8889/nodes/min

    - Delete old, non-running container
    - Create new container and run container_configuration['Cmd']
================================================================================
Error executing action `create` on resource 'machine[min]'
================================================================================


Docker::Error::NotFoundError
----------------------------
Expected(200..204) <=> Actual(404 Not Found)


Resource Declaration:
---------------------
# In /Users/rberger/.chef/local-mode-cache/cache/cookbooks/min_app/recipes/min.rb

 10: machine 'min' do
 11:   action :create
 12: end
 13:



Compiled Resource:
------------------
# Declared in /Users/rberger/.chef/local-mode-cache/cache/cookbooks/min_app/recipes/min.rb:10:in `from_file'

machine("min") do
  action [:create]
  retries 0
  retry_delay 2
  guard_interpreter :default
  chef_server {:chef_server_url=>"http://127.0.0.1:8889", :options=>{:client_name=>"Cymek.local", :signing_key_filename=>nil}}
  provisioner #<ChefMetalDocker::DockerProvisioner:0x00000102162cd8 @credentials=nil, @connection=#<Docker::Connection:0x00000102162bc0 @url="tcp://localhost:4243", @options={}>>
  provisioner_options {"base_image"=>"ubuntu:precise", "create_container"=>{"command"=>"echo \"++++++ HELLO ++++\""}}
  cookbook_name "min_app"
  recipe_name "min"
end



[2014-04-25T00:41:39-07:00] INFO: Running queued delayed notifications before re-raising exception

Running handlers:
[2014-04-25T00:41:39-07:00] ERROR: Running exception handlers
Running handlers complete

[2014-04-25T00:41:39-07:00] ERROR: Exception handlers complete
[2014-04-25T00:41:39-07:00] FATAL: Stacktrace dumped to /Users/rberger/.chef/local-mode-cache/cache/chef-stacktrace.out
Chef Client failed. 1 resources updated in 19.222564 seconds
[2014-04-25T00:41:39-07:00] ERROR: machine[min] (min_app::min line 10) had an error: Docker::Error::NotFoundError: Expected(200..204) <=> Actual(404 Not Found)
[2014-04-25T00:41:40-07:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
```

If I then do a `docker ps -a`:
```
CONTAINER ID        IMAGE               COMMAND               CREATED             STATUS                      PORTS               NAMES
a25732c58640        f1c9c62956ce        chef-client -l info   41 seconds ago      Exited (1) 13 seconds ago                       min
```

