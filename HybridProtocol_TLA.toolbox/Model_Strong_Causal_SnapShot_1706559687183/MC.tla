---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1706559577828101000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1706559577828102000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1706559577828103000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1706559577828104000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_1706559577828105000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 15:19:37 EST 2024 by santamariashithil
