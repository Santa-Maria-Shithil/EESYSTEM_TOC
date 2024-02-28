---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709145744517546000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709145744517547000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709145744517548000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709145744517549000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709145744517550000 == 
{"w", "x", "y", "z"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709145744517551000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Wed Feb 28 13:42:24 EST 2024 by santamariashithil
