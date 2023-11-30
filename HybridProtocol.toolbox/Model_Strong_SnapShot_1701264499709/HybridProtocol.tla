--------------------------- MODULE HybridProtocol ---------------------------
EXTENDS Naturals, FiniteSets

-----------------------------------------------------------------------------

Max(S) == IF S = {} THEN 0 ELSE CHOOSE i \in S : \A j \in S : j <= i


(*********************************************************************************)
(* Constant parameters:                                                          *)
(*       Commands: the set of all commands                                       *)
(*       Replicas: the set of all EPaxos replicas                                *)
(*       FastQuorums(r): the set of all fast quorums where r is a command leader *)
(*       SlowQuorums(r): the set of all slow quorums where r is a command leader *)
(*       Consistency_level: the set of consistency level of all commands         *)
(*********************************************************************************)

CONSTANTS Commands, Replicas, MaxBallot, Consistency_level, Ctx_id

 
 TwoElementSubsetsR(r) == {s \in SUBSET (Replicas \ {r}) : Cardinality(s) = 2}
 SlowQuorums(r) == {{r} \cup s : s \in TwoElementSubsetsR(r)}
 FastQuorums(r) == {{r} \cup s : s \in TwoElementSubsetsR(r)}

ASSUME IsFiniteSet(Replicas)

(***************************************************************************)
(* Quorum conditions:                                                      *)
(*  (simplified)                                                           *)
(***************************************************************************)

ASSUME \A r \in Replicas:
  /\ SlowQuorums(r) \subseteq SUBSET Replicas
  /\ \A SQ \in SlowQuorums(r): 
    /\ r \in SQ
    /\ Cardinality(SQ) = (Cardinality(Replicas) \div 2) + 1

ASSUME \A r \in Replicas:
  /\ FastQuorums(r) \subseteq SUBSET Replicas
  /\ \A FQ \in FastQuorums(r):
    /\ r \in FQ
    /\ Cardinality(FQ) = (Cardinality(Replicas) \div 2) + 
                         ((Cardinality(Replicas) \div 2) + 1) \div 2
    
    
(***************************************************************************)
(* Special none command                                                    *)
(***************************************************************************)

none == CHOOSE c : c \notin Commands


(***************************************************************************)
(* The instance space                                                      *)
(***************************************************************************)

Instances == Replicas \X (1..Cardinality(Commands))

(***************************************************************************)
(* The possible status of a command in the log of a replica.               *)
(***************************************************************************)

Status == {"not-seen", "pre-accepted", "accepted", "causally-committed", "strongly-comitted"}
State == {"ready", "waiting", "done"}


(***************************************************************************)
(* All possible protocol messages:                                         *)
(***************************************************************************)

