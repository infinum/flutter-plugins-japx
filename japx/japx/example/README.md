# Japx example

Demonstrates how to use the japx plugin.

## Description

In this example API call is mocked. We create a user and send that user to server with JSON:API content-type.
For creating body, we created a JSON format which consists of `type` and users `email` and `name`.
Then we parsed that JSON to JSON:API with `Japx` and sent it to the server.

Server response was mocked with a JSON file in assets. Using `Japx` we flattened the response and recreated user
with sending the `data` part of JSON string to the function `UserFromMap` created by `json_serializable`.
