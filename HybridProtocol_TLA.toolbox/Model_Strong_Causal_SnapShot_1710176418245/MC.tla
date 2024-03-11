---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_171017640702550000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_171017640702751000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_171017640702752000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_171017640702753000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_171017640702754000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_171017640702755000 == 
{[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 11 13:00:07 EDT 2024 by santamariashithil
