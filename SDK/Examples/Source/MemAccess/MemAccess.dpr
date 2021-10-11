program MemAccess;

{$R *.res}

uses
  Windows, Messages, Ext2D, E2DKeys;

const
  E2DWndClass   = 'E2D_Window';
  E2DWndCaption = 'MemAccess';
  gFontName     = '..\Data\Font.eff';
  ScreenWidth   = 640;
  ScreenHeight  = 480;
  NumFlakes     = 400;
  MaxFlakeSize  = 2;
  SnowColor     = E2D_TColor($E71C);
  UpdateSpeed   = 30;
  MaxSpeedX     = 3;
  MaxSpeedY     = 3;
  MaxAngleSpeed = 0.05;
  MaxAngleDif   = 2;

type
  TLineRec = packed record
    sX1, sX2 : Integer;
  end;

  TSnowFlake = packed record
    CenterX  : Integer;
    CenterY  : Integer;
    SpeedX   : Integer;
    SpeedY   : Integer;
    Angle    : Single;
    sY1, sY2 : Integer;
    Lines    : array of TLineRec;
  end;

var
  E2DWindow  : HWND;
  E2DMsg     : TMsg;
  flgActive  : Boolean = False;
  LastUpdate : Cardinal;
  gFont      : E2D_TFontID;
  sr         : TRect;
  SnowFlakes : array [0..NumFlakes - 1] of TSnowFlake;
  fpsTick    : Longword;
  FPS        : Longword = 0;
  fpsStr     : String;

function E2DWndProc(Window : HWND; Msg : Cardinal;
                    wParam, lParam : Longint) : Longint; stdcall;
var
  i : Integer;
begin
  case Msg of
    WM_ACTIVATEAPP : if (wParam = WA_ACTIVE) or (wParam = WA_CLICKACTIVE) then
                       flgActive := True
                     else
                       flgActive := False;  
    WM_DESTROY : begin
                   flgActive := False;
                   for i := 0 to NumFlakes - 1 do
                     SetLength(SnowFlakes[i].Lines, 0);
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

function E2DCreate : Boolean;
var
  res  : E2D_Result;
  i, j : Integer;
begin
  Result := False;
  E2D_InitEngine(E2DWindow);

  E2D_InitEngine(E2DWindow);
  res := E2D_CreateFullscreen(ScreenWidth, ScreenHeight, E2D_SCREEN_FRECDEF);
  if res <> E2DERR_OK then begin
    MessageBox(E2DWindow, E2D_ErrorString(res), 'E2D_CreateFullscreen', MB_ICONSTOP);
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

  SetRect(sr, 0, 0, ScreenWidth, ScreenHeight);
  Randomize;

  for i := 0 to NumFlakes - 1 do
    with SnowFlakes[i] do begin
      CenterX := Random(ScreenWidth);
      CenterY := Random(ScreenHeight);
      SpeedX  := 1 + Random(MaxSpeedX);
      SpeedY  := 1 + Random(MaxSpeedY);
      Angle   := 20 / (1 + Random(10));
      sY1 := -(1 + Random(MaxFlakeSize));
      sY2 := 1 + Random(MaxFlakeSize);
      SetLength(Lines, sY2 - sY1 + 1);
      for j := 0 to sY2 - sY1 do
        with Lines[j] do begin
          sX1 := -(1 + Random(MaxFlakeSize));
          sX2 := 1 + Random(MaxFlakeSize);
        end;
    end;

  LastUpdate := GetTickCount;
  fpsTick := LastUpdate;
  Result := True;
end;

function IntToStr(Value : Longint) : String;
begin
  Str(Value, Result);
end;

procedure OnIdle;
var
  this    : Cardinal;
  i, m, n : Integer;
begin
  this := GetTickCount;
  if this - fpsTick >= 500 then begin
    fpsStr := IntToStr(Round(FPS * 1000 / (this - fpsTick)));
    FPS := 0;
    fpsTick := this;
  end;
  if this - LastUpdate >= UpdateSpeed then begin
    for i := 0 to NumFlakes - 1 do
      with SnowFlakes[i] do begin
        CenterX := CenterX + Round(SpeedX * Sin(Angle));
        CenterY := CenterY + SpeedY;
        Angle := Angle + MaxAngleSpeed * (1 + Random(MaxAngleDif)) / 2;
        if Angle > 2 * Pi then
          Angle := Angle - 2 * Pi;
        if (CenterY + sY1 >= ScreenHeight) then begin
          CenterY := sY1;
          CenterX := Random(SCreenWidth);
          SpeedX := 1 + Random(MaxSpeedX);
          SpeedY := 1 + Random(MaxSpeedY);
        end;
      end;
    LastUpdate := this;
  end;

  E2D_UpdateKeyboard;
  if E2D_IsKeyboardKeyDown(E2DKEY_ESCAPE) then begin
    DestroyWindow(E2DWindow);
    Exit;
  end;
  
  E2D_DrawRect($0007, @sr);
  if E2D_BeginEffects = E2DERR_OK then begin
    for i := 0 to NumFlakes - 1 do
      with SnowFlakes[i] do begin
        for m := sY1 to sY2 do
          with Lines[m - sY1] do begin
            for n := sX1 to sX2 do
              E2D_PutPoint(CenterX + n, CenterY + m, SnowColor);
          end;
      end;
    E2D_EndEffects;
  end;

  E2D_DrawText(gFont, PChar(fpsStr), 0, 0, Length(fpsStr));
  E2D_ShowBuffer;
  FPS := FPS + 1;
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
