---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709690183827160000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709690183828161000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709690183828162000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709690183828163000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709690183828164000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709690183828165000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 20:56:23 EST 2024 by santamariashithil
