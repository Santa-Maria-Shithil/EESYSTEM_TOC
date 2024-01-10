---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170483594754656000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170483594754657000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170483594754658000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170483594754659000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170483594754660000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Tue Jan 09 16:32:27 EST 2024 by santamariashithil
