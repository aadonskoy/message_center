# README

Message Center is a service for sending messages to users via selected provider services usinf simple load balancer.

Visit https://messagecenter.fly.dev/ to see sent messages with their statuses.

## How to send a message
You can use make POST reuest with postman or curl:
`https://messagecenter.fly.dev/api/messages`

with body:
```
{
    "text": "Hello World!",
    "phone_number": "sms"
}
```

Ex.:
```bash
curl --location --request POST 'https://messagecenter.fly.dev/api/messages' \
--header 'Content-Type: application/json' \
--data-raw '{
    "text": "Hello World!",
    "phone_number": "1234567890"
}'
```

## Statuses

- `created` - initial state: no request has been made to send the message (maybe 500 from delivery service)
- `pending` - request has been made to send the message

When callback received:
- `delivered` - message has been delivered to the recipient
- `failed` - message has failed to be delivered to the recipient
- `invalid` - message is invalid

## Errors
Service does not accept data with empty `text` and/or `phone_number` fields.

Status 422

```
{
    "errors": {
        "text": [
            "can't be blank"
        ],
        "phone_number": [
            "can't be blank"
        ]
    }
}
```

Also `text` and `phone_number` fields length are limited:

```
{
    "errors": {
        "text": [
            "is too long (maximum is 500 characters)"
        ],
        "phone_number": [
            "is too long (maximum is 25 characters)"
        ]
    }
}
```
