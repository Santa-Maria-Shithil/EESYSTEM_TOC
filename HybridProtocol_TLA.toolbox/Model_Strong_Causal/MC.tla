---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170671209099810000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170671209099811000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170671209099812000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170671209099813000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170671209099814000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

\* CONSTANT definitions @modelParameterConstants:5Keys
const_170671209099815000 == 
{"x", "y"}
----

=============================================================================
\* Modification History
\* Created Wed Jan 31 09:41:31 EST 2024 by santamariashithil
