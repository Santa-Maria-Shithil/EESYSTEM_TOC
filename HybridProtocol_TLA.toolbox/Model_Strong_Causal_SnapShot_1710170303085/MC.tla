---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_171017028584234000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_171017028584235000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_171017028584236000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_171017028584237000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_171017028584238000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_171017028584239000 == 
{[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 11 11:18:05 EDT 2024 by santamariashithil
