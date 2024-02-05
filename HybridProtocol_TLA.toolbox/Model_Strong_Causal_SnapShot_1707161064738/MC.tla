---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170716106015918000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170716106015919000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170716106015920000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170716106015921000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170716106015922000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

\* CONSTANT definitions @modelParameterConstants:5Keys
const_170716106015923000 == 
{"w", "x", "y", "z"}
----

=============================================================================
\* Modification History
\* Created Mon Feb 05 14:24:20 EST 2024 by santamariashithil
