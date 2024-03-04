---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709593500500233000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709593500500234000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709593500500235000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709593500500236000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709593500500237000 == 
{"x", "y"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709593500500238000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]],[op |-> [key |-> "z", type |-> "w"]]}
----

=============================================================================
\* Modification History
\* Created Mon Mar 04 18:05:00 EST 2024 by santamariashithil
