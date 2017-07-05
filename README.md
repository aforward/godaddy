# Godaddy

"A minimal library for posting messages to the GoDaddy API."


## Installation

Add `stripe_post` to your list of dependencies (`:deps`) in `mix.exs`:

```elixir
@deps [
  godaddy: "~> 0.1.0"
]
```

## Configuration

Within your configs, you will need to provide your
[GoDaddy API Keys](https://developer.godaddy.com/keys/).  For example,

```elixir
config :godaddy,
  api_key: "abc123",
  api_secret: "def456"
```

Documentation can
be found at [hexdocs.pm/godaddy](https://hexdocs.pm/godaddy).
