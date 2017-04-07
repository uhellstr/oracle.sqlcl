// declare the 2 java files needed
var DriverManager = Java.type("java.sql.DriverManager");
var ScriptExecutor  = Java.type("oracle.dbtools.raptor.newscriptrunner.ScriptExecutor");

// piece the args back together minus the bg command
var BGsql="";
for(var i=1;i<args.length;i++){
  BGsql = BGsql + " " + args[i];
}

// bg run it
runme(BGsql);

//
// running the actual sql
//
function main(arg){
        function inner(){
               // make a new connect
                var conn2  = ctx.cloneCLIConnection();
                var sqlcl2 = new ScriptExecutor(conn2);

                sqlcl2.setStmt(arg);
                // run it
                sqlcl2.run();
                conn2.close();
        }
        return inner;
};

// make a thread and start it up
// runs later
function runme(arg){
        // import and alias Java Thread and Runnable classes
        var Thread = Java.type("java.lang.Thread");
        var Runnable = Java.type("java.lang.Runnable");

        // declare our thread
        this.thread = new Thread(new Runnable(){
                run: main(arg)
        });

        // start our thread
        this.thread.start();
        return;
}
