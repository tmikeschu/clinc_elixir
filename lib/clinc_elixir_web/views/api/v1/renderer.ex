defmodule ClincElixirWeb.Api.V1.Renderer do
  defmacro __using__(_opts) do
    quote do
      require Logger
      require Jason

      defp log(data, reqres, handling) do
        label = Map.get(%{req: "REQUEST", res: "RESPONSE"}, reqres)

        if reqres == :req, do: Logger.info("HANDLING: #{handling}")
        Logger.info("#{label} DATA: #{Jason.encode!(data)}")
        Logger.info("...")

        data
      end

      defp add_response_slots(body, type, data) do
        Map.put(body, :response_slots, %{
          response_type: type,
          visuals: data,
          speakables: data
        })
      end

      defp add_visual_data(body, data) do
        Map.put(body, :visual_payload, data)
      end

      defp resolve_slot(body, slot_name) do
        update_in(
          body,
          [:slots, slot_name, :values],
          fn vs -> Enum.map(vs, &Map.merge(&1, %{resolved: 1})) end
        )
      end

      defp resolve_slots(body, slot_names) do
        Enum.reduce(slot_names, body, &resolve_slot(&2, &1))
      end

      defp add_slot(body, slot_name, data) do
        put_in(body, [:slots, slot_name], data)
      end
    end
  end
end
