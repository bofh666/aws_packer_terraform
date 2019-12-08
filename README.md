a. Build custom ami with packer, Ubuntu based, with nginx installed. Nginx should return 200 ok on all requests. Nginx should be installed as docker container. Nginx should be automatically started during boot

b. Create terraform recipe for launching vm from custom ami from step A. It should be possible to do http request against vm.

c. Improve terraform recipe  for launching 2 vms from custom ami from step A behind balancer. It should be possible to do http requests to the vms via balancer.

d. Enhance solution by adding health-checking: if instance not answering via http with 200 code it should be automatically recreated.

e. Not every instance types are available to run in every AZ. Implement a script that will check if it is possible to run given instance type in given AZ.

f. Write a JobDSL script that will create a Jenkins job, that will clone some git repo and run a make command. Assume that all required plugins are already installed.
