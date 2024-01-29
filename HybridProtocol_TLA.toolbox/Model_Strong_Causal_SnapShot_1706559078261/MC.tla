---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170655907373594000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170655907373595000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170655907373596000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170655907373597000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170655907373598000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 15:11:13 EST 2024 by santamariashithil
