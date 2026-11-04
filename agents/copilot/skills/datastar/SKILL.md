---
name: datastar
description: Guide for adding live interactivity to .NET web apps with Datastar. Use when adding SSE-driven DOM updates, reactive signals, or small JS sprinkles to server-rendered HTML. Do NOT use for SPA-style navigation or full page replacements.
license: MIT
---

# Datastar (.NET)

## Philosophy

Datastar is **not a frontend framework** and not a SPA replacement. It is a tool for two narrow jobs:

1. **Live events** — stream DOM patches and signal updates from the server over SSE.
2. **JS sprinkles** — small reactive behavior in HTML using `data-*` attributes (show/hide, class toggles, form binding).

**When NOT to use Datastar:**

- Page navigation → use a regular `<a href="...">` link.
- Full-page reloads after a form submit → use a standard `<form method="post">` with a redirect.
- Replacing large sections of the page on every interaction → rethink the UI; that is SPA complexity.

**When to use Datastar:**

- A button triggers a backend action and a small part of the page updates (e.g. a status badge, a list item, a counter).
- A form input triggers a live search and the results panel updates without a page reload.
- A long-running job streams progress to the page.
- A value needs to toggle visibility or a class without a round-trip.

---

## Installation

### Frontend

Vendor the script — do **not** rely on a CDN in production. Download it once:

```
https://cdn.jsdelivr.net/gh/starfederation/datastar@v1.0.1/bundles/datastar.js
```

Put it in `wwwroot/lib/datastar.js` and include it from the layout:

```html
<script type="module" src="/lib/datastar.js"></script>
```

The vendored file is minified (~12 KiB). It is readable for quick lookups. For deeper reference — full plugin and attribute source in TypeScript — clone the source to a temp location:

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/starfederation/datastar /tmp/datastar-src
cd /tmp/datastar-src && git sparse-checkout set library/src
```

The unminified plugins live under `library/src/plugins/`.

### Backend (.NET SDK)

```
dotnet add package Starfederation.Datastar
```

Register in `Program.cs`:

```csharp
builder.Services.AddDatastar();
```

This makes `IDatastarService` injectable into both minimal API handlers and MVC controllers.

---

## Frontend: `data-*` Attributes

### Signals (reactive state)

```html
<!-- Declare signals on any ancestor element -->
<div data-signals="{count: 0, query: ''}">

  <!-- Read a signal -->
  <span data-text="$count"></span>

  <!-- Two-way bind to an input -->
  <input type="text" data-bind:query />

  <!-- Pure JS sprinkle: toggle without a server round-trip -->
  <button data-on:click="$count++">+</button>

</div>
```

Signal names are prefixed with `$` in expressions. Use dot-notation for nesting: `$user.name`.

### Conditionals and styling

```html
<div data-show="$loading">Loading…</div>
<button data-attr="{'disabled': $loading}">Submit</button>
<div data-class="{'bg-red-500': $hasError}"></div>
```

### Events and backend actions

```html
<!-- GET request, sends current signals as query params -->
<button data-on:click="@get('/search')">Search</button>

<!-- POST request, sends signals as JSON body -->
<form data-on:submit__prevent="@post('/save')">
  <input data-bind:title />
  <button type="submit">Save</button>
</form>

<!-- Debounced live search -->
<input data-bind:query data-on:input__debounce_300ms="@get('/search')" />
```

**Modifier syntax:** `data-on:EVENT__MODIFIER1__MODIFIER2`

Common modifiers: `__prevent`, `__stop`, `__debounce`, `__throttle`, `__once`, `__outside`.

### Useful patterns

```html
<!-- Load more on scroll into view -->
<div data-on-intersect="@get('/items/next-page')"></div>

<!-- Poll every 5 seconds -->
<div data-on-interval__5s="@get('/status')"></div>

