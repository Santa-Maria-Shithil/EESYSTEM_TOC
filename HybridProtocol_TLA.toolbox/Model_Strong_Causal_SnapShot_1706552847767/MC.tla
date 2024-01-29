---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170655284359773000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170655284359774000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170655284359775000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170655284359776000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170655284359777000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 13:27:23 EST 2024 by santamariashithil
