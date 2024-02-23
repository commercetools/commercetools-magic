import { ctpClient } from "./client.js";
import { createApiBuilderFromCtpClient } from '@commercetools/platform-sdk'

// Create apiRoot from the imported ClientBuilder and include your Project key
const apiRoot = createApiBuilderFromCtpClient(ctpClient)
const projectKey = process.env.CTP_PROJECT_KEY

export async function getCoCoProduct(productId) {
  try {
    const product = await apiRoot
      .withProjectKey({projectKey})
        .products()
        .withId({ ID: productId })
        .get({queryArgs: { staged: true, expand: 'state' } })
        .execute()
    return product.body
  } catch (err) {
    if (err.statusCode === 404) {
        return null
    }
    throw err
  }
}

export async function setCoCoProductDescription(productID, productVersion, desc) {

  let newDesc = desc.trim();

  try {
    var body = await apiRoot.withProjectKey({projectKey: projectKey})
    .products()
    .withId({ ID: productID })
    .post(
      {
        // The ProductUpdate is the object within the body
        body: {
          // The version of a new Product is 1. This value is incremented every time an update action is applied to the Product. If the specified version does not match the current version, the request returns an error.
          version: productVersion,
          actions: [
            {
              action: 'setDescription',
              description: {
                'en-US': newDesc,
                'en': newDesc
              },
            },
            {
              action : 'transitionState',
              state : {
                typeId : 'state',
                id : process.env.CTP_PRODUCT_STATE_TRANSITION_ID //TODO set the ID from Terraform
              }
            }
          ],
        },
      })
    .execute();
    return body
  } catch (err) {
    if (err.statusCode === 404) return null
    throw err
  }
};