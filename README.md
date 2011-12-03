# vorarbeiter

Vorarbeiter acts as a queue for distributing workload to a designated number of worker processes.

## Synopsis

	% create a queue with 4 worker processes
	Queue = vorarbeiter:new(4),
	
	% give the workers something to do
	Queue ! { enqueue, self(), test_workload, lists, reverse, [[1,2,3]] },
	
	% pick up the results
	receive
		{ test_workload, Result } ->
			Result
	end.


