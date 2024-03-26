---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_171142615471082000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_171142615471083000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_171142615471084000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_171142615471085000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_171142615471086000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_171142615471087000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 26 00:09:14 EDT 2024 by santamariashithil
