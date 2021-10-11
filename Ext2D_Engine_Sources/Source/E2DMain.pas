(************************************* Ext2D Engine *************************************)
(* ������     : E2DMain.pas                                                             *)
(* �����      : ���� ��������                                                           *)
(* ������     : 21.10.06                                                                *)
(* ���������� : ������ ������� ������� ������������� � ������������ ��������, �������   *)
(*              Ext2D Engine.                                                           *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DMain;

interface

  { ��������� ��� ��������� �������������. ��������� :
      WindowHandle : ������ �� ���� ����������. }
  procedure E2D_InitEngine(WindowHandle : Longword); stdcall; export;

  { ��������� ��� �������� ���� ��������� �������� � ������������ ������� ��������. }
  procedure E2D_FreeEngine; stdcall; export;

  { ������� ��� ��������� ������ ���������� Ext2D Engine.
    ������������ �������� : ������� ���� �������� ����� - �������� ������, ������� ���� -
                            �������������� ������; ������� ���� �������� ����� - �����,
                            ������� ���� - ����. }
  function E2D_GetEngineVersion : Longword; stdcall; export;

implementation

uses
  E2DConsts,  { ��� �������� ���������� }
  E2DVars,    { ��� ���������� ������ }
  E2DManager, { ��� �������� �������� }
  Windows;    { ��� ���������� �������� }

procedure E2D_InitEngine;
begin { E2D_InitEngine }
  // ��������� ������ �� ����.
  Window_Handle := WindowHandle;
end; { E2D_InitEngine }

procedure E2D_FreeEngine;
begin { E2D_FreeEngine }
  // ������� �����.
  E2D_DeleteSounds(E2D_MANAGE_DELETEALL);
  // ������� �����������.
  E2D_DeleteImages(E2D_MANAGE_DELETEALL);
  // ������� ������.
  E2D_DeleteFonts(E2D_MANAGE_DELETEALL);

  // ������� ����,
  DID_Mouse    := nil;
  // ����������
  DID_Keyboard := nil;
  // � ������� ������ DirectInput.
  DI_Main      := nil;

  // ������� ������� ������ DirectSound.
  DS_Main := nil;

  // ������� ����������� ������.
  DDS_Selection := nil;

  // ������� ������ �������,
  DDG_Main       := nil;
  // ������ �����,
  DDS_BackBuffer := nil;
  // ��������� �����������
  DDS_Primary    := nil;
  // � ������� ������ DirectDraw.
  DD_Main        := nil;

  // �������� ������� ������� �� �����������
  Cursor_X  := 0;
  // � ���������.
  Cursor_Y  := 0;
  // �������� ���������� ������� ������� �� �����������
  Cursor_dX := 0;
  // � ���������.
  Cursor_dY := 0;
  // �������� ������ ����������
  ZeroMemory(@Keyboard_Data, SizeOf(Keyboard_Data));
  // � ����.
  ZeroMemory(@Mouse_Data, SizeOf(Mouse_Data));

  // ������������� ���������� ���������.
  Volume_Global := E2D_SOUND_MAXVOLUME;

  // �������� ������
  Screen_Width  := 0;
  // � ������
  Screen_Height := 0;
  // � ������������� ������� ������.
  Screen_Gamma  := 256;

  // �������� ������ �� ����.
  Window_Handle := 0;

  // �������� ������.
  ShowCursor(True);
end; { E2D_FreeEngine }

function E2D_GetEngineVersion;
begin { E2D_GetEngineVersion }
  // �������� � ��������� ������ Ext2D Engine.
  Result := $01000054;
end; { E2D_GetEngineVersion }

end.
