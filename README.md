# Gemini 4 Carbon API

Call Google's Gemini 4 Carbon through Muapi's asynchronous REST API, with copy-paste `curl`, Python, and JavaScript examples, a `reasoning_effort` guide, per-token pricing, and a secure-code-review script.

[Muapi Gemini 4 API page](https://muapi.ai/gemini-4) · [Gemini 4 Carbon playground](https://muapi.ai/playground/gemini-4-carbon) · [API reference](https://muapi.ai/docs/api-reference) · [Create an API key](https://muapi.ai/access-keys) · [muapi.ai](https://muapi.ai)

## Related Projects

- [Gemini-4-Hydrogen-API](https://github.com/Anil-matcha/Gemini-4-Hydrogen-API)
- [awesome-gemini-4-carbon](https://github.com/Anil-matcha/awesome-gemini-4-carbon)
- [awesome-abliterated-llms](https://github.com/Anil-matcha/awesome-abliterated-llms)
- [Open-Generative-AI](https://github.com/Anil-matcha/Open-Generative-AI)

## What Gemini 4 Carbon is

Gemini 4 Carbon is Google DeepMind's security-focused frontier model in the Gemini 4 series. Google reports it first on the Artificial Analysis Intelligence Index and state-of-the-art on vulnerability discovery (SEC-bench Pro), exploitation (ExploitGym), and patching (CWE-bench). Those numbers are Google's own reported results, not Muapi measurements. Upstream access to Carbon has been limited since launch, so check the [playground](https://muapi.ai/playground/gemini-4-carbon) for current availability before depending on it.

On Muapi it is a single text endpoint: `gemini-4-carbon`.

## Gemini 4 Carbon vs Gemini 4 Argon

| | Gemini 4 Carbon | Gemini 4 Argon |
|---|---|---|
| Muapi endpoint | `gemini-4-carbon` | `gemini-4-argon` |
| Positioning | Security-focused frontier reasoning | General frontier reasoning |
| Input | Text, optional image, optional system prompt | Text, optional image, optional system prompt |
| `reasoning_effort` | `low`, `medium` (default), `high` | Not exposed |
| Context window | Not published by Google | 1M-token unified context and output |
| Price (per 1M tokens, in / out) | $4.00 / $20.00 | $2.00 / $10.00 |
| Minimum charge per call | $0.0004 | $0.0002 |
| Best for | Vulnerability analysis, secure code review, patch drafting | Long-horizon coding, knowledge work, long documents |

See the [Gemini 4 API page](https://muapi.ai/gemini-4) for the live lineup and both models side by side.

## Quick start

Muapi is asynchronous: submit a request, save the returned `request_id`, then poll the result endpoint.

```bash
export MUAPI_API_KEY="your-key"

curl -X POST https://api.muapi.ai/api/v1/gemini-4-carbon \
  -H "x-api-key: $MUAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Audit this function for injection vulnerabilities and propose a patch.",
    "system_prompt": "You are a senior application security engineer. Be concise and specific.",
    "reasoning_effort": "high"
  }'
# {"request_id":"REQUEST_ID","status":"processing"}

curl "https://api.muapi.ai/api/v1/predictions/REQUEST_ID/result" \
  -H "x-api-key: $MUAPI_API_KEY"
```

Poll until `status` is `completed` or `failed`. On completion the generated text is in `outputs[0]`. You can also pass `?webhook=https://your.app/hook` on the submit call to be notified instead of polling.

## Request fields

| Field | Requirement | Notes |
|---|---|---|
| `prompt` | Required | The user message or instruction. |
| `image_url` | Optional | Public image URL for multimodal questions (screenshots, diagrams, scanned pages). |
| `system_prompt` | Optional | System-level instruction for role, tone, and output format. |
| `reasoning_effort` | Optional | `low`, `medium` (default), or `high`. |

### Choosing `reasoning_effort`

- `low`: quick classification, summarisation, or triage where latency and cost matter most.
- `medium` (default): everyday code review and analysis.
- `high`: hard vulnerability analysis, multi-step patch reasoning, and long diffs. Slower, and reasoning tokens are billed as output tokens, so expect a higher bill.

## Pricing

Billing is per token: **$4.00 per 1M input tokens and $20.00 per 1M output tokens**, with a minimum charge of **$0.0004 per call** and no subscription. Reasoning tokens count as output. A call is charged the minimum up front and topped up to the actual token cost when it completes. Confirm current pricing on the [model page](https://muapi.ai/playground/gemini-4-carbon).

## Examples

| Path | What it does |
|---|---|
| [`examples/curl/submit_and_poll.sh`](examples/curl/submit_and_poll.sh) | Submit, poll, and print the text with `curl` and `jq`. |
| [`examples/python/carbon.py`](examples/python/carbon.py) | Minimal Python client (`requests`) with polling. |
| [`examples/python/secure_review.py`](examples/python/secure_review.py) | Reviews a source file for vulnerabilities and drafts patches. |
| [`examples/javascript/carbon.mjs`](examples/javascript/carbon.mjs) | Minimal Node 18+ client using `fetch`. |
| [`examples/javascript/secure_review.mjs`](examples/javascript/secure_review.mjs) | Node version of the secure-code-review script. |

```bash
pip install -r requirements.txt
export MUAPI_API_KEY="your-key"
python examples/python/secure_review.py path/to/file.py
node examples/javascript/secure_review.mjs path/to/file.js
```

## Errors and production notes

- Keep the API key in an environment variable; never commit credentials.
- Handle non-success HTTP responses and `failed` task states. Failed tasks are refunded.
- Do not resubmit after a timeout without checking the original `request_id`; duplicate submissions are billed.
- Model output is advice, not a verdict: have a human review security findings and patches before acting on them.
- Only send code you are authorised to analyse.

## License

MIT
