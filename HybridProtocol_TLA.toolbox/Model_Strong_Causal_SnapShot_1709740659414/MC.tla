---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709740577156608000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709740577156609000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709740577156610000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709740577156611000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709740577156612000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709740577156613000 == 
{[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Wed Mar 06 10:56:17 EST 2024 by santamariashithil
