package epaxos

import (
	//    "state"
	"epaxosproto"
	"genericsmrproto"
	"sort"
	"time"
)

const (
	WHITE int8 = iota
	GRAY
	BLACK
)

type Exec struct {
	r *Replica
}

type SCComponent struct {
	nodes []*Instance
	color int8
}

// ---added this structure to specifically store replica id and instance no in the stack@sshithil
type StackComponent struct {
	nodes   []*Instance
	replica int64
	instant int64
}

//-----------------@sshithil_>

func (e *Exec) executeCommand(replica int32, instance int32) bool {
	if e.r.InstanceSpace[replica][instance] == nil {
		return false
	}
	inst := e.r.InstanceSpace[replica][instance]
	if inst.Status == epaxosproto.EXECUTED {
		return true
	}
	if inst.Status != epaxosproto.COMMITTED {
		return false
	}

	/*if !e.findSCC(inst) {
		return false
	}*/

	//<-------@sshithil----added replica and instance to the parameter of findSCC to record the instance id to track the causal order
	if !e.findSCC(inst, replica, instance) {
		return false
	}
	//---------@sshithil>

	return true
}

// var stack []*Instance = make([]*Instance, 0, 100)
var stack []*StackComponent = make([]*StackComponent, 0, 100)

// func (e *Exec) findSCC(root *Instance) bool {
func (e *Exec) findSCC(root *Instance, replica int32, instance int32) bool { //@added replica int32 and instance int32 to record the instance if to track causal order @sshithil
	index := 1
	//find SCCs using Tarjan's algorithm
	stack = stack[0:0]
	//return e.strongconnect(root, &index)
	return e.strongconnect(root, &index, replica, instance) //added replica and instance to record the instance id to track the causal order @sshithil
}

// func (e *Exec) strongconnect(v *Instance, index *int) bool {
func (e *Exec) strongconnect(v *Instance, index *int, replica int32, instant int32) bool { //@added replica int32 and instance int32 to record the instance if to track causal order @sshithil
	v.Index = *index
	v.Lowlink = *index
	*index = *index + 1

	l := len(stack)
	if l == cap(stack) {
		newSlice := make([]*StackComponent, l, 2*l)
		copy(newSlice, stack)
		stack = newSlice
	}
	stack = stack[0 : l+1]
	//stack[l] = v
	stack[l].nodes = v         //modified @sshithil
	stack[l].replica = replica //added this line @sshithil
	stack[l].instant = instant //added this line @sshithil

	for q := int32(0); q < int32(e.r.N); q++ {
		inst := v.Deps[q]
		//log.Printf("value of inst dependency: %d", inst)
		for i := e.r.ExecedUpTo[q] + 1; i <= inst; i++ {
			for e.r.InstanceSpace[q][i] == nil || e.r.InstanceSpace[q][i].Cmds == nil || v.Cmds == nil {
				//log.Printf("inside loop3")
				time.Sleep(1000 * 1000)
				//return false @shithil
			}
			/*        if !state.Conflict(v.Command, e.r.InstanceSpace[q][i].Command) {
			          continue
			          }
			*/
			if e.r.InstanceSpace[q][i].Status == epaxosproto.EXECUTED {
				continue
			}
			for e.r.InstanceSpace[q][i].Status != epaxosproto.COMMITTED {
				//log.Printf("inside loop4 and status: %d, replica: %d, instance:%d committed info status: %d", e.r.InstanceSpace[q][i].Status, q, i, v.Status)

				//e.r.instancesToRecover <- &instanceId{q, i} //@sshithil
				//e.r.startRecoveryForInstance(q, i) //@sshithil
				//id := <-e.r.instancesToRecover //@sshithil
				//log.Printf("Vlaue of channel, replica:%d, instace:%d", id.replica, id.instance) //@sshitil

				time.Sleep(1000 * 1000)

			}
			w := e.r.InstanceSpace[q][i]

			if w.Index == 0 {
				//e.strongconnect(w, index)
				//if !e.strongconnect(w, index) {
				if !e.strongconnect(w, index, q, i) { //added parameter q and i to track causal order @sshithil
					for j := l; j < len(stack); j++ {
						//log.Printf("inside loop5")
						stack[j].nodes.Index = 0
					}
					stack = stack[0:l]
					return false
				}
				if w.Lowlink < v.Lowlink {
					v.Lowlink = w.Lowlink
				}
			} else { //if e.inStack(w)  //<- probably unnecessary condition, saves a linear search
				if w.Index < v.Lowlink {
					v.Lowlink = w.Index
				}
			}
		}
	}

	if v.Lowlink == v.Index {
		//found SCC
		list := stack[l:len(stack)]

		//execute commands in the increasing order of the Seq field
		sort.Sort(nodeArray(list))
		for _, w := range list {
			//for w.Cmds == nil {
			for w.nodes.Cmds == nil { //changed @sshithil

				time.Sleep(1000 * 1000)

			}
			for idx := 0; idx < len(w.nodes.Cmds); idx++ {
				//log.Printf("value of accept ok is: %d", w.lb.clientProposals[idx].acceptOKs)
				val := w.nodes.Cmds[idx].Execute(e.r.State)
				val = 0
				if e.r.Dreply && w.nodes.lb != nil && w.nodes.lb.clientProposals != nil {
					e.r.ReplyProposeTS(
						&genericsmrproto.ProposeReplyTS{
							TRUE,
							w.nodes.lb.clientProposals[idx].CommandId,
							w.replica, //originally send val here. I am sending instant id for now. Then need to change again to val. @sshithil
							w.instant},
						w.nodes.lb.clientProposals[idx].Reply)
				}
			}
			w.nodes.Status = epaxosproto.EXECUTED
		}
		stack = stack[0:l]
	}
	return true
}

func (e *Exec) inStack(w *Instance) bool {
	for _, u := range stack {
		if w == u {
			return true
		}
	}
	return false
}

type nodeArray []*StackComponent

func (na nodeArray) Len() int {
	return len(na)
}

func (na nodeArray) Less(i, j int) bool {
	return na[i].nodes.Seq < na[j].nodes.Seq
}

func (na nodeArray) Swap(i, j int) {
	na[i], na[j] = na[j], na[i]
}
