---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709596398759542000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709596398759543000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709596398759544000 == 
{"strong", "causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709596398759545000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709596398759546000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709596398759547000 == 
 {[op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 18:53:18 EST 2024 by santamariashithil