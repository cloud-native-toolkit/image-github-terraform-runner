# GitHub Action Runner - terraform

Container image(s) that can be used as GitHub Action runners on OpenShift clusters based off of this repo - https://github.com/redhat-actions/openshift-actions-runners

An example of how to use this image can be found here - https://developers.redhat.com/articles/2021/06/16/deploy-self-hosted-github-actions-runners-red-hat-openshift#introducing_self_hosted_runners_for_red_hat_openshift

The image is published to [quay.io/cloudnativetoolkit/github-terraform-runner](https://quay.io/cloudnativetoolkit/github-terraform-runner)

The single image publishes multiple tags, one for each of the base images used for the build:

- terraform
- cli-tools-core
- cli-tools-ibmcloud
- cli-tools
