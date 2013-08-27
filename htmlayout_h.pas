unit htmlayout_h;

interface

uses Windows, Messages;

const
  HLN_CREATE_CONTROL    = $AFF + $01;
  HLN_LOAD_DATA         = $AFF + $02;
  HLN_CONTROL_CREATED   = $AFF + $03;
  HLN_DATA_LOADED       = $AFF + $04;
  HLN_DOCUMENT_COMPLETE = $AFF + $05;
  HLN_UPDATE_UI         = $AFF + $06;
  HLN_DESTROY_CONTROL   = $AFF + $07;
  HLN_ATTACH_BEHAVIOR   = $AFF + $08;
  HLN_BEHAVIOR_CHANGED  = $AFF + $09;
  HLN_DIALOG_CREATED    = $AFF + $10;
  HLN_DIALOG_CLOSE_RQ   = $AFF + $0A;
  HLN_DOCUMENT_LOADED   = $AFF + $0B;

  HWND_TRY_DEFAULT      = 0;
  HWND_DISCARD_CREATION = 1;

  LOAD_OK               = 0;
  LOAD_DISCARD          = 1;

  type
    HELEMENT = Pointer;
    HTMLAYOUT_NOTIFY = function (uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer): LRESULT; stdcall;
    LPHTMLAYOUT_NOTIFY = ^HTMLAYOUT_NOTIFY;

    NMHL_CREATE_CONTROL = packed record
      hdr: NMHDR;
      helement: HELEMENT;
      inHwndParent: HWND;
      outControlHwnd: HWND;
      reserved1: DWORD;
      reserved2: DWORD;
    end;
    LPNMHL_CREATE_CONTROL = ^NMHL_CREATE_CONTROL;

    NMHL_DESTROY_CONTROL = packed record
      hdr: NMHDR;
      helement: HELEMENT;
      inHwndParent: HWND;
      reserved1: DWORD;
    end;
    LPNMHL_DESTROY_CONTROL = ^NMHL_DESTROY_CONTROL;

    NMHL_LOAD_DATA = packed record
      hdr: NMHDR;
      uri: PChar;
      outData: Pointer;
      outDataSize: DWORD;
      dataType: UINT;

      principal: HELEMENT;
      initiator: HELEMENT;
    end;
    LPNMHL_LOAD_DATA = ^NMHL_LOAD_DATA;

    NMHL_DATA_LOADED = packed record
      hdr: NMHDR;
      uri: PChar;
      data: Pointer;
      dataSize: DWORD;
      dataType: UINT;
      status: UINT;
    end;
    LPNMHL_DATA_LOADED = ^NMHL_DATA_LOADED;

    NMHL_ATTACH_BEHAVIOR = packed record
      hdr: NMHDR;

      element: HELEMENT;
      behaviorName: PChar;
      //elementProc:
    end;
    LPNMHL_ATTACH_BEHAVIOR = ^NMHL_ATTACH_BEHAVIOR;

  function HTMLayoutInit(hModule: THandle; start: Boolean): Integer; stdcall; external 'htmlayout.dll';

  function HTMLayoutClassNameA: PChar; stdcall; external 'htmlayout.dll';
  function HTMLayoutClassNameW: PChar; stdcall; external 'htmlayout.dll';

  function HTMLayoutProcND(hWnd: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM; pbHandled: PBOOL): Integer; stdcall; external 'htmlayout.dll';
  function HTMLayoutSetCallback(hWndHTMLayout: HWND; cb: LPHTMLAYOUT_NOTIFY; cbParam: Pointer): Integer; stdcall; external 'htmlayout.dll';
  function HTMLayoutLoadHtml(hWndHTMLayout: HWND; html: PChar; size: UINT): Boolean; stdcall; external 'htmlayout.dll';
  function HTMLayoutLoadFile(hWndHTMLayout: HWND; filename: PChar): Boolean; stdcall; external 'htmlayout.dll';

  function HTMLayoutClassNameT:PChar;

implementation

function HTMLayoutClassNameT:PChar;
begin
  Result := HTMLayoutClassNameA;
end;

end.
