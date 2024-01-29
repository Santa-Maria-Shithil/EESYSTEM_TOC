------------------------- MODULE HybridProtocol_TLA -------------------------
EXTENDS Naturals, FiniteSets, Sequences

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

Status == {"not-seen", "pre-accepted", "accepted", "causally-committed", "strongly-comitted", "executed" , "discarded"}
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
          committed, ballots, preparing, clk (*scc*)

TypeOK ==
    /\ cmdLog \in [Replicas -> SUBSET [inst: Instances, 
                                       status: Status \cup {none},
                                       state: State \cup {none},
                                       ballot: Nat \X Replicas,
                                       cmd: Commands \cup {none},
                                       deps: SUBSET Instances,
                                       seq: Nat,
                                       consistency: Consistency_level \cup {none},
                                       ctxid: Ctx_id \cup {none},
                                       scc_set: [Commands -> SUBSET Instances]  (* cmdLog[r].scc_set[c]
                                       *)
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
    (*/\ scc \in [Commands -> SUBSET Instances]*)
   
    
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
  (*/\ scc = [c \in Commands |-> {}]*)


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
                                 tt.status \in {"strongly-committed", "executed"}}}
                       extCom == UNION {msg.committed: msg \in replies} IN
                       (r.deps \subseteq (localCom \cup extCom))    
                /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {record}) \cup 
                                        {[inst   |-> i,
                                          status |-> "strongly-committed",
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
                /\ \A rec \in oldRec : (rec.status \notin {"strongly-committed", "executed"} /\ 
                                        rec.ballot[1] <= cmsg.ballot[1])
                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                            {[inst     |-> cmsg.inst,
                                              status   |-> "strongly-committed",
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
                /\ \A rec \in oldRec : (rec.status \notin {"strongly-committed", "executed"} /\ 
                                        rec.ballot[1] <= cmsg.ballot[1])
                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup 
                                            {[inst     |-> cmsg.inst,
                                              status   |-> "strongly-committed",
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
                                                  status   |-> "strongly-committed",
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
                    leaderOfInst, committed,clk >>
                    
 ReplyPrepare(replica) ==
    \E msg \in sentMsg : 
        /\ msg.type = "prepare"
        /\ msg.dst = replica
        /\ \/ \E rec \in cmdLog[replica] : 
                /\ rec.inst = msg.inst
                /\ msg.ballot[1] > rec.ballot[1]
                /\ sentMsg' = (sentMsg \ {msg}) \cup
                            {[type  |-> "prepare-reply",
                              src   |-> replica,
                              dst   |-> msg.src,
                              inst  |-> rec.inst,
                              ballot|-> msg.ballot,
                              prev_ballot|-> rec.ballot,
                              status|-> rec.status,
                              state |-> rec.state,
                              cmd   |-> rec.cmd,
                              deps  |-> rec.deps,
                              seq   |-> rec.seq,
                              consistency |-> rec.consistency,
                              ctxid |-> rec.ctxid]}
                 /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ {rec}) \cup
                            {[inst  |-> rec.inst,
                              status|-> rec.status,
                              state |-> rec.state, 
                              ballot|-> msg.ballot,
                              cmd   |-> rec.cmd,
                              deps  |-> rec.deps,
                              seq   |-> rec.seq,
                              consistency |-> rec.consistency,
                              ctxid |-> rec.ctxid]}]
                 /\ IF rec.inst \in leaderOfInst[replica] THEN
                        /\ leaderOfInst' = [leaderOfInst EXCEPT ![replica] = 
                                                                @ \ {rec.inst}]
                        /\ UNCHANGED << proposed, executed, committed,
                                        crtInst, ballots, preparing,clk >>
                    ELSE UNCHANGED << proposed, executed, committed, crtInst,
                                      ballots, preparing, leaderOfInst,clk >>
                        
           \/ /\ ~(\E rec \in cmdLog[replica] : rec.inst = msg.inst)
              /\ sentMsg' = (sentMsg \ {msg}) \cup
                            {[type  |-> "prepare-reply",
                              src   |-> replica,
                              dst   |-> msg.src,
                              inst  |-> msg.inst,
                              ballot|-> msg.ballot,
                              prev_ballot|-> << 0, replica >>,
                              status|-> "not-seen",
                              state |-> none,
                              cmd   |-> none,
                              deps  |-> {},
                              seq   |-> 0,
                              consistency |-> none,
                              ctxid |-> none]}
              /\ cmdLog' = [cmdLog EXCEPT ![replica] = @ \cup
                            {[inst  |-> msg.inst,
                              status|-> "not-seen",
                              state |-> none,
                              ballot|-> msg.ballot,
                              cmd   |-> none,
                              deps  |-> {},
                              seq   |-> 0,
                              consistency|-> none,
                              ctxid |-> none]}]
              /\ UNCHANGED << proposed, executed, committed, crtInst, ballots,
                              leaderOfInst, preparing,clk >>       
                              
PrepareFinalize(replica, i, Q) ==
    /\ i \in preparing[replica]
    /\ \E rec \in cmdLog[replica] :
       /\ rec.inst = i
       /\ rec.status \notin {"causally-committed", "strongly-committed", "executed"}
       
       /\ LET replies == {msg \in sentMsg : 
                        /\ msg.inst = i
                        /\ msg.type = "prepare-reply"
                        /\ msg.dst = replica
                        /\ msg.ballot = rec.ballot}
            newClk == [clk EXCEPT ![replica] = @ + 1] IN
            /\ (\A rep \in Q : \E msg \in replies : msg.src = rep)
            /\  \/ \E com \in replies :
                        /\ (com.status \in {"causally-committed", "strongly-committed", "executed"})
                        /\ preparing' = [preparing EXCEPT ![replica] = @ \ {i}]
                        /\ clk' = newClk
                        /\ sentMsg' = sentMsg \ replies
                        /\ UNCHANGED << cmdLog, proposed, executed, crtInst, leaderOfInst,
                                        committed, ballots>>
                \/ /\ ~(\E msg \in replies : msg.status \in {"causally-committed", "strongly-committed", "executed"})
                   /\ \E acc \in replies :
                        /\ acc.status = "accepted"
                        /\ (\A msg \in (replies \ {acc}) : 
                            (msg.prev_ballot[1] <= acc.prev_ballot[1] \/ 
                             msg.status # "accepted"))
                        /\ clk' = newClk
                        /\ sentMsg' = (sentMsg \ replies) \cup
                                 [type  : {"accept"},
                                  src   : {replica},
                                  dst   : Q \ {replica},
                                  inst  : {i},
                                  ballot: {rec.ballot},
                                  cmd   : {acc.cmd},
                                  deps  : {acc.deps},
                                  seq   : {acc.seq},
                                  consistency : {acc.consistency},
                                  ctxid : {acc.ctxid}]
                        /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ {rec}) \cup
                                {[inst  |-> i,
                                  status|-> "accepted",
                                  state |-> "done",
                                  ballot|-> rec.ballot,
                                  cmd   |-> acc.cmd,
                                  deps  |-> acc.deps,
                                  seq   |-> acc.seq,
                                  consistency |-> acc.consistency,
                                  ctxid |-> acc.ctxid]}]
                         /\ preparing' = [preparing EXCEPT ![replica] = @ \ {i}]
                         /\ leaderOfInst' = [leaderOfInst EXCEPT ![replica] = @ \cup {i}]
                         /\ UNCHANGED << proposed, executed, crtInst, committed, ballots>>
                \/ /\ ~(\E msg \in replies : 
                        msg.status \in {"accepted", "causally-committed", "strongly-committed", "executed"})
                   /\ LET preaccepts == {msg \in replies : msg.status = "pre-accepted"} IN
                       (\/  /\ \A p1, p2 \in preaccepts :
                                    p1.cmd = p2.cmd /\ p1.deps = p2.deps /\ p1.seq = p2.seq
                            /\ ~(\E pl \in preaccepts : pl.src = i[1])
                            /\ Cardinality(preaccepts) >= Cardinality(Q) - 1
                            /\ LET pac == CHOOSE pac \in preaccepts : TRUE IN
                                /\ clk' = newClk
                                /\ sentMsg' = (sentMsg \ replies) \cup
                                         [type  : {"accept"},
                                          src   : {replica},
                                          dst   : Q \ {replica},
                                          inst  : {i},
                                          ballot: {rec.ballot},
                                          cmd   : {pac.cmd},
                                          deps  : {pac.deps},
                                          seq   : {pac.seq},
                                          consistency : {pac.consistency},
                                          ctxid : {pac.ctxid}]
                                /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ {rec}) \cup
                                        {[inst  |-> i,
                                          status|-> "accepted",
                                          ballot|-> rec.ballot,
                                          cmd   |-> pac.cmd,
                                          deps  |-> pac.deps,
                                          seq   |-> pac.seq,
                                          consistency |-> pac.consistency,
                                          ctxid |-> pac.ctxid]}]
                                 /\ preparing' = [preparing EXCEPT ![replica] = @ \ {i}]
                                 /\ leaderOfInst' = [leaderOfInst EXCEPT ![replica] = @ \cup {i}]
                                 /\ UNCHANGED << proposed, executed, crtInst, committed, ballots >>
                        \/  /\ \A p1, p2 \in preaccepts : p1.cmd = p2.cmd /\ 
                                                          p1.deps = p2.deps /\
                                                          p1.seq = p2.seq
                            /\ ~(\E pl \in preaccepts : pl.src = i[1])
                            /\ Cardinality(preaccepts) < Cardinality(Q) - 1
                            /\ Cardinality(preaccepts) >= Cardinality(Q) \div 2
                            /\ LET pac == CHOOSE pac \in preaccepts : TRUE IN
                                /\ clk' = newClk
                                /\ sentMsg' = (sentMsg \ replies) \cup
                                         [type  : {"try-pre-accept"},
                                          src   : {replica},
                                          dst   : Q,
                                          inst  : {i},
                                          ballot: {rec.ballot},
                                          cmd   : {pac.cmd},
                                          deps  : {pac.deps},
                                          seq   : {pac.seq},
                                          consistency : {pac.consistency},
                                          ctxid : {pac.ctxid}]
                                /\ preparing' = [preparing EXCEPT ![replica] = @ \ {i}]
                                /\ leaderOfInst' = [leaderOfInst EXCEPT ![replica] = @ \cup {i}]
                                /\ UNCHANGED << cmdLog, proposed, executed,
                                                crtInst, committed, ballots>>
                        \/  /\ \/ \E p1, p2 \in preaccepts : p1.cmd # p2.cmd \/ 
                                                             p1.deps # p2.deps \/
                                                             p1.seq # p2.seq
                               \/ \E pl \in preaccepts : pl.src = i[1]
                               \/ Cardinality(preaccepts) < Cardinality(Q) \div 2
                            /\ preaccepts # {}
                            /\ LET pac == CHOOSE pac \in preaccepts : pac.cmd # none IN
                                /\ StartPhase1(pac.cmd, replica, Q, i, rec.ballot, replies, newClk[replica], pac.conistency,pac.ctxid)
                                /\ preparing' = [preparing EXCEPT ![replica] = @ \ {i}]
                                /\ UNCHANGED << proposed, executed, crtInst, committed, ballots>>)
                \/  /\ \A msg \in replies : msg.status = "not-seen"
                    /\ StartPhase1(none, replica, Q, i, rec.ballot, replies, newClk[replica], none, none)
                    /\ preparing' = [preparing EXCEPT ![replica] = @ \ {i}]
                    /\ UNCHANGED << proposed, executed, crtInst, committed, ballots >>   
                    
                    
