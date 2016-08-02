/* rebuild the sql passed in since args is split on spaces
   To use:
   script printtab <query>
   Example: script printtab select *  from employees
*/

var sql="";
for(var i=1;i<args.length;i++){
  sql = sql + " " + args[i];
}
ctx.write(sql + "\n\n");


var ret = util.executeReturnListofList(sql,null);

/* loop the rows */
for (var i = 0; i < ret.size(); i++) {
    ctx.write('>ROW \n');
    /*loop the cols */
    for( var ii=0;ii<ret[i].size();ii++) {
        ctx.write("\t" + ret[0][ii] + " : " + ret[i][ii] + "\n");
    }
}

ctx.write('\n\n');
