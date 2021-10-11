(************************************* Ext2D Engine *************************************)
(* ������     : E2DScreen.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 30.10.06                                                                *)
(* ���������� : ������ ������� ������� ��� ������ ������� �� �����.                     *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DScreen;

interface

uses
  E2DTypes, Windows, DirectDraw;

  { ������� ��� �������� �������� DirectDraw � �������� � ������������� ����������.
    ��������� :
      ScreenWidth  : ������ ������;
      ScreenHeight : ������ ������;
      Frec         : ������� ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateFullscreen(ScreenWidth, ScreenHeight,
                                Frec : Longword) : E2D_Result; stdcall; export;

  { ������� ��� ��������� �������� ��������� ������. ��������� :
      Desc : ��������� �� ��������� E2D_TDeviceDesc ��� ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetDeviceDesc(Desc : E2D_PDeviceDesc) : E2D_Result; stdcall; export;

  { ������� ��� �������� ������������ �������������� ������. ��������� :
      Rect  : �������������, ������� ���������� ���������;
      Place : ������������ �������������� �� ������.
    ������������ �������� : ���� ������� ����������� ������� - True, ���� �������� -
                            False. }
  function CorrectRectS(Rect : PRect; Place : PPoint) : Boolean; register;

  { ������� ��� �������� ������������ ��������������. ��������� :
      Rect : �������������, ������� ���������� ���������.
    ������������ �������� : ���� ������� ����������� ������� - True, ���� �������� -
                            False. }
  function CorrectRectR(Rect : PRect) : Boolean; register;

  { ������� ��� ������ ����������� �� �����. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������ (��� ������ ����� ����������� ������
                �������� ����� ���� nil);
      Place   : ����� ������������ ����������� �� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawImage(ImageID : E2D_TImageID; ImgRect : PRect;
                         Place : PPoint) : E2D_Result; stdcall; export;

  { ������� ��� ������ ����������� ����������� �� �����. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������ (��� ������ ����� ����������� ������
                �������� ����� ���� nil);
      DstRect : ������������� ����������� �� ������ (��� ������ ����������� �� ���� �����
                ������ �������� ����� ���� nil).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_StretchDraw(ImageID : E2D_TImageID;
                           ImgRect, DstRect : PRect) : E2D_Result; stdcall; export;

  { ������� ��� ������ �� ����� ������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_ShowBuffer : E2D_Result; stdcall; export;


  { ������� ��� ������� ������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_ClearBuffer : E2D_Result; stdcall; export;

  { ������� ��� �������������� ������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_RestoreSurfaces : E2D_Result; stdcall; export;

  { ������� ��� ������ ������. ��������� :
      FontID : ������������� ������, ������� ���������� ������� �����;
      Text   : ��������� �� ������, ������� ���������� �������;
      X, Y   : ������� ������ �� ������;
      Size   : ����� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawText(FontID : E2D_TFontID; Text : PChar; X, Y : Longword;
                        Size : Longword) : E2D_Result; stdcall; export;

  { ������� ��� ��������� ��������������. ��������� :
      Color : ���� ��������������;
      Rect  : �������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawRect(Color : E2D_TColor; Rect : PRect) : E2D_Result; stdcall; export;

  { ������� ��� ��������� ������� ������.
    ������������ �������� : �������. }
  function E2D_GetGamma : E2D_TGamma; stdcall; export;

  { ������� ��� ��������� ������� ������. ��������� :
      Gamma : �������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetGamma(Gamma : E2D_TGamma) : E2D_Result; stdcall; export;

  { ������� ��� ��������� ������� �������� ������������. ��������� :
      R, G, B : ������� ��������, �������� � ������ �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetRGBGamma(R, G, B : E2D_TGamma) : E2D_Result; stdcall; export;

  { ������� ��� ����������� ��������� �����������. ��������� :
      ImageID : ������������� �����������, ������� ���������� ��������;
      FlipHor : ��������� �� ����������� (����� �������);
      FlipVer : ��������� �� ��������� (������ ����).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_FlipImage(ImageID : E2D_TImageID;
                         FlipHor, FlipVer : Boolean) : E2D_Result; stdcall; export;

implementation

uses
  E2DVars,    { ��� ���������� ������ }
  E2DConsts,  { ��� �������� ������ }
  E2DManager; { ��� ����������� ����������� }

function E2D_CreateFullscreen;
var
  ddsd : TDDSurfaceDesc2; { ��������� ��� �������� ����������� }
  caps : TDDSCaps2;       { ��������� ��� �������� ������� ������ }
  rect : TRect;           { ������������� ������ }

  { ��������� ��� �������� �������� DirectDraw. }
  procedure ClearDDObjects;
  begin { ClearDDObjects }
    // ������� ������ �����.
    DDS_BackBuffer := nil;
    // ������� ��������� �����������.
    DDS_Primary    := nil;
    // ������� ������� ������ DirectDraw.
    DD_Main        := nil;
  end; { ClearDDObjects }

begin { E2D_CreateFullscreen }
  // ������� ������� ������ DirectDraw.
  if DirectDrawCreateEx(nil, DD_Main, IID_IDirectDraw7, nil) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_CREATEDD;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������� ����������.
  if DD_Main.SetCooperativeLevel(Window_Handle, DDSCL_EXCLUSIVE or
                                 DDSCL_FULLSCREEN) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // ������� ������� ������ DirectDraw
    DD_Main := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� � ����� ����������.
  if DD_Main.SetDisplayMode(ScreenWidth, ScreenHeight, E2D_SCREEN_BITSPP, Frec,
                            0) <> DD_OK then begin  { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SCREEN_SETDISPMD;
    // ������� ������� ������ DirectDraw
    DD_Main := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� ���������.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // ��������� ���� ��������� �������� ����������� :
  with ddsd do begin { with }
    // ������ ���������,
    dwSize            := SizeOf(ddsd);
    // �����,
    dwFlags           := DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
    // �������� �����������
    ddsCaps.dwCaps    := DDSCAPS_PRIMARYSURFACE or DDSCAPS_FLIP or DDSCAPS_COMPLEX;
    // � ���������� ������ �������.
    dwBackBufferCount := 1;
  end; { with }

  // ������� ��������� �����������.
  if DD_Main.CreateSurface(ddsd, DDS_Primary, nil) <> DD_OK then begin  { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SCREEN_CREATESURF;
    // ������� ������� ������ DirectDraw
    DD_Main := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� ���������.
  ZeroMemory(@caps, SizeOf(caps));
  // ��������� ���� ������� ��������� �������� ������� ������.
  caps.dwCaps := DDSCAPS_BACKBUFFER;

  // ������� ������ �����.
  if DDS_Primary.GetAttachedSurface(caps, DDS_BackBuffer) <> DD_OK then begin  { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SCREEN_CREATESURF;
    // ������� ��������� �����������,
    DDS_Primary := nil;
    // ������� ������� ������ DirectDraw
    DD_Main     := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������������� ������.
  SetRect(rect, 0, 0, ScreenWidth, ScreenHeight);

  // ������� ������ ����� ��������.
  if DDS_Primary.QueryInterface(IID_IDirectDrawGammaControl,
                                DDG_Main) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SCREEN_CREATEGAM;
    // ������� ������� DirectDraw
    ClearDDObjects;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ������
  Screen_Width  := ScreenWidth;
  // � ������ ������.
  Screen_Height := ScreenHeight;
  // ��������� ������.
  ShowCursor(False);

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_CreateFullscreen }

function E2D_GetDeviceDesc;
var
  ddcaps : TDDCaps;              { ��������� �������� ������� �������� ������� }
  dddi   : TDDDeviceIdentifier2; { ��������� �������� �������� ������� }
begin { E2D_GetDeviceDesc }
  // �������� ���������.
  ZeroMemory(@ddcaps, SizeOf(ddcaps));
  // ��������� ���� ������� ��������� �������� �������.
  ddcaps.dwSize := SizeOf(ddcaps);
  // �������� �������� �������� �������.
  if DD_Main.GetCaps(@ddcaps, nil) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_GETDESCR;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� �������� �������� �������.
  if DD_Main.GetDeviceIdentifier(dddi, 0) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_GETDESCR;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ������ ��� �����.
    GetMem(Desc^.Name, MAX_DDDEVICEID_STRING);
    // �������� ��������� ���,
    CopyMemory(Desc^.Name, @dddi.szDescription, MAX_DDDEVICEID_STRING);
    // �����
    Desc^.tVidMem := ddcaps.dwVidMemTotal;
    // � ��������� ����� ����������
    Desc^.aVidMem := ddcaps.dwVidMemFree;
    // � ��������� ����� �������� ����������.
    Desc^.Gamma := ((ddcaps.dwCaps2 and DDCAPS2_PRIMARYGAMMA) <> 0);
  except
     // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end;

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_GetDeviceDesc }

function CorrectRectS;
var
  irw, irh : Longword; { ������� �������������� }
begin { CorrectRectS }
  // ������ ��������� ���������.
  Result := False;
  // ��������� ������
  irw := Rect^.Right - Rect^.Left;
  // � ������ �������������� �����������.
  irh := Rect^.Bottom - Rect^.Top;

  // ��������� �� ����� �� �� ����� ������� ������.
  if Place^.X < 0 then
    // ���� ����� ��������� ��������� ��� ���.
    if Place^.X < - irw then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else begin { else }
      // ���� ��� ��������� ����� ������ ��������������
      Rect^.Left := Rect^.Left - Place^.X;
      // � ��� ��������� �� �����������.
      Place^.X := 0;
    end; { else }

  {$WARNINGS OFF}
  // ��������� �� ����� �� �� ������ ������� ������.
  if Place^.X > Screen_Width - irw then
    // ���� ����� ��������� ��������� ��� ���.
    if Place^.X > Screen_Width then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else { if }
      // ���� ��� ��������� ����� ������ ��������������.
      Rect^.Right := Rect^.Right - (Place^.X + irw - Screen_Width);

  // ��������� �� ����� �� �� ������� ������� ������.
  if Place^.Y < 0 then
    // ���� ����� ��������� ��������� ��� ���.
    if Place^.Y < - irh then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else begin { else }
      // ���� ��� ��������� ����� ������ ��������������
      Rect^.Top  := Rect^.Top - Place^.Y;
      // � ��� ��������� �� ���������.
      Place^.Y := 0;
    end; { else }

  // ��������� �� ����� �� �� ������� ������� ������.
  if Place^.Y > Screen_Height - irh then
    // ���� ����� ��������� ��������� ��� ���.
    if Place^.Y > Screen_Height then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else { if }
      // ���� ��� ��������� ����� ������ ��������������.
      Rect^.Bottom := Rect^.Bottom - (Place^.Y + irh - Screen_Height);
  {$WARNINGS ON}
end; { CorrectRectS }

function CorrectRectR;
begin { CorrectRectR }
  // ������ ��������� ���������.
  Result := False;

  // ��������� �� ����� �� �� ����� ������� ������.
  if Rect^.Left < 0 then
    // ���� ����� ��������� ��������� ��� ���.
    if Rect^.Right < 0 then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else { if }
      // ���� ��� ������������� ����� ������ ��������������.
      Rect^.Left := 0;

  {$WARNINGS OFF}
  // ��������� �� ����� �� �� ������ ������� ������.
  if Rect^.Right > Screen_Width then
    // ���� ����� ��������� ��������� ��� ���.
    if Rect^.Left > Screen_Width then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else { if }
      // ���� ��� ������������� ����� ������ ��������������.
      Rect^.Right := Screen_Width;

  // ��������� �� ����� �� �� ������� ������� ������.
  if Rect^.Top < 0 then
    // ���� ����� ��������� ��������� ��� ���.
    if Rect^.Bottom < 0 then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else { if }
      // ���� ��� ������������� ����� ������ ��������������.
      Rect^.Top := 0;

  // ��������� �� ����� �� �� ������ ������� ������.
  if Rect^.Bottom > Screen_Height then
    // ���� ����� ��������� ��������� ��� ���.
    if Rect^.Top > Screen_Height then begin { if }
      // ���� �� ������ �������� ��������
      Result := True;
      // � ������� �� �������.
      Exit;
    end else { if }
      // ���� ��� ������������� ����� ������ ��������������.
      Rect^.Bottom := Screen_Height;
  {$WARNINGS ON}
end; { CorrectRectR }

function E2D_DrawImage;
var
  Rect  : TRect;  { ������ ������������� ����������� }
  Point : TPoint; { ������ ��������� �� ������ }
begin { E2D_DrawImage }
  // ��������� ������������� �����������.
  if ImageID >= NumImages then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ������������� �����������
  Rect  := ImgRect^;
  // � ��� ��������� �� ������.
  Point := Place^;
  
  // ��������� ������������� ������.
  if not CorrectRectS(@Rect, @Point) then
    // ���� ��� ����� ������� ����������� � ������ �����.
    if DDS_BackBuffer.BltFast(Point.X, Point.Y, Images[ImageID].Surface, @Rect,
                              DDBLTFAST_WAIT or
                              DDBLTFAST_SRCCOLORKEY) <> DD_OK then begin { if }
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_SCREEN_CANTDRAW;
      // � ������� �� �������.
      Exit;
    end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_DrawImage }

function E2D_StretchDraw;
begin { E2D_StretchDraw }
  // ��������� ������������� �����������.
  if ImageID >= NumImages then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������� ����������� � ������ �����.
  if DDS_BackBuffer.Blt(DstRect, Images[ImageID].Surface, ImgRect,
                        DDBLT_WAIT or DDBLT_KEYSRC, nil) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_CANTDRAW;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_StretchDraw }

function E2D_ShowBuffer;
var
  res : HRESULT; { ���������� ��� ���������� ���������� }
begin { E2D_ShowBuffer }
  // ��������� ������������ �������.
  res := DDS_Primary.Flip(nil, DDFLIP_WAIT or DDFLIP_NOVSYNC);
  // ��������� ��������� ����������.
  if res <> DD_OK then
    // ���� �� ���������� ��������� ��������� ����������.
    if res = DDERR_SURFACELOST then begin { if }
      // ���� ���������� ��������������� �����������
      Result := E2D_RestoreSurfaces;
      // � ������� �� �������.
      Exit;
    end else begin { else }
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_SCREEN_CANTFLIP;
      // � ������� �� �������.
      Exit;
    end; { else }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_ShowBuffer }

function E2D_ClearBuffer;
var
  blt : TDDBltFX; { ��������� ��� ������� ������ }
begin { E2D_ClearBuffer }
  // �������� ���������.
  ZeroMemory(@blt, SizeOf(blt));
  // ��������� ���� ������� ��������� ��������� : �����
  blt.dwSize := SizeOf(blt);
  // � ���� ����������.
  blt.dwFillColor := E2D_SCREEN_COLORKEY;

  // ������� ������ �����.
  if DDS_BackBuffer.Blt(nil, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                        @blt) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_CANTCLEAR;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_ClearBuffer }

function E2D_RestoreSurfaces;
var
  i : Longword; { ������� ����� }
begin { E2D_RestoreSurfaces }
  // ��������������� ��� �����������.
  if DD_Main.RestoreAllSurfaces <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������.
    Result := E2DERR_SCREEN_CANTRESTORE;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ���������� ����������� �����������.
  if NumImages > 0 then
    // ���� ���� ����������� �������� �� ������������.
    for i := 0 to NumImages - 1 do begin { for }
      // �������� ����������� �� �����������.
      Result := E2D_CopyImage(Images[i].Surface, Images[i].Data);
      // ��������� ��������� ����������.
      if Result <> E2DERR_OK then
        // ���� �� ���������� ������� �� �������.
        Exit;
    end; { for }

  // ��������� ���������� ����������� �������.
  if NumFonts > 0 then
    // ���� ���� ����������� �������� �� ������������.
    for i := 0 to NumFonts - 1 do begin { for }
      // �������� ����������� �� �����������.
      Result := E2D_CopyImage(Fonts[i].Surface, Fonts[i].Data);
      // ��������� ��������� ����������.
      if Result <> E2DERR_OK then
        // ���� �� ���������� ������� �� �������.
        Exit;
    end; { for }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_RestoreSurfaces }

function E2D_DrawText;
var
  i   : Longword;      { ������� ����� }
  cr  : TRect;         { ������������� ������� }
  ci  : E2D_TCharInfo; { ���������� � ������� }
  cw  : Longword;      { ������� ����� ������ }
begin { E2D_DrawText }
  // ��������� ������������� ������.
  if FontID >= NumFonts then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� ����� ������.
  cw := 0;

  // ��������� ����� ������.
  if Size > 0 then
    // ���� ���������� ������� ���������� ��� �������.
    for i := 0 to Size - 1 do begin { for }
      try
        // �������� ��������� ���������� � �������.
        ci := Fonts[FontID].Info.CharsInfo[PByte(Longword(Text) + i)^];
      except
        // ���� �� ���������� �������� ��� ������ � ���������
        Result := E2DERR_SYSTEM_INVPOINTER;
        // � ������� �� �������.
        Exit;
      end;

      // ������ ������������� �������.
      SetRect(cr, ci.X, ci.Y, ci.X + ci.Width, ci.Y + Fonts[FontID].Info.Size);

      // ������� ������.
      if DDS_BackBuffer.BltFast(X + cw, Y, Fonts[FontID].Surface, @cr,
                                DDBLTFAST_WAIT or
                                DDBLTFAST_SRCCOLORKEY) <> DD_OK then begin { if }
        // ���� �� ���������� �������� ��� ������ � ���������
        Result := E2DERR_SCREEN_CANTDRAW;
        // � ������� �� �������.
        Exit;
      end; { if }

      cw := cw + ci.Width;
    end; { for }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_DrawText }

function E2D_DrawRect;
var
  blt   : TDDBltFX; { ��������� ��� ���������� �������������� }
  cRect : TRect;    { ������ ������������� }
begin { E2D_DrawRect }
  // �������� ���������.
  ZeroMemory(@blt, SizeOf(blt));
  // ��������� ���� ������� ��������� ��������� : �����
  blt.dwSize := SizeOf(blt);
  // � ���� ����������.
  blt.dwFillColor := Color;

  // ��������� �������������.
  cRect := Rect^;

  // ��������� �������������.
  if not CorrectRectR(@cRect) then
    // ���� ��� ����� ������ �������������.
    if DDS_BackBuffer.Blt(@cRect, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                          @blt) <> DD_OK then begin { if }
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_SCREEN_CANTDRAW;
      // � ������� �� �������.
      Exit;
    end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_DrawRect }

function E2D_GetGamma;
begin { E2D_GetGamma }
  // �������� � ��������� �������.
  Result := Screen_Gamma;
end; { E2D_GetGamma }

function E2D_SetGamma;
begin { E2D_SetGamma }
  // ������������� ������� ������.
  Result := E2D_SetRGBGamma(Gamma, Gamma, Gamma);
  // ��������� ��������� ����������.
  if Result = E2DERR_OK then
    // ���� ���������� ��������� �������.
    Screen_Gamma := Gamma;
end; { E2D_SetGamma }

function E2D_SetRGBGamma;
var
  ramp : TDDGammaRamp; { ��������� ��� ���������� �������� }
  i    : Longword;     { ������� ����� }
begin { E2D_SetRGBGamma }
  // ������������� ������� �������� ������������ :
  for i := 0 to 255 do begin { for }
    // �������,
    ramp.red[i]   := R * i;
    // �������
    ramp.green[i] := G * i;
    // � �����.
    ramp.blue[i]  := B * i;
  end; { for }

  // ������������� �������.
  if DDG_Main.SetGammaRamp(0, ramp) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_CANTSETGAM;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_SetRGBGamma }

function E2D_FlipImage;
var
  i, j   : Longword;        { �������� ������ }
  c1, c2 : E2D_TColor;      { �������� �������� }
  iw, ih : Longword;        { ������� ����������� }
  adr    : Longword;        { ����� ������ }
begin { E2D_FlipImage }
  // ��������� ������������� �����������.
  if ImageID >= NumImages then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ������,
  iw := Images[ImageID].Info.Width;
  // ������
  ih := Images[ImageID].Info.Height;
  // � ����� ������ �����������.
  adr := Longword(Images[ImageID].Data);

  // ���� ���������� ���������� ����������� �� �����������
  if FlipHor then try
    // �������� ����������� ��������� �����������.
    for j := 0 to ih - 1 do
      for i := 0 to (iw div 2) - 1 do begin { for }
        // ���������� �������� ��������.
        c1 := E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^;
        c2 := E2D_PColor(adr + (j * iw + iw - 1 - i) * E2D_SCREEN_BYTESPP)^;

        // ������ ������� �������.
        E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^ := c2;
        E2D_PColor(adr + (j * iw + iw - 1 - i) * E2D_SCREEN_BYTESPP)^ := c1;
      end; { for }
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ���� ���������� ���������� ����������� �� ���������
  if FlipVer then try
    // �������� ����������� ��������� �����������.
    for i := 0 to iw - 1 do
      for j := 0 to (ih div 2) - 1 do begin { for }
        // ���������� �������� ��������.
        c1 := E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^;
        c2 := E2D_PColor(adr + ((ih - 1 - j) * iw + i) * E2D_SCREEN_BYTESPP)^;

        // ������ ������� �������.
        E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^ := c2;
        E2D_PColor(adr + ((ih - 1 - j) * iw + i) * E2D_SCREEN_BYTESPP)^ := c1;
      end; { for }
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� ����������� �� �����������.
  Result := E2D_CopyImage(Images[ImageID].Surface, Images[ImageID].Data);
end; { E2D_FlipImage }

end.
