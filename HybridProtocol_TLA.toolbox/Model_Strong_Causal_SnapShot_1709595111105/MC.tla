---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709595106008354000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709595106008355000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709595106008356000 == 
{"causal","strong"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709595106008357000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709595106008358000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709595106008359000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 18:31:46 EST 2024 by santamariashithil
