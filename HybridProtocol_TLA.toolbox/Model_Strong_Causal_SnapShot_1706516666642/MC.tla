---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170651657548153000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170651657548254000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170651657548255000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170651657548256000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170651657548257000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 03:22:55 EST 2024 by santamariashithil
