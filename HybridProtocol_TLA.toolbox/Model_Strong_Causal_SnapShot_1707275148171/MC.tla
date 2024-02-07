---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1707275144064626000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1707275144064627000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1707275144064628000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1707275144064629000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_1707275144064630000 == 
{"w", "x", "y", "z"}
----

\* Constant expression definition @modelExpressionEval
const_expr_1707275144064632000 == 
Instances
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1707275144064632000>>)
----

=============================================================================
\* Modification History
\* Created Tue Feb 06 22:05:44 EST 2024 by santamariashithil
