defmodule SpotifyCharts do
  @spotify "https://spotifycharts.com/api/?type=regional&country=global&recurrence=daily&date=latest"
  def get_charts do
    make_request
    |> get_body
    |> parse_json
    |> get_items
    |> print_items
  end

  defp make_request, do: HTTPoison.get(@spotify)
  defp get_body({:ok, %{body: body}}), do: body
  defp get_body(_), do: "[]"
  defp parse_json(body), do: Poison.decode!(body)
  defp get_items(%{"entries" => %{"items" => items}}), do: items
  defp get_items(_), do: :error

  defp get_items(item_list) do
    case item_list do
      %{"entries" => %{"items" => items}} ->
        items
      _ ->
        nil
    end
  end

  defp print_items([]), do: nil
  defp print_items([item| rest]) do
    print_item(item)
    print_items(rest)
  end

  def print_item(item) do
    IO.puts "#{item["current_position"]}. #{item["track"]["name"]}"
  end
end
