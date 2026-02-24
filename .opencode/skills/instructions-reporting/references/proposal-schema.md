# Proposal Payload Contract

Use this structure for `pentest_add_proposal.payload_json`.

The runtime normalizes aliases into canonical fields and rejects invalid payloads.

## Required Fields

- `name` (string): finding title
- `severity` (string): one of `critical|high|medium|low|info`
- `description` (string): vulnerability narrative and impact

## Optional Fields

- `proof_of_concept` (string): reproducible steps and evidence summary
- `remediation` (string): concrete fix guidance
- `assets` (string[]): affected assets
- `cvss_score` (number): `0.0` to `10.0`
- `cvss_vector` (string): `CVSS:3.1/...` or `N/A [failed to compute]`

CVSS note:
- `cvss_score` and `cvss_vector` are both accepted.
- `pentest_calculate_cvss` can derive both from CVSS 3.1 base metrics.
- If compute fails, use `cvss_vector = N/A [failed to compute]` and `cvss_score = null`.

## Accepted Aliases (normalized server-side)

- `title` -> `name`
- `affected_endpoint` / `affected_endpoints` -> `assets`
- `cvss.score` -> `cvss_score`
- `cvss.vector` -> `cvss_vector`

Invalid or missing required fields are rejected.

## Example

```json
{
  "name": "IDOR on order endpoint",
  "severity": "high",
  "description": "Authenticated users can access orders from other accounts by iterating IDs.",
  "proof_of_concept": "GET /api/orders/1002 with account A session returns account B order.",
  "remediation": "Enforce object-level authorization checks on every order read path.",
  "assets": ["https://target.example/api/orders/{id}"],
  "cvss_score": 8.1,
  "cvss_vector": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:L"
}
```
