defmodule RefranerBot.Bot do
  @botname :refraner_bot

  def bot(), do: @botname

  use ExGram.Bot, name: @botname

  require Logger

  middleware(ExGram.Middleware.IgnoreUsername)

  def handle({:inline_query, %{query: ""}}, context) do
    {:ok, refranes} = Refraner.get_refranes(count: 10)
    articles = Enum.map(refranes, &RefranerBot.Inline.create_article/1)
    answer_inline_query(context, articles)
  end

  def handle({:inline_query, %{query: search}}, context) do
    {:ok, refranes} = Refraner.get_refranes(count: 10, search: search)
    articles = Enum.map(refranes, &RefranerBot.Inline.create_article/1)
    answer_inline_query(context, articles)
  end

  def handle({:command, "start", _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, "refran", %{from: %{id: user_id, first_name: first_name}}}, context) do
    {:ok, [%{"id" => refran_id} = full_refran]} = Refraner.get_refranes()
    refran_text = RefranerBot.Utils.pretty_refran(full_refran)

    Logger.info("Sending refran #{refran_id} to #{first_name} [#{user_id}]")

    buttons = RefranerBot.Utils.generate(refran_id, [:show, :rate], %{})

    answer(context, refran_text, parse_mode: "Markdown", reply_markup: buttons)
  end

  def handle(
        {:callback_query, %{data: "action:show_refran_info:" <> id}},
        context
      ) do
    {:ok, full_refran} = Refraner.get_refran_by_id(id)
    refran = RefranerBot.Utils.pretty_refran_info(full_refran)
    buttons = RefranerBot.Utils.generate(id, [:hide, :rate], %{})
    edit(context, :inline, refran, parse_mode: "Markdown", reply_markup: buttons)
  end

  def handle(
        {:callback_query, %{data: "action:hide_refran_info:" <> id}},
        context
      ) do
    {:ok, full_refran} = Refraner.get_refran_by_id(id)
    refran_text = RefranerBot.Utils.pretty_refran(full_refran)
    buttons = RefranerBot.Utils.generate(id, [:show, :rate], %{})

    edit(context, :inline, refran_text, parse_mode: "Markdown", reply_markup: buttons)
  end

  def handle(
        {:callback_query,
         %{
           id: cb_id,
           data: "rate_refran:" <> data,
           from: %{id: user_id}
         }},
        context
      ) do
    [rate, id] = String.split(data, ":")

    Logger.info("User #{user_id} rated refran #{id} with #{rate}")

    Refraner.add_vote(user_id, id, rate)

    answer_callback(context, cb_id, text: "You voted #{rate}!")
  end
end
