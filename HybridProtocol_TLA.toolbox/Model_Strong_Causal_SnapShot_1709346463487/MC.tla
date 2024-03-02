---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709346453330616000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709346453330617000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709346453330618000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709346453330619000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709346453330620000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709346453330621000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Fri Mar 01 21:27:33 EST 2024 by santamariashithil
