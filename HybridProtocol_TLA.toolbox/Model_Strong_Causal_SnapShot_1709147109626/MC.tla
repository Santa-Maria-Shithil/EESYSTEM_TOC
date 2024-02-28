---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1709147105547627000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1709147105547628000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1709147105547629000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1709147105547630000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1709147105547631000 == 
{"w", "x", "y", "z"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_1709147105547632000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]]}
----

\* Constant expression definition @modelExpressionEval
const_expr_1709147105547633000 == 
cmdLog
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1709147105547633000>>)
----

=============================================================================
\* Modification History
\* Created Wed Feb 28 14:05:05 EST 2024 by santamariashithil
