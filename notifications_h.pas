unit notifications_h;

interface

uses Windows, Messages, htmlayout_h;

const
  MAX_URL_LENGTH        = 2048;

  WM_BEHAVIOR_NOTIFY    = WM_USER + 100;

  HLN_COMMAND_CLICK     = 1;
  HLN_HYPERLINK         = 2;

  HL_ENTER              = 1;
  HL_LEAVE              = 2;
  HL_CLICK              = 3;

type
  NMHL_COMMAND_CLICK = packed record
    hdr: NMHDR;
    szElementID: array[0..MAX_URL_LENGTH] of char;
    he: HELEMENT;
  end;
  PNMHL_COMMAND_CLICK = ^NMHL_COMMAND_CLICK;

  NMHL_HYPERLINK = packed record
    hdr: NMHDR;
    action: Cardinal;
    szHREF: array[0..MAX_URL_LENGTH] of char;
    szTarget: array[0..MAX_URL_LENGTH] of char;
    he: HELEMENT;
  end;
  PNMHL_HYPERLINK = ^NMHL_HYPERLINK;

implementation

end.
