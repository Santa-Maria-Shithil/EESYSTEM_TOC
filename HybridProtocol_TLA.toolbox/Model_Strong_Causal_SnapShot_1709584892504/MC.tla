---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709584591391124000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709584591391125000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709584591391126000 == 
{"strong"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709584591391127000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709584591391128000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709584591391129000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 15:36:31 EST 2024 by santamariashithil