Message ==
        [type: {"pre-accept"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas,
        cmd: Commands \cup {none}, deps: SUBSET Instances, seq: Nat,   consistency: Consistency_level, ctxid: Ctx_id,clk: Nat]
  \cup  [type: {"accept"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas,
        cmd: Commands \cup {none}, deps: SUBSET Instances, seq: Nat, consistency: Consistency_level, ctxid: Ctx_id, clk: Nat]
  \cup  [type: {"commit"},
        inst: Instances, ballot: Nat \X Replicas,
        cmd: Commands \cup {none}, deps: SUBSET Instances, seq: Nat, consistency: Consistency_level, ctxid: Ctx_id, clk: Nat]
  \cup  [type: {"prepare"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas]
  \cup  [type: {"pre-accept-reply"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas,
        deps: SUBSET Instances, seq: Nat, committed: SUBSET Instances]
  \cup  [type: {"accept-reply"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas]
  \cup  [type: {"prepare-reply"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas, prev_ballot: Nat \X Replicas,
        status: Status,
        cmd: Commands \cup {none}, deps: SUBSET Instances, seq: Nat]
  \cup  [type: {"try-pre-accept"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas,
        cmd: Commands \cup {none}, deps: SUBSET Instances, seq: Nat]
  \cup  [type: {"try-pre-accept-reply"}, src: Replicas, dst: Replicas,
        inst: Instances, ballot: Nat \X Replicas, status: Status \cup {"OK"}]
        
        
 

(*******************************************************************************)
(* Variables:                                                                  *)
(*                                                                             *)
(*          comdLog = the commands log at each replica                         *)
(*          proposed = command that have been proposed                         *)
(*          executed = the log of executed commands at each replica            *)
(*          sentMsg = sent (but not yet received) messages                     *)
(*          crtInst = the next instance available for a command                *)
(*                    leader                                                   *)
(*          leaderOfInst = the set of instances each replica has               *)
(*                         started but not yet finalized                       *)
(*          committed = maps commands to set of commit attributs               *)
(*                      tuples                                                 *)
(*          ballots = largest ballot number used by any                        *)
(*                    replica                                                  *)
(*          preparing = set of instances that each replica is                  *)
(*                      currently preparing (i.e. recovering)                  *) 
(*                                                                             *)
(*                                                                             *)
(*******************************************************************************)

 
VARIABLES cmdLog, proposed, executed, sentMsg, crtInst, leaderOfInst,
          committed, ballots, preparing, clk

TypeOK ==
    /\ cmdLog \in [Replicas -> SUBSET [inst: Instances, 
                                       status: Status \cup {none},
                                       state: State \cup {none},
                                       ballot: Nat \X Replicas,
                                       cmd: Commands \cup {none},
                                       deps: SUBSET Instances,
                                       seq: Nat,
                                       consistency: Consistency_level \cup {none},
                                       ctxid: Ctx_id \cup {none}
                         
                                       ]]
    /\ proposed \in SUBSET Commands
    /\ executed \in [Replicas -> SUBSET (Nat \X Commands)]
    /\ sentMsg \in SUBSET Message
    /\ crtInst \in [Replicas -> Nat]
    /\ leaderOfInst \in [Replicas -> SUBSET Instances]
    /\ committed \in [Instances -> SUBSET ((Commands \cup {none}) \X
                                           (SUBSET Instances) \X 
                                           Nat)]
    /\ ballots \in Nat
    /\ preparing \in [Replicas -> SUBSET Instances]
    /\ clk \in [Replicas -> Nat]
    
vars == << cmdLog, proposed, executed, sentMsg, crtInst, leaderOfInst, 
           committed, ballots, preparing, clk >>

(***************************************************************************)
(* Initial state predicate                                                 *)
(***************************************************************************)

Init ==
  /\ sentMsg = {}
  /\ cmdLog = [r \in Replicas |-> {}]
  /\ proposed = {}
  /\ executed = [r \in Replicas |-> {}]
  /\ crtInst = [r \in Replicas |-> 1]
  /\ leaderOfInst = [r \in Replicas |-> {}]
  /\ committed = [i \in Instances |-> {}]
  /\ ballots = 1
  /\ preparing = [r \in Replicas |-> {}]
  /\ clk = [r \in Replicas |-> 1]



(***************************************************************************)
(* Actions                                                                 *)
(***************************************************************************)
RECURSIVE checkWaiting(_)
checkWaiting(cleader) == LET waitingRecs== {rec \in cmdLog[cleader]: rec.state = "waiting"} 
                         waitingInst=={rec.inst: rec \in waitingRecs} IN
                         IF Cardinality(waitingInst) = 0 THEN
                            "ready"
                         ELSE checkWaiting(cleader)
                            

StartPhase1(C, cleader, Q, inst, ballot, oldMsg, oldClk,cl,ctx) ==
    IF cl = "causal" THEN
        LET newDeps == {rec.inst: rec \in cmdLog[cleader]} 
            newSeq == 1 + Max({t.seq: t \in cmdLog[cleader]} \cup {oldClk}) 
            oldRecs == {rec \in cmdLog[cleader] : rec.inst = inst}
            waitingRecs== {rec \in cmdLog[cleader]: rec.state = "waiting"} 
            waitingInst=={rec.inst: rec \in waitingRecs} IN
            IF Cardinality(waitingInst) = 0 THEN
                /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ oldRecs) \cup 
                                        {[inst   |-> inst,
                                          status |-> "causally-committed",
                                          state |-> "done",
                                          ballot |-> ballot,
                                          cmd    |-> C,
                                          deps   |-> newDeps,
                                          seq    |-> newSeq,
                                          consistency |-> cl,
                                          ctxid |-> ctx ]}]
                /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \cup {inst}]
                /\ sentMsg' = (sentMsg \ oldMsg) \cup 
                                        [type  : {"commit"},
                                          src   : {cleader},
                                          dst   : Q \ {cleader},
                                          inst  : {inst},
                                          ballot: {ballot},
                                          cmd   : {C},
                                          deps  : {newDeps},
                                          seq   : {newSeq},
                                          consistency : {cl},
                                          ctxid : {ctx},
                                          clk : {oldClk}]
           ELSE
                 /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ oldRecs) \cup 
                                        {[inst   |-> inst,
                                          status |-> "accepted",
                                          state |-> "waiting",
                                          ballot |-> ballot,
                                          cmd    |-> C,
                                          deps   |-> newDeps,
                                          seq    |-> newSeq,
                                          consistency |-> cl,
                                          ctxid |-> ctx ]}]
                /\ LET newcmdstate == checkWaiting(cleader) IN
                     /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ oldRecs) \cup 
                        {[inst   |-> inst,
                          status |-> "causally-committed",
                          state |-> "done",
                          ballot |-> ballot,
                          cmd    |-> C,
                          deps   |-> newDeps,
                          seq    |-> newSeq,
                          consistency |-> cl,
                          ctxid |-> ctx ]}]
                    /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \cup {inst}]
                    /\ sentMsg' = (sentMsg \ oldMsg) \cup 
                                            [type  : {"commit"},
                                              src   : {cleader},
                                              dst   : Q \ {cleader},
                                              inst  : {inst},
                                              ballot: {ballot},
                                              cmd   : {C},
                                              deps  : {newDeps},
                                              seq   : {newSeq},
                                              consistency : {cl},
                                              ctxid : {ctx},
                                              clk : {oldClk}]
           
     ELSE
            LET newDeps == {rec.inst: rec \in cmdLog[cleader]} 
            newSeq == 1 + Max({t.seq: t \in cmdLog[cleader]} \cup {oldClk}) 
            oldRecs == {rec \in cmdLog[cleader] : rec.inst = inst} 
            waitingRecs== {rec \in cmdLog[cleader]: rec.state = "waiting"} 
            waitingInst=={rec.inst: rec \in waitingRecs} IN
            IF Cardinality(waitingInst) = 0 THEN
                /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ oldRecs) \cup 
                                        {[inst   |-> inst,
                                          status |-> "pre-accepted",
                                          state |-> "done",
                                          ballot |-> ballot,
                                          cmd    |-> C,
                                          deps   |-> newDeps,
                                          seq    |-> newSeq,
                                          consistency |-> cl,
                                          ctxid |-> ctx ]}]
                /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \cup {inst}]
                /\ sentMsg' = (sentMsg \ oldMsg) \cup 
                                        [type  : {"pre-accept"},
                                          src   : {cleader},
                                          dst   : Q \ {cleader},
                                          inst  : {inst},
                                          ballot: {ballot},
                                          cmd   : {C},
                                          deps  : {newDeps},
                                          seq   : {newSeq},
                                          consistency : {cl},
                                          ctxid : {ctx},
                                          clk : {oldClk}]
           ELSE
                 /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ oldRecs) \cup 
                                        {[inst   |-> inst,
                                          status |-> "pre-accepted",
                                          state |-> "waiting",
                                          ballot |-> ballot,
                                          cmd    |-> C,
                                          deps   |-> newDeps,
                                          seq    |-> newSeq,
                                          consistency |-> cl,
                                          ctxid |-> ctx ]}]
                /\ LET newcmdstate == checkWaiting(cleader) IN
                     /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ oldRecs) \cup 
                        {[inst   |-> inst,
                          status |-> "pre-accepted",
                          state |-> "done",
                          ballot |-> ballot,
                          cmd    |-> C,
                          deps   |-> newDeps,
                          seq    |-> newSeq,
                          consistency |-> cl,
                          ctxid |-> ctx ]}]
                    /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \cup {inst}]
                    /\ sentMsg' = (sentMsg \ oldMsg) \cup 
                                            [type  : {"pre-accept"},
                                              src   : {cleader},
                                              dst   : Q \ {cleader},
                                              inst  : {inst},
                                              ballot: {ballot},
                                              cmd   : {C},
                                              deps  : {newDeps},
                                              seq   : {newSeq},
                                              consistency : {cl},
                                              ctxid : {ctx},
                                              clk : {oldClk}]

