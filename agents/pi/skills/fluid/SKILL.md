---
name: fluid
description: Guide for Fluid.Core (.NET Liquid templating). Use when writing or modifying .liquid templates, setting up FluidViewRenderer, building TemplateContext, registering filters/tags, or implementing HTMX fragment rendering. Do NOT apply Shopify Liquid, Scriban, Razor, or Mustache semantics.
license: MIT
---

# Fluid.Core — .NET Liquid Templating

## What Fluid Is (and Isn't)

Fluid.Core is a .NET implementation of the [Liquid template language](https://shopify.github.io/liquid/). It is **not**:
- Razor (`@model`, `@foreach`, `@Html.*` — none of this exists)
- Scriban (different syntax, different filters, different objects)
- Mustache (`{{#section}}`, `{{/section}}` — wrong language)
- Shopify Liquid (many Shopify-specific tags/filters don't exist in Fluid)

The reference for what works in Fluid is [Deane Barker's guide](https://deanebarker.net/tech/fluid/) and the [Fluid GitHub README](https://github.com/sebastienros/fluid). When in doubt, the C# README is authoritative over the Shopify docs.

---

## Thread Safety Rules (Critical)

| Object | Thread-safe? | Pattern |
|---|---|---|
| `FluidParser` | ✅ Yes | Singleton — create once, reuse everywhere |
| `IFluidTemplate` | ✅ Yes | Cache parsed templates; re-parse only when source changes |
| `TemplateContext` | ❌ No | Create a **new** instance for every render call |
| `TemplateOptions` | ✅ Yes (once configured) | Configure at startup, then treat as read-only |

---

## Setup — Two Packages

**`Fluid.Core`** — Parser, TemplateContext, rendering. Required.

**`Fluid.ViewEngine`** — Adds `FluidViewRenderer` with layout (`{% layout %}`), partials (`{% include %}`), file provider, and caching. Use this for ASP.NET MVC-style rendering.

```xml
<PackageReference Include="Fluid.Core" Version="2.*" />
<PackageReference Include="Fluid.ViewEngine" Version="2.*" />
```

---

## TemplateOptions — Configure Once at Startup

```csharp
// In DI setup or as a static singleton
var options = new TemplateOptions();

// Allow access to any public member without whitelisting.
// Appropriate when templates are developer-written and you control what goes into the context.
options.MemberAccessStrategy = new UnsafeMemberAccessStrategy
{
    MemberNameStrategy = MemberNameStrategies.SnakeCase  // templates use snake_case
};

// Convert enums to their string name (required — enums don't render by default)
options.ValueConverters.Add(obj => obj is Enum e ? e.ToString() : null);

// Register custom filters (see below)
options.Filters.AddFilter("timeago", MyFilters.Timeago);
```

### MemberNameStrategy

If `SnakeCase` is set, **every** property access in templates must use snake_case:
- C# `IsAuthenticated` → liquid `{{ is_authenticated }}` ✓
- C# `LastHeartbeat` → liquid `{{ last_heartbeat }}` ✓
- `{{ IsAuthenticated }}` → **silent empty output** (no error)

If `SnakeCase` is not set, use PascalCase matching the C# property name exactly.

**Pick one and be consistent across the entire project.**

---

## Rendering with FluidViewEngine (Preferred for Full Pages)

```csharp
// Register in DI
builder.Services.AddSingleton<FluidViewRenderer>(sp =>
{
    var opts = new FluidViewEngineOptions();
    opts.ViewsFileProvider = new PhysicalFileProvider(
        Path.Combine(builder.Environment.ContentRootPath, "Templates"));
    opts.ViewsLocationFormats.Clear();
    opts.ViewsLocationFormats.Add("{0}.liquid");          // e.g. "Kiosks/index" → Kiosks/index.liquid
    opts.PartialsLocationFormats.Add("Shared/{0}.liquid"); // {% include 'header' %} → Shared/header.liquid
    return new FluidViewRenderer(opts);
});
```

```csharp
// Render a page
public async Task<string> RenderPageAsync(string view, object model, CancellationToken ct)
{
    var context = new TemplateContext(model, _templateOptions);
    context.SetValue("is_authenticated", ...);
    context.SetValue("csrf_token", ...);

    using var writer = new StringWriter();
    await _renderer.RenderViewAsync(writer, view, context);
    return writer.ToString();
}
```

**Layout template** (`Templates/layout.liquid`):
```liquid
<!DOCTYPE html>
<html>
<head><title>{{ tab_title | default: "My App" }}</title></head>
<body>
  {% renderbody %}
</body>
</html>
```

**Page template** (`Templates/Kiosks/index.liquid`):
```liquid
{% layout 'layout' %}

<h1>Kiosks</h1>
{% for kiosk in kiosks %}
  <p>{{ kiosk.name }}</p>
{% endfor %}
```

---

## Building TemplateContext

There are two ways to expose data. They behave differently — understand the difference.

### 1. Model (bottom of the scope chain)
```csharp
// Properties of the model object land at top-level in the template
var context = new TemplateContext(new { kiosks, sites, selected_site_id }, options);
// → {{ kiosks }}, {{ sites }}, {{ selected_site_id }}
```

### 2. SetValue (added to the context scope — takes precedence over model)
```csharp
context.SetValue("is_authenticated", true);
context.SetValue("csrf_token", tokens.RequestToken);
// → {{ is_authenticated }}, {{ csrf_token }}
```

**Rule of thumb:** Page-specific data goes in the model. Cross-cutting concerns (auth, CSRF, title) go via `SetValue`.

Do not set a key via both model AND SetValue — `SetValue` wins silently and the model property is invisible.

### What the template can access

A template can **only** access what you explicitly provide. It cannot call methods, access static members, or reach things not in the context. The `MemberAccessStrategy` controls which properties are visible on objects.

Common mistake: passing a C# object and wondering why properties are blank. Check:
1. Is the type registered? (or is `UnsafeMemberAccessStrategy` set?)
2. Is the property name correct for the configured naming strategy?
3. Is the object actually in the context, not just in your head?

---

## Passing Collections

```csharp
// List<T> works directly
context.SetValue("orders", orderList);  // or include in model

// Dictionary iteration — prefer typed objects over raw dicts
// If you must iterate a Dictionary<string,string>:
{% for kv in fields %}
  {{ kv[0] }} = {{ kv[1] }}  ← key and value accessed by index
{% endfor %}
// Better: pass List<{Name, Value}> so you can do {{ field.name }}, {{ field.value }}
```

---

## Fluid-Specific Syntax Gotchas

`{% layout 'name' %}` and `{% renderbody %}` only work with `FluidViewRenderer` (Fluid.ViewEngine), not raw `FluidParser`.

`{{ date | date: "%Y-%m-%d %H:%M" }}` — the `date` filter uses **strftime format**, not .NET format strings.

`{{ html | raw }}` — bypasses the encoder; use for trusted HTML strings when `HtmlEncoder` is active.

**Filters that do NOT exist in Fluid** (agents commonly assume these):
- `money`, `money_with_currency`, `img_tag`, `link_to` — Shopify commerce filters
- `t:` i18n filter — Shopify only
- `handleize` — not in Fluid
- `| @key`, `| @value` — Scriban syntax, wrong language

In Liquid, `nil` and `false` are falsy. Everything else — including `0` and empty string — is truthy.

For general Liquid syntax (loops, filters, conditionals) see [Deane Barker's Fluid guide](https://deanebarker.net/tech/fluid/) — written for Fluid specifically, not Shopify.

---

## HTML Encoding

**Depends on which package you use:**

- **Raw `Fluid.Core`**: `NullEncoder` by default — no HTML encoding. Safe for developer-controlled content; XSS risk if rendering user input.
- **`Fluid.ViewEngine` (`FluidViewRenderer`)**: `HtmlEncoder.Default` by default via `FluidViewEngineOptions.TextEncoder`. Output is HTML-encoded automatically.

When using `FluidViewRenderer`, use `{{ value | raw }}` to output trusted HTML strings (e.g. pre-built markup, embedded fragments). Forgetting `| raw` causes visible `&lt;`, `&gt;` etc. in the page.

To override encoding in `FluidViewEngineOptions`:
```csharp
engineOptions.TextEncoder = NullEncoder.Instance;     // disable
engineOptions.TextEncoder = HtmlEncoder.Default;       // enable (default for ViewEngine)
```

---

## Custom Filters

```csharp
// Register on TemplateOptions (once, at startup)
options.Filters.AddFilter("timeago", (input, arguments, context) =>
{
    var obj = input.ToObjectValue();
    if (obj is not DateTime dt && obj is DateTimeOffset dto)
        dt = dto.UtcDateTime;
    else if (obj is not DateTime)
        return new StringValue("never");

    var span = DateTime.UtcNow - dt.ToUniversalTime();
    return new StringValue(span switch
    {
        { TotalSeconds: < 60 }  => $"{(int)span.TotalSeconds}s ago",
        { TotalMinutes: < 60 }  => $"{(int)span.TotalMinutes}min ago",
        { TotalHours: < 24 }    => $"{(int)span.TotalHours}h ago",
        _                       => dt.ToString("yyyy-MM-dd")
    });
});
```

Usage in template:
```liquid
{{ kiosk.last_heartbeat | timeago }}
```

Filter signature:
- `input`: `FluidValue` — the thing to the left of `|`
- `arguments`: named/positional args after `:` — access via `arguments.At(0)`, `arguments["name"]`
- `context`: current `TemplateContext`
- Return: a `FluidValue` (`StringValue`, `NumberValue`, `BooleanValue`, `NilValue.Instance`, etc.)
- Method must return `ValueTask<FluidValue>` — use `ValueTask.FromResult(...)` or just `return new StringValue(...)`

**When to ask the developer to add a filter:** If a template needs formatting logic that can't be cleanly expressed with built-in filters (date formatting, relative time, currency, truncation with custom rules, domain-specific display strings), ask the developer to register a custom filter rather than embedding workarounds in the template. Filters live in C#, get full access to the context, and keep templates readable. Template logic should describe *what* to show, not *how* to format it.

---

## Custom Tags and Blocks

Tags are standalone (`{% tagname %}`). Blocks have an end tag (`{% blockname %}...{% endblockname %}`).

```csharp
// Empty block — no arguments
_parser.RegisterEmptyBlock("nowrap", async (statements, writer, encoder, context) =>
{
    await statements.RenderStatementsAsync(writer, encoder, context);
    return Statement.Normal();
});

// Identifier block — takes a single string token (NOT an expression)
_parser.RegisterIdentifierBlock("fragment", async (identifier, statements, writer, encoder, context) =>
{
    await statements.RenderStatementsAsync(writer, encoder, context);  // transparent render
    return Statement.Normal();
});
```

The identifier in an identifier block is always a **plain string**, even if it looks like a variable:
```liquid
{% fragment order-table %}   ← identifier is the string "order-table"
{% endfragment %}
```

---

## Fragment Pattern (HTMX Partial Rendering)

> **This is a developer-defined pattern, not a Fluid.Core built-in.** The `{% fragment %}` block is registered as a custom identifier block. It only works in projects that have set it up. It was designed for HTMX partial swaps — whether it's the right pattern for Datastar hasn't been evaluated yet.

The goal: one `.liquid` file serves both full-page rendering and individual fragment extraction for HTMX swaps.

### Template
```liquid
{% layout 'layout' %}

<section>
  <h1>Orders</h1>
  <button hx-get="/orders/fragment/table" hx-target="#orders-table" hx-swap="outerHTML">
    Refresh
  </button>

  {% fragment orders-table %}
  <table id="orders-table">
    {% for order in orders %}
    <tr><td>{{ order.id }}</td><td>{{ order.status }}</td></tr>
    {% endfor %}
  </table>
  {% endfragment %}
</section>
```

### Registration (once, at parser setup)

```csharp
// The block renders transparently during full-page rendering.
// During fragment rendering, only the block's statements are rendered in isolation.
_parser.RegisterIdentifierBlock("fragment",
    async (identifier, statements, writer, encoder, context) =>
    {
        await statements.RenderStatementsAsync(writer, encoder, context);
        return Statement.Normal();
    });
```

### Fragment Extraction via AST

```csharp
using Fluid.Ast;
using Fluid.Parser;

internal sealed class FragmentCollector : AstRewriter
{
    public Dictionary<string, List<Statement>> Fragments { get; } = new(StringComparer.OrdinalIgnoreCase);

    protected override Statement VisitParserBlockStatement<T>(ParserBlockStatement<T> parserBlockStatement)
    {
        if (parserBlockStatement.TagName == "fragment")
        {
            var name = parserBlockStatement.Value?.ToString();
            if (!string.IsNullOrEmpty(name) && !Fragments.ContainsKey(name))
                Fragments[name] = parserBlockStatement.Statements.ToList();
        }
        return base.VisitParserBlockStatement(parserBlockStatement); // recurse for nested
    }
}
```

### Fragment Renderer

```csharp
public async Task<string> RenderFragmentAsync(
    string templatePath, string fragmentName, object model, CancellationToken ct)
{
    // Parse and cache the template (IFluidTemplate is thread-safe and reusable)
    var template = await GetOrParseTemplateAsync(templatePath, ct);

    // Extract fragments (cache this too — it's just a dictionary of Statement lists)
    var fragments = GetOrExtractFragments(templatePath, template);

    if (!fragments.TryGetValue(fragmentName, out var statements))
        throw new InvalidOperationException($"Fragment '{fragmentName}' not found in '{templatePath}'");

    var context = new TemplateContext(model, _options);
    var fragmentTemplate = new FluidTemplate(statements);
    using var writer = new StringWriter();
    await fragmentTemplate.RenderAsync(writer, context);
    return writer.ToString();
}
```

**Important**: Fragment rendering bypasses `{% layout %}`. The fragment endpoint returns raw HTML for insertion, not a full document — that's the point.

### HTMX endpoint pattern

```csharp
[HttpGet("orders/fragment/{name}")]
public async Task<IActionResult> OrderFragment(string name, CancellationToken ct)
{
    var orders = await _orderService.GetOrdersAsync(ct);
    var html = await _renderer.RenderFragmentAsync("Orders/index", name, new { orders }, ct);
    return Content(html, "text/html");
}
```

---

## Failing Loud in Dev Mode

By default, undefined variables and unknown filters render as empty strings with no error — making bugs invisible. Enable strict modes and/or the `Undefined` delegate for development.

### Strict modes (fail fast, throw on first miss)

```csharp
if (env.IsDevelopment())
{
    options.StrictVariables = true;  // throws FluidException on undefined variable
    options.StrictFilters = true;    // throws FluidException on unknown filter
}
```

`StrictVariables` catches both missing top-level variables and missing nested properties. The exception message includes the variable path.

### Visible placeholder (less disruptive, shows in rendered page)

Useful when iterating on templates — keeps the page rendering while making gaps obvious:

```csharp
if (env.IsDevelopment())
{
    options.Undefined = (name, type) =>
        new StringValue($"⚠️[{name}]");
    options.StrictFilters = true;  // still fail hard on typo'd filter names
}
```

The `type` argument is the parent object's type, or `null` for a missing top-level variable — useful for logging:

```csharp
options.Undefined = (name, type) =>
{
    _logger.LogWarning("Undefined template variable {Name} on {Type}", name, type?.Name ?? "global");
    return ValueTask.FromResult<FluidValue>(NilValue.Instance);
};
```

**Recommendation**: use `StrictVariables = true` + `StrictFilters = true` in dev. Silent failures in templates waste a lot of time.

---

## Template Hot-Reload (Dev DX)

`FluidViewRenderer` has `TrackFileChanges = true` by default. It uses `PhysicalFileProvider`'s `IChangeToken` to watch `**/*.liquid` and clears the entire template cache on any change. **Templates are re-parsed on the next request with no app restart.**

This requires `PhysicalFileProvider` — in-memory providers don't support file watching and won't hot-reload.

To disable in production (small perf gain):
```csharp
opts.TrackFileChanges = false;  // on FluidViewEngineOptions
```

**Browser auto-refresh is outside Fluid's scope.** For dev convenience, inject a polling livereload snippet in the layout when in dev mode:
```liquid
{% if is_development %}
<script>
  setInterval(() => fetch('/dev/ping').then(r => { if(r.status === 205) location.reload(); }), 1000);
</script>
{% endif %}
```
Or use browser-sync as a sidecar process.

---

## Datastar with Fluid

Defer to the **datastar skill** for SSE protocol details. Fluid's role is simply rendering the HTML fragment to inject:

```csharp
var html = await _renderer.RenderFragmentAsync("Orders/index", "orders-table", new { orders }, ct);
// pass html to whatever SSE/datastar streaming mechanism you're using
```

The fragment's root element needs a stable `id` that Datastar targets for merging.

---

## Common Agent Mistakes to Avoid

**Wrong language syntax** — Fluid is not Razor (`@model`, `@foreach`), not Mustache (`{{#section}}`), not Scriban (`| @key`). Do not mix syntax from these languages.

**Shopify-specific features don't exist in Fluid** — filters like `money`, `img_tag`, `link_to`, `handleize`, the `t:` i18n filter, and the `{% render %}` tag (Shopify's sandboxed include) are not part of Fluid. Use `{% include %}` for partials.

**`{% layout %}` requires `FluidViewRenderer`** — it doesn't work with raw `FluidParser.Parse()` / `template.Render()`. Same for `{% renderbody %}`.

**Silent empty output from member access failures** — two causes, both produce no error:
- SnakeCase strategy is set but template uses PascalCase (or vice versa)
- Type is not registered and `UnsafeMemberAccessStrategy` is not set

**Methods don't work, only properties** — `{{ order.GetTotal() }}` silently returns nothing. If you need computed values, ask the developer to expose them as a property or add a custom filter.

**`date` filter uses strftime, not .NET format strings** — `%Y-%m-%d`, not `yyyy-MM-dd`.

**HTML encoding differs by package** — raw `Fluid.Core`: off by default. `FluidViewRenderer` (ViewEngine): on by default. Use `| raw` for trusted HTML when using ViewEngine.

**`TemplateContext` is not thread-safe** — always create a new instance per render call.

---

## Quick Debugging Checklist

- Template outputs nothing for a variable → enable `StrictVariables` and `StrictFilters` in dev (see above) — silent failures will become exceptions
- `{% layout %}` has no effect → are you using `FluidViewRenderer` (Fluid.ViewEngine), not raw `IFluidTemplate.Render()`?
- Filter not found at runtime → filter registered on `TemplateOptions.Filters` before first render?
- Fragment not found → fragment block registered on the parser? Template actually parsed (not a stale cache)?
- Enum renders as number or empty → add `ValueConverters` for enum → string
- HTML is double-escaped → `HtmlEncoder` is active but string already contains markup; use `| raw`
