---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_1707199323441606000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_1707199323441607000 == 
{1,2,3,4,5}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_1707199323441608000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_1707199323441609000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Commands
const_1707199323441610000 == 
{ [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

\* CONSTANT definitions @modelParameterConstants:5Keys
const_1707199323441611000 == 
{"w", "x", "y", "z"}
----

\* Constant expression definition @modelExpressionEval
const_expr_1707199323442613000 == 
Instances
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_1707199323442613000>>)
----

=============================================================================
\* Modification History
\* Created Tue Feb 06 01:02:03 EST 2024 by santamariashithil
