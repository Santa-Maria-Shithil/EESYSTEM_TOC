---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170652172406566000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170652172406567000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170652172406568000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170652172406569000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170652172406570000 == 
{ [op |-> {[key |-> "x", type |-> "w"]}], [op |-> {[key |-> "y", type |-> "r"]}]}
----

=============================================================================
\* Modification History
\* Created Mon Jan 29 04:48:44 EST 2024 by santamariashithil
