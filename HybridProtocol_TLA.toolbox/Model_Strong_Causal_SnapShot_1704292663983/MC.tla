---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170429153045750000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170429153045751000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170429153045752000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170429153045753000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170429153045754000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Wed Jan 03 09:18:50 EST 2024 by santamariashithil