<!-- Run JS on load -->
<div data-effect="console.log('mounted, count is', $count)"></div>
```

---

## Backend: SSE Endpoints (.NET SDK)

All SSE handlers return `IResult` (or `void`) and receive `IDatastarService` by injection. The service handles the `Content-Type: text/event-stream` header and flushing automatically.

### Patch elements

```csharp
app.MapGet("/search", async (
    [FromQuery] string query,
    IDatastarService ds) =>
{
    var results = await SearchAsync(query);
    await ds.PatchElementsAsync($"""
        <ul id="results">
          {string.Join("", results.Select(r => $"<li>{r.Name}</li>"))}
        </ul>
        """);
});
```

The element with `id="results"` in the existing page is morphed in place — only changed parts of the DOM are touched.

### Remove an element

```csharp
await ds.RemoveElementAsync("#toast");
```

### Patch signals (update frontend state from the server)

```csharp
await ds.PatchSignalsAsync(JsonSerializer.Serialize(new { count = 42 }));
```

### Multiple events in one stream

```csharp
app.MapPost("/save", async (IDatastarService ds) =>
{
    // Show a spinner immediately
    await ds.PatchSignalsAsync("""{"saving": true}""");

    await SaveAsync();

    // Patch the result and clear the spinner
    await ds.PatchElementsAsync("""<div id="status">Saved ✓</div>""");
    await ds.PatchSignalsAsync("""{"saving": false}""");
});
```

### Read signals sent by the client

Use `ReadSignalsAsync<T>()` for minimal API handlers:

```csharp
public record SearchSignals(string Query, int Page);

app.MapGet("/search", async (IDatastarService ds) =>
{
    var signals = await ds.ReadSignalsAsync<SearchSignals>();
    var results = await SearchAsync(signals.Query, signals.Page);
    await ds.PatchElementsAsync(RenderResults(results));
});
```

Or use `[FromSignals]` model binding in MVC controllers:

```csharp
[HttpGet("/search")]
public async Task<IActionResult> Search([FromSignals] SearchSignals signals)
{
    var results = await SearchAsync(signals.Query, signals.Page);
    await _ds.PatchElementsAsync(RenderResults(results));
    return new EmptyResult();
}
```

---

## Signal DTO conventions

- Use `record` types for signal DTOs; they are immutable by default.
- Mark optional properties `nullable` with `[JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]` so only changed signals are sent back.
- Signal names in JSON are **camelCase** to match the frontend convention.

```csharp
public record FormSignals
{
    public required string Title { get; init; }

    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string? Error { get; init; }
}
```

---

## Complete Example: Live Counter

**HTML (Razor / static):**

```html
<div id="counter" data-signals="{count: 0}">
  <span data-text="'Count: ' + $count"></span>
  <button data-on:click="@post('/counter/increment')">+</button>
  <button data-on:click="@post('/counter/decrement')">-</button>
</div>
```

**Backend:**

```csharp
// In-memory state (replace with real persistence)
var count = 0;

app.MapPost("/counter/increment", async (IDatastarService ds) =>
{
    count++;
    await ds.PatchSignalsAsync(JsonSerializer.Serialize(new { count }));
});

app.MapPost("/counter/decrement", async (IDatastarService ds) =>
{
    count--;
    await ds.PatchSignalsAsync(JsonSerializer.Serialize(new { count }));
});
```

---

## Complete Example: Live Search

**HTML:**

```html
<div data-signals="{query: ''}">
  <input
    type="search"
    placeholder="Search…"
    data-bind:query
    data-on:input__debounce_300ms="@get('/search')"
  />
  <div id="results"></div>
</div>
```

**Backend:**

```csharp
app.MapGet("/search", async (IDatastarService ds) =>
{
    var signals = await ds.ReadSignalsAsync<SearchSignals>();

    if (string.IsNullOrWhiteSpace(signals.Query))
    {
        await ds.RemoveElementAsync("#results *");
        return;
    }

    var items = await SearchAsync(signals.Query);

    await ds.PatchElementsAsync($"""
        <ul id="results">
          {string.Join("\n", items.Select(i => $"<li id=\"item-{i.Id}\">{i.Name}</li>"))}
        </ul>
        """);
});

public record SearchSignals(string Query);
```

---

## Complete Example: Live History Feed

A detail page where new events are **appended** to a history list as they arrive — without replacing the whole list. Uses `ElementPatchMode.Append` so each SSE write adds to the bottom rather than morphing.

**HTML:**

```html
<!-- History list rendered server-side on initial load -->
<ul id="history-list">
  @foreach (var e in Model.Events)
  {
    <li id="event-@e.Id">@e.Description — <time>@e.OccurredAt</time></li>
  }
</ul>

