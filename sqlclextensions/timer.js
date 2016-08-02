// SQLCL's Command Registry
var CommandRegistry = Java.type("oracle.dbtools.raptor.newscriptrunner.CommandRegistry");

// CommandListener for creating any new command
var CommandListener =  Java.type("oracle.dbtools.raptor.newscriptrunner.CommandListener")

// Broke the .js out from the Java.extend to be easier to read
var cmd = {};

// Called to attempt to handle any command
cmd.handle = function (conn,ctx,cmd) {
   // Check that the command is what we want to handle
   if ( cmd.getSql().indexOf("timer") == 0 ){
       ctx.write("Timer, what up?\n");

       // return TRUE to indicate the command was handled
       return true;
    }
   // return FALSE to indicate the command was not handled
   // and other commandListeners will be asked to handle it
   return false;
}

// fired before ANY command
cmd.begin = function (conn,ctx,cmd) {
   var start = new Date();

   // stash something for later like the start date
   ctx.putProperty("cmd.start",start);
}

// fired after ANY Command
cmd.end = function (conn,ctx,cmd) {
   var end = new Date().getTime();
   var start = ctx.getProperty("cmd.start");
   if ( start ) {
      start = start.getTime();
      // print out elapsed time of all commands
      ctx.write("Elapsed Time:" + (end - start) + "\n");
   }
}

// Actual Extend of the Java CommandListener

var MyCmd2 = Java.extend(CommandListener, {
        handleEvent: cmd.handle ,
        beginEvent:  cmd.begin  ,
        endEvent:    cmd.end
});

// Registering the new Command
CommandRegistry.addForAllStmtsListener(MyCmd2.class);
