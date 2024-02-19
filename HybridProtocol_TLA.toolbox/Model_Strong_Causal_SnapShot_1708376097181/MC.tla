---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1708375612112146000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1708375612112147000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1708375612112148000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1708375612112149000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1708375612112150000 == 
{"w", "x", "y", "z"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1708375612112151000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

=============================================================================
\* Modification History
\* Created Mon Feb 19 15:46:52 EST 2024 by santamariashithil
