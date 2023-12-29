---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170369091143620000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170369091143621000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170369091143622000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170369091143623000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170369091143624000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Wed Dec 27 10:28:31 EST 2023 by santamariashithil
