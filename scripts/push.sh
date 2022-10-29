#!/bin/bash
set -Eeuxo pipefail

while :; do
  case "${1:-}" in
    --repo)
      repo="${2}"
      shift;;
    --account)
      account="${2}"
      shift;;
    --region)
      region="${2}"
      shift;;
    *)
      break
  esac
  shift
done

function die () {
    echo "FATAL: ${*}" 1>&2
    exit 1
}

[[ -z "${repo}" ]] && echo "docker image repository name must be set!"
[[ -z "${account}" ]] && echo "aws account id must be set!"
[[ -z "${region}" ]] && echo "aws region must be set!"
[[ -z "${repo}" || -z "${account}" || -z "${region}" ]] && die "Required variables not provided"

PROJECT="template"
SERVICE="docker-lambda"
STAGE="dev"
TAG="latest"

aws ecr describe-repositories --repository-name "$repo" || \
  aws ecr create-repository --repository-name "$repo" --image-scanning-configuration scanOnPush=true

docker tag "$repo:$TAG" "$account.dkr.ecr.$region.amazonaws.com/$repo:$TAG"

aws ecr get-login-password | docker login --username AWS --password-stdin "$account.dkr.ecr.$region.amazonaws.com"

docker push $account.dkr.ecr.$region.amazonaws.com/$repo:$TAG

DIGEST="$(aws ecr describe-images --repository-name $repo --image-ids imageTag=$TAG | jq -c '.imageDetails[0].imageDigest' -r)"

aws ssm put-parameter --name "/$PROJECT/$SERVICE/$STAGE/$repo" --type "SecureString" --value "$account.dkr.ecr.$region.amazonaws.com/$repo@$DIGEST" --overwrite
