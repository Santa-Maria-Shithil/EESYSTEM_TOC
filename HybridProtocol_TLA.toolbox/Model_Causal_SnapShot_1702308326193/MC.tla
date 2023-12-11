---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170230822263438000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170230822263539000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170230822263540000 == 
{"causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170230822263541000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170230822263542000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Mon Dec 11 10:23:42 EST 2023 by santamariashithil