ReplyTryPreaccept(replica) ==
    \E tpa \in sentMsg :
        /\ tpa.type = "try-pre-accept" 
        /\ tpa.dst = replica
        /\ LET oldRec == {rec \in cmdLog[replica] : rec.inst = tpa.inst}
           newClk == [clk EXCEPT ![replica] = @ + 1] IN
            /\ \A rec \in oldRec : rec.ballot[1] <= tpa.ballot[1] /\ 
                                   rec.status \notin {"accepted",  "causally-committed", "strongly-committed", "executed"}
            /\ \/ (\E rec \in cmdLog[replica] \ oldRec:
                        /\ tpa.inst \notin rec.deps
                        /\ \/ rec.inst \notin tpa.deps
                           \/ rec.seq >= tpa.seq
                        /\ clk'=newClk
                        /\ sentMsg' = (sentMsg \ {tpa}) \cup
                                    {[type  |-> "try-pre-accept-reply",
                                      src   |-> replica,
                                      dst   |-> tpa.src,
                                      inst  |-> tpa.inst,
                                      ballot|-> tpa.ballot,
                                      status|-> rec.status,
                                      state |-> rec.state,
                                      consistency |-> rec.consistency,
                                      ctxid |-> rec.ctxid]})
                        /\ UNCHANGED << cmdLog, proposed, executed, committed, crtInst,
                                        ballots, leaderOfInst, preparing >>
               \/ /\ (\A rec \in cmdLog[replica] \ oldRec: 
                            tpa.inst \in rec.deps \/ (rec.inst \in tpa.deps /\
                                                      rec.seq < tpa.seq))
                  /\ sentMsg' = (sentMsg \ {tpa}) \cup
                                    {[type  |-> "try-pre-accept-reply",
                                      src   |-> replica,
                                      dst   |-> tpa.src,
                                      inst  |-> tpa.inst,
                                      ballot|-> tpa.ballot,
                                      status|-> "OK",
                                      state |-> tpa.state,
                                      consistency |-> tpa.consistency,
                                      ctxid |-> tpa.ctxid]}
                  /\ clk'=newClk
                  /\ cmdLog' = [cmdLog EXCEPT ![replica] = (@ \ oldRec) \cup
                                    {[inst  |-> tpa.inst,
                                      status|-> "pre-accepted",
                                      state |-> "done",
                                      ballot|-> tpa.ballot,
                                      cmd   |-> tpa.cmd,
                                      deps  |-> tpa.deps,
                                      seq   |-> tpa.seq,
                                      consistency |-> tpa.consistency,
                                      ctxid |-> tpa.ctxid]}]
                  /\ UNCHANGED << proposed, executed, committed, crtInst, ballots,
                                  leaderOfInst, preparing >>
                      
             
