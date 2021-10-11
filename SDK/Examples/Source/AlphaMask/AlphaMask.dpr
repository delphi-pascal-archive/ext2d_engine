program AlphaMask;

{$R *.res}

uses
  Windows, Messages, Ext2D, E2DKeys;

const
  E2DWndClass   = 'E2D_Window';
  E2DWndCaption = 'AlphaMask';

  ScreenWidth  = 640;
  ScreenHeight = 480;
  UpdateSpeed  = 50;
  gName        = '..\Data\explode.eif';
  aName        = '..\Data\explode_a.eif';
  bkName       = '..\Data\fon.eif';
  gFontName    = '..\Data\font.eff';
  FrameWidth   = 64;

var
  E2DWindow : HWND;
  E2DMsg    : TMsg;
  flgActive : Boolean = False;

  gImage   : E2D_TImageID;
  aImage   : E2D_TImageID;
  bkImage  : E2D_TImageID;
  gFont    : E2D_TFontID;
  gInf     : E2D_TImageInfo;
  gImgRect : TRect;
  sr       : TRect;
  fr       : TRect;
  sp       : TPoint;
  tr       : TRect;
  lastTick : Longword;
  fpsTick  : Longword;
  FPS      : Longword = 0;
  fpsStr   : String;
  flg      : Boolean = False;

function E2DWndProc(Window : HWND; Msg : Cardinal;
                    wParam, lParam : Longint) : Longint; stdcall;
begin
  case Msg of
    WM_ACTIVATEAPP : if (wParam = WA_ACTIVE) or (wParam = WA_CLICKACTIVE) then begin
                       flgActive := True
                     end else
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
begin
  Result := False;

  E2D_InitEngine(E2DWindow);
  res := E2D_CreateFullscreen(ScreenWidth, ScreenHeight, E2D_SCREEN_FRECDEF);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateFullscreen', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(gName, @gInf, gImage);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(aName, nil, aImage);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(bkName, nil, bkImage);
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

  Randomize;
  SetRect(gImgRect, 0, 0, FrameWidth, gInf.Height);
  sp.X := Random(ScreenWidth - FrameWidth);
  sp.Y := Random(ScreenHeight - gInf.Height);
  SetRect(sr, 0, 0, ScreenWidth, ScreenHeight);
  SetRect(fr, sp.X, sp.Y, sp.X + FrameWidth, sp.Y + gInf.Height);
  SetRect(tr, 0, 0, 60, 30);

  lastTick := GetTickCount;
  fpsTick := lastTick;
  flgActive := True;
  Result := True;
end;

procedure UpdateFrame;
var
  thisTick : Longword;
begin
  thisTick := GetTickCount;
  if thisTick - lastTick >= UpdateSpeed then begin
    if gImgRect.Right >= gInf.Width then begin
      gImgRect.Left := 0;
      gImgRect.Right := FrameWidth;
      sp.X := -30 + Random(ScreenWidth - FrameWidth + 60);
      sp.Y := -30 + Random(ScreenHeight - gInf.Height + 60);
      E2D_DrawImage(bkImage, @fr, @fr);
      E2D_ShowBuffer;
      E2D_DrawImage(bkImage, @fr, @fr);
      SetRect(fr, sp.X, sp.Y, sp.X + FrameWidth, sp.Y + gInf.Height);
    end else begin
      gImgRect.Left := gImgRect.Left + FrameWidth;
      gImgRect.Right := gImgRect.Right + FrameWidth;
    end;
    lastTick := thisTick;
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

    UpdateFrame;

    E2D_DrawImage(bkImage, @tr, @tr);
    if E2D_DrawImage(bkImage, @fr, @fr) = E2DERR_SCREEN_CANTDRAW then begin
      E2D_RestoreSurfaces;
      E2D_DrawImage(bkImage, @sr, @sr);
      E2D_ShowBuffer;
      E2D_DrawImage(bkImage, @sr, @sr);
    end;
    if E2D_BeginEffects = E2DERR_OK then begin
      E2D_EffectAlphaMask(gImage, aImage, @gImgRect, @sp, @gImgRect);
      E2D_EndEffects;
    end;
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

  E2D_DrawImage(bkImage, @sr, @sr);
  E2D_ShowBuffer;
  E2D_DrawImage(bkImage, @sr, @sr);

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
