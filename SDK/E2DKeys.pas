(************************************* Ext2D Engine *************************************)
(* ������     : E2DKeys.pas                                                             *)
(* �����      : ���� ��������                                                           *)
(* ������     : 16.05.06                                                                *)
(* ���������� : ������ ������� �������� ������ ����������.                              *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DKeys;

interface

const
  { ��������� ������ }
  E2DKEY_ESCAPE = $01; { Escape }

  E2DKEY_F1  = $3B; { F1 }
  E2DKEY_F2  = $3C; { F2 }
  E2DKEY_F3  = $3D; { F3 }
  E2DKEY_F4  = $3E; { F4 }
  E2DKEY_F5  = $3F; { F5 }
  E2DKEY_F6  = $40; { F6 }
  E2DKEY_F7  = $41; { F7 }
  E2DKEY_F8  = $42; { F8 }
  E2DKEY_F9  = $43; { F9 }
  E2DKEY_F10 = $44; { F10 }
  E2DKEY_F11 = $57; { F11 }
  E2DKEY_F12 = $58; { F12 }

  E2DKEY_SYSRQ  = $B7; { SysRq }
  E2DKEY_SCROLL = $46; { Scroll Lock }
  E2DKEY_PAUSE  = $C5; { Pause }

  E2DKEY_GRAVE     = $29; { ` }
  E2DKEY_1         = $02; { 1 �� ������� ���������� }
  E2DKEY_2         = $03; { 2 �� ������� ���������� }
  E2DKEY_3         = $04; { 3 �� ������� ���������� }
  E2DKEY_4         = $05; { 4 �� ������� ���������� }
  E2DKEY_5         = $06; { 5 �� ������� ���������� }
  E2DKEY_6         = $07; { 6 �� ������� ���������� }
  E2DKEY_7         = $08; { 7 �� ������� ���������� }
  E2DKEY_8         = $09; { 8 �� ������� ���������� }
  E2DKEY_9         = $0A; { 9 �� ������� ���������� }
  E2DKEY_0         = $0B; { 0 �� ������� ���������� }
  E2DKEY_MINUS     = $0C; { - �� ������� ���������� }
  E2DKEY_EQUALS    = $0D; { = }
  E2DKEY_BACKSLASH = $2B; { \ }
  E2DKEY_BACK      = $0E; { Backspace }

  E2DKEY_Q        = $10; { Q }
  E2DKEY_W        = $11; { W }
  E2DKEY_E        = $12; { E }
  E2DKEY_R        = $13; { R }
  E2DKEY_T        = $14; { T }
  E2DKEY_Y        = $15; { Y }
  E2DKEY_U        = $16; { U }
  E2DKEY_I        = $17; { I }
  E2DKEY_O        = $18; { O }
  E2DKEY_P        = $19; { P }
  E2DKEY_LBRACKET = $1A; { [ }
  E2DKEY_RBRACKET = $1B; { ] }

  E2DKEY_A          = $1E; { A }
  E2DKEY_S          = $1F; { S }
  E2DKEY_D          = $20; { D }
  E2DKEY_F          = $21; { F }
  E2DKEY_G          = $22; { G }
  E2DKEY_H          = $23; { H }
  E2DKEY_J          = $24; { J }
  E2DKEY_K          = $25; { K }
  E2DKEY_L          = $26; { L }
  E2DKEY_SEMICOLON  = $27; { ; }
  E2DKEY_APOSTROPHE = $28; { ' }

  E2DKEY_Z      = $2C; { Z }
  E2DKEY_X      = $2D; { X }
  E2DKEY_C      = $2E; { C }
  E2DKEY_V      = $2F; { V }
  E2DKEY_B      = $30; { B }
  E2DKEY_N      = $31; { N }
  E2DKEY_M      = $32; { M }
  E2DKEY_COMMA  = $33; { , }
  E2DKEY_PERIOD = $34; { . ������� ���������� }
  E2DKEY_SLASH  = $35; { / ������� ���������� }

  E2DKEY_TAB      = $0F; { Tab }
  E2DKEY_CAPITAL  = $3A; { Caps Lock }
  E2DKEY_LSHIFT   = $2A; { ����� Shift }
  E2DKEY_LCONTROL = $1D; { ����� Control }
  E2DKEY_LWIN     = $DB; { ����� ������� Windows }
  E2DKEY_LMENU    = $38; { ����� Alt }
  E2DKEY_SPACE    = $39; { ������� }
  E2DKEY_RMENU    = $B8; { ������ Alt }
  E2DKEY_RWIN     = $DC; { ������ ������� Windows }
  E2DKEY_APPS     = $DD; { ���� }
  E2DKEY_RCONTROL = $9D; { ������ Control }
  E2DKEY_RSHIFT   = $36; { ������ Shift }
  E2DKEY_RETURN   = $1C; { Enter �� ������� ���������� }

  E2DKEY_INSERT = $D2; { Insert �� ���������� ���������� }
  E2DKEY_HOME   = $C7; { Home �� ���������� ���������� }
  E2DKEY_PRIOR  = $C9; { Page Up �� ���������� ���������� }
  E2DKEY_DELETE = $D3; { Delete �� ���������� ���������� }
  E2DKEY_END    = $CF; { End �� ���������� ���������� }
  E2DKEY_NEXT   = $D1; { Page Down �� ���������� ���������� }

  E2DKEY_UP    = $C8; { ������� ����� �� ���������� ���������� }
  E2DKEY_LEFT  = $CB; { ������� ����� �� ���������� ���������� }
  E2DKEY_RIGHT = $CD; { ������� ������ �� ���������� ���������� }
  E2DKEY_DOWN  = $D0; { ������� ���� �� ���������� ���������� }

  E2DKEY_NUMPAD1 = $4F; { 1 �� �������� ���������� }
  E2DKEY_NUMPAD2 = $50; { 2 �� �������� ���������� }
  E2DKEY_NUMPAD3 = $51; { 3 �� �������� ���������� }
  E2DKEY_NUMPAD4 = $4B; { 4 �� �������� ���������� }
  E2DKEY_NUMPAD5 = $4C; { 5 �� �������� ���������� }
  E2DKEY_NUMPAD6 = $4D; { 6 �� �������� ���������� }
  E2DKEY_NUMPAD7 = $47; { 7 �� �������� ���������� }
  E2DKEY_NUMPAD8 = $48; { 8 �� �������� ���������� }
  E2DKEY_NUMPAD9 = $49; { 9 �� �������� ���������� }
  E2DKEY_NUMPAD0 = $52; { 0 �� �������� ���������� }

  E2DKEY_NUMLOCK        = $45; { Num Lock }
  E2DKEY_NUMPADSLASH    = $B5; { / �� �������� ���������� }
  E2DKEY_NUMPADMULTIPLY = $37; { * �� �������� ���������� }
  E2DKEY_NUMPADMINUS    = $4A; { - �� �������� ���������� }
  E2DKEY_NUMPADADD      = $4E; { + �� �������� ���������� }
  E2DKEY_NUMPADRETURN   = $9C; { Enter �� �������� ���������� }
  E2DKEY_NUMPADPERIOD   = $53; { . �� �������� ���������� }

implementation

end.
