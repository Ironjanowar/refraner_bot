defmodule RefranerBot.Bot do
  @bot :refraner_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Muestra la ayuda")
  command("refran", description: "Manda un refran")
  command("about", description: "Información sobre el creador")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hola! Envía /help si quieres saber como funciona el bot")
  end

  def handle({:command, :help, _msg}, context) do
    {message, opts} = RefranerBot.help()
    answer(context, message, opts)
  end

  def handle({:command, :about, _msg}, context) do
    {message, opts} = RefranerBot.about()
    answer(context, message, opts)
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
    answer_inline_query(context, articles, cache_time: 0)
  end

  def handle({:inline_query, %{query: search}}, context) do
    articles = RefranerBot.get_inline_refranes(limit: 10, search: search)
    answer_inline_query(context, articles)
  end
end
