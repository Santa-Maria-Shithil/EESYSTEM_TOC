------------------------- MODULE HybridProtocol_TLA -------------------------
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
        deps: SUBSET Instances, seq: Nat, committed: SUBSET Instances, consistency: Consistency_level, ctxid: Ctx_id, clk: Nat]
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
(* Helper Functions                                                        *)
(***************************************************************************)

RECURSIVE checkWaiting(_)
checkWaiting(cleader) == LET waitingRecs== {rec \in cmdLog[cleader]: rec.state = "waiting"} 
                         waitingInst=={rec.inst: rec \in waitingRecs} IN
                         IF Cardinality(waitingInst) = 0 THEN
                            "ready"
                         ELSE checkWaiting(cleader)
                         
FindingWaitingInst(finalDeps) ==
    LET waitingRecs(deps) == {rec \in cmdLog[deps]: rec.state = "waiting"}
        waitingInst(deps) == {rec.inst: rec \in waitingRecs(deps)}
        allWaitingInst == UNION({waitingInst(deps): deps \in finalDeps})
    IN
        allWaitingInst


(***************************************************************************)
(* Actions                                                                 *)
(***************************************************************************)

StartPhase1Causal(C, cleader, Q, inst, ballot, oldMsg, oldClk,cl,ctx) ==
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
                                              
                                              
                                              
StartPhase1Strong(C, cleader, Q, inst, ballot, oldMsg, oldClk,cl,ctx) ==
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


StartPhase1(C, cleader, Q, inst, ballot, oldMsg, oldClk,cl,ctx) ==
    IF cl = "causal" THEN
        StartPhase1Causal(C, cleader, Q, inst, ballot, oldMsg, oldClk,cl,ctx)
           
     ELSE
         StartPhase1Strong(C, cleader, Q, inst, ballot, oldMsg, oldClk,cl,ctx)
         
           
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
                (rec.ballot = msg.ballot \/ rec.ballot[1] < msg.ballot[1]))
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
                
                
                            
Phase1Fast(cleader, i, Q) ==
    /\ i \in leaderOfInst[cleader]
    /\ Q \in FastQuorums(cleader)
    /\ \E record \in cmdLog[cleader]:
        /\ record.inst = i
        /\ record.status = "pre-accepted"
        /\ record.ballot[1] = 0
        /\ LET replies == {msg \in sentMsg: 
                                /\ msg.inst = i
                                /\ msg.type = "pre-accept-reply"
                                /\ msg.dst = cleader
                                /\ msg.src \in Q
                                /\ msg.ballot = record.ballot} IN
            /\ (\A replica \in (Q \ {cleader}): 
                    \E msg \in replies: msg.src = replica)
            /\ (\A r1, r2 \in replies:
                /\ r1.deps = r2.deps
                /\ r1.seq = r2.seq)
            /\ LET r == CHOOSE r \in replies : TRUE IN
                /\ LET localCom == {t.inst: 
                            t \in {tt \in cmdLog[cleader] : 
                                 tt.status \in {"strongly-comitted", "executed"}}}
                       extCom == UNION {msg.committed: msg \in replies} IN
                       (r.deps \subseteq (localCom \cup extCom))    
                /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {record}) \cup 
                                        {[inst   |-> i,
                                          status |-> "strongly-comitted",
                                          state |-> "done",
                                          ballot |-> record.ballot,
                                          cmd    |-> record.cmd,
                                          deps   |-> r.deps,
                                          seq    |-> r.seq,
                                          consistency |-> record.consistency,
                                          ctxid |-> record.ctxid]}]
                /\ LET newClk == [clk EXCEPT ![cleader] = @+1] IN
                            sentMsg' = (sentMsg \ replies) \cup
                            {[type  |-> "commit",
                            inst    |-> i,
                            ballot  |-> record.ballot,
                            cmd     |-> record.cmd,
                            deps    |-> r.deps,
                            seq     |-> r.seq,
                            consistency |-> r.consistency,
                            ctxid |-> r.ctxid,
                            clk |-> newClk[cleader]]}
                /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \ {i}]
                /\ committed' = [committed EXCEPT ![i] = 
                                            @ \cup {<<record.cmd, r.deps, r.seq>>}]
                /\ clk' = [clk EXCEPT ![cleader] = @+1]
                /\ UNCHANGED << proposed, executed, crtInst, ballots, preparing >>   
   
   
   
                               
