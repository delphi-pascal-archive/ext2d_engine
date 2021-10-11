program E2DApp;

uses
  Windows, Messages, Ext2D;

const
  E2DWndClass   = 'E2D_Window';
  E2DWndCaption = '';

var
  E2DWindow : HWND;
  E2DMsg    : TMsg;
  flgActive : Boolean = False;

function E2DWndProc(Window : HWND; Msg : Cardinal;
                    wParam, lParam : Longint) : Longint; stdcall;
begin
  case Msg of
    WM_ACTIVATEAPP : if (wParam = WA_ACTIVE) or (wParam = WA_CLICKACTIVE) then
                       flgActive := True
                     else
                       flgActive := False;  
    WM_DESTROY : begin
                   flgActive := False;
                   E2D_FreeEngine;
                   PostQuitMessage(0);
                   Result := 0;
                   Exit;
                 end;
  end;
  Result := DefWindowProc(Window, Msg, wParam, lParam);
end;

function CreateE2DWindow : Boolean;
var
  wc : TWndClassEx;
begin
  Result := False;

  ZeroMemory(@wc, SizeOf(wc));
  with wc do begin
    cbSize        := SizeOf(wc);
    lpfnWndProc   := @E2DWndProc;                 
    hInstance     := SysInit.HInstance;
    hIcon         := LoadIcon(HInstance, IDI_APPLICATION);
    lpszClassName := PChar(E2DWndClass);
  end;

  if RegisterClassEx(wc) = 0 then
    Exit;

  E2DWindow := CreateWindowEx(0, PChar(E2DWndClass), PChar(E2DWndCaption),
                              WS_POPUP, 0, 0, 1, 1, 0, 0, HInstance, nil);
  if E2DWindow = 0 then
    Exit;

  Result := not ShowWindow(E2DWindow, SW_SHOW);
end;

procedure OnIdle;
begin
  // Здесть пишем основной цикл программы (расчет положения обьектов, вывод на экран и т.д.).
  // Данная процедура выполняется непрерывно, пока приложение активно.
end;

begin
  if not CreateE2DWindow then begin
    MessageBox(0, 'Невозможно создать окно.', 'Ошибка', MB_ICONSTOP);
    Exit;
  end;

  // Здесь можно выполнять инициализацию, загрузку ресурсов и т.д.
  
  while True do
    if PeekMessage(E2DMsg, 0, 0, 0, PM_NOREMOVE) then
      if not GetMessage(E2DMsg, 0, 0, 0) then
        Break
      else begin
        TranslateMessage(E2DMsg);
        DispatchMessage(E2DMsg);
      end
    else
      if flgActive then
        OnIdle
      else
        WaitMessage;
end.
