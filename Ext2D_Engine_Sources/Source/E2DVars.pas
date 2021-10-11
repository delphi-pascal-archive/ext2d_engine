(************************************* Ext2D Engine *************************************)
(* ������     : E2DVars.pas                                                             *)
(* �����      : ���� ��������                                                           *)
(* ������     : 04.06.06                                                                *)
(* ���������� : ������ ������� ���������� ����������.                                   *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DVars;

interface

uses
  E2DTypes, E2DConsts,  DirectDraw, DirectSound, DirectInput8;

var
  { ���������� DirectDraw }
  DD_Main        : IDirectDraw7            = nil; { ������� ������ }
  DDS_Primary    : IDirectDrawSurface7     = nil; { ��������� ����������� }
  DDS_BackBuffer : IDirectDrawSurface7     = nil; { ������ ����� }
  DDG_Main       : IDirectDrawGammaControl = nil; { ������ ������� }

  { ���������� DirectSound }
  DS_Main : IDirectSound8 = nil; { ������� ������ }

  { ���������� DirectInput }
  DI_Main      : IDirectInput8       = nil; { ������� ������ }
  DID_Keyboard : IDirectInputDevice8 = nil; { ���������� }
  DID_Mouse    : IDirectInputDevice8 = nil; { ���� }

  { ���������� ������ }
  DDS_Selection : IDirectDrawSurface7 = nil; { ����������� }

  { ��������� ���������� }
  Window_Handle : Longword = 0; { ������ �� ���� ���������� }

  { ���������� ������ }
  Screen_Width  : Longword   = 0;   { ������ }
  Screen_Height : Longword   = 0;   { ������ }
  Screen_Gamma  : E2D_TGamma = 256; { ������� }

  { ���������� ������ }
  Volume_Global : Byte = E2D_SOUND_MAXVOLUME; { ���������� ��������� }

  { ���������� ����� }
  Keyboard_Data : array [0..255] of Byte; { ������ ���������� }
  Mouse_Data    : TDIMouseState2;         { ������ ���� }
  Cursor_X      : Longword = 0;           { ������� ������� �� ����������� }
  Cursor_Y      : Longword = 0;           { ������� ������� �� ��������� }
  Cursor_dX     : Longint  = 0;           { ���������� ������� ������� �� ����������� }
  Cursor_dY     : Longint  = 0;           { ���������� ������� ������� �� ��������� }

  { ���������� ���������� }
  Images : array [0..E2D_MANAGE_MAXIMAGES - 1] of E2D_TImage; { ����������� }
  Sounds : array [0..E2D_MANAGE_MAXSOUNDS - 1] of E2D_TSound; { ����� }
  Fonts  : array [0..E2D_MANAGE_MAXFONTS  - 1] of E2D_TFont;  { ������ }

  { �������� �������� }
  NumImages : Longword = 0; { ������� ���������� ����������� }
  NumSounds : Longword = 0; { ������� ���������� ������ }
  NumFonts  : Longword = 0; { ������� ���������� ������� }

implementation

end.
