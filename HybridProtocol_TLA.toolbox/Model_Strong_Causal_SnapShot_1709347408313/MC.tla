---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709346852135698000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709346852135699000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709346852135700000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709346852135701000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709346852135702000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709346852135703000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Fri Mar 01 21:34:12 EST 2024 by santamariashithil
