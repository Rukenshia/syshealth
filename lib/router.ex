defmodule SysHealth.Router do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Poison

  plug :match
  plug :dispatch

  get "/memory" do
    [totalmem, usedmem, _, _, freemem | _] = System.cmd("vmstat", ["-s", "-SM"])
    |> elem(0)
    |> String.split("\n")
    |> Stream.map(
      fn (x) ->
        x
        |> String.trim()
        |> String.split()
        |> List.first()
      end
    )
    |> Enum.to_list()

    send_resp(conn, 200, Poison.encode!(%{ok: true, total: totalmem, used: usedmem, free: freemem}))
  end

  get "/load" do
    idle = System.cmd("top", ["-bn1"])
    |> elem(0)
    |> String.split("\n")
    |> Enum.at(2)
    |> String.split(", ")
    |> Enum.at(3)

    send_resp(conn, 200, Poison.encode!(%{ok: true, idle: idle}))
  end

  match _ do
    send_resp(conn, 400, Poison.encode!(%{ok: false}))
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect kind
    IO.inspect reason
    IO.inspect stack

    send_resp(conn, conn.status, Poison.encode!(%{ok: false}))
  end
end
