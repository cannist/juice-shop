import javascript

from string f, int n
where exists(File file | f = file.getRelativePath() and n = file.getNumberOfLinesOfCode())
select f, n order by n desc
