//#include <lib_helpers.mqh>

#define WS_TIMEOUT 30
#define WS_HEST_BEAT 45

#property version   "1.00"
#property strict

#import "mt4-common.dll"
   int Init( const uchar &url[], int timeout, int heatBeatPeriod);
   int SetHeader( const uchar &key[], const uchar &value[]);
   int GetCommand(uchar &data[]);
//   int httpSendPost(const uchar &url[], const uchar &in[], int timeout, uchar &output[]);
   int WSGetLastError(uchar &data[]);   
   int SendCommand(const uchar &command[]);
   void Deinit();
#import

class WebSocketsProcessor 
///: public SendHandler  
{

private:
  bool _isInited;
  string _host;
  int _timeout;;
  int _heatBeatPeriod;
public:
  
  WebSocketsProcessor(string host_, int timeout_, int heatBeatPeriod_) {
    _host = host_;
    _timeout = timeout_;
    _heatBeatPeriod = heatBeatPeriod_;  
  }

  void Send(string message) {
    if(!_isInited)
      return;
  
    SendCommand( message );
  }
  
  void ReInit() {
    
    Deinit();
      
    _isInited = ws_Init( _host, _timeout, _heatBeatPeriod );
  }
  
  int Init() {
    _isInited = ws_Init( _host, _timeout, _heatBeatPeriod );
    
    return IsInited();
  }
  
  bool IsInited() {
    return _isInited;
  }
  
  string GetLastError() {
    return WS_GetLastError();
  }

  void SetHeader(string _key, string _value) {
    //if(!_isInited)
    //  return;
  
    ws_SetHeader( _key, _value );
  }

  static int ws_Init(string _host, int _timeout, int _heatBeatPeriod) {
   uchar __host[];
   StringToCharArray(_host, __host);
   
   return ::Init(__host, _timeout, _heatBeatPeriod);
}

  static void ws_SetHeader(string _key, string _value) {
    uchar __key[], __value[];
    
    StringToCharArray(_key, __key);
    StringToCharArray(_value, __value);
   
    ::SetHeader(__key, __value);
  }


  static string WS_GetLastError() {
    uchar _error[8048];
  
    WSGetLastError( _error );
          
    return CharArrayToString( _error );
  }

  static string GetCommand() {
    uchar _command[260480];
  
    int r = 0;
    r = ::GetCommand( _command );
   
    if(r == 1) {
      return CharArrayToString( _command );
    }
   
    return "";
  }
  
  static void SendCommand(string command) {
   uchar __command[];
   StringToCharArray(command, __command);
   
   ::SendCommand(__command);
  }
};