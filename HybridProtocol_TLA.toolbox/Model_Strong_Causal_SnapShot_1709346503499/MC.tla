---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709346492346628000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709346492346629000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709346492346630000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709346492346631000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709346492346632000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709346492346633000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Fri Mar 01 21:28:12 EST 2024 by santamariashithil
