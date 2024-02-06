---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1707199556406624000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1707199556406625000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1707199556406626000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1707199556406627000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_1707199556406628000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

\* CONSTANT definitions @modelParameterConstants:5Keys
const_1707199556406629000 == 
{"w", "x", "y", "z"}
----

\* Constant expression definition @modelExpressionEval
const_expr_1707199556406631000 == 
Instances
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1707199556406631000>>)
----

=============================================================================
\* Modification History
\* Created Tue Feb 06 01:05:56 EST 2024 by santamariashithil
