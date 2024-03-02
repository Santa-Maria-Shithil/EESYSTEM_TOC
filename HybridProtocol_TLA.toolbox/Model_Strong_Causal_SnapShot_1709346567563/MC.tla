---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709346557449640000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709346557449641000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709346557449642000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709346557449643000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709346557449644000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709346557449645000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Fri Mar 01 21:29:17 EST 2024 by santamariashithil
