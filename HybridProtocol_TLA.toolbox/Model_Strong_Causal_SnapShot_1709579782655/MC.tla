---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_17095795745512000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_17095795745523000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_17095795745524000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_17095795745525000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_17095795745526000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_17095795745527000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 14:12:54 EST 2024 by santamariashithil
