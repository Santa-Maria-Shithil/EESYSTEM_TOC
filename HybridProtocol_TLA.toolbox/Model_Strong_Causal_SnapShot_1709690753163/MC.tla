---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709690736989192000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709690736989193000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709690736989194000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709690736989195000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709690736989196000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709690736989197000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 21:05:36 EST 2024 by santamariashithil
