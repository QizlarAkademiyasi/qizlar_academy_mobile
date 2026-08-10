---
name: urls
description: Protect the Qizlar Academy API base URL source and Firebase Remote Config key mapping. Use whenever inspecting, debugging, testing, refactoring, or changing API URLs, Dio baseUrl setup, Firebase Remote Config URL keys, flavor URL selection, URL defaults, fallbacks, caches, or related configuration.
---

# URLs

Preserve the API URL contract exactly.

## Mandatory contract

- Read the production API domain only from Firebase Remote Config key `baseUrl`.
- Read the development API domain only from Firebase Remote Config key `devUrl`.
- Select exactly one key from the active flavor; do not read both and choose later.
- Do not introduce hardcoded API base URLs, `dart-define` URL defaults, alternate or legacy keys, disk-cache fallbacks, or any other URL source.
- Fetch and activate Firebase Remote Config before constructing Dio clients.
- Keep `Apis.baseUrl` and every Dio API client bound to `AppRemoteConfig.instance.domain`.

## Approval gate

Before editing any code, test, build configuration, Firebase key mapping, or documentation that could change this contract:

1. Explain the exact proposed URL behavior change and affected files.
2. Ask the user for explicit approval.
3. Stop and wait. Do not edit in the same turn before approval arrives.

Treat broad requests such as refactoring, cleanup, migration, bug fixing, or configuration updates as insufficient approval. Obtain a separate explicit confirmation for the URL-contract change. Read-only inspection and tests that do not mutate files do not require approval.

After approval, keep the change within the approved scope and verify that no forbidden URL source was introduced.
