resource "commercetools_state" "product_awaiting_description" {
  key  = "product-awaiting-description"
  type = "ProductState"
  name = {
    en    = "Awaiting Description"
    en-US = "Awaiting Description"
  }
  description = {
    en    = "Product awiting a description."
    en-US = "Product awiting a description."
  }
  initial = true
}

resource "commercetools_state" "product_ready_for_magic" {
  key  = "product-ready-for-magic"
  type = "ProductState"
  name = {
    en    = "Ready For Magic"
    en-US = "Ready For Magic"
  }
  description = {
    en    = "Product tags updated and ready for new description. This state triggers the update process."
    en-US = "Product tags updated and ready for new description. This state triggers the update process."
  }
}

resource "commercetools_state" "product_description_updated" {
  key  = "product-description-updated"
  type = "ProductState"
  name = {
    en    = "Description Updated"
    en-US = "Description Updated"
  }
  description = {
    en    = "Product description updated and ready for review."
    en-US = "Product description updated and ready for review."
  }
}

resource "commercetools_state" "product_magic_approved" {
  key  = "product-magic-approved"
  type = "ProductState"
  name = {
    en    = "Magic Description Approved"
    en-US = "Magic Description Approved"
  }
  description = {
    en    = "Product magic description approved and ready for publishing."
    en-US = "Product magic description approved and ready for publishing."
  }
}

// Only allow transition from "Awaiting Description" to "Ready for Magic"
resource "commercetools_state_transitions" "magic_transition_1" {
  from = commercetools_state.product_awaiting_description.id
  to = [
    commercetools_state.product_ready_for_magic.id,
  ]

  depends_on = [
    commercetools_state.product_awaiting_description,
    commercetools_state.product_ready_for_magic
  ]
}

// Only allow transition from "Ready for Magic" to "Description Updated" or "Awaiting Description"
resource "commercetools_state_transitions" "magic_transition_2" {
  from = commercetools_state.product_ready_for_magic.id
  to = [
    commercetools_state.product_awaiting_description.id,
    commercetools_state.product_description_updated.id
  ]

  depends_on = [
    commercetools_state.product_ready_for_magic,
    commercetools_state.product_awaiting_description,
    commercetools_state.product_description_updated
  ]
}

// Only allow transition from "Description Updated" to "Ready for Magic" or "Magic Approved"
resource "commercetools_state_transitions" "magic_transition_3" {
  from = commercetools_state.product_description_updated.id
  to = [
    commercetools_state.product_ready_for_magic.id,
    commercetools_state.product_magic_approved.id,
  ]

  depends_on = [
    commercetools_state.product_description_updated,
    commercetools_state.product_ready_for_magic,
    commercetools_state.product_magic_approved
  ]
}

// Only allow transition from "Magic Approved" to "Awaiting Description"
resource "commercetools_state_transitions" "magic_transition_4" {
  from = commercetools_state.product_magic_approved.id
  to = [
    commercetools_state.product_awaiting_description.id,
  ]

  depends_on = [
    commercetools_state.product_awaiting_description,
    commercetools_state.product_magic_approved
  ]
}