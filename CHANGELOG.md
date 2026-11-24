# Changelog

## v2.4.3

- Unknown fields in Akiles responses are ignored instead of raising: resources
  are built with `struct/2` instead of `struct!/2`. Akiles keeps adding fields
  (`tag_ids` on members and groups in April 2026, on gadgets now), and each one
  crashed every call returning that object.
- `Akiles.Gadget` gets `tag_ids`.
