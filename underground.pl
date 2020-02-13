
%Q1

multiple_lines(S) :- 
stop(X,_,S),stop(Z,_,S), 
X \= Z.

%Q2

termini(L,S1,S2) :- 
stop(L,1,S1),stop(L,Y,S2), 
\+ (stop(L, A, _), A > Y).

%Q3

list_stops(L,List) :- list_stops_Helper(L,List,_).

list_stops_Helper(L,List,N) :- ttime(L,N,Z,_), stop(L,N,S),
!, list_stops_Helper(L,ZYList,Z),
List=[S|ZYList].

list_stops_Helper(L,List,Y) :- ttime(L,_,Y,_), stop(L,Y,S), 
\+ (stop(L, A, _), A > Y), 
List=[S].


%Q4

path(X,Y,Path) :- pathHelper(X,Y,[X],Path,X,_,_).


%find Y return and previous line different

pathHelper(X,Y,VISITED,Path,P,Zrp,Trp) :- 
stop(L,Q1,X),stop(L,Q2,Z),ttime(L,Q1,Q2,T), 
\+member(Z,VISITED), Z = Y,
Zrp = X, Trp = 0, P\=L,
Path = [segmentTime(L,X,Y,T)].

%find Y return and previous line same

pathHelper(X,Y,VISITED,Path,P,Zrp,Trp) :- 
stop(L,Q1,X),stop(L,Q2,Z),ttime(L,Q1,Q2,T), 
\+member(Z,VISITED), Z = Y,
P = L, Zrp = Y, Trp = T,
Path = [].

%traverse one at a time and previous line same

pathHelper(X,Y,VISITED,Path,P,Zrp,Trp) :- 
stop(L,Q1,X),stop(L,Q2,Z),ttime(L,Q1,Q2,T), 
\+member(Z,VISITED), Z \= Y,
pathHelper(Z,Y,[Z|VISITED],Path,L,Zr,Tr), 
P = L , Zrp = Zr, Trp is T+Tr.

%traverse one at a time and previous line not same

pathHelper(X,Y,VISITED,Path,P,Zrp,Trp) :- 
stop(L,Q1,X),stop(L,Q2,Z),ttime(L,Q1,Q2,T), 
\+member(Z,VISITED), Z \= Y,
pathHelper(Z,Y,[Z|VISITED],ZYPath,L,Zr,Tr),
P \=L ,Zrp = X, Trp = 0, Ts is T+Tr,
Path = [segmentTime(L,X,Zr,Ts)|ZYPath].




%Q5 easiest

nonMinLEN(X,Y,Path) :- 
path(X,Y,Path),length(Path,LEN),
!,
path(X,Y,Path1),length(Path1,LEN1),
LEN>LEN1.

easiest_Path(X,Y,Path) :-  
path(X,Y,Path),length(Path,_),
\+nonMinLEN(X,Y,Path).


%Q6 shortest

indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
indexOf(Tail, Element, Index1),
!,
Index is Index1+1.


numStations(0, []).
numStations(NewTotal, [H|T]) :-
H = segmentTime(L, X, Y, _),
list_stops(L,List),
indexOf(List,X,I1),
indexOf(List,Y,I2),
I3 is I1 - I2 +1,
numStations(Total, T),
NewTotal is Total+I3.


nonMinStations(X,Y,Path) :- 
path(X,Y,Path),numStations(SUM,Path),
!,
path(X,Y,Paths),numStations(SUM1,Paths),
SUM<SUM1.

shortest_Path(X,Y,Path) :-  
path(X,Y,Path),numStations(_,Path),
\+nonMinStations(X,Y,Path).


%Q7 fastest

timeOfPath(0, []).
timeOfPath(NewTotal, [H|T]) :-
H = segmentTime(_, _, _, Time),
timeOfPath(Total, T),
NewTotal is Total+Time.

nonMinTime(X,Y,Path) :- 
path(X,Y,Path),timeOfPath(SUM,Path),
!,
path(X,Y,Paths),
timeOfPath(SUM1,Paths),
SUM>SUM1.

fastest_Path(X,Y,Path) :-  
path(X,Y,Path),timeOfPath(_,Path),
\+nonMinTime(X,Y,Path).