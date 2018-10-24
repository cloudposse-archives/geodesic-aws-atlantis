## Makefile Targets
```
Available targets:

  create/certificate                  Provision ACM certificate
  create/iam-role                     Provision IAM role
  create/lb                           Create ALB
  create/lb/alias                     Create ALB Route53 Alias
  create/service                      Create ECS Service
  create/task                         Deploy one-off ECS task (not recommended)
  deploy                              Deploy the latest image
  destroy/certificate                 Destroy ACM certificate
  destroy/lb                          Destroy ALB
  destroy/service                     Destroy ECS service
  destroy/task                        Destroy one-off task
  docker/run                          Run atlantis (for local development)
  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  info                                Describe status of ECS Service
  logs                                Tail logs from ECS service
  validate/certificate                Validate ACM certificate

```
