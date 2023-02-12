defmodule RefranerBot.MessageFormatter do
  alias RefranerBot.Entities.Refran

  alias ExGram.Model.InlineQueryResultArticle
  alias ExGram.Model.InputTextMessageContent

  @default_opts [parse_mode: "Markdown"]
  @defaults %{show: :summary}
  def format_refran(refranes, opts \\ %{}) do
    refran = unwrap(refranes)
    opts = normalize_opts(opts, @defaults)
    show = Map.fetch!(opts, :show)
    do_format_refran(refran, show)
  end

  defp unwrap([%Refran{} = refran]), do: refran
  defp unwrap(%Refran{} = refran), do: refran

  defp do_format_refran(refran, :full) do
    refran_data =
      refran
      |> Map.from_struct()
      |> Map.drop([:id, :__meta__])
      |> Enum.filter(fn
        {:refran, _} -> false
        {_, nil} -> false
        _ -> true
      end)
      |> Enum.map(fn {k, v} -> " - *#{format_key(k)}:* #{v}" end)
      |> Enum.join("\n")

    message = """
    📜 _#{refran.refran}_ 📜
    #{refran_data}
    """

    opts = @default_opts ++ show_buttons(refran.id, :hide)
    {message, opts}
  end

  defp do_format_refran(refran, :summary) do
    opts = @default_opts ++ show_buttons(refran.id, :show)
    {"📜 _#{refran.refran}_ 📜", opts}
  end

  defp from_atom(key) when is_atom(key), do: Atom.to_string(key)
  defp from_atom(key), do: key

  defp format_key(key) do
    key
    |> from_atom()
    |> String.capitalize()
    |> String.split("_")
    |> Enum.join(" ")
  end

  defp normalize_opts(opts, defaults) do
    opts = Map.new(opts)
    Map.merge(defaults, opts)
  end

  defp show_buttons(refran_id, :show) do
    buttons = [[[text: "Show info", callback_data: "show:#{refran_id}"]]]
    [reply_markup: ExGram.Dsl.create_inline(buttons)]
  end

  defp show_buttons(refran_id, :hide) do
    buttons = [[[text: "Hide info", callback_data: "hide:#{refran_id}"]]]
    [reply_markup: ExGram.Dsl.create_inline(buttons)]
  end

  def format_inline([]), do: []

  def format_inline(refranes) do
    Enum.map(refranes, &generate_inline/1)
  end

  defp generate_inline(%Refran{} = refran) do
    {formatted_refran, opts} = format_refran(refran)
    parse_mode = opts[:parse_mode]
    reply_markup = opts[:reply_markup]

    %InlineQueryResultArticle{
      type: "article",
      id: refran.id,
      title: refran.refran,
      input_message_content: %InputTextMessageContent{
        message_text: formatted_refran,
        parse_mode: parse_mode
      },
      reply_markup: reply_markup,
      description: refran.tipo || ""
    }
  end
end
