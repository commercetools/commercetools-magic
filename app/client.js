import {
  createClient,
  createHttpClient,
  createAuthForClientCredentialsFlow,
  createCorrelationIdMiddleware,
} from '@commercetools/sdk-client-v2'

const projectKey = process.env.CTP_PROJECT_KEY;

//console.log("ProjectKey: " + projectKey);

const authMiddleware = createAuthForClientCredentialsFlow({
  host: process.env.CTP_AUTH_URL,
  projectKey: projectKey,
  credentials: {
    clientId: process.env.CTP_CLIENT_ID,
    clientSecret: process.env.CTP_CLIENT_SECRET,
  },
  scopes: [process.env.CTP_SCOPES],
  fetch,
})

const httpMiddleware = createHttpClient({
  host: process.env.CTP_API_URL,
  fetch,
})

// Add X-Correlation-Id header for debugging/troubleshooting
const correlationIdMiddleware = createCorrelationIdMiddleware({
  generate: () => String
})

export const ctpClient  = createClient({
  middlewares: [authMiddleware, httpMiddleware, correlationIdMiddleware],
})