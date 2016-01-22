# Auth0 jobtest

## The task:
```
Currently our architecture relies in AWS ELBs to distribute load and manage application failures.
In order to gain more control in the way we scale, we need to put a reverse proxy between ELB and application nodes

         ELB
          |
        --------
       |        |
     proxy    proxy
 -----------------------
 |    |    |     |     |
    application nodes


Exercise:
Using the configuration manager of your choice, create and deploy a reverse proxy, and application nodes (you can use a static webpage as app)
Autoscale them under heavy load. Define a threshold and stress the VMs to be sure them scales up and down.
You will need to find a way to register/unregister application nodes in the reverse proxies
```

## Usage:
```
export AWS_ACCESS_KEY_ID='XXX'
export AWS_SECRET_ACCESS_KEY='XXX'
make build_ami
make plan
make apply
```

## Current state:

![graph](/graph.png?raw=true "relations")

## TODO:

- [ ] cleanup `proxy-(1c|1a)` creation
- [X] create dns record for the consul servers
- [ ] use `aws_nat_gateway` instead of the ec2 instance
- [ ] create temp vpc for the ami build - `vpc_id` and `subnet_id` hardcoded in the packer configs
- [ ] create separated security groups for each role
- [ ] remove private subnet from the vpc
