(************************************* Ext2D Engine *************************************)
(* ������     : E2DConsts.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 01.06.06                                                                *)
(* ���������� : ������ ������� �������� ���������.                                      *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DConsts;

interface

const
  { ����� ��������� }
  E2DERR_OK = $00000000; { ��� ������ }

  { ��������� ��������� ������ }
  E2DERR_SYSTEM_INVPOINTER  = $00000101; { ������������ ��������� }
  E2DERR_SYSTEM_CANTGETMEM  = $00000102; { ���������� �������� ������ }
  E2DERR_SYSTEM_CANTCOPYMEM = $00000103; { ���������� ���������� ������ }
  E2DERR_SYSTEM_INVALIDID   = $00000104; { ������������ ������������� }
  E2DERR_SYSTEM_SETCOOPLVL  = $00000105; { ���������� ���������� ������� ���������� }

  { ��������� ������ �������� }
  E2DERR_LOAD_CANTOPEN   = $00000201; { ���������� ������� ���� }
  E2DERR_LOAD_CANTREAD   = $00000202; { ���������� ��������� ������ �� ����� }
  E2DERR_LOAD_INVALID    = $00000203; { ���� ������������ ��� ��������� }
  E2DERR_LOAD_DECOMPRESS = $00000204; { ������ ������������ }

  { ��������� ������ ���������� }
  E2DERR_MANAGE_OUTOFMEM   = $00000301; { ������������ ������ ������� }
  E2DERR_MANAGE_CREATESURF = $00000302; { ���������� ������� ����������� }
  E2DERR_MANAGE_CREATEBUF  = $00000303; { ���������� ������� ����� }
  E2DERR_MANAGE_CANTLOCK   = $00000304; { ���������� ������������� ������ }

  { ��������� ������ ������ }
  E2DERR_SCREEN_CREATEDD    = $00000401; { ���������� ������� ������� ������ DirectDraw }
  E2DERR_SCREEN_SETDISPMD   = $00000402; { ���������� ���������� ���������� }
  E2DERR_SCREEN_GETDESCR    = $00000403; { ���������� �������� �������� ���������� }
  E2DERR_SCREEN_CREATEGAM   = $00000404; { ���������� ������� ����� �������� }
  E2DERR_SCREEN_CREATESURF  = $00000405; { ���������� ������� ����������� }
  E2DERR_SCREEN_CANTDRAW    = $00000406; { ���������� ��������� ����� }
  E2DERR_SCREEN_CANTFLIP    = $00000407; { ���������� ��������� ������������ }
  E2DERR_SCREEN_CANTCLEAR   = $00000408; { ���������� �������� ����� }
  E2DERR_SCREEN_CANTRESTORE = $00000409; { ���������� ������������ ����������� }
  E2DERR_SCREEN_CANTSETGAM  = $00000410; { ���������� ���������� ������� }

  { ��������� ������ ����� }
  E2DERR_SOUND_CREATEDS   = $00000501; { ���������� ������� ������� ������ DirectSound }
  E2DERR_SOUND_CANTPLAY   = $00000502; { ���������� ������������� ���� }
  E2DERR_SOUND_CANTSTOP   = $00000503; { ���������� ���������� ���� }
  E2DERR_SOUND_CANTGETVOL = $00000504; { ���������� �������� ��������� }
  E2DERR_SOUND_CANTSETVOL = $00000505; { ���������� ���������� ��������� }
  E2DERR_SOUND_CANTGETPAN = $00000506; { ���������� �������� �������� }
  E2DERR_SOUND_CANTSETPAN = $00000507; { ���������� ���������� �������� }

  { ��������� ������ ����� }
  E2DERR_INPUT_CREATEDI   = $00000601; { ���������� ������� ������� ������ DirectInput }
  E2DERR_INPUT_CREATEDEV  = $00000602; { ���������� ������� ���������� }
  E2DERR_INPUT_SETDATAFMT = $00000603; { ���������� ������ ������ ������ }
  E2DERR_INPUT_CANTACQR   = $00000604; { ���������� ��������� ���������� }
  E2DERR_INPUT_GETSTATE   = $00000605; { ���������� �������� ������ }

  { ��������� ���������� }
  E2D_MANAGE_MAXIMAGES = $10000; { ������������ ���������� ����������� }
  E2D_MANAGE_MAXSOUNDS = $10000; { ������������ ���������� ������ }
  E2D_MANAGE_MAXFONTS  = $100;   { ������������ ���������� ������� }
  E2D_MANAGE_DELETEALL = $0;     { ������� ��� }

  { ��������� ���������� ������ }
  E2D_SCREEN_BITSPP   = $10; { ������� ����� (��� �� ������) }
  E2D_SCREEN_BYTESPP  = 2;   { ������� ����� (���� �� ������) }
  E2D_SCREEN_FRECDEF  = $0;  { ������� ���������� �������� �� ��������� }
  E2D_SCREEN_COLORKEY = $0;  { �������� ���� }

  { ��������� ������ }
  E2D_SOUND_MAXVOLUME = $FF;  { ������������ ��������� }
  E2D_SOUND_MINVOLUME = $0;   { ����������� ��������� }
  E2D_SOUND_PANLEFT   = -$7F; { ������ : ����� }
  E2D_SOUND_PANRIGHT  = $7F;  { ������ : ������ }
  E2D_SOUND_PANCENTER = $0;   { ������ : ����� }

  { ������ ���� }
  E2D_INPUT_MBLEFT   = 0; { ����� }
  E2D_INPUT_MBRIGHT  = 1; { ������ }
  E2D_INPUT_MBMIDDLE = 2; { ������� }
  E2D_INPUT_MBADD1   = 3; { �������������� 1 }
  E2D_INPUT_MBADD2   = 4; { �������������� 2 }
  E2D_INPUT_MBADD3   = 5; { �������������� 3 }
  E2D_INPUT_MBADD4   = 6; { �������������� 4 }

implementation

end.