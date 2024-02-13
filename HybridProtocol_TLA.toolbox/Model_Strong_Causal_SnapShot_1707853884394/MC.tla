---- MODULE MC ----
EXTENDS HybridProtocol_TLA, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxBallot
const_170785387972819000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Replicas
const_170785387972820000 == 
{1,2,3}
----

\* CONSTANT definitions @modelParameterConstants:2Consistency_level
const_170785387972821000 == 
{"strong","causal"}
----

\* CONSTANT definitions @modelParameterConstants:3Ctx_id
const_170785387972822000 == 
{1,2}
----

\* CONSTANT definitions @modelParameterConstants:4Keys
const_170785387972823000 == 
{"w", "x", "y", "z"}
----

\* CONSTANT definitions @modelParameterConstants:5Commands
const_170785387972824000 == 
 { [op |-> [key |-> "x", type |-> "w"]], [op |-> [key |-> "y", type |-> "r"]], [op |-> [key |-> "x", type |-> "r"]], [op |-> [key |-> "y", type |-> "w"]], [op |-> [key |-> "w", type |-> "w"]], [op |-> [key |-> "z", type |-> "r"]]}
----

\* Constant expression definition @modelExpressionEval
const_expr_170785387972826000 == 
Instances
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_170785387972826000>>)
----

=============================================================================
\* Modification History
\* Created Tue Feb 13 14:51:19 EST 2024 by santamariashithil
