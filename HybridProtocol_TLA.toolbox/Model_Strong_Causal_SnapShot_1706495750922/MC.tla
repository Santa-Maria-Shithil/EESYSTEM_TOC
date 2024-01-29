---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170649382184020000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170649382184021000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170649382184122000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170649382184123000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170649382184124000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Sun Jan 28 21:03:41 EST 2024 by santamariashithil