FinalizeTryPreAccept(cleader, i, Q) ==
    \E rec \in cmdLog[cleader]:
        /\ rec.inst = i
        /\ LET tprs == {msg \in sentMsg : msg.type = "try-pre-accept-reply" /\
                            msg.dst = cleader /\ msg.inst = i /\
                            msg.ballot = rec.ballot} 
            newClk == [clk EXCEPT ![cleader] = @ + 1] IN
            /\ \A r \in Q: \E tpr \in tprs : tpr.src = r
            /\ \/ /\ \A tpr \in tprs: tpr.status = "OK"
                  /\ sentMsg' = (sentMsg \ tprs) \cup
                             [type  : {"accept"},
                              src   : {cleader},
                              dst   : Q \ {cleader},
                              inst  : {i},
                              ballot: {rec.ballot},
                              cmd   : {rec.cmd},
                              deps  : {rec.deps},
                              seq   : {rec.seq},
                              state : {rec.state},
                              consistency : {rec.consistency},
                              ctxid : {rec.ctxid}]
                  /\ clk'=newClk            
                  /\ cmdLog' = [cmdLog EXCEPT ![cleader] = (@ \ {rec}) \cup
                            {[inst  |-> i,
                              status|-> "accepted",
                              ballot|-> rec.ballot,
                              cmd   |-> rec.cmd,
                              deps  |-> rec.deps,
                              seq   |-> rec.seq,
                              state |-> rec.state,
                              consistency |-> rec.consistency,
                              ctxid |-> rec.ctxid]}]
                  /\ UNCHANGED << proposed, executed, committed, crtInst, ballots,
                                  leaderOfInst, preparing >>
               \/ /\ \E tpr \in tprs: tpr.status \in {"accepted", "causally-committed", "strongly-committed", "executed"}
                  /\ StartPhase1(rec.cmd, cleader, Q, i, rec.ballot, tprs, newClk[cleader], rec.consistency, rec.ctxid)
                  /\ UNCHANGED << proposed, executed, committed, crtInst, ballots,
                                  leaderOfInst, preparing >>
               \/ /\ \E tpr \in tprs: tpr.status = "pre-accepted"
                  /\ \A tpr \in tprs: tpr.status \in {"OK", "pre-accepted"}
                  /\ sentMsg' = sentMsg \ tprs
                  /\ leaderOfInst' = [leaderOfInst EXCEPT ![cleader] = @ \ {i}]
                  /\ UNCHANGED << cmdLog, proposed, executed, committed, crtInst,
                                  ballots, preparing >> 
                                  
