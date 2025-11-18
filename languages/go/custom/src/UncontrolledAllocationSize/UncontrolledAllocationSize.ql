/**
 * @name Uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external user can result in integer
 *              overflow or denial of service (DoS).
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id go/uncontrolled-allocation-size
 * @tags security
 *       external/cwe/cwe-770
 */

import go
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.TaintTracking

/**
 * A data flow configuration for tracking user-controlled values that flow to allocation size arguments.
 */
module UncontrolledAllocationSizeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr call |
      call.getTarget().getName() = "make" and
      sink.asExpr() = call.getArgument(1)
    )
  }
}

module UncontrolledAllocationSizeFlow = TaintTracking::Global<UncontrolledAllocationSizeConfig>;

import UncontrolledAllocationSizeFlow::PathGraph

from UncontrolledAllocationSizeFlow::PathNode source, UncontrolledAllocationSizeFlow::PathNode sink
where UncontrolledAllocationSizeFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This memory allocation depends on a $@.",
  source.getNode(), "user-provided value"
