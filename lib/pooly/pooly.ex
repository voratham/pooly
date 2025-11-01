defmodule Pooly do
  use Application

  def start(_type, _args) do
    # pool_config = [
    #   mfa: {SampleWorker, :start_link, []},
    #   size: 5
    # ]
    pools_config = [
      [name: "Pool1", mfa: {SampleWorker, :start_link, []}, size: 2],
      [name: "Pool2", mfa: {SampleWorker, :start_link, []}, size: 3],
      [name: "Pool3", mfa: {SampleWorker, :start_link, []}, size: 4]
    ]

    start_pool(pools_config)
  end

  def start_pool(pools_config) do
    Pooly.Supervisor.start_link(pools_config)
  end

  def checkout do
    Pooly.Server.checkout()
  end

  def checkin(worker_pid) do
    Pooly.Server.checkin(worker_pid)
  end

  def status do
    Pooly.Server.status()
  end
end
