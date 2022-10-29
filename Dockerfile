# transpiles the TypeScript code into JavaScript
FROM public.ecr.aws/lambda/nodejs:16-arm64 as builder

WORKDIR /usr/app

COPY index.ts package.json yarn.lock tsconfig.json ./

RUN npm install --global yarn

RUN yarn run ci

RUN yarn run bundle

# produces a container image that contains only JavaScript files and production dependencies

FROM public.ecr.aws/lambda/nodejs:16-arm64 

WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=builder /usr/app/build/* ./

CMD ["index.handler"]
