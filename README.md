<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->


[![Cloud Posse](https://cloudposse.com/logo-300x69.svg)](https://cloudposse.com)

# terraform-aws-iam-user [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-iam-user.svg)](https://github.com/cloudposse/terraform-aws-iam-user/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Deploy the Atlantis Server with ECS Fargate. This should be used as a git submodule with [`geodesic`](https://github.com/cloudposse/geodesic).


---

This project is part of our comprehensive ["SweetOps"](https://docs.cloudposse.com) approach towards DevOps. 


It's 100% Open Source and licensed under the [APACHE2](LICENSE).










## Usage

### Write secrets to Chamber

Atlantis will be invoked with chamber to expose the secrets as environment variables.

**IMPORTANT** Make sure to write the parameters to the same region as your ECS tasks.

```
# Allow atlantis to process `atlantis.yaml`
chamber write atlantis ATLANTIS_ALLOW_REPO_CONFIG true

# Set the log verbosity
chamber write atlantis ATLANTIS_LOG_LEVEL debug

# Set the listen port for atlantis
chamber write atlantis ATLANTIS_PORT 4141

# Set the atlantis webhook base URL
chamber write atlantis ATLANTIS_ATLANTIS_URL https://atlantis.ourcomain.com

# Set the GitHub user corresponding to the personal access token
chamber write atlantis ATLANTIS_GH_USER outcompanybot

# Set the GitHub personal access token corresponding to the github user
chamber write atlantis ATLANTIS_GH_TOKEN the-token-generated-by-github

# Set the WebHook callback secret
chamber write atlantis ATLANTIS_GH_WEBHOOK_SECRET $(uuidgen)

# Set the permitted repositories
chamber write atlantis ATLANTIS_REPO_WHITELIST 'github.com/cloudposse/*'

# Permissions granted to teams
chamber write atlantis ATLANTIS_GH_TEAM_WHITELIST engineering:plan,testing:*

# Configuration this atlantis server will monitor
chamber write atlantis ATLANTIS_REPO_CONFIG atlantis/testing.yaml

# Command that atlantis will watch for
chamber write atlantis ATLANTIS_WAKE_WORD atlantis/testing

# Docker image to use with ECS
chamber write atlantis ATLANTIS_IMAGE cloudposse/testing.cloudposse.co:dev

# ACM Certificate domain
chamber write atlantis ATLANTIS_DOMAIN ourcompany.com

# ACM Alternative name
chamber write atlantis ATLANTIS_HOSTNAME atlantis.ourcompany.com

# Stage that we're operating under
chamber write atlantis STAGE testing

```


### Deploy Atlantis on ECS Fargate

This commands are asynchronous. You may need to retry them multiple times. 

```
chamber exec atlantis -- make create/iam-role
chamber exec atlantis -- make create/certificate
chamber exec atlantis -- make validate/certificate
chamber exec atlantis -- make create/lb
chamber exec atlatnis -- make create/service
```






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



## Related Projects

Check out these related projects.

- [geodesic](https://github.com/cloudposse/geodesic) - Geodesic is the fastest way to get up and running with a rock solid, production grade cloud platform built on strictly Open Source tools.
- [Packages](https://github.com/cloudposse/packages) - Cloud Posse installer and distribution of native apps
- [build-harness](https://github.com/cloudposse/build-harness) - Collection of Makefiles to facilitate building Golang projects, Dockerfiles, Helm charts, and more




## References

For additional context, refer to some of these links. 

- [terraform-root-modules](https://github.com/cloudposse/terraform-root-modules) - Collection of Terraform "root module" invocations for provisioning reference architectures
- [root.cloudposse.co](https://github.com/cloudposse/root.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Parent ("Root") Organization in AWS.
- [audit.cloudposse.co](https://github.com/cloudposse/audit.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for an Audit Logs Organization in AWS.
- [prod.cloudposse.co](https://github.com/cloudposse/prod.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Production Organization in AWS.
- [staging.cloudposse.co](https://github.com/cloudposse/staging.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Staging Organization in AWS.
- [dev.cloudposse.co](https://github.com/cloudposse/dev.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Development Sandbox Organization in AWS.


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-iam-user/issues), send us an [email][email] or join our [Slack Community][slack].

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [*commercial support*][commercial_support] for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)](mailto:hello@cloudposse.com)

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll develop original modules to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands-on support to implement our reference architectures. 


## Community Forum

Get access to our [Open Source Community Forum][slack] on Slack. It's **FREE** to join for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build *sweet* infrastructure.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-iam-user/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://github.com/orgs/cloudposse/projects/3) with our other projects, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

[![Cloud Posse](https://cloudposse.com/logo-300x69.svg)](https://cloudposse.com)

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We love [Open Source Software](https://github.com/cloudposse/)!

We offer paid support on all of our projects.  

Check out [our other projects][github], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.

  [docs]: https://docs.cloudposse.com/
  [website]: https://cloudposse.com/
  [github]: https://github.com/cloudposse/
  [commercial_support]: https://github.com/orgs/cloudposse/projects
  [jobs]: https://cloudposse.com/jobs/
  [hire]: https://cloudposse.com/contact/
  [slack]: https://slack.cloudposse.com/
  [linkedin]: https://www.linkedin.com/company/cloudposse
  [twitter]: https://twitter.com/cloudposse/
  [email]: mailto:hello@cloudposse.com


### Contributors

|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] |
|---|---|---|

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://github.com/osterman.png?size=150
  [goruha_homepage]: https://github.com/goruha
  [goruha_avatar]: https://github.com/goruha.png?size=150
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://github.com/aknysh.png?size=150


