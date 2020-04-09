# Japx

Lightweight [JSON:API][1] parser that flattens complex [JSON:API][1] structure and turns it into simple JSON and vice versa.
It works by transferring `Map<String, dynamic>` to `Map<String, dynamic>`, so you can use [json_serializable](https://pub.dev/packages/json_serializable)  or any other object mapping tool that you prefer.

## Installation

Add `japx: ^1.0.0` to your `pubspec.yml` file.

## Usage

For decoding the API responses use function `japxDecode(Map<String, dynamic> jsonApi)` which returns flattened JSON. 

For encoding use function `japxEncode(Object json, {Map<String, dynamic> additionalParams})` which will return a JSON with JSON:API format.

## Decoding

### Examples

API response: 

```json
{
  "data": {
    "id": "1",
    "type": "users",
    "attributes": {
      "email": "john@infinum.co",
      "username": "john"
    }
  }
```

will be transferred to this:

```json
{
  "data": {
    "id": "1",
    "type": "users",
    "email": "john@infinum.co",
    "username": "john"
  }
}
```

### Advanced examples

#### Parsing relationship

Response:

```json
{
  "data": [{
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON API paints my bikeshed!",
      "body": "The shortest article. Ever.",
      "created": "2015-05-22T14:56:29.000Z",
      "updated": "2015-05-22T14:56:28.000Z"
    },
    "relationships": {
      "author": {
        "data": {"id": "42", "type": "people"}
      }
    }
  }],
  "included": [
    {
      "type": "people",
      "id": "42",
      "attributes": {
        "name": "John",
        "age": 80,
        "gender": "male"
      }
    }
  ]
}
```

Parsed JSON:

```json
{
  "data": [{
    "type": "articles",
    "id": "1",
    "title": "JSON API paints my bikeshed!",
    "body": "The shortest article. Ever.",
    "created": "2015-05-22T14:56:29.000Z",
    "updated": "2015-05-22T14:56:28.000Z",
    "author": {
      "type": "people",
      "id": "42",
      "name": "John",
      "age": 80,
      "gender": "male"
    }
  }]
}
```

#### Decoding additional info

Response:

```json
{
  "data": [
    {
      "type": "articles",
      "id": "3",
      "attributes": {
        "title": "JSON API paints my bikeshed!",
        "body": "The shortest article. Ever.",
        "created": "2015-05-22T14:56:29.000Z",
        "updated": "2015-05-22T14:56:28.000Z"
      }
    }
  ],
  "meta": {
    "total-pages": 13
  },
  "links": {
    "self": "http://example.com/articles?page[number]=3&page[size]=1",
    "first": "http://example.com/articles?page[number]=1&page[size]=1",
    "prev": "http://example.com/articles?page[number]=2&page[size]=1",
    "next": "http://example.com/articles?page[number]=4&page[size]=1",
    "last": "http://example.com/articles?page[number]=13&page[size]=1"
  },
  "additional": {
    "info": "My custom info"
  }
}
```

Parsed JSON:

```json
{
  "data": [
    {
      "type": "articles",
      "id": "3",
      "title": "JSON API paints my bikeshed!",
      "body": "The shortest article. Ever.",
      "created": "2015-05-22T14:56:29.000Z",
      "updated": "2015-05-22T14:56:28.000Z"
    }
  ],
  "meta": {
    "total-pages": 13
  },
  "links": {
    "self": "http://example.com/articles?page[number]=3&page[size]=1",
    "first": "http://example.com/articles?page[number]=1&page[size]=1",
    "prev": "http://example.com/articles?page[number]=2&page[size]=1",
    "next": "http://example.com/articles?page[number]=4&page[size]=1",
    "last": "http://example.com/articles?page[number]=13&page[size]=1"
  },
  "additional": {
    "info": "My custom info"
  }
}
```

## Encoding

### Examples

#### Basic encoding

Your JSON:

```json
{
  "type": "articles",
  "email": "user@example.com",
  "password": "password",
  "push_token": "x",
  "uuid": "123"
}
```

JSON:API:

```json
{
  "data": {
    "type": "articles",
    "attributes": {
      "email": "user@example.com",
      "password": "password",
      "push_token": "x",
      "uuid": "123"
    },
    "relationships": {}
  }
}
```

### Advanced Examples

#### Recursive encoding

Your JSON:

```json
{
  "type": "articles",
  "id": "1",
  "title": "JSON API paints my bikeshed!",
  "body": "The shortest article. Ever.",
  "created": "2015-05-22T14:56:29.000Z",
  "updated": "2015-05-22T14:56:28.000Z",
  "author": {
    "type": "people",
    "id": "42",
    "name": "John",
    "age": 80,
    "gender": "male",
    "article": {
      "type": "articles",
      "id": "1",
      "title": "JSON API paints my bikeshed!",
      "body": "The shortest article. Ever.",
      "created": "2015-05-22T14:56:29.000Z",
      "updated": "2015-05-22T14:56:28.000Z",
      "author": {
        "type": "people",
        "id": "42",
        "name": "John",
        "age": 80,
        "gender": "male"
      }
    }
  }
}
```

Encode result:

```json
{
  "data": {
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON API paints my bikeshed!",
      "body": "The shortest article. Ever.",
      "created": "2015-05-22T14:56:29.000Z",
      "updated": "2015-05-22T14:56:28.000Z"
    },
    "relationships": {
      "author": {
        "data": {"id": "42", "type": "people"}
      }
    }
  }
}
```

#### Meta encoding

JSON with meta parameter:

```json
{
  "id" : "33",
  "type" : "time_off_request",
  "status" : "approved",
  "start_date" : "2019-01-14",
  "end_date" : "2019-01-31",
  "policy" : [
    { "id": "24", "type": "time_off_policy", "meta": "TOP24" },
    { "id": "25", "type": "time_off_policy", "meta": "TOP25" }
  ],
  "user" : {
    "id" : "25",
    "type" : "user",
    "avatar" : "",
    "email" : "user@email.com",
    "name" : "user name",
    "meta": {
      "meta_user": "meta1",
      "meta_user2": "meta2"
    }
  },
  "meta": [
    { "page": 24 },
    { "offset": 24 }
  ]
}
```

Result:

```json
{
  "data": {
    "id": "33",
    "type": "time_off_request",
    "attributes": {
      "status": "approved",
      "start_date": "2019-01-14",
      "end_date": "2019-01-31",
      "meta": [
        { "page": 24 },
        { "offset": 24 }
      ]
    },
    "relationships": {
      "user": {
        "data": {
          "id": "25",
          "type": "user"
        }
      },
      "policy": {
        "data": [
          {
            "id": "24",
            "type": "time_off_policy"

          },
          {
            "id": "25",
            "type": "time_off_policy"
          }
        ]
      }
    }
  }
}
```

## Example project

Simple project with mocked API can be found in this repository. Cclone the repository, set the `main.dart ` as an application starting point and run the project.

## Authors

## License

