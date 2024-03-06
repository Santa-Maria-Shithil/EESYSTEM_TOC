---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170968989808298000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170968989808299000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709689898082100000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709689898082101000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709689898082102000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709689898082103000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 20:51:38 EST 2024 by santamariashithil
