---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1706560681354136000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1706560681354137000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1706560681354138000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1706560681354139000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_1706560681354140000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 15:38:01 EST 2024 by santamariashithil
