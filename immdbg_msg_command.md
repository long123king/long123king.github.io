from immlib import *

NAME = "msg"
  
class MsgHook(BpHook):

    def __init__(self):
        BpHook.__init__(self)
        self.imm = Debugger()

    def run(self, regs):
        self.imm.log("Message Type : 0x%08x" % regs["EAX"])

class LogMsgHook(LogBpHook):

    def __init__(self):
        LogBpHook.__init__(self)
        self.imm = Debugger()

    def run(self, regs):
        self.imm.log("Message Type : 0x%08x" % regs["EAX"])
        msgout = open("C:\\msgout.txt", "a")
        msgout.write("Message Type : 0x%08x\n" % regs["EAX"])
        msgout.close()
        
def resetfile(file1):
    FILE=open(file1,"w")
    FILE.write("")
    FILE.close()
    return "" 

def main(args):
    imm = Debugger()     
    resetfile("C:\\msgout.txt")
    
    msgHook = LogMsgHook()
    msgHook.description = "Hook Dialog Function"
    msgHook.add("WndProc", 0x004019c8)

    imm.setBreakpoint(0x00401ee8)
    
    imm.run()

    return "Daniel has break at 0x004019c8"
    
    
    
