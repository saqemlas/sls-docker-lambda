# Serverless Lambda Function Docker Image

AWS Lambda is a powerful computing model because it gives developers a known execution environment with a specific runtime that accepts and runs arbitrary code. But this also causes problems if you have a use case outside the environments predetermined by AWS.

To address this issue, AWS introduced [Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html). Layers allow packaging `.zip` files with the libraries and dependencies needed for the Lambda functions. But [Lambda Layers still have limitations](https://lumigo.io/blog/lambda-layers-when-to-use-it/) including testing, static analysis, and versioning. In December 2020, [AWS Lambda released Docker container support](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/). 

We can now [package and deploy Lambda functions](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/) as container images of up to 10 GB in size. In this way, you can also easily build and deploy larger workloads that rely on sizable dependencies. We are providing base images for all the supported Lambda runtimes (Python, Node.js, Java, .NET, Go, Ruby) so that you can easily add your code and dependencies. We also have base images for custom runtimes based on Amazon Linux that you can extend to include your own runtime implementing the Lambda Runtime API.

Combined with the [Arm-based AWS Graviton2 processor](https://aws.amazon.com/blogs/aws/aws-lambda-functions-powered-by-aws-graviton2-processor-run-your-functions-on-arm-and-get-up-to-34-better-price-performance/), you can save money in two ways. First, your functions run more efficiently due to the Graviton2 architecture. Second, you pay less for the time that they run. In fact, Lambda functions powered by Graviton2 are designed to deliver up to 19 percent better performance at 20 percent lower cost. In addition to the price reduction, functions using the Arm architecture benefit from the performance and security built into the Graviton2 processor. Workloads using multithreading and multiprocessing, or performing many I/O operations, can experience lower execution time and, as a consequence, even lower costs. This is particularly useful now that you can use Lambda functions with up to 10 GB of memory and 6 vCPUs.


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
