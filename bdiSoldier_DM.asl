
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
		.shoot(3,Position);
	}.


+health(H): H >= 20 & medicHelp
	<-
	-medicHelp.

+ayudaMedica(pos): H < 20 
	<-
	.print("Medidco Ayuda!");
	+medicHelp;
	?myMedics(M);
	+medicPos(mp);
	+mediID(mid);
	.send(M, tell, ayudaMedica(pos)).

