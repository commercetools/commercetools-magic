import 'dotenv/config'
import { getCoCoProduct, setCoCoProductDescription } from './ct-product.js';
import { getDescFromNameAndKeywords } from './openai.js';

async function makeMagic(productId) {

  const product = await getCoCoProduct(productId);

  const triggerState = process.env.CTP_PRODUCT_STATE_TRIGGER;

  let currentState;
  let seedWords;
  let tone;

  if(product.state.obj.key === undefined) {
    return new Error("Product state is undefined.");
  } else {
    currentState = product.state.obj.key;
  }

  if(product.masterData.staged.masterVariant.attributes.find(attr => attr.name === "seed-words") === undefined) {
    return new Error("seed-words product attribute is undefined.");
  } else {
    seedWords = product.masterData.staged.masterVariant.attributes.find(attr => attr.name === "seed-words").value;
  }

  if(product.masterData.staged.masterVariant.attributes.find(attr => attr.name === "tone").value.label === undefined) {
    return new Error("tone product attribute is undefined.");
  } else {
    tone = product.masterData.staged.masterVariant.attributes.find(attr => attr.name === "tone").value.label;
  }

  console.log(`Tone: ${tone}, Seed Words: ${seedWords}`);

  if(currentState == triggerState) {
   let magicDesc = await getDescFromNameAndKeywords(product.masterData.staged.name["en-US"], tone, seedWords);
   console.log(`Magic: ${magicDesc}`);
   setCoCoProductDescription(product.id, product.version, magicDesc)
  } else {
    console.log(`Product ${product.id} not in trigger state (${triggerState}). Current product state is ${currentState} .`)
  }

  return("OK")
}

export const cloudEvent = ('magicDescription', cloudEvent => {
    let dataString = Buffer.from(cloudEvent.data, 'base64').toString();
    console.log("String: " + dataString);
    let dataJson = JSON.parse(dataString);
    let productId = dataJson.data.resource.id;

    makeMagic(productId).then(resp => {
      console.log(resp)
    })
    .catch(err => {
      console.log(err)
    });
  });