# model-the-domain

**Phase:** before writing

## rule

Name things after the concepts the users and the business actually use, and make the code's structure follow the domain: its entities, their states, and the transitions between them. Make lifecycle states explicit instead of inferring them from scattered fields.

## when it applies

- naming new types, tables, modules, and functions
- any record that moves through states (draft → published, pending → paid → refunded)
- when two teams use different words for the same thing, or one word for two things

## example

An order is `pending`, `paid`, `shipped`, or `refunded`, stored as one `status` with allowed transitions in one place, rather than derived from `paid_at`, `shipped_at`, and `refund_id` being null or not.

## usual violation

Generic names (`Item`, `Data`, `Manager`, `process()`) and states encoded as combinations of nullable columns, so nobody can say which combinations are legal.
