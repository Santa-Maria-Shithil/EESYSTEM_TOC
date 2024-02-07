---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1707275226868659000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1707275226868660000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1707275226868661000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1707275226868662000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1707275226868663000 == 
{"w", "x", "y", "z"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1707275226868664000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

\* Constant expression definition @modelExpressionEval
const_expr_1707275226868666000 == 
Instances
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1707275226868666000>>)
----

=============================================================================
\* Modification History
\* Created Tue Feb 06 22:07:06 EST 2024 by santamariashithil
