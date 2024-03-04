---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170958243206436000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170958243206437000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170958243206438000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170958243206439000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_170958243206440000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_170958243206441000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 15:00:32 EST 2024 by santamariashithil
