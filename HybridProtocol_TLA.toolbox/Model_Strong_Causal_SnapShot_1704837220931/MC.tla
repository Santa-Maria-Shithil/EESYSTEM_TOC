---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1704837217769124000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1704837217769125000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1704837217769126000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1704837217769127000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_1704837217769128000 == 
{1,2}
----

\* Constant expression definition @modelExpressionEval
const_expr_1704837217769130000 == 
cmdLog
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1704837217769130000>>)
----

=============================================================================
\* Modification History
\* Created Tue Jan 09 16:53:37 EST 2024 by santamariashithil
