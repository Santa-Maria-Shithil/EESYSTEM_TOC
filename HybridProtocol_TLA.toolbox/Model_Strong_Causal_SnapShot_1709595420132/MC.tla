---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709595407813409000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709595407815410000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709595407815411000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709595407815412000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709595407815413000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709595407815414000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 18:36:47 EST 2024 by santamariashithil