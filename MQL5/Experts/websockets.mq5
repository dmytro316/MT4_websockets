#property version   "1.00"
#property strict

#include <lib_websockets.mqh>

input string   Host = "http://localhost:8080";
input int      HeatBeatPeriod = 45;

int commandPingMilliseconds = 20;
WebSocketsProcessor *ws;

int OnInit() {

  ws = new WebSocketsProcessor(Host, 30, 45);    
  
  ws.SetHeader( "account", IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) );
  ws.Init();
  
  ws.Send( "test" + IntegerToString(GetTickCount()) );

  EventSetMillisecondTimer(commandPingMilliseconds);
  
  return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
  EventKillTimer();
  delete ws;
  Deinit();
}

void OnTick() {

}

void OnTimer() {
  string cmd = ws.GetCommand();

  if(cmd != "") {
    Print("cmd: " + cmd);
    ws.SendCommand( "test" + IntegerToString(GetTickCount()) );
  }
  
//  Print("sending command");
//  WS_SendCommand( "test" + GetTickCount() );
}