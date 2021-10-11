(************************************* Ext2D Engine *************************************)
(* ������     : E2DSelect.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 21.10.06                                                                *)
(* ���������� : ������ ������� ������� ��� ������������� ������ ��������.               *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DSelect;

interface

uses
  E2DTypes, Windows;

  { ������� ��� �������� ����������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateSelection : E2D_Result; stdcall; export;

  { ������� ��� ������ ����������� �� ����������� ������. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������ (��� ������ ����� ����������� ������
                �������� ����� ���� nil);
      Place   : ����� ������������ ����������� �� ����������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawImageToSelect(ImageID : E2D_TImageID; ImgRect : PRect;
                                 Place : PPoint) : E2D_Result; stdcall; export;

  { ������� ��� ��������� �������������� �� ����������� ������. ��������� :
      Color : ���� ��������������;
      Rect  : �������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawRectToSelect(Color : E2D_TColor;
                                Rect : PRect) : E2D_Result; stdcall; export;

  { ������� ��� ������� ����������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_ClearSelect : E2D_Result; stdcall; export;

  { ������� ��� ���������� � ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_BeginSelection : E2D_Result; stdcall; export;

  { ������� ��� ���������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EndSelection : E2D_Result; stdcall; export;
  
  { ������� ��� ������������� ������. ��������� :
      X, Y : ���������� �����, ��� ������� �������������� �����.
    ������������ �������� : ���� ������� �����������. }
  function E2D_GetSelectionVal(X, Y : Longword) : E2D_TColor; stdcall; export;

implementation

uses
  E2DConsts,  { ��� �������� ������ }
  E2DVars,    { ��� ���������� ������ }
  E2DManager, { ��� �������� ����������� }
  E2DScreen,  { ��� �������������� ������������ }
  DirectDraw; { ��� ������� DirectDraw }

var
  { ��������� �� ����������� ������ }
  SS_Pointer : Pointer = nil;
  { ������ ������ ������� ����������� ������ � ������ }
  SS_Pitch : Longword = 0;

function E2D_CreateSelection;
var
  ii : E2D_TImageInfo; { ������� ����������� }
begin { E2D_CreateSelection }
  // ��������� ������
  ii.Width := Screen_Width;
  // � ������ �����������.
  ii.Height := Screen_Height;

  // ������� �����������.
  if CreateSurface(DDS_Selection, @ii) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_CREATESURF;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_CreateSelection }

function E2D_DrawImageToSelect;
var
  Rect   : TRect;  { ������ ������������� ����������� }
  Point  : TPoint; { ������ ��������� �� ����������� ������ }
begin { E2D_DrawImageToSelect }
  // ��������� ������������� �����������.
  if ImageID >= NumImages then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ������������� �����������
  Rect  := ImgRect^;
  // � ��� ��������� �� �� ����������� ������.
  Point := Place^;

  // ��������� ������������� ������.
  if not CorrectRectS(@Rect, @Point) then
    //  ���� ��� ����� ������� ����������� �� ����������� ������.
    if DDS_Selection.BltFast(Point.X, Point.Y, Images[ImageID].Surface, @Rect,
                             DDBLTFAST_WAIT or
                             DDBLTFAST_SRCCOLORKEY) <> DD_OK then begin { if }
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_SCREEN_CANTDRAW;
      // � ������� �� �������.
      Exit;
    end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_DrawImageToSelect }

function E2D_DrawRectToSelect;
var
  blt   : TDDBltFX; { ��������� ��� ���������� �������������� }
  cRect : TRect;    { ������ ������������� }
begin { E2D_DrawRectToSelect }
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
    if DDS_Selection.Blt(@cRect, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                         @blt) <> DD_OK then begin { if }
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_SCREEN_CANTDRAW;
      // � ������� �� �������.
      Exit;
    end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_DrawRectToSelect }

function E2D_ClearSelect;
var
  blt : TDDBltFX; { ��������� ��� ������� ����������� ������ }
begin { E2D_ClearSelect }
  // �������� ���������.
  ZeroMemory(@blt, SizeOf(blt));
  // ��������� ���� ������� ��������� ��������� : �����
  blt.dwSize := SizeOf(blt);
  // � ���� ����������.
  blt.dwFillColor := E2D_SCREEN_COLORKEY;

  // ������� ����������� ������.
  if DDS_Selection.Blt(nil, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                       @blt) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SCREEN_CANTCLEAR;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_ClearSelect }

function E2D_BeginSelection;
var
  ddsd : TDDSurfaceDesc2; { ��������� ��� �������� ����������� }
begin { E2D_BeginSelection }
  // �������� ���������.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // ��������� ���� ������� ��������� �������� �����������.
  ddsd.dwSize := SizeOf(ddsd);

  // ��������� ����������� ������.
  if DDS_Selection.Lock(nil, ddsd, DDLOCK_WAIT, 0) = DD_OK then begin { if }
    // ���� ���������� ��������� ��������� �� ����������� ������,
    SS_Pointer := ddsd.lpSurface;
    // ������ ������ � ������
    SS_Pitch := ddsd.lPitch;
    // � ������ ��������� ��������.
    Result := E2DERR_OK;
  end else { if }
    // ���� �� ���������� �������� ��� ������ � ���������.
    Result := E2DERR_MANAGE_CANTLOCK;
end; { E2D_BeginSelection }

function E2D_EndSelection;
begin { E2D_EndSelection }
  // ������� ��������� �� ����������� ������.
  SS_Pointer := nil;
  // �������� ������ ������ � ������.
  SS_Pitch := 0;
  // �������� ����������� ������.
  DDS_Selection.Unlock(nil);
  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_EndSelection }

function E2D_GetSelectionVal;
begin { E2D_GetSelectionVal }
  // ��������� �� ����� �� �� ������� �����������.
  if (X >= Screen_Width) or (Y >= Screen_Height) then
    // ���� ����� �������� � ��������� 0.
    Result := 0
  else
    // ���� ��� �������� � ��������� ���� �������.
    Result := E2D_PColor(Longword(SS_Pointer) + Y * SS_Pitch + X * E2D_SCREEN_BYTESPP)^;
end; { E2D_GetSelectionVal }

end.