<!-- Trigger the long-lived SSE stream as soon as the page loads -->
<div data-init="@get('/deliveries/@Model.DeliveryId/events/stream')"></div>
```

**Backend — long-lived SSE stream:**

```csharp
app.MapGet("/deliveries/{deliveryId}/events/stream", async (
    Guid deliveryId,
    IDatastarService ds,
    IEventStore eventStore,
    CancellationToken ct) =>
{
    // Subscribe to new events for this delivery
    await foreach (var ev in eventStore.SubscribeAsync(deliveryId, ct))
    {
        await ds.PatchElementsAsync(
            $"""<li id="event-{ev.Id}">{ev.Description} — <time>{ev.OccurredAt:g}</time></li>""",
            new PatchElementsOptions
            {
                Selector = "#history-list",
                PatchMode = ElementPatchMode.Append,
            },
            ct);
    }
});
```

Key points:
- `Selector = "#history-list"` targets the container; `PatchMode = ElementPatchMode.Append` adds children to the end.
- Each `<li>` gets a stable `id` so a reconnect and re-stream won't duplicate entries (morph will find the existing element).
- The stream stays open until the client navigates away or the server cancels. Do not use `data-on-interval` polling for this — hold the connection.
- `data-init` fires once when the element is added to the DOM, initiating the stream immediately on page load without a user action.

---

## Complete Example: Live Inline Validation

Validate individual fields on the server as the user types, patching back only the form fragment so error messages and field states update in place.

**HTML:**

```html
<form id="signup-form" data-signals="{email: '', firstName: '', lastName: ''}">

  <label>
    Email
    <input
      type="email"
      data-bind:email
      data-on:input__debounce_500ms="@post('/signup/validate')"
      aria-describedby="email-error"
    />
    <span id="email-error" role="alert"></span>
  </label>

  <label>
    First Name
    <input
      type="text"
      data-bind:first-name
      data-on:input__debounce_500ms="@post('/signup/validate')"
    />
    <span id="first-name-error" role="alert"></span>
  </label>

  <button data-on:click__prevent="@post('/signup')">Sign Up</button>

</form>
```

**Backend — validate endpoint (patches error spans in place):**

```csharp
app.MapPost("/signup/validate", async (IDatastarService ds) =>
{
    var signals = await ds.ReadSignalsAsync<SignupSignals>();

    // Patch each error span; empty string clears it
    var emailError = ValidateEmail(signals.Email);
    await ds.PatchElementsAsync(
        $"""<span id="email-error" role="alert">{emailError}</span>""");

    var firstNameError = ValidateRequired("First name", signals.FirstName);
    await ds.PatchElementsAsync(
        $"""<span id="first-name-error" role="alert">{firstNameError}</span>""");
});

public record SignupSignals(string Email, string FirstName, string LastName);

static string ValidateEmail(string? email) =>
    string.IsNullOrWhiteSpace(email) ? "" :
    email.Contains('@') ? "" : "Enter a valid email address.";

static string ValidateRequired(string field, string? value) =>
    string.IsNullOrWhiteSpace(value) ? $"{field} is required." : "";
```

**Backend — submit endpoint (validates everything before saving):**

```csharp
app.MapPost("/signup", async (IDatastarService ds) =>
{
    var signals = await ds.ReadSignalsAsync<SignupSignals>();

    var emailError = ValidateEmail(signals.Email);
    var firstNameError = ValidateRequired("First name", signals.FirstName);

    if (emailError != "" || firstNameError != "")
    {
        await ds.PatchElementsAsync($"""<span id="email-error" role="alert">{emailError}</span>""");
        await ds.PatchElementsAsync($"""<span id="first-name-error" role="alert">{firstNameError}</span>""");
        return;
    }

    await SaveSignupAsync(signals);

    // Patch the whole form out and show a confirmation
    await ds.PatchElementsAsync("""<p id="signup-form">Thanks for signing up!</p>""");
});
```

Key points:
- Each error span has a stable `id` — morph replaces only that span on each keystroke.
- Debounce (`__debounce_500ms`) prevents a round-trip on every character.
- The submit handler re-validates server-side; never trust client-only validation.
- `aria-describedby` / `role="alert"` keeps the pattern accessible.

---

## Gotchas

- Elements patched via SSE **must have an `id`** on the top-level element for morphing to work.
- Nested elements you want to preserve across morphs (inputs, animations) should also carry an `id`.
- Signal names are camelCase on the frontend. `[JsonPropertyName]` can bridge PascalCase C# properties.
- Do not write signal values back to the client on every request — only send what changed.
- Datastar signals are scoped to the page; they do not persist across navigation. Use `sessionStorage` or a hidden field if you need cross-page state.
- For streaming long responses (jobs, logs), hold the SSE connection open and write events as they occur, then let the stream close naturally.
- **Razor views:** `@get(...)` is a Razor expression. Escape it as `@@get(...)` so Razor emits a literal `@get` to the browser.
