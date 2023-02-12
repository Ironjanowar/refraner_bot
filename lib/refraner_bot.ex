defmodule RefranerBot do
  alias RefranerBot.{Store, MessageFormatter}

  @default_opts %{show: :summary}
  def get_refran(opts \\ %{}) do
    opts = normalize_opts(opts, @default_opts)

    opts |> Store.get_refran() |> MessageFormatter.format_refran(opts)
  end

  defp normalize_opts(opts, defaults) do
    opts = Map.new(opts)
    Map.merge(defaults, opts)
  end
end
