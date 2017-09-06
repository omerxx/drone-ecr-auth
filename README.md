# Drone ECR authenticator

## The problem
Drone cannot use ECR private images for the build phase, since `auth_config` uses the basic authentication process for docker, which isn't working with ECR.
ECR requires an AWS authentication process with keys that rotate every 12 hours.

## Usage
Run the container as the first build step in Drone 
Provide the container a role with policy that has premissions for `ecr:*`, or provide keys with the environment variables of the container.
Use it to pull the build container, which will be available to the build phase.
Here's a drone pipline example:

```yaml
pipeline:
  ecr-auth:
    image: omerxx/drone-ecr-auth
    pull: true
    privileged: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    commands:
      - $(aws ecr get-login --no-include-email --region us-east-1)
      - docker pull <account_id>.dkr.ecr.us-east-1.amazonaws.com/build_image

  build:
    image: <account_id>.dkr.ecr.us-east-1.amazonaws.com/build_image
    .
    .
    .
```

### Another example with AWS keys:
```yaml
pipeline:
  ecr-auth:
    image: omerxx/drone-ecr-auth
    pull: true
    privileged: true
    environment:
      - AWS_ACCESS_KEY_ID=MYKEYS
      - AWS_SECRET_ACCESS_KEY=MYSECRET
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    commands:
      - $(aws ecr get-login --no-include-email --region us-east-1)
      - docker pull <account_id>.dkr.ecr.us-east-1.amazonaws.com/build_image

  build:
    image: <account_id>.dkr.ecr.us-east-1.amazonaws.com/build_image
    .
    .
    .
```
## How it works
This is an alpine based python light image, that holds awscli tool and ready to work with aws keys
