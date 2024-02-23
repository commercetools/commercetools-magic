import OpenAI from "openai";

export async function getDescFromNameAndKeywords(productName, tone, keywords) {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY
  });

  let seedText = '';
  if(tone == 'Expert') {
    seedText = process.env.SEED_TEXT_EXPERT;
  } else {
    seedText = process.env.SEED_TEXT_SOPHISTICATED;
  }

  const response = await openai.completions.create({
    model: "gpt-3.5-turbo-instruct",
    prompt: seedText + `\n\nProduct name: ${productName}\nSeed words: ${keywords}\nTone: ${tone}\nProduct Description:`,
    temperature: 0.8,
    max_tokens: 60,
    top_p: 1.0,
    frequency_penalty: 0.0,
    presence_penalty: 0.0,
  })

  return response.choices[0].text;
}