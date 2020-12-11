import javascript

// placeholder - will replace with RemoteFlowSource
from
  RemoteFlowSource rep, string f, int startLine, int endLine, int startColumn, int endColumn,
  string sourceType
where
  exists(Location l | l = rep.asExpr().getLocation() |
    f = l.getFile().getRelativePath() and
    startLine = l.getStartLine() and
    endLine = l.getEndLine() and
    startColumn = l.getStartColumn() and
    endColumn = l.getEndColumn()
  ) and
  sourceType = rep.getSourceType()
select rep, f, startLine, endLine, startColumn, endColumn, sourceType
