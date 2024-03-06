---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709740416612576000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709740416612577000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709740416612578000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709740416612579000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709740416612580000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709740416612581000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Wed Mar 06 10:53:36 EST 2024 by santamariashithil
