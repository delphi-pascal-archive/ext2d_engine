(************************************* Ext2D Engine *************************************)
(* ������     : E2DEffects.pas                                                          *)
(* �����      : ���� ��������                                                           *)
(* ������     : 23.10.06                                                                *)
(* ���������� : ������ ������� ������� ��� ������ ������� �� ����� � ��������������     *)
(*              ���������� ��������.                                                    *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DEffects;

interface

uses
  E2DTypes, Windows;

  { ������� ��� ���������� � ������ ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_BeginEffects : E2D_Result; stdcall; export;

  { ������� ��� ���������� ������ ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EndEffects : E2D_Result; stdcall; export;

  { ������� ��� ������ ����������� ����������� �� �����. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������;
      Place   : ����� ������������ ����������� �� ������;
      Alpha   : ����������� ������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EffectBlend(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                           Alpha : E2D_TAlpha) : E2D_Result; stdcall; export;

  { ������� ��� ������ ����������� ����������� �� ����� � �������������� ����� �����.
    ��������� :
      ImageID     : ������������� �����������, ������� ���������� �������;
      MaskImageID : ������������� ����������� ����� �����;
      ImgRect     : ������������� ����������� ��� ������;
      Place       : ����� ������������ ����������� �� ������;
      MaskPlace   : ����� ������������ ����������� ����� �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EffectAlphaMask(ImageID, MaskImageID : E2D_TImageID; ImgRect : PRect;
                               Place, MaskPlace : PPoint) : E2D_Result; stdcall; export;

  { ������� ��� ������ ����������� �� ����� � �������������� ����������������� �������.
    ��������� :
      ImageID   : ������������� �����������, ������� ���������� �������;
      ImgRect   : ������������� ����������� ��� ������;
      Place     : ����� ������������ ����������� �� ������;
      ColorCalc : ������� ��� ���������� ����� �������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EffectUser(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                          ColorCalc : E2D_TColorCalcFunc) : E2D_Result; stdcall; export;

  { ��������� ��� ������ �� ����� �����. ��������� :
      X, Y  : ����� ������������ ����� �� ������;
      Color : ���� �����. }
  procedure E2D_PutPoint(X, Y : Longword; Color : E2D_TColor); stdcall; export;

implementation

uses
  E2DScreen,  { ��� �������� ��������������� }
  E2DConsts,  { ��� �������� ������ }
  E2DVars,    { ��� ���������� DirectDraw � ������ }
  DirectDraw; { ��� ������� DirectDraw }

var
  { ������������� ������ }
  ScreenRect : TRect;
  { ��������� �� ������ ����� }
  BB_Pointer : Pointer = nil;
  { ������ ������ ������� ������ � ������ }
  BB_Pitch : Longword = 0;

function E2D_BeginEffects;
var
  ddsd : TDDSurfaceDesc2; { ��������� ��� �������� ����������� }
begin { E2D_BeginEffects }
  // ������ ������������� ������.
  SetRect(ScreenRect, 0, 0, Screen_Width, Screen_Height);

  // �������� ���������.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // ��������� ���� ������� ��������� �������� �����������.
  ddsd.dwSize := SizeOf(ddsd);

  // ��������� ������ �����.
  if DDS_BackBuffer.Lock(@ScreenRect, ddsd, DDLOCK_WAIT, 0) = DD_OK then begin { if }
    // ���� ���������� ��������� ��������� �� ������ �����,
    BB_Pointer := ddsd.lpSurface;
    // ������ ������ � ������
    BB_Pitch := ddsd.lPitch;
    // � ������ ��������� ��������.
    Result := E2DERR_OK;
  end else { if }
    // ���� �� ���������� �������� ��� ������ � ���������.
    Result := E2DERR_MANAGE_CANTLOCK;
end; { E2D_BeginEffects }

function E2D_EndEffects;
begin { E2D_EndEffects }
  // ������� ��������� �� ������ �����.
  BB_Pointer := nil;
  // �������� ������ ������ � ������.
  BB_Pitch := 0;
  // �������� ������ �����.
  DDS_BackBuffer.Unlock(@ScreenRect);
  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_EndEffects }

var
  a : E2D_TAlpha;

function E2D_EffectBlend;

  { ������� ��� ���������� ����� �������. ��������� :
      SrcColor : ���� ���������;
      DstColor : ���� ���������.
    ������������ �������� : ���� ������� � ������ ������������. }
  function CalcBlend(SrcColor, DstColor : E2D_TColor) : E2D_TColor; assembler; stdcall;
  asm
    PUSH ESI
    PUSH EDI

    MOV ESI, DWORD(DstColor)
    AND ESI, $1F
    MOV EDI, DWORD(SrcColor)
    AND EDI, $1F

    SUB  EDI, ESI
    MOV  EAX, DWORD(a)
    IMUL EDI
    SHR  EAX, 8
    ADD  EAX, ESI
    PUSH EAX

    MOV ESI, DWORD(DstColor)
    SHR ESI, 5
    AND ESI, $3F
    MOV EDI, DWORD(SrcColor)
    SHR EDI, 5
    AND EDI, $3F

    SUB  EDI, ESI
    MOV  EAX, DWORD(a)
    IMUL EDI
    SHR  EAX, 8
    ADD  EAX, ESI
    SHL  EAX, 5
    PUSH EAX

    MOV ESI, DWORD(DstColor)
    SHR ESI, 11
    AND ESI, $1F
    MOV EDI, DWORD(SrcColor)
    SHR EDI, 11
    AND EDI, $1F

    SUB  EDI, ESI
    MOV  EAX, DWORD(a)
    IMUL EDI
    SHR  EAX, 8
    ADD  EAX, ESI
    SHL  EAX, 11

    POP EDI
    ADD EAX, EDI
    POP EDI
    ADD EAX, EDI

    POP EDI
    POP ESI
  end; { asm }

begin { E2D_EffectBlend }
  // ��������� �����������.
  a := Alpha;
  // ������� ���������� �����������.
  Result := E2D_EffectUser(ImageID, ImgRect, Place, @CalcBlend);
end; { E2D_EffectBlend }

function E2D_EffectAlphaMask;
var
  i, j       : Longword;   { �������� ����� }
  sC, dC, aC : E2D_TColor; { �������� �������� ���������, ��������� � ����� ����� }
  sB, dB, B  : Byte;       { ����� ������������ �������� }
  sG, dG, G  : Byte;       { ������� ������������ �������� }
  sR, dR, R  : Byte;       { ������� ������������ �������� }
  Alpha      : E2D_TAlpha; { ����������� ������������ }
  iofs, aofs : Longword;   { �������� ������� }
  wrkP       : E2D_PColor; { ��������� �� ������ }
  Rect       : TRect;      { ������ ������������� ����������� }
  ImgPoint   : TPoint;     { ������ ��������� �� ������ ����������� }
  MaskPoint  : TPoint;     { ������ ��������� ����������� ����� ����� }
label
  OnOK; { ���������� ������� }
begin { E2D_EffectAlphaMask }
  // ��������� �������������� �����������.
  if (ImageID >= NumImages) or (MaskImageID >= NumImages) then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ������������� �����������
  Rect      := ImgRect^;
  // � ��� ��������� �� ������
  ImgPoint  := Place^;
  // � ������������ ����������� ����� �����.
  MaskPoint := MaskPlace^;

  // ��������� ������������� ������.
  if CorrectRectS(@Rect, @ImgPoint) then
    // ���� ��� �� ����� �������� ��������� �������.
    goto OnOK;
  // ��������� ����� ������������ ����������� ����� ����� �� �����������
  MaskPoint.X := MaskPoint.X + (Rect.Left - ImgRect^.Left);
  // � ���������.
  MaskPoint.Y := MaskPoint.Y + (Rect.Top - ImgRect^.Top);

  {$WARNINGS OFF}
  // ��������� ������� �������� �����������
  iofs := Longword(Images[ImageID].Data) +
          Rect.Top * E2D_SCREEN_BYTESPP * Images[ImageID].Info.Width;
  // � ����� �����.
  aofs := Longword(Images[MaskImageID].Data) +
          MaskPoint.Y * E2D_SCREEN_BYTESPP * Images[MaskImageID].Info.Width;

  // ����������� ������� ���������� �����������.
  for j := 0 to Rect.Bottom - Rect.Top - 1 do begin { for }
    // ��������� ����� �������� �����������
    iofs := iofs + Rect.Left * E2D_SCREEN_BYTESPP;
    // � ����� �����.
    aofs := aofs + MaskPoint.X * E2D_SCREEN_BYTESPP;

    // ����������� ������� ���������� �����������.
    for i := 0 to Rect.Right - Rect.Left - 1 do begin { for }
      // �������� ������ ���������.
      sC := E2D_PColor(iofs)^;

      // ��������� ���� �� �������� ������ ������.
      if sC <> E2D_SCREEN_COLORKEY then begin { if }
        // ���� ���� ���������� ���������
        wrkP := E2D_PColor(Longword(BB_Pointer) + (ImgPoint.Y + j) * BB_Pitch +
                           (ImgPoint.X + i) * E2D_SCREEN_BYTESPP);
        // � �������� ������ ���������.
        dC := wrkP^;

        // �������� ����� ������������ ���������
        sB := sC and $1F;
        // � ���������,
        dB := dC and $1F;
        // ������� ������������ ���������
        sG := (sC shr 5) and $3F;
        // � ���������
        dG := (dC shr 5) and $3F;
        // � ������� ������������ ���������
        sR := (sC shr 11) and $1F;
        // � ���������.
        dR := (dC shr 11) and $1F;

        // �������� ������ ����� �����.
        aC := E2D_PColor(aofs)^;
        // ��������� ����������� ������������ ��� �������.
        Alpha := Trunc(aC / High(E2D_TColor) * High(E2D_TAlpha));

        // ��������� ����� �������� �����,
        B := (Alpha * (sB - dB) shr 8) + dB;
        // �������
        G := (Alpha * (sG - dG) shr 8) + dG;
        // � ������� ������������.
        R := (Alpha * (sR - dR) shr 8) + dR;

        // ������������� ����� ������ ���������.
        wrkP^ := B or (G shl 5) or (R shl 11);
      end; { if }

      // ����������� �������� �����������
      iofs := iofs + E2D_SCREEN_BYTESPP;
      // � ����� �����.
      aofs := aofs + E2D_SCREEN_BYTESPP;
    end; { for }

    // ��������� ����� �������� �����������
    iofs := iofs + (Images[ImageID].Info.Width - Rect.Right) * E2D_SCREEN_BYTESPP;
    // � ����� �����.
    aofs := aofs + (Images[MaskImageID].Info.Width - Rect.Right) * E2D_SCREEN_BYTESPP;
    {$WARNINGS ON}
  end; { for }

OnOK :
  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_EffectAlphaMask }

function E2D_EffectUser;
var
  ofs, ofsS : Longword; { �������� ������ }
  Rect      : TRect;    { ������ ������������� ����������� }
  Point     : TPoint;   { ������ ��������� �� ������ }
  irw, irh  : Longword; { ������� ����������� }
  iw        : Longword; { ������ ����������� }
label                    
  OnOK; { ���������� ������� }
begin { E2D_EffectUser }
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
  if CorrectRectS(@Rect, @Point) then
    // ���� ��� �� ����� �������� ��������� �������.
    goto OnOK;

  {$WARNINGS OFF}
  // ��������� ������� ��������.
  ofs := Longword(Images[ImageID].Data) +
         Rect.Top * E2D_SCREEN_BYTESPP * Images[ImageID].Info.Width;
  // ��������� ������� �������� ��� ������.
  ofsS := Longword(BB_Pointer) + Point.Y * BB_Pitch;

  // ��������� ������
  irw := Rect.Right - Rect.Left;
  // � ������ �������������� �����������
  irh := Rect.Bottom - Rect.Top;
  // � ������ ��������� �����������.
  iw  := Images[ImageID].Info.Width;

  asm
    MOV ESI, ofs
    MOV EDI, ofsS

    XOR EBX, EBX
  @@CycleY :
    CMP EBX, irh
    JE  OnOK

    MOV EAX, E2D_SCREEN_BYTESPP
    MUL Rect.Left
    ADD ESI, EAX

    PUSH EBX
    XOR ECX, ECX
  @@CycleX :
    CMP ECX, irw
    JE  @@DoneX

    MOV  BX, WORD PTR [ESI]
    CMP  BX, E2D_SCREEN_COLORKEY
    JE   @@IsColorKey

    PUSH EDI
    MOV  EAX, Point.X
    ADD  EAX, ECX
    ADD  EDI, EAX
    ADD  EDI, EAX

    PUSH ESI
    MOV  SI, WORD PTR [EDI]
    PUSH EBX
    PUSH ESI
    CALL ColorCalc
    MOV  WORD PTR [EDI], AX
    POP  ESI
    POP  EDI

  @@IsColorKey :
    ADD ESI, E2D_SCREEN_BYTESPP
    INC ECX
    JMP @@CycleX

  @@DoneX :
    POP EBX
    MOV EAX, iw
    SUB EAX, Rect.Right
    ADD ESI, EAX
    ADD ESI, EAX
    ADD EDI, BB_Pitch
    INC EBX
    JMP @@CycleY
  end; { asm }

OnOK :
  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_EffectUser }

procedure E2D_PutPoint;
begin { E2D_PutPoint }
  // ���������, �� ����� �� �� ������� ������.
  if (X < Screen_Width) and (Y < Screen_Height) then
    // ���� ��� ������������� ����� ���� �����.
    E2D_PColor(Longword(BB_Pointer) + Y * BB_Pitch + X * E2D_SCREEN_BYTESPP)^ := Color;
end; { E2D_PutPoint }

end.
