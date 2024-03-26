---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_171142521177418000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_171142521177419000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_171142521177420000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_171142521177421000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_171142521177422000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_171142521177423000 == 
{[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 25 23:53:31 EDT 2024 by santamariashithil
