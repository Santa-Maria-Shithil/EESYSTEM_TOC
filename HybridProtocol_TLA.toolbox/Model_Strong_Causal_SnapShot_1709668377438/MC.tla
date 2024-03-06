---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_17096681624172000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_17096681624183000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_17096681624184000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_17096681624185000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_17096681624186000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_17096681624187000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Tue Mar 05 14:49:22 EST 2024 by santamariashithil
