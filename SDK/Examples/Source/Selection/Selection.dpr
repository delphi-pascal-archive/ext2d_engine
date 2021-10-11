program Selection;

{$R *.res}

uses
  Windows, Messages, Ext2D, E2DKeys;

const
  E2DWndClass   = 'E2D_Window';
  E2DWndCaption = 'Selection';

  ScreenWidth  = 640;
  ScreenHeight = 480;
  UpdateSpeed  = 10;

  gRedSphere    = '..\Data\RedSphere.eif';
  gSelectSphere = '..\Data\SelectSphere.eif';
  gspRed        = '..\Data\spRed.eif';
  gspGreen      = '..\Data\spGreen.eif';
  gspBlue       = '..\Data\spBlue.eif';
  gCursName     = '..\Data\3DArrow.eif';
  gFontName     = '..\Data\font.eff';

var
  E2DWindow : HWND;
  E2DMsg    : TMsg;
  flgActive : Boolean = False;

  gSphere    : E2D_TImageID;
  gSelSphere : E2D_TImageID;
  gSelR      : E2D_TImageID;
  gSelG      : E2D_TImageID;
  gSelB      : E2D_TImageID;
  gCursor    : E2D_TImageID;
  gFont      : E2D_TFontID;
  gImgInfo   : E2D_TImageInfo; 

  gSphereRect : TRect;
  gCursorRect : TRect;

  Sphere1Pos : TPoint;
  Sphere2Pos : TPoint;
  Sphere3Pos : TPoint;

  lastTick : Longword;
  fpsTick  : Longword;
  FPS      : Longword = 0;
  fpsStr   : String;
  Angle    : Single = 0.0;
  cPos     : TPoint;

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
begin
  Result := False;

  E2D_InitEngine(E2DWindow);
  res := E2D_CreateFullscreen(ScreenWidth, ScreenHeight, E2D_SCREEN_FRECDEF);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateFullscreen', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_CreateSelection;
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateSelection', MB_ICONSTOP);
    Exit;
  end; 

  res := E2D_AddImageFromFile(gRedSphere, @gImgInfo, gSphere);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;
  SetRect(gSphereRect, 0, 0, gImgInfo.Width, gImgInfo.Height);

  res := E2D_AddImageFromFile(gSelectSphere, @gImgInfo, gSelSphere);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(gspRed, @gImgInfo, gSelR);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(gspGreen, @gImgInfo, gSelG);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(gspBlue, @gImgInfo, gSelB);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(gCursName, @gImgInfo, gCursor);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;
  SetRect(gCursorRect, 0, 0, gImgInfo.Width, gImgInfo.Height);

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

  res := E2D_AddMouse;
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddMouse', MB_ICONSTOP);
    Exit;
  end;

  Sphere1Pos.X := 0;
  Sphere2Pos.X := 230;
  Sphere3Pos.X := 440;
  fpsTick := GetTickCount;
  lastTick := 0;
  flgActive := True;
  Result := True;
end;

function GetSelectionID : Byte;
var
  wrkS : E2D_TColor;
begin
  E2D_ClearSelect;
  E2D_DrawImageToSelect(gSelR, @gSphereRect, @Sphere1Pos);
  E2D_DrawImageToSelect(gSelG, @gSphereRect, @Sphere2Pos);
  E2D_DrawImageToSelect(gSelB, @gSphereRect, @Sphere3Pos);
  if E2D_BeginSelection = E2DERR_OK then begin
    wrkS := E2D_GetSelectionVal(cPos.X, cPos.Y);
    E2D_EndSelection;
    case wrkS of
      $1F shl 11 : Result := 1;
      $3F shl 5  : Result := 2;
      $1F        : Result := 3;
      else         Result := 0;
    end;
  end else
    Result := 0;
end;

procedure UpdateFrame;
var
  wrkTick : Cardinal;
begin
  wrkTick := GetTickCount;
  if wrkTick - lastTick > UpdateSpeed then begin
    Angle := Angle + 0.02;
    if Angle > 2 * Pi then
      Angle := Angle - 2 * Pi;
    lastTick := wrkTick;

    Sphere1Pos.Y := 140 - Trunc(Sin(Angle) * 100);
    Sphere2Pos.Y := 140 - Trunc(Sin(Angle + Pi / 4) * 100);
    Sphere3Pos.Y := 140 - Trunc(Sin(Angle + Pi / 2) * 100);
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
    E2D_UpdateMouse;
    E2D_GetCursorPosition(cPos);
    UpdateFrame;

    E2D_ClearBuffer;
    case GetSelectionID of
      0 : begin
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere1Pos);
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere2Pos);
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere3Pos);
          end;
      1 : begin
            E2D_DrawImage(gSelSphere, @gSphereRect, @Sphere1Pos);
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere2Pos);
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere3Pos);
          end;
      2 : begin
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere1Pos);
            E2D_DrawImage(gSelSphere, @gSphereRect, @Sphere2Pos);
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere3Pos);
          end;
      3 : begin
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere1Pos);
            E2D_DrawImage(gSphere, @gSphereRect, @Sphere2Pos);
            E2D_DrawImage(gSelSphere, @gSphereRect, @Sphere3Pos);
          end;
    end;
    E2D_DrawImage(gCursor, @gCursorRect, @cPos);
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
