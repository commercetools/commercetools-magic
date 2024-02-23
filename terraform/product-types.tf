resource "commercetools_product_type" "magic_product_type" {
  key         = "magic-product-type"
  name        = "Product Type for OpenAI"
  description = "Product type with attributes to interact with OpenAI"
  attribute {
    name = "seed-words"
    label = {
      en-US = "Seed Words"
    }
    required = false
    constraint = "SameForAll"
    type {
      name = "text"
    }
  }

  attribute {
    name = "tone"
    label = {
      en-US = "Tone"
    }
    required = false
    constraint = "SameForAll"
    type {
      name = "enum"
      value {
        key   = "expert"
        label = "Expert"
      }
      value {
        key   = "sophisticated"
        label = "Sophisticated"
      }
    }
  }
}