(***************************************************************************)
(* Command Execution Actions                                               *)
(***************************************************************************)

BoundedSeq(S, n) == UNION {[1..i -> S] : i \in 0..n}  (* this is generating all possible paths among 
all the instances of the system*)
BSeq(S) == BoundedSeq(S, Cardinality(S)+1)


NewDepPathSet(replica,G) ==
    {
    p \in BSeq(G) : /\ p /= <<>>
                          /\ \forall i \in 1 .. (Len(p)-1) : (*this is checking wehther each pair of vertex (of an edge)
                          in the path is also a part of the dependency graph.  Checking this by finding whether the 
                          first vertex of the edge is the instance itself and the second vertex of the edge is in the dependency
                          graph of the instance*)
                            \E rec \in cmdLog[replica]: 
                                /\ rec.inst = p[i]
                                /\ p[i+1] \in rec.deps
                             
                             }

AreConnectedIn(replica, m,n,G) == 
    \E p \in NewDepPathSet(replica,G) : (p[1]=m) /\ (p[Len(p)] = n)



IsStronglyConnectedSCC(replica,i,scc,G) == 
    \A m,n \in scc: m#n => AreConnectedIn(replica,m,n,G)
        


FindAllInstances(replica, i) ==   (* finding all the instances of the command log *)
    {rec.inst: rec \in cmdLog[replica] 
        }
        
