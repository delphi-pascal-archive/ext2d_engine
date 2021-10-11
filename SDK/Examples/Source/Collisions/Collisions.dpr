program Collisions;

{$R *.res}

uses
  Windows, Messages, Ext2D, E2DKeys;

const
  E2DWndClass   = 'E2D_Window';
  E2DWndCaption = 'Collisions';

  MAX_SPRITES  = 20;
  ScreenWidth  = 640;
  ScreenHeight = 480;
  MAX_SPEED    = 2;
  UpdateSpeed  = 5;
  dxName       = '..\Data\directx.eif';
  dxFontName   = '..\Data\font.eff';

type
  TSprite = packed record
    X, Y   : Longint; 
    dX, dY : Longint;
    IsCol  : Boolean;
  end;

var
  E2DWindow : HWND;
  E2DMsg    : TMsg;
  flgActive : Boolean = False;

  dxImage   : E2D_TImageID;
  dxFont    : E2D_TFontID;
  dxImgRect : TRect;
  dxInf     : E2D_TImageInfo;
  dxSprites : array [0..MAX_SPRITES - 1] of TSprite;
  lastTick  : Longword;
  fpsTick   : Longword;
  FPS       : Longword = 0;
  fpsStr    : String;

{$WARNINGS OFF}

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
  i   : Longword;
begin
  Result := False;

  E2D_InitEngine(E2DWindow);
  res := E2D_CreateFullscreen(ScreenWidth, ScreenHeight, E2D_SCREEN_FRECDEF);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateFullscreen', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddImageFromFile(dxName, @dxInf, dxImage);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_AddImageFromFile', MB_ICONSTOP);
    Exit;
  end;

  res := E2D_AddFontFromFile(dxFontName, nil, dxFont);
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

  SetRect(dxImgRect, 0, 0, dxInf.Width, dxInf.Height);
  Randomize;
  for i := 0 to MAX_SPRITES - 1 do begin
    dxSprites[i].X := Round(i / (MAX_SPRITES) * (ScreenWidth - dxInf.Width));
    dxSprites[i].Y := Random(ScreenHeight) - dxInf.Height;
    repeat
      dxSprites[i].dX := Random(2 * MAX_SPEED + 1) - MAX_SPEED;
      dxSprites[i].dY := Random(2 * MAX_SPEED + 1) - MAX_SPEED;
    until
      (dxSprites[i].dX <> 0) or (dxSprites[i].dY <> 0);
  end;
  
  lastTick := GetTickCount;
  fpsTick := lastTick;
  flgActive := True;
  Result := True;
end;

procedure UpdateSprites;
var
  thisTick : Longword;
  col : Boolean;
  i, j : Longword;
begin
  thisTick := GetTickCount;
  if thisTick - lastTick >= UpdateSpeed then begin
    lastTick := thisTick;
    for i := 0 to MAX_SPRITES - 1 do
      with dxSprites[i] do begin
        IsCol := False;
         
        X := X + dX;
        Y := Y + dY;

        if X < -20 then begin
          X := -20;
          dX := -dX;
        end;

        if X > ScreenWidth - dxInf.Width + 20 then begin
          X := ScreenWidth - dxInf.Width + 20;
          dX := -dX;
        end;

        if Y < -20 then begin
          Y := -20;
          dY := -dY;
        end;

        if Y > ScreenHeight - dxInf.Height + 20 then begin
          Y := ScreenHeight - dxInf.Height + 20;
          dY := -dY;
        end;
      end;

    for i := 0 to MAX_SPRITES - 2 do
      for j := i + 1 to MAX_SPRITES - 1 do begin
        E2D_GetCollision(dxImage, dxImage, @dxImgRect, @dxImgRect, @dxSprites[i].X,
                         @dxSprites[j].X, col);

        if col then begin
          with dxSprites[i] do begin
            if not IsCol then begin
              dX := -dX;
              dY := -dY;
              IsCol := True;
            end;
          end;

          with dxSprites[j] do begin
            if not IsCol then begin
              dX := -dX;
              dY := -dY;
              IsCol := True;
            end;
          end;
        end;
      end;
  end;
end;

procedure DrawSprites;
var
  i : Longword;
begin
  for i := 0 to MAX_SPRITES - 1 do
    E2D_DrawImage(dxImage, @dxImgRect, @dxSprites[i].X);
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

    UpdateSprites;

    E2D_ClearBuffer;
    DrawSprites;
    E2D_DrawText(dxFont, PChar(fpsStr), 0, 0, Length(fpsStr));
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
