class Message < ApplicationRecord
  TEXT_BODY_LENGTH = 500
  PHONE_NUMBER_LENGTH = 25

  # created - initial state: no request has been made to send the message (maybe 500 from delivery service)
  # pending - request has been made to send the message
  # Callback received:
  # delivered - message has been delivered to the recipient
  # failed - message has failed to be delivered to the recipient
  # invalid - message is invalid
  enum :status, { created: 0, pending: 1, delivered: 2, failed: 3, incorrect: 4 }, default: :created

  validates :text, presence: true, length: { maximum: TEXT_BODY_LENGTH }
  validates :phone_number, presence: true, length: { maximum: PHONE_NUMBER_LENGTH }
end
