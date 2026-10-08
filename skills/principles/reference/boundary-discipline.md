# boundary-discipline

**Phase:** before writing

## rule

Validate, convert, and handle failure at the edges of the system: user input, network, files, databases, third-party APIs. Inside the boundary, trust the types and keep the code free of defensive checks. Keep side effects at the edges, and logic in the middle.

## when it applies

- request handlers, CLI argument parsing, message consumers, file readers
- calls to external services and their responses
- deciding where a null check or a try/except belongs

## example

An HTTP handler parses the JSON body into a validated `CreateInvoice` value and returns 422 on failure. The invoice service below it takes `CreateInvoice` and never checks for missing fields.

## usual violation

Validation sprinkled through the core ("just in case"), raw request dicts passed five layers deep, and I/O calls buried inside business logic that then becomes hard to test.
