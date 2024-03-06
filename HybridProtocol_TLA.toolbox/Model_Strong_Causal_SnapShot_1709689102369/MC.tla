---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170968909122083000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170968909122084000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170968909122085000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170968909122086000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_170968909122087000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_170968909122088000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 20:38:11 EST 2024 by santamariashithil
