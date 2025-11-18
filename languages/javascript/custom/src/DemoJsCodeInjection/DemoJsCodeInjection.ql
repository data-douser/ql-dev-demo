/**
 * @id js/demo-code-injection
 * @name Demo JavaScript Code Injection
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @tags security
 *       external/cwe/cwe-094
 */

import javascript
import semmle.javascript.security.dataflow.CodeInjectionQuery
import CodeInjectionFlow::PathGraph

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
where CodeInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  sink.getNode().(Sink).getMessagePrefix() + " depends on a $@.", source.getNode(),
  "user-provided value"