Propose(C, cleader,cl,ctx) ==
    LET newInst == <<cleader, crtInst[cleader]>> 
        newBallot == <<0, cleader>> 
        newClk == [clk EXCEPT ![cleader] = @ + 1]
    IN  /\ proposed' = proposed \cup {C}
        /\ (\E Q \in FastQuorums(cleader):
                 StartPhase1(C, cleader, Q, newInst, newBallot, {},newClk[cleader],cl,ctx))
        /\ crtInst' = [crtInst EXCEPT ![cleader] = @ + 1]
        /\ clk' = newClk
        /\ UNCHANGED << executed, committed, ballots, preparing>>
        
        
Phase1Reply(replica) ==
    \E msg \in sentMsg:
        /\ msg.type = "pre-accept"
        /\ msg.dst = replica
        /\ LET oldRec == {rec \in cmdLog[replica]: rec.inst = msg.inst} IN
            /\ (\A rec \in oldRec : 
                (rec.ballot = msg.ballot \/rec.ballot[1] < msg.ballot[1]))
            /\ LET newDeps == msg.deps \cup 
                            ({t.inst: t \in cmdLog[replica]} \ {msg.inst})
                   newClk == 1 + Max({clk[replica]} \cup {msg.seq})
                   newSeq == Max({newClk, 
                                  1 + Max({t.seq: t \in cmdLog[replica]})})
                   instCom == {t.inst: t \in {tt \in cmdLog[replica] :
                              tt.status \in {"committed", "executed"}}}
                   
                    waitingRecs == {rec \in cmdLog[replica]: rec.state = "waiting"} 
                    waitingInst == {rec.inst: rec \in waitingRecs} IN
                    IF Cardinality(waitingInst) = 0 THEN
                        /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                                            {[inst   |-> msg.inst,
                                              status |-> "pre-accepted",
                                              state  |-> "done",
                                              ballot |-> msg.ballot,
                                              cmd    |-> msg.cmd,
                                              deps   |-> newDeps,
                                              seq    |-> newSeq,
                                              consistency |-> msg.consistency,
                                              ctxid |-> msg.ctxid ]}]
                        /\ sentMsg' = (sentMsg \ {msg}) \cup
                                            {[type  |-> "pre-accept-reply",
                                              src   |-> replica,
                                              dst   |-> msg.src,
                                              inst  |-> msg.inst,
                                              ballot|-> msg.ballot,
                                              deps  |-> newDeps,
                                              seq   |-> newSeq,
                                              committed|-> instCom,
                                              consistency |-> msg.consistency,
                                              ctxid |-> msg.ctxid,
                                              clk |-> newClk]}
                        /\ clk' = [clk EXCEPT ![replica] = newClk]
                        /\ UNCHANGED << proposed, crtInst, executed, leaderOfInst,
                                        committed, ballots, preparing >>
                    ELSE
                        /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                                            {[inst   |-> msg.inst,
                                              status |-> "pre-accepted",
                                              state  |-> "waiting",
                                              ballot |-> msg.ballot,
                                              cmd    |-> msg.cmd,
                                              deps   |-> newDeps,
                                              seq    |-> newSeq,
                                              consistency |-> msg.consistency,
                                              ctxid |-> msg.ctxid ]}]
                        /\ LET newcmdstate == checkWaiting(replica) IN
                            /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                                            {[inst   |-> msg.inst,
                                              status |-> "pre-accepted",
                                              state  |-> "done",
                                              ballot |-> msg.ballot,
                                              cmd    |-> msg.cmd,
                                              deps   |-> newDeps,
                                              seq    |-> newSeq,
                                              consistency |-> msg.consistency,
                                              ctxid |-> msg.ctxid ]}]
                        /\ sentMsg' = (sentMsg \ {msg}) \cup
                                            {[type  |-> "pre-accept-reply",
                                              src   |-> replica,
                                              dst   |-> msg.src,
                                              inst  |-> msg.inst,
                                              ballot|-> msg.ballot,
                                              deps  |-> newDeps,
                                              seq   |-> newSeq,
                                              committed|-> instCom,
                                              consistency |-> msg.consistency,
                                              ctxid |-> msg.ctxid,
                                              clk |-> newClk]}
                        /\ clk' = [clk EXCEPT ![replica] = newClk]
                        /\ UNCHANGED << proposed, crtInst, executed, leaderOfInst,
                                        committed, ballots, preparing >>
                            
                               
