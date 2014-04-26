# Overview

Experiment to figure out how to get chef-metal-docker to start a
container that acts like a normal instance and persists afer the
chef-client run.

So I've been trying to get something that could be used as a complete persistent service and seem to be missing some fundamental concepts. I can't seem to even get chef-metal-docker to create a container and run a command.

I set up `chef-zero -H 0.0.0.0` server running on my ubuntu 14.04 workstation instance and uploaded a simple cookbook (https://github.com/rberger/chef-metal-min/cookbooks/min_app and also the apt cookbook)

I'm using this chef-zero server for both the workstation chef-client runs and the container chef-client runs so as to minimize ip address and routing issues.

If I create a provisioner_options in `min_app/recipes/min.rb` of:
```
with_provisioner_options 'base_image' => 'ubuntu:precise',  'create_container' => { 'command' =>  'ls -l /opt'}
```

and do a chef-client run on the workstation:
```
chef-client -o min_app::min -l info
```

The chef-client run fails but the container is created and if I start the container again it generates the output:

```
docker start -i -a 12ee3aafaa9a
total 0
```

Which shows that the container doesn't have chef installed.

If I then set the provisioner to:
```
with_provisioner_options 'base_image' => 'ubuntu:precise'
```
The chef-client run on my workstation will create the min_image docker image but it has the `chef-client -l info` as the command.  (Not sure why it created those extra containers):
```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                CREATED              STATUS              PORTS               NAMES
5f10d4a7230b        8859b13fbf47        chef-client -l info    About a minute ago   Exit 0                                  min
0796e0785921        4d4020697ca8        /bin/sh -c #(nop) AD   2 minutes ago        Exit 0                                  hopeful_engelbart
bab6f286bc43        061845e6cee3        /bin/sh -c #(nop) AD   2 minutes ago        Exit 0                                  hungry_darwin
35d4161453cf        2644d502c274        /bin/sh -c #(nop) AD   2 minutes ago        Exit 0                                  cocky_pike
dfb83a23e339        779457a7795b        /bin/sh -c #(nop) AD   2 minutes ago        Exit 0                                  desperate_pike
```
If I then change the provisioner to:
```
with_provisioner_options 'base_image' => 'min_image:latest',  'create_container' => { 'command' =>  'ls -l /opt'}
```
and then run the chef-client on the workstation it all succeeds (the workstation and the container chef-client runs) but it still executes the command `chef-client -l info` and __not__ `ls -l /opt`:
```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS               NAMES
bc331b9b81f2        231fbb21f23a        chef-client -l info    18 seconds ago      Exit 0                                  min
```

So what am I doing wrong? Does anyone have an example of creating a container and confirming that the command is actually executed?

Once I can do that, the next thing would be to know how to make it so the container stays up and runs one or more processes.
