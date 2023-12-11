---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170230753560620000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170230753560621000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170230753560622000 == 
{"causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170230753560623000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170230753560624000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Mon Dec 11 10:12:15 EST 2023 by santamariashithil