Phase1Slow(cleader, i, Q) ==
    /\ i \in leaderOfInst[cleader]
    /\ Q \in SlowQuorums(cleader)
    /\ \E record \in cmdLog[cleader]:
        /\ record.inst = i
        /\ record.status = "pre-accepted"
        /\ LET replies == {msg \in sentMsg: 
                                /\ msg.inst = i 
                                /\ msg.type = "pre-accept-reply" 
                                /\ msg.dst = cleader 
                                /\ msg.src \in Q
                                /\ msg.ballot = record.ballot} IN
            /\ (\A replica \in (Q \ {cleader}): \E msg \in replies: msg.src = replica)
            /\ LET finalDeps == UNION {msg.deps : msg \in replies}
                   finalSeq == Max({msg.seq : msg \in replies})
                    waitingRecs == {rec \in cmdLog[cleader]: rec.inst \in finalDeps /\ rec.state = "waiting"} 
                    waitingInst == {rec.inst: rec \in waitingRecs}  IN   
                        IF Cardinality(waitingInst) = 0 THEN
                            /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {record}) \cup 
                                                    {[inst   |-> i,
                                                      status |-> "accepted",
                                                      state  |-> "done", 
                                                      ballot |-> record.ballot,
                                                      cmd    |-> record.cmd,
                                                      deps   |-> finalDeps,
                                                      seq    |-> finalSeq,
                                                      consistency |-> record.consistency, 
                                                      ctxid |-> record.ctxid ]}]
                            /\ LET newClk == [clk EXCEPT ![cleader] = @+1] IN \E SQ \in SlowQuorums(cleader):
                               (sentMsg' = (sentMsg \ replies) \cup
                                        [type : {"accept"},
                                        src : {cleader},
                                        dst : SQ \ {cleader},
                                        inst : {i},
                                        ballot: {record.ballot},
                                        cmd : {record.cmd},
                                        deps : {finalDeps},
                                        seq : {finalSeq},
                                        consistency : {record.consistency},
                                        ctxid : {record.ctxid},
                                        clk : {newClk[cleader]}])
                            /\ clk' = [clk EXCEPT ![cleader] = @+1]
                            /\ UNCHANGED << proposed, executed, crtInst, leaderOfInst,
                                            committed, ballots, preparing >>
                         ELSE
                            /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {record}) \cup 
                                                    {[inst   |-> i,
                                                      status |-> "accepted",
                                                      state  |-> "waiting", 
                                                      ballot |-> record.ballot,
                                                      cmd    |-> record.cmd,
                                                      deps   |-> finalDeps,
                                                      seq    |-> finalSeq,
                                                      consistency |-> record.consistency, 
                                                      ctxid |-> record.ctxid ]}]
                            /\ LET newcmdstate == checkWaiting(cleader) IN
                                /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {record}) \cup 
                                                    {[inst   |-> i,
                                                      status |-> "accepted",
                                                      state  |-> "done", 
                                                      ballot |-> record.ballot,
                                                      cmd    |-> record.cmd,
                                                      deps   |-> finalDeps,
                                                      seq    |-> finalSeq,
                                                      consistency |-> record.consistency, 
                                                      ctxid |-> record.ctxid ]}]
                                /\ LET newClk == [clk EXCEPT ![cleader] = @+1] IN \E SQ \in SlowQuorums(cleader):
                                   (sentMsg' = (sentMsg \ replies) \cup
                                            [type : {"accept"},
                                            src : {cleader},
                                            dst : SQ \ {cleader},
                                            inst : {i},
                                            ballot: {record.ballot},
                                            cmd : {record.cmd},
                                            deps : {finalDeps},
                                            seq : {finalSeq},
                                            consistency : {record.consistency},
                                            ctxid : {record.ctxid},
                                            clk : {newClk[cleader]}])
                                /\ clk' = [clk EXCEPT ![cleader] = @+1]
                                /\ UNCHANGED << proposed, executed, crtInst, leaderOfInst,
                                                committed, ballots, preparing >>
       
                                                
                                                
  Phase2Reply(replica) ==
    \E msg \in sentMsg: 
        /\ msg.type = "accept"
    /\ msg.dst = replica
    /\ LET oldRec == {rec \in cmdLog[replica]: rec.inst = msg.inst}
           waitingRecs == {rec \in cmdLog[replica]: rec.state = "waiting"} 
           waitingInst == {rec.inst: rec \in waitingRecs}  IN
          IF Cardinality(waitingInst) = 0 THEN
        /\ (\A rec \in oldRec: (rec.ballot = msg.ballot \/ 
                                rec.ballot[1] < msg.ballot[1]))
        /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                            {[inst   |-> msg.inst,
                              status |-> "accepted",
                              state  |-> "done", 
                              ballot |-> msg.ballot,
                              cmd    |-> msg.cmd,
                              deps   |-> msg.deps,
                              seq    |-> msg.seq,
                              consistency |-> msg.consistency, 
                              ctxid |-> msg.ctxid]}]
        /\ LET newClk == [clk EXCEPT ![replica] = @+1] IN
            sentMsg' = (sentMsg \ {msg}) \cup
                                {[type  |-> "accept-reply",
                                  src   |-> replica,
                                  dst   |-> msg.src,
                                  inst  |-> msg.inst,
                                  ballot|-> msg.ballot,
                                  consistency |-> msg.consistency,
                                  ctxid |-> msg.ctxid,
                                  clk |-> newClk[replica]]}
        /\ clk' = [clk EXCEPT ![replica] = @+1]
        /\ UNCHANGED << proposed, crtInst, executed, leaderOfInst,
                        committed, ballots, preparing >>   
         ELSE
           /\ (\A rec \in oldRec: (rec.ballot = msg.ballot \/ 
                                rec.ballot[1] < msg.ballot[1]))
           /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                            {[inst   |-> msg.inst,
                              status |-> "accepted",
                              state  |-> "waiting", 
                              ballot |-> msg.ballot,
                              cmd    |-> msg.cmd,
                              deps   |-> msg.deps,
                              seq    |-> msg.seq,
                              consistency |-> msg.consistency, 
                              ctxid |-> msg.ctxid]}]
           /\ LET newcmdstate == checkWaiting(replica) IN   
             /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                            {[inst   |-> msg.inst,
                              status |-> "accepted",
                              state  |-> "done", 
                              ballot |-> msg.ballot,
                              cmd    |-> msg.cmd,
                              deps   |-> msg.deps,
                              seq    |-> msg.seq,
                              consistency |-> msg.consistency, 
                              ctxid |-> msg.ctxid]}]               
               /\ LET newClk == [clk EXCEPT ![replica] = @+1] IN
                sentMsg' = (sentMsg \ {msg}) \cup
                                    {[type  |-> "accept-reply",
                                      src   |-> replica,
                                      dst   |-> msg.src,
                                      inst  |-> msg.inst,
                                      ballot|-> msg.ballot,
                                      consistency |-> msg.consistency,
                                      ctxid |-> msg.ctxid,
                                      clk |-> newClk[replica]]}
              /\ clk' = [clk EXCEPT ![replica] = @+1]
              /\ UNCHANGED << proposed, crtInst, executed, leaderOfInst,
                            committed, ballots, preparing >>                                          
           
           
           
                                                
 Phase2Finalize(cleader, i, Q) ==
    /\ i \in leaderOfInst[cleader]
    /\ Q \in SlowQuorums(cleader)
    /\ \E record \in cmdLog[cleader]:
        /\ record.inst = i
        /\ record.status = "accepted"
        /\ LET replies == {msg \in sentMsg: 
                                /\ msg.inst = i 
                                /\ msg.type = "accept-reply" 
                                /\ msg.dst = cleader 
                                /\ msg.src \in Q 
                                /\ msg.ballot = record.ballot} IN
            /\ (\A replica \in (Q \ {cleader}): \E msg \in replies: 
                                                        msg.src = replica)
            /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {record}) \cup 
                                    {[inst   |-> i,
                                      status |-> "strongly-committed",
                                      state  |-> "done",
                                      ballot |-> record.ballot,
                                      cmd    |-> record.cmd,
                                      deps   |-> record.deps,
                                      seq    |-> record.seq,
                                      consistency |-> record.consistency,
                                      ctxid |-> record.ctxid]}]
            /\ LET newClk == [clk EXCEPT ![cleader] = @+1] IN
               sentMsg' = (sentMsg \ replies) \cup
                        {[type  |-> "commit",
                        inst    |-> i,
                        ballot  |-> record.ballot,
                        cmd     |-> record.cmd,
                        deps    |-> record.deps,
                        seq     |-> record.seq,
                        consistency |-> record.consistency,
                        ctxid |-> record.ctxid,
                        clk |-> newClk[cleader]]}
            /\ committed' = [committed EXCEPT ![i] = @ \cup 
                               {<<record.cmd, record.deps, record.seq>>}]
            /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \ {i}]
            /\ clk' = [clk EXCEPT ![cleader] = @+1]
            /\ UNCHANGED << proposed, executed, crtInst, ballots, preparing >>                                            
                         
                         
                         
                               

