defmodule RefranerBot.Bot do
  @bot :refraner_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Muestra la ayuda")
  command("refran", description: "Manda un refran")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:command, :refran, _msg}, context) do
    {message, opts} = RefranerBot.get_refran()
    answer(context, message, opts)
  end

  def handle({:callback_query, %{data: "show:" <> id}}, context) do
    {message, opts} = RefranerBot.get_refran(id: id, show: :full)
    edit(context, :inline, message, opts)
  end

  def handle({:callback_query, %{data: "hide:" <> id}}, context) do
    {message, opts} = RefranerBot.get_refran(id: id, show: :summary)
    edit(context, :inline, message, opts)
  end

  def handle({:inline_query, %{query: ""}}, context) do
    articles = RefranerBot.get_inline_refranes(limit: 10)
    answer_inline_query(context, articles)
  end

  def handle({:inline_query, %{query: search}}, context) do
    articles = RefranerBot.get_inline_refranes(limit: 10, search: search)
    answer_inline_query(context, articles)
  end
end
