package epaxos

import (
	//    "state"
	"epaxosproto"
	"genericsmrproto"
	"log"
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

	if !e.findSCC(inst) {
		return false
	}

	return true
}

var stack []*Instance = make([]*Instance, 0, 100)

func (e *Exec) findSCC(root *Instance) bool {
	index := 1
	//find SCCs using Tarjan's algorithm
	stack = stack[0:0]
	return e.strongconnect(root, &index)
}

func (e *Exec) strongconnect(v *Instance, index *int) bool {
	v.Index = *index
	v.Lowlink = *index
	*index = *index + 1

	l := len(stack)
	if l == cap(stack) {
		newSlice := make([]*Instance, l, 2*l)
		copy(newSlice, stack)
		stack = newSlice
	}
	stack = stack[0 : l+1]
	stack[l] = v

	for q := int32(0); q < int32(e.r.N); q++ {
		inst := v.Deps[q]
		log.Printf("value of inst dependency: %d", inst)
		for i := e.r.ExecedUpTo[q] + 1; i <= inst; i++ {
			for e.r.InstanceSpace[q][i] == nil || e.r.InstanceSpace[q][i].Cmds == nil || v.Cmds == nil {
				log.Printf("inside loop3")
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
				log.Printf("inside loop4 and status: %d, replica: %d, instance:%d committed info status: %d", e.r.InstanceSpace[q][i].Status, q, i, v.Status)

				e.r.instancesToRecover <- &instanceId{q, i} //@sshithil
				//e.r.startRecoveryForInstance(q, i) //@sshithil
				//id := <-e.r.instancesToRecover
				//log.Printf("Vlaue of channel, replica:%d, instace:%d", id.replica, id.instance)

				//time.Sleep(1000 * 1000)
				time.Sleep(10 * 1e9) //10 seconds
				//return false //@sshithl

			}
			w := e.r.InstanceSpace[q][i]

			if w.Index == 0 {
				//e.strongconnect(w, index)
				if !e.strongconnect(w, index) {
					for j := l; j < len(stack); j++ {
						log.Printf("inside loop5")
						stack[j].Index = 0
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
			for w.Cmds == nil {
				log.Printf("inside loop6")
				time.Sleep(1000 * 1000)
				//return false //@sshithil
			}
			for idx := 0; idx < len(w.Cmds); idx++ {
				log.Printf("inside loop7")
				val := w.Cmds[idx].Execute(e.r.State)
				if e.r.Dreply && w.lb != nil && w.lb.clientProposals != nil {
					e.r.ReplyProposeTS(
						&genericsmrproto.ProposeReplyTS{
							TRUE,
							w.lb.clientProposals[idx].CommandId,
							val,
							w.lb.clientProposals[idx].Timestamp},
						w.lb.clientProposals[idx].Reply)
				}
			}
			w.Status = epaxosproto.EXECUTED
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

type nodeArray []*Instance

func (na nodeArray) Len() int {
	return len(na)
}

func (na nodeArray) Less(i, j int) bool {
	return na[i].Seq < na[j].Seq
}

func (na nodeArray) Swap(i, j int) {
	na[i], na[j] = na[j], na[i]
}
