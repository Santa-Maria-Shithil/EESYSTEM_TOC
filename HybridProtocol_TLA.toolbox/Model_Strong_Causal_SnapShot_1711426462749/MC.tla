---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1711426392842114000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1711426392842115000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1711426392842116000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1711426392842117000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1711426392842118000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1711426392842119000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 26 00:13:12 EDT 2024 by santamariashithil
