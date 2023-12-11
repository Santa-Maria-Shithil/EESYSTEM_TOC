---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170230769172926000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170230769172927000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170230769172928000 == 
{"causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170230769172929000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170230769172930000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Mon Dec 11 10:14:51 EST 2023 by santamariashithil
