defmodule SysHealth do
    def start_link() do
      {:ok, _} = Plug.Adapters.Cowboy.http(SysHealth.Router, [], port: 4001)
    end

    def init(_opts), do: nil
  end
