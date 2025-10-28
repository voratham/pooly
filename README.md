# Pooly

**TODO: Add description**

## Step Learning

```elixir
{:ok , worker_sup} = Pooly.WorkerSupervisor.start_link({ SampleWorker , :start_link, []})

Supervisor.start_child(worker_sup , [[]])
Supervisor.which_children(worker_sup)
Supervisor.count_children(worker_sup)


 {:ok , worker_pid }= Supervisor.start_child(worker_sup , [[]])
 SampleWorker.stop(worker_pid)
 Supervisor.which_children(worker_sup)


:ets.new(:mum_faves, [])
:ets.new(:mum_faves, [:set])
# for process ownership
:ets.new(:mum_faves, [:set, :private])


:ets.new(:mum_faves, [:set , :private , :named_table])

:ets.insert(:mum_faves, {"Bodyslam" , 2025, "Rock"})
:ets.insert(:mum_faves, {"Oat Pramote" , 2025, "Pop"})
:ets.insert(:mum_faves, {"GOT7" , 2025, "Pop"})
:ets.insert(:mum_faves, {"Silly fool" , 2025, "Rock"})
:ets.insert(:mum_faves, {"Potato" , 2025, "Rock"})
:ets.tab2list(:mum_faves)

:ets.delete(:mum_faves, "GOT7")

:ets.lookup(:mum_faves, "Bodyslam")

:ets.match(:mum_faves, {:"$1", 2025, :"$2"})

:ets.match(:mum_faves, {:"$2", 2025, :"$1"})

:ets.match(:mum_faves, {:"$1", 2025, :"_"})


pid = spawn(fn ->
    :timer.sleep(2000)
    exit(:boom)
  end)
ref = Process.monitor(pid)
flush()


:observer.start()

```

📊 Pooly Architecture

```mermaid
graph TD
    A["Pooly Application<br/>(Application module)<br/>Startup Entry Point"] -->|start/2| B["Pooly.Supervisor<br/>(Main Supervisor)<br/>strategy: one_for_all"]

    B -->|supervises| C["Pooly.Server<br/>(GenServer)<br/>Pool Manager"]

    C -->|sends :start_worker_supervisor| D["Pooly.WorkerSupervisor<br/>(Supervisor)<br/>strategy: simple_one_for_one"]

    D -->|creates workers| E["Worker Pool<br/>(SampleWorker instances)<br/>e.g., 5 workers"]

    C -->|manages| F["ETS Table<br/>monitors<br/>tracks out-of-pool workers"]

    C -->|maintains| G["Workers List<br/>available/idle workers"]
```

🔄 Sequence diagram

```mermaid
sequenceDiagram
    participant App as Application
    participant PoolySup as Pooly.Supervisor
    participant Server as Pooly.Server
    participant WorkerSup as WorkerSupervisor
    participant Workers as Workers Pool

    App->>PoolySup: start_link(pool_config)
    PoolySup->>Server: supervise Server
    Server->>Server: init state
    Server->>Server: send :start_worker_supervisor

    Server->>WorkerSup: start_child (supervisor_spec)
    WorkerSup->>Workers: create N workers
    Workers-->>WorkerSup: workers ready

    WorkerSup-->>Server: {:ok, worker_sup_pid}
    Server->>Server: prepopulate workers to list
    Server-->>PoolySup: {:ok, supervisor_pid}
```
