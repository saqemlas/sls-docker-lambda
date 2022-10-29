# Serverless Lambda Function Docker Image

AWS Lambda is a powerful computing model because it gives developers a known execution environment with a specific runtime that accepts and runs arbitrary code. But this also causes problems if you have a use case outside the environments predetermined by AWS.

To address this issue, AWS introduced [Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html). Layers allow packaging `.zip` files with the libraries and dependencies needed for the Lambda functions. But [Lambda Layers still have limitations](https://lumigo.io/blog/lambda-layers-when-to-use-it/) including testing, static analysis, and versioning. In December 2020, [AWS Lambda released Docker container support](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/).

## Usage

### Local Development

- Create Docker Image (update variables in ./build.sh)
```bash
yarn run build --repo <repository_name>
```

- Run Container Locally
```bash
docker run -p 9000:8080  <function-name>:latest
```

- in another terminal, run
```bash
curl "http://localhost:9000/2015-03-31/functions/function/invocations"
```

### Deployment

Lambda functions are handled in two different ways
- One function uses Serverless Framework builds and pushes image to ECR
    - uses yaml template
    - limited image control
- Another function uses scripts to build and push image to ECR, saves repository name to SSM for Serverless Framework to assign to Lambda Function
    - uses scripts and splits build/deployment
    - control of image

- To update just lambda function code
```bash
yarn run build --repo <repository_name>
yarn run push --repo <repository_name> --account <account_id> --region <region>
```

- To deploy stack
```bash
yarn run deploy --param="repo=<repository_name>"
```

### Testing

- To test sls deployed function
```bash
curl https://<api_id>.execute-api.eu-west-1.amazonaws.com/v1
```

- To test script deployed function
```bash
curl https://<api_id>.execute-api.eu-west-1.amazonaws.com/v2
```
