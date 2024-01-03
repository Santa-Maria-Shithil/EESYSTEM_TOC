---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170429103914732000 == 
{10}
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170429103914733000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170429103914734000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170429103914735000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_170429103914736000 == 
{1,2}
----

=============================================================================
\* Modification History
\* Created Wed Jan 03 09:10:39 EST 2024 by santamariashithil
