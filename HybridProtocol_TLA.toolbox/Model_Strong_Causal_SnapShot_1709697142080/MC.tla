---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709697095144544000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709697095144545000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709697095144546000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709697095144547000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709697095144548000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709697095144549000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 22:51:35 EST 2024 by santamariashithil
