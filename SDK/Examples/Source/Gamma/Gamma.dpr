program Gamma;

{$R *.res}

uses
  Windows, Messages, Ext2D, E2DKeys;

const
  E2DWndClass   = 'E2D_Window';
  E2DWndCaption = 'Gamma';

  ScreenWidth  = 640;
  ScreenHeight = 480;
  UpdateSpeed  = 20;
  gName        = '..\Data\plane.eif';
  gFontName    = '..\Data\font.eff';

var
  E2DWindow : HWND;
  E2DMsg    : TMsg;
  flgActive : Boolean = False;

  gImage   : E2D_TImageID;
  gFont    : E2D_TFontID;
  gInf     : E2D_TImageInfo;
  gImgRect : TRect;
  sp       : TPoint;
  Gam      : E2D_TGamma = 256;
  iGam     : Shortint = -4;
  lastTick : Longword;
  fpsTick  : Longword;
  FPS      : Longword = 0;
  fpsStr   : String;

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

function IntToStr(Value : Longint) : String;
begin
  Str(Value, Result);
end;

function E2DCreate : Boolean;
var
  res : E2D_Result;
  dd : E2D_TDeviceDesc;
begin
  Result := False;

  E2D_InitEngine(E2DWindow);
  res := E2D_CreateFullscreen(ScreenWidth, ScreenHeight, E2D_SCREEN_FRECDEF);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateFullscreen', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_GetDeviceDesc(@dd);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_GetDeviceDesc', MB_ICONSTOP);
    Exit;
  end;

  if not dd.Gamma then begin
    MessageBox(E2DWindow, 'Нет поддержки гамма контроля.', 'Ext2D Engine', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(gName, @gInf, gImage);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddFontFromFile(gFontName, nil, gFont);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddFontFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_CreateInput;
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateInput', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddKeyboard;
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddKeyboard', MB_ICONSTOP);
    Exit;
  end;

  SetRect(gImgRect, 0, 0, gInf.Width, gInf.Height);
  sp.X := (ScreenWidth div 2) - (gInf.Width div 2);
  sp.Y := (ScreenHeight div 2) - (gInf.Height div 2);

  lastTick := GetTickCount;
  fpsTick := lastTick;
  flgActive := True;
  Result := True;
end;

procedure UpdateGamma;
var
  thisTick : Longword;
begin
  thisTick := GetTickCount;
  if thisTick - lastTick >= UpdateSpeed then begin
    lastTick := thisTick;
    Gam := Gam + iGam;
    if (Gam = 0) or (Gam = 256) then
      iGam := - iGam;
    E2D_SetGamma(Gam);
  end;
end;

procedure OnIdle;
var
  thisTick : Longword;

begin
  if flgActive then begin
    thisTick := GetTickCount;
    if thisTick - fpsTick >= 500 then begin
      fpsStr := IntToStr(Round(FPS * 1000 / (thisTick - fpsTick)));
      FPS := 0;
      fpsTick := thisTick;
    end;

    E2D_UpdateKeyboard;
    if E2D_IsKeyboardKeyDown(E2DKEY_ESCAPE) then begin
      DestroyWindow(E2DWindow);
      Exit;
    end;

    UpdateGamma;

    E2D_ClearBuffer;
    E2D_DrawImage(gImage, @gImgRect, @sp);
    E2D_DrawText(gFont, PChar(fpsStr), 0, 0, Length(fpsStr));
    E2D_ShowBuffer;
    FPS := FPS + 1;
  end;
end;

begin
  if not CreateE2DWindow then begin
    MessageBox(0, 'Невозможно создать окно.', 'Ошибка', MB_ICONSTOP);
    Exit;
  end;

  if not E2DCreate then begin
    DestroyWindow(E2DWindow);
    Exit;
  end;
  
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
