---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_17095862191672000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_17095862191673000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_17095862191674000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_17095862191675000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_17095862191676000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_17095862191677000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 16:03:39 EST 2024 by santamariashithil
