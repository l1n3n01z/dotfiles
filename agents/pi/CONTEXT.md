# Pi Agent UX Extensions

This context defines user-facing behaviors for lightweight pi extensions in this repo, with emphasis on model selection and status-line clarity.

## Language

**Copilot Model Multiplier**:
A numeric factor applied to a GitHub Copilot model that should be visible during model selection and in the current-model status label.
_Avoid_: price, cost score, weighting

**Multiplier Cache**:
A global JSON snapshot at `~/.pi/agent/copilot-multipliers.json` with a fetch timestamp used as the primary runtime source.
_Avoid_: per-project cache, hardcoded map, live scrape only

**Unknown Multiplier**:
A temporary unresolved multiplier rendered as `x?` until cache refresh resolves the model.
_Avoid_: zero multiplier, missing model

## Relationships

- A **Copilot Model Multiplier** is looked up from the **Multiplier Cache**.
- If lookup fails, the model shows an **Unknown Multiplier** and a refresh is attempted.

## Example dialogue

> **Dev:** "In `/model`, should `github-copilot:gpt-4.1` show multiplier info right away?"
> **Domain expert:** "Yes — show it from the **Multiplier Cache** in picker and status line; if unknown, show **Unknown Multiplier** as `x?`."

## Flagged ambiguities

- "status" was ambiguous between transient notifications and persistent status-line label — resolved: we update the status-line model label only; no new notification behavior is required.