AreStronglyConnectedIn(replica, m, n, G) ==
    /\ AreConnectedIn(replica, m, n, G)
    /\ AreConnectedIn(replica, n, m, G)
        
        
SccTidSet(replica, i, dep, tid) == 
{
    tid_set \in SUBSET UNION {dep,{<<replica,i>>}}:
    /\ tid \in tid_set
    /\ IsStronglyConnectedSCC(replica, i , tid_set, UNION {dep,{<<replica,i>>}})
    /\ \forall m \in dep:
         AreStronglyConnectedIn(replica, m, tid, dep) => m \in tid_set
         }
         
FindSpecificInstance(replica, inst) == (*find a specific instance*)
    {rec \in cmdLog[replica] : rec.inst = inst} 
         
FindDeps(replica, i) == (*find the dependency of a specific instance*)
    { rec.deps: rec \in FindSpecificInstance("a",<<replica,i>>)}   (*--replace replica value--*)
    
MaxSequence(allSequences) == 
    CHOOSE seq \in allSequences : \A otherSeq \in allSequences : Cardinality(seq) >= Cardinality(otherSeq)

MinSetCover(allSequences) == 
    LET
        RECURSIVE minCover(_, _)
        minCover(SeqSet, Cover) ==
            IF SeqSet = {}
            THEN Cover
            ELSE
                LET seq == MaxSequence(SeqSet) IN
                    IF (\E inst \in Cover: \E i \in inst : i \in seq) /\ (Cover # {}) THEN
                        minCover(SeqSet \ {seq}, Cover)
                    ELSE
                        minCover(SeqSet \ {seq}, Cover \cup {seq})
    IN
        minCover(allSequences, {})


   
FindSCC(replica, i) == 
{
   scc \in SUBSET FindAllInstances(replica, i): 
    /\ IsStronglyConnectedSCC(replica, i, scc, Instances)
    /\ LET dep == FindDeps(replica, i) 
        dep2 == CHOOSE s \in dep  : TRUE IN
        /\ \E tid \in scc: scc \in SccTidSet(replica, i, dep2, tid)
}

FinalSCC(replica,i) ==
    MinSetCover(FindSCC(replica, i))



(*************Ordering Instances in SCC**************)

FindSeq(replica, inst) == (*find the sequence number of a specific instance*)
    {rec.seq: rec \in FindSpecificInstance(replica,inst)}
    
ChoosingSetElement(replica,i) == 
    CHOOSE inst \in FindSeq(replica,i): TRUE

MinSeq(allInstances) ==
    CHOOSE inst \in allInstances : \A otherInst \in allInstances : 
        ChoosingSetElement("a", <<inst[1],inst[2]>>) <= ChoosingSetElement("a",<<otherInst[1],otherInst[2]>>)(*--replace replica value--*)

OrderingInstancesFirstLevel(scc) ==  (*ordering based on sequence number (ascending)*)
     LET
        RECURSIVE minCover(_, _)
        minCover(SeqSet, Cover) ==
            IF SeqSet = {}
            THEN Cover
            ELSE
                LET seq == MinSeq(SeqSet) IN
                        minCover(SeqSet \ {seq}, Append(Cover,seq))
     IN
       minCover(scc, <<>>)
    

(*OrderingInstancesSecondLevel(scc) ==  (*ordering the instances among themeselves from the same replica according to the instance number (ascending)*) 
    LET
        orderedSccNodes == OrderingInstancesFirstLevel(scc)
        RECURSIVE secondLevelOrdering(_,_)
        secondLevelOrdering(sccSet, index) == 
            IF index = Len(orderedSccNodes)
            THEN sccSet
            ELSE 
                LET 
                    itemToSwap == sccSet[index] IN
                    (*IF itemToSwap[1] = item[i][1] /\ itemToSwap[2] >= item[i][2] 
                    THEN sccSet[index] == item[i]
                        sccSet[i] == itemToSwap
                    ELSE
                        sccSet[index] == sccSet[index]
                        sccSet[i] == sccSet[i]*)
                    sccSet[i] == itemToSwap : i \in index..Len(sccSet)
                    
                                  
    IN
        secondLevelOrdering(orderedSccNodes,1)*)
                        


ExecuteCommand(replica, i) == 
     \E rec \in cmdLog[replica]:
        /\ rec.inst = i
        /\ rec.status = "causally-committed" \/ rec.status = "strongly-committed"
        /\ LET scc_set == FinalSCC(replica,i) IN (*finding all scc *)
            /\ \A scc \in scc_set: 
                \A instant \in OrderingInstancesFirstLevel(scc): (*ordering each scc *)
                    \E rec2 \in cmdLog[instant[1]]:
                        /\rec2.inst=instant[2]
                        /\ IF rec2.cmd.op.type = "r" THEN  (*checking whether the operation is read or write*)
                            /\cmdLog' = [cmdLog EXCEPT ![instant[1]] = (@ \ instant[2]) \cup
                                            {[inst   |-> rec2.inst,
                                              status |-> "executed",
                                              state  |-> rec2.state,
                                              ballot |-> rec2.ballot,
                                              cmd    |-> rec2.cmd,
                                              deps   |-> rec2.deps,
                                              seq    |-> rec2.seq,
                                              consistency |-> rec2.consistency,
                                              ctxid |-> rec2.ctxid ]}]
                            /\UNCHANGED <<proposed, executed, sentMsg, crtInst, leaderOfInst,
                                    committed, ballots, preparing, clk>>
                           
                           ELSE 
                            LET 
                                recs == {rec3 \in cmdLog[replica]: rec3.state = "executed" /\ rec3.cmd.op.key = rec2.cmd.op.key} (* finding the instant that has the same key as the instant that we are going to execute *)
                                seq == {rec4.seq: rec4 \in recs} (* finding the seq number of the last write *) IN
                                    IF rec2.seq > seq THEN
                                        /\cmdLog' = [cmdLog EXCEPT ![instant[1]] = (@ \ instant[2]) \cup
                                            {[inst   |-> rec2.inst,
                                              status |-> "executed", (* latest write win *)
                                              state  |-> rec2.state,
                                              ballot |-> rec2.ballot,
                                              cmd    |-> rec2.cmd,
                                              deps   |-> rec2.deps,
                                              seq    |-> rec2.seq,
                                              consistency |-> rec2.consistency,
                                              ctxid |-> rec2.ctxid ]}]
                                       /\UNCHANGED <<proposed, executed, sentMsg, crtInst, leaderOfInst,
                                         committed, ballots, preparing, clk>>
                                    ELSE
                                        /\cmdLog' = [cmdLog EXCEPT ![instant[1]] = (@ \ instant[2]) \cup
                                            {[inst   |-> rec2.inst,
                                              status |-> "discarded",
                                              state  |-> rec2.state,
                                              ballot |-> rec2.ballot,
                                              cmd    |-> rec2.cmd,
                                              deps   |-> rec2.deps,
                                              seq    |-> rec2.seq,
                                              consistency |-> rec2.consistency,
                                              ctxid |-> rec2.ctxid ]}]
                                       /\UNCHANGED <<proposed, executed, sentMsg, crtInst, leaderOfInst,
                                         committed, ballots, preparing, clk>>

