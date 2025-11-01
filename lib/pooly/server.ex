defmodule Pooly.Server do
  use GenServer

  import Supervisor.Spec

  defmodule State do
    # defstruct sup: nil, size: nil, mfa: nil, workers: nil, worker_sup: nil, monitors: nil
    defstruct pool_sup: nil,
              worker_sup: nil,
              monitors: nil,
              size: nil,
              workers: nil,
              name: nil,
              mfa: nil
  end

  # API

  # V2
  def start_link(pools_config) do
    GenServer.start_link(__MODULE__, pools_config, name: __MODULE__)
  end

  def checkout(pool_name) do
    GenServer.call(:"#{pool_name}Server", :checkout)
  end

  def checkin(pool_name, worker_pid) do
    GenServer.cast(:"#{pool_name}Server", {:checkin, worker_pid})
  end

  def status(pool_name) do
    GenServer.call(:"#{pool_name}Server", :status)
  end

  # V2
  def init(pools_config) do
    pools_config
    |> Enum.each(fn pool_config ->
      send(self(), {:start_pool, pool_config})
    end)

    {:ok, pools_config}
  end

  def handle_info({:start_pool, pool_config}, state) do
    {:ok, _pool_sup} = Supervisor.start_child(Pooly.PoolsSupervisor, supervisor_spec(pool_config))

    {:noreply, state}
  end

  # V2
  defp supervisor_spec(pool_config) do
    IO.puts("YYYYYYY #{inspect(pool_config)} ")

    opts = [id: :"#{pool_config[:name]}Supervisor"]
    IO.puts("test :: #{inspect(opts)}")
    supervisor(Pooly.PoolSupervisor, [pool_config], opts)
  end
end
