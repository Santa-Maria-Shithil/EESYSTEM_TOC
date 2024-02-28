---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709148772174676000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709148772177677000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709148772177678000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709148772177679000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709148772177680000 == 
{"w", "x", "y", "z"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709148772177681000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Wed Feb 28 14:32:52 EST 2024 by santamariashithil
