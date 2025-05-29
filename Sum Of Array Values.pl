% Base case: the sum of an empty list is 0
sum([], 0).

% Recursive case: sum of a list is the head + sum of the tail
sum([Head|Tail], Sum) :-
    sum(Tail, TailSum),
    Sum is Head + TailSum.