(*<<<<"a", 0>>, <<"b", 0>>, <<"c", 0>>, <<"a", 1>>>>*) 
                

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
            \/ (\E Q \in SlowQuorums(cleader) : FinalizeTryPreAccept(cleader, inst, Q)))
    \/ \E replica \in Replicas: 
            \E inst \in cmdLog[replica]: ExecuteCommand(replica, inst)
    
    
  
            
   
            
ReplicaAction ==
    \E replica \in Replicas :
        (\/ Phase1Reply(replica)
         \/ \E cmsg \in sentMsg : (cmsg.type = "commit" /\ Commit(replica, cmsg))
         \/ Phase2Reply(replica)
         \/ \E i \in Instances : 
            /\ crtInst[i[1]] > i[2] (* This condition states that the instance has *) 
                                    (* been started by its original owner          *)
            /\ \E Q \in SlowQuorums(replica) : SendPrepare(replica, i, Q)
         \/ ReplyPrepare(replica)
         \/ \E i \in preparing[replica] :
            \E Q \in SlowQuorums(replica) : PrepareFinalize(replica, i, Q)
         \/ ReplyTryPreaccept(replica)
         \/ \E inst \in cmdLog[replica]: ExecuteCommand(replica, inst)
         )


(***************************************************************************)
(* Next action                                                             *)
(***************************************************************************)