Commit(replica, cmsg) ==
    IF cmsg.consistency = "causal" THEN
        LET oldRec == {rec \in cmdLog[replica] : rec.inst = cmsg.inst}
            newClk == 1 + Max({clk[replica]} \cup {cmsg.clk})
            waitingRecs == {rec \in cmdLog[replica]: rec.state = "waiting"} 
            waitingInst == {rec.inst: rec \in waitingRecs} IN
            IF Cardinality(waitingInst) = 0 THEN
                /\ \A rec \in oldRec : (rec.status \notin {"causally-committed", "executed"} /\ 
                                        rec.ballot[1] <= cmsg.ballot[1])
                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                            {[inst     |-> cmsg.inst,
                                              status   |-> "causally-committed",
                                              state    |-> "done",
                                              ballot   |-> cmsg.ballot,
                                              cmd      |-> cmsg.cmd,
                                              deps     |-> cmsg.deps,
                                              seq      |-> cmsg.seq,
                                              consistency |-> cmsg.consistency,
                                              ctxid |-> cmsg.ctxid ]}]
                /\ committed' = [committed EXCEPT ![cmsg.inst] = @ \cup 
                                       {<<cmsg.cmd, cmsg.deps, cmsg.seq>>}]
                /\ clk' = [clk EXCEPT ![replica] = newClk]
                /\ UNCHANGED << proposed, executed, crtInst, leaderOfInst,
                                sentMsg, ballots, preparing>>      
            ELSE
                /\ \A rec \in oldRec : (rec.status \notin {"causally-committed", "executed"} /\ 
                                        rec.ballot[1] <= cmsg.ballot[1])
                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                            {[inst     |-> cmsg.inst,
                                              status   |-> "causally-committed",
                                              state    |-> "waiting",
                                              ballot   |-> cmsg.ballot,
                                              cmd      |-> cmsg.cmd,
                                              deps     |-> cmsg.deps,
                                              seq      |-> cmsg.seq,
                                              consistency |-> cmsg.consistency,
                                              ctxid |-> cmsg.ctxid ]}]
                /\ LET newcmdstate == checkWaiting(replica) IN
                    /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                                {[inst     |-> cmsg.inst,
                                                  status   |-> "causally-committed",
                                                  state    |-> "done",
                                                  ballot   |-> cmsg.ballot,
                                                  cmd      |-> cmsg.cmd,
                                                  deps     |-> cmsg.deps,
                                                  seq      |-> cmsg.seq,
                                                  consistency |-> cmsg.consistency,
                                                  ctxid |-> cmsg.ctxid ]}]
                    /\ committed' = [committed EXCEPT ![cmsg.inst] = @ \cup 
                                           {<<cmsg.cmd, cmsg.deps, cmsg.seq>>}]
                    /\ clk' = [clk EXCEPT ![replica] = newClk]
                    /\ UNCHANGED << proposed, executed, crtInst, leaderOfInst,
                                    sentMsg, ballots, preparing>> 
    ELSE
        TRUE                     
 


