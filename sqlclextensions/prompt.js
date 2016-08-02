/*
 * Set the prompt in sqlcl and change to ansiconsole
 *
 * Usage:
 * script prompt
 *
 */

var ps1= 'set sqlprompt "_user\'@\'_connect_identifier > "'
sqlcl.setStmt(ps1);
sqlcl.run();
var ansi='set sqlformat ansiconsole'
sqlcl.setStmt(ansi);
sqlcl.run();
