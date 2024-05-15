set echo off
SET statusbar ON
SET statusbar ADD editmode 
SET statusbar ADD txn
SET statusbar ADD timing
SET highlighting ON
SET highlighting keyword foreground green
SET highlighting identifier foreground magenta
SET highlighting string foreground yellow
SET highlighting NUMBER foreground cyan
SET highlighting comment background white
SET highlighting comment foreground black
set statusbar cursor dbid editmode git java linecol memory timing username txn
SET sqlprompt "@|GREEN  ' '_user|@ '@' @|RED  _connect_identifier|@ >"
define EDITOR=emacs
format rules /home/uhellstr/orascript/format.xml
