---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170716241210058000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170716241210059000 == 
{1,2,3,4}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170716241210060000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170716241210061000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170716241210062000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

\* CONSTANT definitions @modelParameterConstants:5Keys
const_170716241210063000 == 
{"w", "x", "y", "z"}
----

=============================================================================
\* Modification History
\* Created Mon Feb 05 14:46:52 EST 2024 by santamariashithil
