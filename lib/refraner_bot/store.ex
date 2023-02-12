defmodule RefranerBot.Store do
  import Ecto.Query

  alias RefranerBot.Entities.Refran
  alias RefranerBot.Repo

  @default_params %{language: "ES", order_by: :random, limit: 1}
  def get_refranes(params \\ %{}) do
    params = normalize_params(params, @default_params)
    language = params |> Map.fetch!(:language) |> String.upcase()
    id = maybe_string_to_integer(params[:id])
    limit = Map.fetch!(params, :limit)

    from(r in Refran, limit: ^limit)
    |> add_order_by(params[:order_by])
    |> maybe_filter_by(:idioma_codigo, language)
    |> maybe_filter_by(:id, id)
    |> maybe_search_text(params[:search])
    |> Repo.all()
  end

  defp normalize_params(params, defaults) do
    params = Map.new(params)
    Map.merge(defaults, params)
  end

  defp maybe_string_to_integer(nil), do: nil
  defp maybe_string_to_integer(str) when is_binary(str), do: String.to_integer(str)

  defp maybe_filter_by(query, _field, nil), do: query
  defp maybe_filter_by(query, field, value), do: where(query, [r], field(r, ^field) == ^value)

  defp add_order_by(query, :random), do: order_by(query, fragment("RANDOM()"))
  defp add_order_by(query, _), do: query

  defp maybe_search_text(query, nil), do: query

  defp maybe_search_text(query, search_text) do
    search_text = "%#{search_text}%"
    where(query, [r], like(r.refran, ^search_text))
  end
end
