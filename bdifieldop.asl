//TEAM_AXIS

+flag (F): team(200) 
  <-
  .create_control_points(F,25,3,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  .print("Got control points").


+target_reached(T): patrolling & team(200) 
  <-
  .print("AMMOPACK!");
  .reload;
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T 
  <-
  ?control_points(C);
  .nth(P,C,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).


//TEAM_ALLIED 

+flag (F): team(100) 
  <-
  .goto(F).

+flag_taken: team(100) 
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.

+heading(H): exploring
  <-
  .reload;
  .wait(2000);
  .turn(0.375).

//+heading(H): returning
//  <-
//  .print("returning").

+target_reached(T): team(100)
  <- 
  .print("target_reached");
  +exploring;
  .turn(0.375).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <- 
  .shoot(3,Position).

// Fieldop Help

+ammoproposal(Pos)[source(A)]: not ayudando(_,_)
  <-
    ?health(MiSalud);
    ?position(MiPos);
    .send(A,tell,mybidF(MiPos,MiSalud));
    +ayudando(A,Pos);
    -ammoproposal(_);
    .print("enviada propuesta de ayuda").

+acceptproposal[source(A)]: ayudando(A,Pos)
  <-
    .print("Me voy a ayudar al agente: ", A, "a la posición: ", Pos);
    .goto(Pos).

+cancelproposal[source(A)]: ayudando(A,Pos)
  <-
    .print("Cancelan mi proposicion.");
    -ayudando(A,Pos).

+target_reached(T): ayudando(A,T)
  <-
    .print("AMMOPACK! para el agente: ", A);
    .reload;
    ?miposicion(P);
    .goto(P);
    -ayudando(A,T).

+threshold_ammo(H):
  <-
  .reload.
