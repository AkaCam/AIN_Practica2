
//TEAM_AXIS

+flag (F): team(200)
  <-
  .register_service("backup");
  .print("Drakukeo, el empalador");
  .create_control_points(F,25,3,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  .print("Got control <points").

+target_reached(T): patrolling & team(200)
  <-
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

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): position(P) 
  <-
	.safeToShoot(P, Cond);
  if(Cond)
	{
    .look_at(Position);
		.shoot(3,Position);
    .get_service("backup");
    .print("AyudaaAAaaaaa");
    +backup(L);
    .send(L, tell, ir_a(Position));
	}.


+ir_a(Pos)[source(A)]
  <-
 .print("Recibido mensaje ir_a de: ", A, " para ir a: ", Pos);
 +ayudando;
 .goto(Pos).

//////////////////////////////////////////



// Pedir Ayuda A Medicos

+health(H): H>=30 & salud
  <-
  -salud.

+health(H): H<30 & not (salud)
  <-
  .print("Solicito ayuda a los Medicos");
  +salud;
  .get_medics.

+myMedics(M): salud //& not (buscaMedico)
  <-
  .print("Pido ayuda a medicos");
  ?position(Pos);
  +posMedico([]);
  +agentsMedico([]);
  .send(M, tell, medicproposal(Pos));
  .wait(1000);
  !!elegirmejorMedico;
  -myMedics(_).

 +mybidMedico(Pos)[source(A)]: salud //and not (buscaMedico)
   <-
   .print("Recibo propuesta de Medico");
   ?posMedico(B);
   .concat(B, [Pos], B1); -+posMedico(B1);
   ?agentsMedico(Ag);
   .concat(Ag, [A], Ag1); -+agentsMedico(Ag1);
   -mybidMedico(Pos).

+!elegirmejorMedico(Posicion): posMedico(Bi) & agentsMedico(Ag)
  <-
  +buscaMedico;
  ?posMedico(Bi);
  ?agentsMedico(Ag);
  .print("Empiezo a buscar el Mejor Medico");

  while(long > 0){
      .print("Selecciono el mejor medico");
      .nth(0,Med,Pos);
      .nth(Pos,Si,S);
      if(S>=25){
        .print("Selecciono soldados");
        -seguir;
        .nth(Pos,Ag,A);
        .send(A,tell,acceptproposal);
        .mejordelete(Pos,Ag,Ag1);
        .send(Ag1,tell,cancelproposal);
      }
      .mejordelete(0,Med,B1);
      .length(Med,long);
    }
  .nth(0, Bi, Pos);
  .nth(0, Ag, A);

  .send(A, tell, acceptproposal);
  .delete(0, Ag, Ag1);
  .send(Ag1, tell, cancelproposal);
  -+posMedico([]);
  -+agentsMedico([]).

+!elegirmejorMedico: not (posMedico(Bi))
  <-print("Ningun Medico me puede ayudar");
  -pedidaayuda.


////////////////////////////////////////////////////////