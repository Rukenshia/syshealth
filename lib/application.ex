defmodule SysHealth.Application do
    use Application

    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        worker(SysHealth, []),
      ]

      opts = [strategy: :one_for_one, name: SysHealth.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end
