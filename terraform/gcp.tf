resource "google_pubsub_topic" "product_state_transition" {
  name = "product-state-transition"
}

resource "google_pubsub_topic_iam_member" "ctp_change_publisher" {
  topic = google_pubsub_topic.product_state_transition.name
  role = "roles/pubsub.publisher"
  member = "serviceAccount:subscriptions@commercetools-platform.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "product_magic_subscription" {
  name  = "product-magic-subscription"
  topic = google_pubsub_topic.product_state_transition.name

  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}

# https://docs.commercetools.com/api/projects/subscriptions#google-cloud-pubsub-destination
resource "commercetools_subscription" "product_state_transition_subscription" {
  key = "product-state-transition"

  destination {
    type = "GoogleCloudPubSub"
    project_id = var.gcp_project_id
    topic = google_pubsub_topic.product_state_transition.name
  }

  format {
    type = "CloudEvents"
    cloud_events_version = "1.0"
  }

  message {
    resource_type_id = "product"
    types            = ["ProductStateTransition"]
  }

  depends_on = [ google_pubsub_topic_iam_member.ctp_change_publisher ]
}