---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170655896897087000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170655896897088000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170655896897089000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170655896897090000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170655896897091000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 15:09:28 EST 2024 by santamariashithil
