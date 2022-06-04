(* ::Package:: *)

(* ::Section::Bold:: *)
(*Package Description*)


(* ::Input::Bold:: *)
(*(*Mathematica Package*)*)
(**)
(*BeginPackage["cartPendulum`"]*)
(**)
(*(*Exported symbols added here with SymbolName::usage*)*)
(**)
(*ffCartPendulum::usage = "*)
(*ffCartPendulum[ICs_,n_,\[Tau]_,\[Tau]1_,A_]*)
(*Computes the feedforward state and costate trajectories for swinging up the pendulum optimally*)
(*{xff,xdotff,\[Theta]ff,\[Theta]dotff,uff}*)
(*";*)
(**)
(*testSwingUp::usage = "*)
(*testSwingUp[ICs_,\[Tau]_,\[Tau]1_,uff0_,A_]*)
(*Test the approximate solution on the open-loop dynamics*)
(*{xs,\[Theta]s,xdots,\[Theta]dots}*)
(*";*)
(**)
(*TestSwingUpGeneralFB::usage = "*)
(*TestSwingUpGeneralFB[ICs_,\[Tau]_,\[Tau]1_,xff0_,xdotff0_,\[Theta]ff0_,\[Theta]dotff0_,uff0_,A_]*)
(*Add Linear feedback only at the end *)
(*{xs,\[Theta]s,us}*)
(*";*)
(**)
(*CalculateGains::usage = "*)
(*CalculateGains[xff0_,xdotff0_,\[Theta]ff0_,\[Theta]dotff0_,uff0_,A_]*)
(*Calculate the gain matrix by solving the quasi stationary Ricatti Equation*)
(*K*)
(*";*)
(**)
(*TestSwingUpGeneralFBNumeric::usage = "*)
(*TestSwingUpGeneralFBNumeric[ICs_,\[Tau]_,\[Tau]1_,xff0_,xdotff0_,\[Theta]ff0_,\[Theta]dotff0_,uff0_,A_,KTable_,n_]*)
(*Simulates the true dynamics with feedback added according to Ktable*)
(*{xs,\[Theta]s,us,K1,K2,K3,K4}*)
(*";*)
(**)
(*simulateLinearFeedbackEnd::usage = "*)
(*simulateLinearFeedbackEnd[ICs_,n_,\[Tau]_,\[Tau]1_,A_]*)
(*Outputs plots directly using TestSwingUpGeneralFB*)
(*Grid[{{p1a,p1b,p1c}}]*)
(*";*)
(**)
(*simulateLQRFeedback::usage = "*)
(*simulateLQRFeedback[ICs_,n_,n2_,\[Tau]_,\[Tau]1_,A_]*)
(*Outputs plots directly using TestSwingUpGeneralFBNumeric*)
(*Grid[{{p1a,p1b,p1c}}]*)
(*";*)
(**)
(**)
(**)
(**)
(**)
(*(*Begin Private Context*)*)
(*Begin["`Private`"]*)
(**)
(*(*ICs - Initial Conditions *)*)
(*ffCartPendulum[ICs_,n_,\[Tau]_,\[Tau]1_,A_,order_]:=Module[{x,xdot,f,\[Theta],\[Theta]dot,\[Lambda]1,\[Lambda]2,\[Lambda]3,\[Lambda]4,\[CapitalDelta]t,bcs,eqns,sv,froot,xff,xdotff,xff0,xdotff0,\[Theta]ff0,\[Theta]dotff0,uff0,\[Theta]ff,\[Theta]dotff,uff},\[CapitalDelta]t=\[Tau]/n;*)
(*f[{x_,xdot_,\[Theta]_,\[Theta]dot_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_}]:={xdot,1/(1-A Cos[\[Theta]]^2) (A \[Theta]dot^2 Sin[\[Theta]]+1/(1-A Cos[\[Theta]]^2) (\[Lambda]4 Cos[\[Theta]]-\[Lambda]2)+A Cos[\[Theta]] Sin[\[Theta]]),\[Theta]dot,1/(1-A Cos[\[Theta]]^2) (-(1/(1-A Cos[\[Theta]]^2))(-\[Lambda]2 Cos[\[Theta]]+\[Lambda]4 Cos[\[Theta]]^2)-Sin[\[Theta]]-A \[Theta]dot^2 Cos[\[Theta]] Sin[\[Theta]]),0,-\[Lambda]1,2/(A Cos[2 \[Theta]]+A-2)^3 (Cos[\[Theta]] (4 Sin[\[Theta]] (A \[Lambda]4^2 Cos[2 \[Theta]]+4 A \[Lambda]2^2+(A+2) \[Lambda]4^2)-(A Cos[2 \[Theta]]-3 A+2) (A Cos[2 \[Theta]]+A-2) (A \[Theta]dot^2 \[Lambda]2-\[Lambda]4))+A ((A-2) Cos[2 \[Theta]]+A) (A Cos[2 \[Theta]]+A-2) (\[Lambda]2-\[Theta]dot^2 \[Lambda]4)-4 \[Lambda]2 \[Lambda]4 Sin[\[Theta]] (3 A Cos[2 \[Theta]]+3 A+2)),4 /(A Cos[2 \[Theta]]+A-2) (A \[Theta]dot Sin[\[Theta]] (\[Lambda]2-\[Lambda]4 Cos[\[Theta]]))-\[Lambda]3};*)
(*bcs={Subscript[x, 0]==ICs[[1]],Subscript[xdot, 0]==ICs[[2]],Subscript[x, n]==Subscript[xdot, n]==0,Subscript[\[Theta], 0]==ICs[[3]],Subscript[\[Theta]dot, 0]==ICs[[4]],Subscript[\[Theta]dot, n]==0,Subscript[\[Theta], n]==\[Pi]};eqns=Flatten[Join[bcs,Table[Thread[{Subscript[x, i],Subscript[xdot, i],Subscript[\[Theta], i],Subscript[\[Theta]dot, i],Subscript[\[Lambda]1, i],Subscript[\[Lambda]2, i],Subscript[\[Lambda]3, i],Subscript[\[Lambda]4, i]}==1/2 \[CapitalDelta]t (f[{Subscript[x, i-1],Subscript[xdot, i-1],Subscript[\[Theta], i-1],Subscript[\[Theta]dot, i-1],Subscript[\[Lambda]1, i-1],Subscript[\[Lambda]2, i-1],Subscript[\[Lambda]3, i-1],Subscript[\[Lambda]4, i-1]}]+f[{Subscript[x, i],Subscript[xdot, i],Subscript[\[Theta], i],Subscript[\[Theta]dot, i],Subscript[\[Lambda]1, i],Subscript[\[Lambda]2, i],Subscript[\[Lambda]3, i],Subscript[\[Lambda]4, i]}])+{Subscript[x, i-1],Subscript[xdot, i-1],Subscript[\[Theta], i-1],Subscript[\[Theta]dot, i-1],Subscript[\[Lambda]1, i-1],Subscript[\[Lambda]2, i-1],Subscript[\[Lambda]3, i-1],Subscript[\[Lambda]4, i-1]}],{i,1,n}]]];sv=Flatten[Table[{{Subscript[x, i],ICs[[1]]},{Subscript[xdot, i],ICs[[2]]},{Subscript[\[Theta], i],ICs[[3]]},{Subscript[\[Theta]dot, i],ICs[[4]]},{Subscript[\[Lambda]1, i],0},{Subscript[\[Lambda]2, i],0},{Subscript[\[Lambda]3, i],0},{Subscript[\[Lambda]4, i],0}},{i,0,n}],1];froot=FindRoot[eqns,sv];*)
(*xff0=ListInterpolation[Table[Subscript[x, i],{i,0,n}]/. froot,{0,\[Tau]},InterpolationOrder->order];*)
(*xdotff0=ListInterpolation[Table[Subscript[xdot, i],{i,0,n}]/. froot,{0,\[Tau]},InterpolationOrder->order];\[Theta]ff0=ListInterpolation[Table[Subscript[\[Theta], i],{i,0,n}]/. froot,{0,\[Tau]},InterpolationOrder->order];\[Theta]dotff0=ListInterpolation[Table[Subscript[\[Theta]dot, i],{i,0,n}]/. froot,{0,\[Tau]},InterpolationOrder->order];uff0=ListInterpolation[Table[1/(1-A Cos[Subscript[\[Theta], i]]^2) (Subscript[\[Lambda]4, i]Cos[Subscript[\[Theta], i]]-Subscript[\[Lambda]2, i]),{i,0,n}]/. froot,{0,\[Tau]},InterpolationOrder->order];*)
(**)
(*xff[t_]:=Piecewise[{{xff0[t],0<=t<=\[Tau]}},0];*)
(*xdotff[t_]:=Piecewise[{{xdotff0[t],0<=t<=\[Tau]}},0];*)
(*\[Theta]ff[t_]:=Piecewise[{{\[Theta]ff0[t],0<=t<=\[Tau]}},\[Pi]];*)
(*\[Theta]dotff[t_]:=Piecewise[{{\[Theta]dotff0[t],0<=t<=\[Tau]}},0];*)
(*uff[t_]:=Piecewise[{{uff0[t],0<=t<=\[Tau]}},0];*)
(**)
(*{xff,xdotff,\[Theta]ff,\[Theta]dotff,uff}]*)
(**)
(*testSwingUp[ICs_,\[Tau]_,\[Tau]1_,uff0_,A_]:=Module[{eq,init,x,xdot,\[Theta],\[Theta]dot,xs,xdots,\[Theta]s,\[Theta]dots,t,J},*)
(*eq={x'[t]==xdot[t],xdot'[t]==1/(1-A Cos[\[Theta][t]]^2) (uff0[t]+A \[Theta]dot[t]^2 Sin[\[Theta][t]]+A Cos[\[Theta][t]] Sin[\[Theta][t]]),\[Theta]'[t]==\[Theta]dot[t],\[Theta]dot'[t]==1/(1-A Cos[\[Theta][t]]^2) (-Sin[\[Theta][t]]-Cos[\[Theta][t]] (uff0[t]+A \[Theta]dot[t]^2 Sin[\[Theta][t]]))};*)
(*init={x[0]==ICs[[1]],xdot[0]==ICs[[2]],\[Theta][0]==ICs[[3]],\[Theta]dot[0]==ICs[[4]]};*)
(*{xs,xdots,\[Theta]s,\[Theta]dots}=NDSolveValue[{eq,init},{x,xdot,\[Theta],\[Theta]dot},{t,0,\[Tau]1},Method->{"DiscontinuityProcessing"->None}];*)
(*J = NIntegrate[uff0[t]^2,{t,0,\[Tau]}];*)
(*{xs,xdots,\[Theta]s,\[Theta]dots,uff0,J}]*)
(**)
(*TestSwingUpGeneralFB[ICs_,\[Tau]_,\[Tau]1_,xff0_,xdotff0_,\[Theta]ff0_,\[Theta]dotff0_,uff0_,A_]:=Module[{eq,init,\[Theta],\[Theta]dot,\[Theta]ff,\[Theta]dotff,x,xdot,xff,xdotff,uff,t,\[Kappa]1,\[Kappa]2,\[Kappa]3,\[Kappa]4,ufb,u,\[Theta]s,\[Theta]dots,xs,xdots,us,J},*)
(*\[Kappa]1=\[Kappa]2=3;  (* lqr for q=r for balancing pendulum *)*)
(*\[Kappa]3 = -0.1;\[Kappa]4 = -0.65;*)
(*xff[t_]:=Piecewise[{{xff0[t],0<=t<=\[Tau]}},0];*)
(*xdotff[t_]:=Piecewise[{{xdotff0[t],0<=t<=\[Tau]}},0];*)
(*\[Theta]ff[t_]:=Piecewise[{{\[Theta]ff0[t],0<=t<=\[Tau]}},\[Pi]];*)
(*\[Theta]dotff[t_]:=Piecewise[{{\[Theta]dotff0[t],0<=t<=\[Tau]}},0];*)
(*uff[t_]:=Piecewise[{{uff0[t],0<=t<=\[Tau]}},0];*)
(*ufb[t_] := Piecewise[{{0,0<=t<=\[Tau]}},\[Kappa]1(\[Theta]ff[t]-\[Theta][t])+\[Kappa]2 (\[Theta]dotff[t]-\[Theta]dot[t])+\[Kappa]3(xff[t]-x[t])+\[Kappa]4 (xdotff[t]-xdot[t])];*)
(*u[t_]:=uff[t]+ufb[t];*)
(*eq={x'[t]==xdot[t],xdot'[t]==1/(1-A Cos[\[Theta][t]]^2) (u[t]+A \[Theta]dot[t]^2 Sin[\[Theta][t]]+A Cos[\[Theta][t]] Sin[\[Theta][t]]),\[Theta]'[t]==\[Theta]dot[t],\[Theta]dot'[t]==1/(1-A Cos[\[Theta][t]]^2) (-Sin[\[Theta][t]]-Cos[\[Theta][t]] (u[t]+A \[Theta]dot[t]^2 Sin[\[Theta][t]]))};*)
(*init={x[0]==ICs[[1]],xdot[0]==ICs[[2]],\[Theta][0]==ICs[[3]],\[Theta]dot[0]==ICs[[4]]};*)
(*{xs,xdots,\[Theta]s,\[Theta]dots}=NDSolveValue[{eq,init},{x,xdot,\[Theta],\[Theta]dot},{t,0,\[Tau]1},Method->{"DiscontinuityProcessing"->None}];*)
(*us[t_]:=uff[t]+Piecewise[{{0,0<=t<=\[Tau]}},\[Kappa]1(\[Theta]ff[t]-\[Theta]s[t])+\[Kappa]2 (\[Theta]dotff[t]-\[Theta]dots[t])+\[Kappa]3(xff[t]-xs[t])+\[Kappa]4 (xdotff[t]-xdots[t])];*)
(*J = NIntegrate[us[t]^2,{t,0,\[Tau]}];*)
(*{xs,xdots,\[Theta]s,\[Theta]dots,us,J}]*)
(**)
(*CalculateGains[xff0_,xdotff0_,\[Theta]ff0_,\[Theta]dotff0_,uff0_,A_]:=Module[{x,L,RHS,xdot,\[Theta],\[Theta]dot,u,K,S,soltn,i,j,s11,s12,s13,s14,s22,s23,s24,s33,s34,s44,Af,Bf,Q,fx,xState,ric,R,Mf,x2dot,\[Theta]2dot},*)
(*xState = {x,xdot,\[Theta],\[Theta]dot};*)
(*x2dot = 1/(1-A Cos[\[Theta]]^2) (u+A \[Theta]dot^2 Sin[\[Theta]]+A Cos[\[Theta]] Sin[\[Theta]]);*)
(*\[Theta]2dot= 1/(1-A Cos[\[Theta]]^2) (-Sin[\[Theta]]-Cos[\[Theta]] (u+A \[Theta]dot^2 Sin[\[Theta]]));*)
(*fx = {xdot,x2dot,\[Theta]dot,\[Theta]2dot};*)
(*L = 1/2*u^2;*)
(*Af = Grad[fx,xState]; (* For nD stuff use Grad*)*)
(*Bf = D[fx,u] ;(*For 1D stuff use D*)*)
(*Q = Grad[Grad[L,xState],xState];*)
(*Mf = Grad[D[L,u],xState];*)
(*R = D[L,{u,2}];*)
(*S = ({*)
(* {s11, s12, s13, s14},*)
(* {s12, s22, s23, s24},*)
(* {s13, s23, s33, s34},*)
(* {s14, s24, s34, s44}*)
(*});*)
(*ric =Q +  Af\[Transpose] . S +S . Af -Outer[Times,S . Bf,Bf\[Transpose] . S ] ; (* This is the Syntax for calculating Outer Products *)(*Q = I, M = 0, R = 1*)*)
(*RHS = Table[0,{i,4},{j,4}];*)
(*x = xff0;xdot = xdotff0;\[Theta] =\[Theta]ff0;\[Theta]dot = \[Theta]dotff0;u = uff0; (* Entering State Values *)*)
(*soltn = NMinimize[{1,ric == RHS},{s11,s12,s13,s14,s22,s23,s24,s33,s34,s44}][[2]];*)
(*S = S/.soltn;*)
(*K = Bf\[Transpose] . S ;*)
(*K]*)
(**)
(*TestSwingUpGeneralFBNumeric[ICs_,\[Tau]_,\[Tau]1_,xff0_,xdotff0_,\[Theta]ff0_,\[Theta]dotff0_,uff0_,A_,KTable_,n_]:=Module[{K1,K2,K3,K4,eq,init,\[Theta],\[Theta]dot,\[Theta]ff,\[Theta]dotff,x,xdot,xff,xdotff,uff,t,ufb,u,\[Theta]s,\[Theta]dots,xs,xdots,us,\[Kappa]1,\[Kappa]2,\[Kappa]3,\[Kappa]4,J},*)
(*\[Kappa]1=\[Kappa]2=3;  (* lqr for q=r for balancing pendulum *)*)
(*\[Kappa]3 = -0.1;\[Kappa]4 = -0.65;*)
(*K1[t_]:=Piecewise[Table[{KTable[[i]][[1]],(i-1)*\[Tau]/n <= t <= i*\[Tau]/n},{i,1,n}],KTable[[n]][[1]]];K2[t_]:=Piecewise[Table[{KTable[[i]][[2]],(i-1)*\[Tau]/n <= t <= i*\[Tau]/n},{i,1,n}],KTable[[n]][[2]]];K3[t_]:=Piecewise[Table[{KTable[[i]][[3]],(i-1)*\[Tau]/n <= t <= i*\[Tau]/n},{i,1,n}],KTable[[n]][[3]]];K4[t_]:=Piecewise[Table[{KTable[[i]][[4]],(i-1)*\[Tau]/n <= t <= i*\[Tau]/n},{i,1,n}],KTable[[n]][[4]]];*)
(*xff[t_]:=Piecewise[{{xff0[t],0<=t<=\[Tau]}},0];*)
(*xdotff[t_]:=Piecewise[{{xdotff0[t],0<=t<=\[Tau]}},0];*)
(*\[Theta]ff[t_]:=Piecewise[{{\[Theta]ff0[t],0<=t<=\[Tau]}},\[Pi]];*)
(*\[Theta]dotff[t_]:=Piecewise[{{\[Theta]dotff0[t],0<=t<=\[Tau]}},0];*)
(*uff[t_]:=Piecewise[{{uff0[t],0<=t<=\[Tau]}},0];*)
(*ufb[t_]:=Piecewise[{{K3[t]*(\[Theta]ff[t]-\[Theta][t])+K4[t] *(\[Theta]dotff[t]-\[Theta]dot[t])+K1[t]*(xff[t]-x[t])+K2[t] * (xdotff[t]-xdot[t]),0<=t<=\[Tau]}},\[Kappa]1(\[Theta]ff[t]-\[Theta][t])+\[Kappa]2 (\[Theta]dotff[t]-\[Theta]dot[t])+\[Kappa]3(xff[t]-x[t])+\[Kappa]4 (xdotff[t]-xdot[t])];*)
(*u[t_]:=uff[t]+ufb[t];*)
(*eq={x'[t]==xdot[t],xdot'[t]==1/(1-A Cos[\[Theta][t]]^2) (u[t]+A \[Theta]dot[t]^2 Sin[\[Theta][t]]+A Cos[\[Theta][t]] Sin[\[Theta][t]]),\[Theta]'[t]==\[Theta]dot[t],\[Theta]dot'[t]==1/(1-A Cos[\[Theta][t]]^2) (-Sin[\[Theta][t]]-Cos[\[Theta][t]] (u[t]+A \[Theta]dot[t]^2 Sin[\[Theta][t]]))};*)
(*init={x[0]==ICs[[1]],xdot[0]==ICs[[2]],\[Theta][0]==ICs[[3]],\[Theta]dot[0]==ICs[[4]]};*)
(*{xs,xdots,\[Theta]s,\[Theta]dots}=NDSolveValue[{eq,init},{x,xdot,\[Theta],\[Theta]dot},{t,0,\[Tau]1},Method->{"DiscontinuityProcessing"->None}];*)
(*us[t_]:=uff[t]+Piecewise[{{K3[t]*(\[Theta]ff[t]-\[Theta]s[t])+K4[t] *(\[Theta]dotff[t]-\[Theta]dots[t])+K1[t]*(xff[t]-xs[t])+K2[t] * (xdotff[t]-xdots[t]),0<=t<=\[Tau]}},\[Kappa]1(\[Theta]ff[t]-\[Theta]s[t])+\[Kappa]2 (\[Theta]dotff[t]-\[Theta]dots[t])+\[Kappa]3(xff[t]-xs[t])+\[Kappa]4 (xdotff[t]-xdots[t])];J = NIntegrate[us[t]^2,{t,0,\[Tau]}];*)
(*{xs,xdots,\[Theta]s,\[Theta]dots,us,K1,K2,K3,K4,J}]*)
(**)
(*simulateLinearFeedbackEnd[ICs_,n_,\[Tau]_,\[Tau]1_,A_]:= Module[{x1a,xdot1a,\[Theta]1a,\[Theta]dot1a,u1a,*)
(*	    x1b,xdot1b,\[Theta]1b,\[Theta]dot1b,u1b,*)
(*	    x1c,xdot1c,\[Theta]1c,\[Theta]dot1c,u1c,*)
(*	    p1a,p1b,p1c,J,J1},*)
(**)
(*{x1a,xdot1a,\[Theta]1a,\[Theta]dot1a,u1a}=ffCartPendulum[ICs,n,\[Tau],\[Tau]1,A];  *)
(*{x1b,xdot1b,\[Theta]1b,\[Theta]dot1b,u1b,J1}=testSwingUp[ICs,\[Tau],\[Tau]1,u1a,A]; *)
(*{x1c,xdot1c,\[Theta]1c,\[Theta]dot1c,u1c,J}=TestSwingUpGeneralFB[ICs,\[Tau],\[Tau]1,x1a,xdot1a,\[Theta]1a,\[Theta]dot1a,u1a,A];*)
(**)
(*p1a=Plot[{\[Theta]1a[t],u1a[t],x1a[t],\[Theta]dot1a[t],xdot1a[t]},{t,0,\[Tau]1},Filling->{2->Axis},PlotRange->{-4,4},PlotLegends->{"\[Theta]1a","u1a","x1a","\[Theta]dot1a","xdot1a"},PlotLabel->"Feedforward solution",AspectRatio->1/3,ImageSize->400,GridLines->{None,{-\[Pi],\[Pi]}}];*)
(**)
(*p1b=Plot[{\[Theta]1b[t],u1a[t],x1b[t],\[Theta]dot1b[t],xdot1b[t]},{t,0,\[Tau]1},PlotRange->{-4,4},Filling->{2->Axis},PlotLegends->{"\[Theta]1b","u1b","x1b","\[Theta]dot1b","xdot1b"},PlotLabel->"Test on dynamics",AspectRatio->1/3,ImageSize->400,GridLines->{None,{-\[Pi],\[Pi]}}];*)
(**)
(*p1c=Plot[{\[Theta]1c[t],u1c[t],x1c[t],\[Theta]dot1c[t],xdot1c[t]},{t,0,\[Tau]1},PlotRange->{-4,4},Filling->{2->Axis},PlotLegends->{"\[Theta]1c","u1c","x1c","\[Theta]dot1c","xdot1c"},PlotLabel->"Linear feedback solution",AspectRatio->1/3,ImageSize->400,GridLines->{None,{-\[Pi],\[Pi]}}];*)
(**)
(*{J1,J,p1a,p1b,p1c}]*)
(**)
(*simulateLQRFeedback[ICs_,n_,n2_,\[Tau]_,\[Tau]1_,A_]:= Module[{x1a,xdot1a,\[Theta]1a,\[Theta]dot1a,u1a,*)
(*	    x1b,xdot1b,\[Theta]1b,\[Theta]dot1b,u1b,*)
(*	    x1c,xdot1c,\[Theta]1c,\[Theta]dot1c,u1c,*)
(*	    p1a,p1b,p1c,KTable,K1,K2,K3,K4,J},*)
(**)
(*{x1a,xdot1a,\[Theta]1a,\[Theta]dot1a,u1a}=ffCartPendulum[ICs,n,\[Tau],\[Tau]1,A];*)
(*KTable = Table[CalculateGains[x1a[\[Tau]1/n2*i],xdot1a[\[Tau]1/n2*i],\[Theta]1a[\[Tau]1/n2*i],\[Theta]dot1a[\[Tau]1/n2*i],u1a[\[Tau]1/n2*i],A],{i,0,n2}]; *)
(*{x1b,xdot1b,\[Theta]1b,\[Theta]dot1b,u1b,_}=testSwingUp[ICs,\[Tau],\[Tau]1,u1a,A]; *)
(*{x1c,xdot1c,\[Theta]1c,\[Theta]dot1c,u1c,K1,K2,K3,K4,J}=TestSwingUpGeneralFBNumeric[ICs,\[Tau],\[Tau]1,x1a,xdot1a,\[Theta]1a,\[Theta]dot1a,u1a,A,KTable,n2];*)
(**)
(*p1a=Plot[{\[Theta]1a[t],u1a[t],x1a[t],\[Theta]dot1a[t],xdot1a[t]},{t,0,\[Tau]1},Filling->{2->Axis},PlotRange->{-4,4},PlotLegends->{"\[Theta]1a","u1a","x1a","\[Theta]dot1a","xdot1a"},PlotLabel->"Feedforward solution",AspectRatio->1/3,ImageSize->400,GridLines->{None,{-\[Pi],\[Pi]}}];*)
(**)
(*p1b=Plot[{\[Theta]1b[t],u1a[t],x1b[t],\[Theta]dot1b[t],xdot1b[t]},{t,0,\[Tau]1},PlotRange->{-4,4},Filling->{2->Axis},PlotLegends->{"\[Theta]1b","u1b","x1b","\[Theta]dot1b","xdot1b"},PlotLabel->"Test on dynamics",AspectRatio->1/3,ImageSize->400,GridLines->{None,{-\[Pi],\[Pi]}}];*)
(**)
(*p1c=Plot[{\[Theta]1c[t],u1c[t],x1c[t],\[Theta]dot1c[t],xdot1c[t]},{t,0,\[Tau]1},PlotRange->{-4,4},Filling->{2->Axis},PlotLegends->{"\[Theta]1c","u1c","x1c","\[Theta]dot1c","xdot1c"},PlotLabel->"LQR feedback solution",AspectRatio->1/3,ImageSize->400,GridLines->{None,{-\[Pi],\[Pi]}}];*)
(**)
(*{J,p1a,p1b,p1c}]*)
(**)
(**)
(*EndPackage[]*)


(* ::CodeText::Bold:: *)
(*Testing Functions*)


(* ::CodeText::Bold:: *)
(*n = 10; \[Tau] = 5; \[Tau]1 = \[Tau]*1.25 ; A = 0.2; *)
(*ICs = {0.89486028245609, -0.9468360111172656, -0.002994757534002989, 1.677668990900959}; *)
(*(*ICs = {0,0,0,0};*)*)
(*{J1, J, p1a, p1b, p1c} = simulateLinearFeedbackEnd[ICs, n, \[Tau], \[Tau]1, A];*)
(*Grid[{{p1a, p1b, p1c}}]*)
(*J1*)
(*J*)


(* ::CodeText::Bold:: *)
(*n = 5; \[Tau] = 5; \[Tau]1 = \[Tau]*1.25 ; n2 = 20;*)
(*A = 0.2; ICs = {0.89486028245609, -0.9468360111172656, -0.002994757534002989, 1.677668990900959};*)
(*{J, p1a, p1b, p1c} = simulateLQRFeedback[ICs, n, n2, \[Tau], \[Tau]1, A];*)
(*Grid[{{p1a, p1b, p1c}}]*)
(*J*)


(* ::CodeText:: *)
(*(* Repeated Computations function*) (*No feedback *)*)
(*n = 5; \[Tau] = 5; \[Tau]1 = \[Tau]*1.25 ; n2 = 20; M = 2;*)
(*A = 0.2; initialConditions = {0, 0, 0, 0};*)
(*MyAppend[f1_, f2_, T1_, dT_] := Module[{f},*)
(*  f[t_] := Piecewise[{{f1[t], 0 <= t <= T1}, {f2[t - T1], T1 <= t <= T1 + dT}}];*)
(*  f]*)
(**)
(*ICs = initialConditions;*)
(*xs[t_] := 0;*)
(*xdots[t_] := 0;*)
(*\[Theta]s[t_] := 0;*)
(*\[Theta]dots[t_] := 0;*)
(*Js = 0;*)
(*For[i = 0, i < M, i++,*)
(* 	{x1a, xdot1a, \[Theta]1a, \[Theta]dot1a, u1a} = ffCartPendulum[ICs, n, \[Tau]*(1 - i/M), \[Tau]1, A];  *)
(* 	Plot[{\[Theta]1a[t], u1a[t], x1a[t], \[Theta]dot1a[t], xdot1a[t]}, {t, 0, \[Tau]*(1 - i/M)}, PlotRange -> {-4, 4}, Filling -> {2 -> Axis}, PlotLegends -> {"\[Theta]1b", "u1b", "x1b", "\[Theta]dot1b", "xdot1b"}, PlotLabel -> "Intermediate Plots", AspectRatio -> 1/3, ImageSize -> 400, GridLines -> {None, {-\[Pi], \[Pi]}}]*)
(*   *)
(*   	If[i != M - 1,*)
(*    	(*If condition is true*)*)
(*    		{x1b, xdot1b, \[Theta]1b, \[Theta]dot1b, u1b, J} = testSwingUp[ICs, \[Tau]*1/M, \[Tau]*1/M, u1a, A]; *)
(*    		ICs = {x1b[\[Tau]*1/M], xdot1b[\[Tau]*1/M], \[Theta]1b[\[Tau]*1/M], \[Theta]dot1b[\[Tau]*1/M]};*)
(*    		xs = MyAppend[xs, x1b, \[Tau]*i/M, \[Tau]*1/M];*)
(*    		xdots = MyAppend[xdots, xdot1b, \[Tau]*i/M, \[Tau]*1/M];*)
(*    		\[Theta]s = MyAppend[\[Theta]s, \[Theta]1b, \[Tau]*i/M, \[Tau]*1/M];*)
(*    		\[Theta]dots = MyAppend[\[Theta]dots, \[Theta]dot1b, \[Tau]*i/M, \[Tau]*1/M];*)
(*    		us = MyAppend[us, u1b, \[Tau]*i/M, \[Tau]*1/M];*)
(*    		Js = Js + J;*)
(*    	,*)
(*    	(*If condition is false*)*)
(*    		{x1b, xdot1b, \[Theta]1b, \[Theta]dot1b, u1b, J} = testSwingUp[ICs, \[Tau]*1/M, \[Tau]*1/M + \[Tau]1 - \[Tau], u1a, A]; *)
(*    		xs = MyAppend[xs, x1b, \[Tau]*i/M, \[Tau]*1/M + \[Tau]1 - \[Tau]];*)
(*    		xdots = MyAppend[xdots, xdot1b, \[Tau]*i/M, \[Tau]*1/M + \[Tau]1 - \[Tau]];*)
(*    		\[Theta]s = MyAppend[\[Theta]s, \[Theta]1b, \[Tau]*i/M, \[Tau]*1/M + \[Tau]1 - \[Tau]];*)
(*    		\[Theta]dots = MyAppend[\[Theta]dots, \[Theta]dot1b, \[Tau]*i/M, \[Tau]*1/M + \[Tau]1 - \[Tau]];*)
(*    		us = MyAppend[us, u1b, \[Tau]*i/M, \[Tau]*1/M + \[Tau]1 - \[Tau]];*)
(*    	]	*)
(*  // Print]*)
(*p1b = Plot[{\[Theta]s[t], us[t], xs[t], \[Theta]dots[t], xdots[t]}, {t, 0, \[Tau]1}, PlotRange -> {-4, 4}, Filling -> {2 -> Axis}, PlotLegends -> {"\[Theta]1b", "u1b", "x1b", "\[Theta]dot1b", "xdot1b"}, PlotLabel -> "Test on dynamics", AspectRatio -> 1/3, ImageSize -> 400, GridLines -> {None, {-\[Pi], \[Pi]}}]*)
(*Js*)
(**)


(* ::CodeText:: *)
(*ICs*)
(*{x1a, xdot1a, \[Theta]1a, \[Theta]dot1a, u1a} = ffCartPendulum[ICs, n, \[Tau], \[Tau]1, A];  *)
(*Plot[{\[Theta]1a[t], u1a[t], x1a[t], \[Theta]dot1a[t], xdot1a[t]}, {t, 0, \[Tau]}, PlotRange -> {-4, 4}, Filling -> {2 -> Axis}, PlotLegends -> {"\[Theta]1b", "u1b", "x1b", "\[Theta]dot1b", "xdot1b"}, PlotLabel -> "Intermediate Plots", AspectRatio -> 1/3, ImageSize -> 400, GridLines -> {None, {-\[Pi], \[Pi]}}]*)
(**)


(* ::CodeText::Bold:: *)
(*n = 40; \[Tau] = 5; \[Tau]1 = \[Tau]*1.25 ; n2 = 20; M = 2;*)
(*A = 0.2;*)
(*ICs = {-0.04586643004043421, -1.5525579578695232, 0.7616256926010762, 1.9326806921803874};*)
(*{J1, J, p1a, p1b, p1c} = simulateLinearFeedbackEnd[ICs, n, \[Tau], \[Tau]1, A];*)
(*Grid[{{p1a, p1b, p1c}}]*)
(*J1*)
(*J*)
(**)
(**)
(**)
