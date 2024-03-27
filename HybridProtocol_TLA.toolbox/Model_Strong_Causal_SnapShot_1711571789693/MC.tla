---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_17115716369692000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_17115716369713000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_17115716369714000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_17115716369715000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_17115716369716000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_17115716369717000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Wed Mar 27 16:33:56 EDT 2024 by santamariashithil
