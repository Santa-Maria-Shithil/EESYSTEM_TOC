---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709689926862113000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709689926863114000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709689926863115000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709689926863116000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709689926863117000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709689926863118000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 20:52:06 EST 2024 by santamariashithil
