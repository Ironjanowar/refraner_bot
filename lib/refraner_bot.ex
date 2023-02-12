defmodule RefranerBot do
  alias RefranerBot.{Store, MessageFormatter}

  @default_opts %{show: :summary}
  def get_refran(opts \\ %{}) do
    opts = normalize_opts(opts, @default_opts)
    opts |> Store.get_refranes() |> MessageFormatter.format_refran(opts)
  end

  def get_inline_refranes(opts \\ %{}) do
    opts
    |> normalize_opts(@default_opts)
    |> Store.get_refranes()
    |> MessageFormatter.format_inline()
  end

  defp normalize_opts(opts, defaults) do
    opts = Map.new(opts)
    Map.merge(defaults, opts)
  end

  defdelegate help, to: MessageFormatter, as: :help_command
  defdelegate about, to: MessageFormatter, as: :about_command
end
