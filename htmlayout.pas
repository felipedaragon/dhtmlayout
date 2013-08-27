unit htmlayout;

interface

uses Windows, ExtCtrls, Forms, Controls, Classes, Messages, SysUtils, htmlayout_h, notifications_h;

type
  THtmLayoutHandleLinkEvent = function (param: PNMHL_HYPERLINK): Boolean of object;
  THtmLayoutAttachBehavior = function (param: NMHL_ATTACH_BEHAVIOR): Integer of object;
  THtmLayoutCreateControl =  function (param: NMHL_CREATE_CONTROL): Integer of object;
  THtmLayoutLoadData =  function (param: NMHL_LOAD_DATA): Integer of object;
  THtmlLayoutDocumentCompleted = function(): Integer of object;

  THtmLayout = Class(TCustomPanel)
  private
    FTeste: String;
    FOnHandleLink: THtmLayoutHandleLinkEvent;
    FOnAttachBehavior: THtmLayoutAttachBehavior;
    FOnCreateControl: THtmLayoutCreateControl;
    FOnControlCreated: THtmLayoutCreateControl;
    FOnLoadData: THtmLayoutLoadData;
    FOnDataLoaded: THtmLayoutLoadData;
    FOnDocumentCompleted: THtmlLayoutDocumentCompleted;
  protected
    procedure WndProc(var Message: TMessage);override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;

    function LoadHTML(html: String): Boolean;
    function LoadFile(filename: String): Boolean;

    property Teste: String read FTeste write FTeste;
  published
    property Align;
    property BorderStyle;

    property OnAttachBehavior: THtmLayoutAttachBehavior read FOnAttachBehavior write FOnAttachBehavior;
    property OnCreateControl: THtmLayoutCreateControl read FOnCreateControl write FOnCreateControl;
    property OnControlCreated: THtmLayoutCreateControl read FOnControlCreated write FOnControlCreated;
    property OnHandleLink: THtmLayoutHandleLinkEvent read FOnHandleLink write FOnHandleLink;
    property OnLoadData: THtmLayoutLoadData read FOnLoadData write FOnLoadData;
    property OnDataLoaded: THtmLayoutLoadData read FOnDataLoaded write FOnDataLoaded;
    property OnDocumentCompleted: THtmlLayoutDocumentCompleted read FOnDocumentCompleted write FOnDocumentCompleted;
  end;

  function NotifyHandler(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer): LRESULT; stdcall;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponentsProc('Internet', [THtmLayout]);
end;

function NotifyHandler(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer): LRESULT; stdcall;
var
  phdr: ^NMHDR;
  htmlayout: THtmLayout;
begin
  htmlayout := vParam;
  phdr := Pointer(lParam);

  case phdr^.code of
    HLN_CREATE_CONTROL:
    begin
      if (Assigned(htmlayout.OnCreateControl)) then
        Result := htmlayout.FOnCreateControl(LPNMHL_CREATE_CONTROL(Pointer(lParam))^);
    end;
    HLN_CONTROL_CREATED:
    begin
      if (Assigned(htmlayout.OnControlCreated)) then
        Result := htmlayout.FOnControlCreated(LPNMHL_CREATE_CONTROL(Pointer(lParam))^);
    end;
    HLN_LOAD_DATA:
    begin
      if (Assigned(htmlayout.OnLoadData)) then
        Result := htmlayout.FOnLoadData(LPNMHL_LOAD_DATA(Pointer(lParam))^);
    end;
    HLN_DATA_LOADED:
    begin
      if (Assigned(htmlayout.OnDataLoaded)) then
        Result := htmlayout.FOnDataLoaded(LPNMHL_LOAD_DATA(Pointer(lParam))^);
    end;
    HLN_DOCUMENT_COMPLETE:
    begin
      if (Assigned(htmlayout.OnDocumentCompleted)) then
        Result := htmlayout.FOnDocumentCompleted;
    end;
    HLN_ATTACH_BEHAVIOR:
    begin
      if (Assigned(htmlayout.OnAttachBehavior)) then
        Result := htmlayout.FOnAttachBehavior(LPNMHL_ATTACH_BEHAVIOR(Pointer(lParam))^);
    end;
    else
      Result := 0;
  end;
end;

function THtmLayout.LoadHTML(html: String): Boolean;
begin
  Result := HTMLayoutLoadHtml(Handle, PChar(html), Length(html));
end;

function THtmLayout.LoadFile(filename: String): Boolean;
var
  conteudo: TStringList;
begin
  conteudo := TStringList.Create;
  try
    conteudo.LoadFromFile(filename);
    Result := LoadHTML(conteudo.Text);
  finally
    conteudo.Free;
  end;

end;

constructor THtmLayout.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor THtmLayout.Destroy;
begin
  inherited Destroy;
end;

procedure THtmLayout.WndProc(var Message: TMessage);
var
  lResult: Integer;
  handled: BOOL;

  phdr: ^NMHDR;
begin
  if (csDesigning in ComponentState) then
  begin
    inherited WndProc(Message);
    Exit;
  end;

  lResult := HTMLayoutProcND(Handle, Message.Msg, Message.WParam, Message.LParam, @handled);
  if (handled) then
  begin
    Message.Result := lResult;
    Exit;
  end;

  case Message.Msg of
  WM_CREATE:
  begin
    HTMLayoutSetCallback(Handle, @NotifyHandler, Self);
  end;
  WM_BEHAVIOR_NOTIFY:
  begin
    phdr := Pointer(Message.lParam);

    if (HLN_HYPERLINK = phdr^.code) then
    begin
      if Assigned(FOnHandleLink) then
      begin
        FOnHandleLink(Pointer(Message.lParam));
      end;
    end;
  end;
  WM_ERASEBKGND:
  begin
    Message.Result := 1;
    Exit;
  end;
  else
  begin
    inherited WndProc(Message);
    Exit;
  end;
  end;

  Message.Result := 0;
end;

end.
