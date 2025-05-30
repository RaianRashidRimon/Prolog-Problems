% Base case: the maximum of a single element list is the element itself
max([X], X).

% Recursive case: find the maximum of the head and the max of the tail
max([Head|Tail], Max) :-
    max(Tail, TailMax),
    (Head > TailMax -> Max = Head ; Max = TailMax).