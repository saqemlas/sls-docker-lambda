import { Context, APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';

async function handler(_event: APIGatewayProxyEventV2, _context: Context): Promise<APIGatewayProxyResultV2> {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'hello world',
    }),
  };
}

export { handler };
