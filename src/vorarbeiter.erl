-module(vorarbeiter).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").


%% @doc Starts a new Vorarbeiter and returns its PID.
%% @spec new(NoOfWorkers::integer()) -> pid()
new(NoOfWorkers) ->
	spawn(?MODULE, vorarbeiter, [NoOfWorkers]).


%% @doc Spawns N workers.
%% @spec spawn_n_workers(N::integer(), Queue::pid()) -> ok
spawn_n_workers(0, _) ->
	ok;

spawn_n_workers(N, Queue) ->
	spawn_link(?MODULE, worker, [Queue]),
	spawn_n_workers(N-1, Queue).


%% @doc The main loop, receiving the workload from the client and assigning it to the workers.
%% @spec vorarbeiter(NoOfWorkers::interger()) -> ok
vorarbeiter(NoOfWorkers) ->
	process_flag(trap_exit, true),
	spawn_n_workers(NoOfWorkers, self()),
	receive
		{ get_work, Worker } ->
			receive
				{ enqueue, Client, WorkloadId, Module, Function, Args } ->
					Worker ! { work, Client, WorkloadId, Module, Function, Args }
			end;
		{ 'EXIT', Pid, Why } ->
			io:format("~p died: ~p~n", [ Pid, Why ]),
			spawn_n_workers(1, self())
	end,
	vorarbeiter(NoOfWorkers).


%% @doc The worker loop, asking the Vorarbeiter for work and executing it, returning the result directly to the client.
%% @spec worker(Queue::pid()) -> ok
worker(Queue) ->
	Queue ! { get_work, self() },
	receive
		{ work, Client, WorkloadId, Module, Function, Args } ->
			Result = apply(Module, Function, Args)
	end,
	Client ! { WorkloadId, Result },
	worker(Queue).


new_test() ->
	Queue = new(2),
	Queue ! { enqueue, self(), workload_id, lists, reverse, [[1,2,3]] },
	receive
		{ workload_id, Result } ->
			[3,2,1] = Result
	end,
	ok.