(***************************************************************************)
(* Action groups                                                           *)
(***************************************************************************)        

CommandLeaderAction ==
    \/ (\E C \in (Commands \ proposed) :
            \E cl \in Consistency_level: 
                \E ctx \in Ctx_id:
                    \E cleader \in Replicas : Propose(C, cleader,cl,ctx))
   
            
ReplicaAction ==
    \E replica \in Replicas :
        (\/ Phase1Reply(replica)
         \/ \E cmsg \in sentMsg : (cmsg.type = "commit" /\ Commit(replica, cmsg))
        )


(***************************************************************************)
(* Next action                                                             *)
(***************************************************************************)

Next == 
    \/ CommandLeaderAction
    \/ ReplicaAction


(***************************************************************************)
(* The complete definition of the algorithm                                *)
(***************************************************************************)

Spec == Init /\ [][Next]_vars


(***************************************************************************)
(* Theorems                                                                *)
(***************************************************************************)

Nontriviality ==
    \A i \in Instances :
        [](\A C \in committed[i] : C \in proposed \/ C = none)

Stability ==
    \A replica \in Replicas :
        \A i \in Instances :
            \A C \in Commands :
                []((\E rec1 \in cmdLog[replica] :
                    /\ rec1.inst = i
                    /\ rec1.cmd = C
                    /\ rec1.status \in {"committed", "executed"}) =>
                    [](\E rec2 \in cmdLog[replica] :
                        /\ rec2.inst = i
                        /\ rec2.cmd = C
                        /\ rec2.status \in {"committed", "executed"}))

Consistency ==
    \A i \in Instances :
        [](Cardinality(committed[i]) <= 1)

THEOREM Spec => ([]TypeOK) /\ Nontriviality /\ Stability /\ Consistency
                                                  
    
=============================================================================
\* Modification History
\* Last modified Wed Nov 29 08:27:22 EST 2023 by santamariashithil
\* Created Wed Nov 22 12:14:45 EST 2023 by santamariashithil
