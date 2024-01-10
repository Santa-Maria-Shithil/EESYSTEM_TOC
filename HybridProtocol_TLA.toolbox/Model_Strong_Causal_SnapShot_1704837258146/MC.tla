---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1704837255070138000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1704837255070139000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1704837255070140000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1704837255070141000 == 
{1}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_1704837255070142000 == 
{1,2}
----

\* Constant expression definition @modelExpressionEval
const_expr_1704837255070144000 == 
cmdLog[1]
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1704837255070144000>>)
----

=============================================================================
\* Modification History
\* Created Tue Jan 09 16:54:15 EST 2024 by santamariashithil
