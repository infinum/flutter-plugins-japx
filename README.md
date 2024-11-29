# Flutter Japx - JSON:API Decoder/Encoder

<p align="center">
    <img src="https://raw.githubusercontent.com/infinum/flutter-plugins-japx/master/japx-logo-new.png" width="300" max-width="50%" alt="Japx"/>
</p>

Lightweight [JSON:API][1] parser that flattens complex [JSON:API][1] structure and turns it into simple JSON and vice versa.
It works by transferring `Map<String, dynamic>` to `Map<String, dynamic>`, so you can use [json_serializable](https://pub.dev/packages/json_serializable)  or any other object mapping tool that you prefer.

## Table of contents

* [Usage](#usage)
* [Decoding](#decoding)
* [Encoding](#encoding)
* [Example project](#example-project)
* [Contributing](#contributing)
* [License](#license)
* [Credits](#credits)

## Usage

For decoding the API responses use function `Japx.decode(Map<String, dynamic> jsonApi, {String includeList})` which returns flattened JSON. 
Include list is an optional parameter and it is used for deserializing JSON:API relationships.

For encoding use function `Japx.encode(Object json, {Map<String, dynamic> additionalParams})` which will return a JSON with JSON:API format.

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

Simple project with mocked API can be found in this repository. Clone the repository, set the `main.dart` as an application starting point and run the project.

### Usage with JsonSerializable

This package can be implemented as a simple layer into your exisiting stack. For example, if you use JsonSerializable, you can do it like this:

```dart
@JsonSerializable(nullable: false)
class Article {

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(Japx.decode(json));
  Map<String, dynamic> toJson() => Japx.encode(_$ArticleToJson(this));
```

## Contributing

We believe that the community can help us improve and build better a product.
Please refer to our [contributing guide](CONTRIBUTING.md) to learn about the types of contributions we accept and the process for submitting them.

To ensure that our community remains respectful and professional, we defined a [code of conduct](CODE_OF_CONDUCT.md) <!-- and [coding standards](<link>) --> that we expect all contributors to follow.

We appreciate your interest and look forward to your contributions.

## License

```text
Copyright 2024 Infinum

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Credits

Maintained and sponsored by [Infinum](https://infinum.com).

<div align="center">
    <a href='https://infinum.com'>
    <picture>
        <source srcset="https://assets.infinum.com/brand/logo/static/white.svg" media="(prefers-color-scheme: dark)">
        <img src="https://assets.infinum.com/brand/logo/static/default.svg">
    </picture>
    </a>
</div>