Next == 
    \/ CommandLeaderAction
    \/ ReplicaAction
    \/ (* Disjunct to prevent deadlock on termination *)
      (*((\A r \in Replicas:
            \A inst \in cmdLog[r]: inst.status = "causally-committed" \/ inst.status = "strongly-committed") /\ UNCHANGED vars)*)
      ((\A r \in Replicas:
            \A inst \in cmdLog[r]: inst.status = "executed" \/ inst.status = "discarded") /\ UNCHANGED vars)


(***************************************************************************)
(* The complete definition of the algorithm                                *)
(***************************************************************************)

Spec == Init /\ [][Next]_vars

(***************************************************************************)
(* Safety Property                                                         *)
(***************************************************************************)



(***************************************************************************)
(* Liveness Property                                                       *)
(***************************************************************************)

(***************************************************************************)
(* Termination Property                                                    *)
(***************************************************************************)

(*Termination == <>((\A r \in Replicas:
            \A inst \in cmdLog[r]: inst.status = "causally-committed" \/ inst.status = "strongly-committed"))*)
Termination == <>((\A r \in Replicas:
            \A inst \in cmdLog[r]: inst.status = "executed" \/ inst.status = "discarded"))

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
\* Last modified Mon Jan 29 04:19:51 EST 2024 by santamariashithil
\* Created Thu Nov 30 14:15:52 EST 2023 by santamariashithil
