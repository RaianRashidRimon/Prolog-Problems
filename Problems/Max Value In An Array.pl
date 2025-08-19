max([X], X).





max([Head|Tail], Max) :-
    max(Tail, TailMax),
    (Head > TailMax -> Max = Head ; Max = TailMax).
