(************************************* Ext2D Engine *************************************)
(* ������     : E2DPhysic.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 27.08.06                                                                *)
(* ���������� : ������ ������� ������� ��� ����������� ������������.                    *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DPhysic;

interface

uses
  E2DTypes, Windows;

  { ������� ��� ����������� ������������. ��������� :
      Image1ID, Image2ID  : �������������� �����������, ��� �������� ������� ����������
                            ���������� ������������;
      Place1, Place2      : ����� ������������ ����������� �� ������;
      Collision           : ���������� ��� ���������� ���������� ������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetCollision(Image1ID, Image2ID : E2D_TImageID;
                            ImageRect1, ImageRect2 : PRect; Place1, Place2 : PPoint;
                            var Collision : Boolean) : E2D_Result; stdcall; export;

implementation

uses
  E2DConsts, { ��� �������� ������ � ������ }
  E2DVars;   { ��� ����������� }

function E2D_GetCollision;
var
  ir         : TRect;      { ������������� ����������� �� ������ }
  sr1, sr2   : TRect;      { �������������� �� ������ }
  ir1, ir2   : TRect;      { �������������� ����������� }
  cv1, cv2   : E2D_TColor; { ����� �������� }
  i, j       : Longword;   { �������� ����� }
  ofs1, ofs2 : Longword;   { �������� ������� }
label
  OnOK; { ���������� ������� }
begin { E2D_GetCollision }
  // ������������� ������������.
  Collision := False;

  // ��������� �������������� �����������.
  if (Image1ID >= NumImages) or (Image2ID >= NumImages) then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� �������������� �� ������ ��� �������
    SetRect(sr1, Place1^.X, Place1^.Y, Place1^.X + ImageRect1^.Right - ImageRect1^.Left,
            Place1^.Y + ImageRect1^.Bottom - ImageRect1^.Top);
    // � ������� �����������
    SetRect(sr2, Place2^.X, Place2^.Y, Place2^.X + ImageRect2^.Right - ImageRect2^.Left,
            Place2^.Y + ImageRect2^.Bottom - ImageRect2^.Top);

    // � �������� �������������� �� ������.
    IntersectRect(ir, sr1, sr2);
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ��������� �����������.
  if (ir.Left = 0) and (ir.Right = 0) and (ir.Top = 0) and (ir.Bottom = 0) then
    // ���� ����������� ��� ��������� �������.
    goto OnOK;

  // ���������� �������������� ����������� ��� �������
  ir1 := ir;
  // � ������� �������.
  ir2 := ir;

  // �������� �������������� ��� �������
  OffsetRect(ir1, -Place1^.X, -Place1^.Y);
  // � ������� �������.
  OffsetRect(ir2, -Place2^.X, -Place2^.Y);

  {$WARNINGS OFF}
  // ��������� ������� �������� ��� �������
  ofs1 := Longword(Images[Image1ID].Data) + (ImageRect1^.Top + ir1.Top) *
                   E2D_SCREEN_BYTESPP * Images[Image1ID].Info.Width;
  // � ������� ��������.
  ofs2 := Longword(Images[Image2ID].Data) + (ImageRect2^.Top + ir2.Top) *
                   E2D_SCREEN_BYTESPP * Images[Image2ID].Info.Width;

  // �������� ��������� �������� �������� � ��������������.
  for j := 0 to ir.Bottom - ir.Top - 1 do begin { for }
    // ��������� ����� �������� ��� �������
    ofs1 := ofs1 + (ImageRect1^.Left + ir1.Left) * E2D_SCREEN_BYTESPP;
    // � ������� ��������.
    ofs2 := ofs2 + (ImageRect2^.Left + ir2.Left) * E2D_SCREEN_BYTESPP;

    // ��������� �������� �������� � ��������������.
    for i := 0 to ir.Right - ir.Left - 1 do begin { for }
      // �������� ������� ��� �������
      cv1 := E2D_PColor(ofs1)^;
      // � ������� ��������.
      cv2 := E2D_PColor(ofs2)^;

      // ���������� �������� ��������.
      if (cv1 <> E2D_SCREEN_COLORKEY) and (cv2 <> E2D_SCREEN_COLORKEY) then begin { if }
        // ���� ��� ��� ������� �� ����� ���� ������������� ������������
        Collision := True;
        // � ������� �� �����.
        goto OnOK;
      end; { if }

      // ����������� �������� �������
      ofs1 := ofs1 + E2D_SCREEN_BYTESPP;
      // � ������� ��������.
      ofs2 := ofs2 + E2D_SCREEN_BYTESPP;
    end; { for }

    // ��������� ����� �������� ��� �������
    ofs1 := ofs1 + (ImageRect1^.Right - ir1.Right +
                    Images[Image1ID].Info.Width - ImageRect1^.Right) * E2D_SCREEN_BYTESPP;
    // � ������� ��������.
    ofs2 := ofs2 + (ImageRect2^.Right - ir2.Right +
                    Images[Image2ID].Info.Width - ImageRect2^.Right) * E2D_SCREEN_BYTESPP;
    {$WARNINGS ON}
  end; { for }

OnOK :
  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_GetCollision }

end.
