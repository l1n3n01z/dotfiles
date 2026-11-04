---
name: stats
description: Show GitHub Copilot premium request usage across sessions
---
Parse session history and display premium request statistics.

Run this shell command and present the output as a formatted table:

```bash
cat ~/.copilot/session-state/*/events.jsonl 2>/dev/null | \
  jq -s '
    [.[] | select(.type == "session.shutdown").data] |
    group_by(.currentModel // "unknown") |
    map({
      model: .[0].currentModel // "unknown",
      sessions: length,
      requests: [.[].totalPremiumRequests // 0] | add,
      input_tokens: [.[].modelMetrics | to_entries[]?.value.usage.inputTokens // 0] | add,
      output_tokens: [.[].modelMetrics | to_entries[]?.value.usage.outputTokens // 0] | add
    }) |
    sort_by(-.requests)
  '
```

Format the output as a markdown table showing:
- Model name
- Number of sessions
- Total premium requests (with cost multiplier note: opus=3x, sonnet=1x, haiku=0.33x)
- Total input/output tokens

Also show a grand total row at the bottom.