CommitCausal(replica, cmsg) ==
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
                            
                            
                            
                                    
CommitStrong(replica, cmsg) ==
    LET oldRec == {rec \in cmdLog[replica] : rec.inst = cmsg.inst}
            newClk == 1 + Max({clk[replica]} \cup {cmsg.clk})
            waitingRecs == {rec \in cmdLog[replica]: rec.state = "waiting"} 
            waitingInst == {rec.inst: rec \in waitingRecs} IN
            IF Cardinality(waitingInst) = 0 THEN
                /\ \A rec \in oldRec : (rec.status \notin {"strongly-comitted", "executed"} /\ 
                                        rec.ballot[1] <= cmsg.ballot[1])
                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                            {[inst     |-> cmsg.inst,
                                              status   |-> "strongly-comitted",
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
                /\ \A rec \in oldRec : (rec.status \notin {"strongly-comitted", "executed"} /\ 
                                        rec.ballot[1] <= cmsg.ballot[1])
                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                            {[inst     |-> cmsg.inst,
                                              status   |-> "strongly-comitted",
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
                                                  status   |-> "strongly-comitted-committed",
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
 
 
 
                            
Commit(replica, cmsg) ==
    IF cmsg.consistency = "causal" THEN
        CommitCausal(replica, cmsg)
    ELSE
        CommitStrong(replica, cmsg)
        

(***************************************************************************)
(* Recovery actions                                                        *)
(***************************************************************************)

SendPrepare(replica, i, Q) ==
    /\ i \notin leaderOfInst[replica]
    \*/\ i \notin preparing[replica]
    /\ ballots <= MaxBallot
    /\ ~(\E rec \in cmdLog[replica] :
                        /\ rec.inst = i
                        /\ rec.status \in {"causally-committed", "strongly-committed", "executed"})
    /\ sentMsg' = sentMsg \cup
                    [type   : {"prepare"},
                     src    : {replica},
                     dst    : Q,
                     inst   : {i},
                     ballot : {<< ballots, replica >>}]
    /\ ballots' = ballots + 1
    /\ preparing' = [preparing EXCEPT ![replica] = @ \cup {i}]
    /\ UNCHANGED << cmdLog, proposed, executed, crtInst,
                    leaderOfInst, committed >>
                    
                    

(***************************************************************************)
(* Action groups                                                           *)
(***************************************************************************)        

CommandLeaderAction ==
    \/ (\E C \in (Commands \ proposed) :
            \E cl \in Consistency_level: 
                \E ctx \in Ctx_id:
                    \E cleader \in Replicas : Propose(C, cleader,cl,ctx))
    \/ (\E cleader \in Replicas : \E inst \in leaderOfInst[cleader] :
            \/ (\E Q \in FastQuorums(cleader) : Phase1Fast(cleader, inst, Q))
            \/ (\E Q \in SlowQuorums(cleader) : Phase1Slow(cleader, inst, Q))
            \/ (\E Q \in SlowQuorums(cleader) : Phase2Finalize(cleader, inst, Q))
            )
   
            
ReplicaAction ==
    \E replica \in Replicas :
        (\/ Phase1Reply(replica)
         \/ \E cmsg \in sentMsg : (cmsg.type = "commit" /\ Commit(replica, cmsg))
         \/ Phase2Reply(replica)
         (*\/ \E i \in Instances : 
            /\ crtInst[i[1]] > i[2] (* This condition states that the instance has *) 
                                    (* been started by its original owner          *)
            /\ \E Q \in SlowQuorums(replica) : SendPrepare(replica, i, Q)*)
        )


(***************************************************************************)
(* Next action                                                             *)
(***************************************************************************)

Next == 
    \/ CommandLeaderAction
    \/ ReplicaAction
    \/ (* Disjunct to prevent deadlock on termination *)
      ((\A r \in Replicas:
            \A inst \in cmdLog[r]: inst.status = "causally-committed" \/ inst.status = "strongly-committed") /\ UNCHANGED vars)


(***************************************************************************)
(* The complete definition of the algorithm                                *)
(***************************************************************************)

Spec == Init /\ [][Next]_vars

(***************************************************************************)
(* Termination Property                                                    *)
(***************************************************************************)

Termination == <>((\A r \in Replicas:
            \A inst \in cmdLog[r]: inst.status = "causally-committed" \/ inst.status = "strongly-committed"))


(***************************************************************************)
(* Theorems                                                                *)
(***************************************************************************)

(*Nontriviality ==
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

THEOREM Spec => ([]TypeOK) /\ Nontriviality /\ Stability /\ Consistency*)
                                                  
    

=============================================================================
\* Modification History
\* Last modified Wed Dec 13 13:55:38 EST 2023 by santamariashithil
\* Created Thu Nov 30 14:15:52 EST 2023 by santamariashithil
