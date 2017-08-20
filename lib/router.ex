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
    [totalmem, usedmem, _, _, freemem] = System.cmd("vmstat", ["-s", "-SM"])
    |> String.split("\n")
    |> Stream.map(
      fn (x) ->
        x
        |> String.trim()
        |> String.split()
        |> List.first()
      end
    )

    send_resp(conn, 200, Poison.encode!(%{ok: true, total: totalmem, used: usedmem, free: freemem}))
  end

  match _ do
    send_resp(conn, 400, Poison.encode!(%{"ok": false}))
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect kind
    IO.inspect reason
    IO.inspect stack

    send_resp(conn, conn.status, Poison.encode!(%{"ok": false}))
  end
end