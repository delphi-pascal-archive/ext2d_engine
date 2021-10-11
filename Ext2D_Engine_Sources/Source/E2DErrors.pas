(************************************* Ext2D Engine *************************************)
(* ������     : E2DErrors.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 16.05.06                                                                *)
(* ���������� : ������ �������� �������� �������� ������.                               *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DErrors;

interface

uses
  E2DTypes; 

  { ������� ���������� ���������� �� ������. ��������� :
      ErrorCode : ��� ��������� ������.
    ������������ �������� : ��������� �� ������ � ��������� ������. }
  function E2D_ErrorString(ErrorCode : E2D_Result) : PChar; stdcall; export;

implementation

uses
  E2DConsts; { ��� ������� ������ }

function E2D_ErrorString;
begin { E2D_ErrorString }
  // ��������� ��� ������.
  case ErrorCode of
    // ���� ��� �������, ���������� �������� ������.
    E2DERR_OK                 : Result := PChar('��� ������.');
    
    E2DERR_SYSTEM_INVPOINTER  : Result := PChar('������������ ���������.');
    E2DERR_SYSTEM_CANTGETMEM  : Result := PChar('���������� �������� ������.');
    E2DERR_SYSTEM_CANTCOPYMEM : Result := PChar('���������� ���������� ������.');
    E2DERR_SYSTEM_INVALIDID   : Result := PChar('������������ �������������.');
    E2DERR_SYSTEM_SETCOOPLVL  : Result := PChar('���������� ���������� ������� ����������.');

    E2DERR_LOAD_CANTOPEN      : Result := PChar('���������� ������� ����.');
    E2DERR_LOAD_CANTREAD      : Result := PChar('���������� ��������� ������ �� �����.');
    E2DERR_LOAD_INVALID       : Result := PChar('���� ������������ ��� ���������.');
    E2DERR_LOAD_DECOMPRESS    : Result := PChar('������ ������������.');

    E2DERR_MANAGE_OUTOFMEM    : Result := PChar('������������ ������ �������.');
    E2DERR_MANAGE_CREATESURF  : Result := PChar('���������� ������� �����������.');
    E2DERR_MANAGE_CREATEBUF   : Result := PChar('���������� ������� �����.');
    E2DERR_MANAGE_CANTLOCK    : Result := PChar('���������� ������������� ������.');

    E2DERR_SCREEN_CREATEDD    : Result := PChar('���������� ������� ������� ������ DirectDraw.');
    E2DERR_SCREEN_SETDISPMD   : Result := PChar('���������� ���������� ����������.');
    E2DERR_SCREEN_GETDESCR    : Result := PChar('���������� �������� �������� ����������.');
    E2DERR_SCREEN_CREATEGAM   : Result := PChar('���������� ������� ����� ��������.');
    E2DERR_SCREEN_CREATESURF  : Result := PChar('���������� ������� �����������.');
    E2DERR_SCREEN_CANTDRAW    : Result := PChar('���������� ��������� �����.');
    E2DERR_SCREEN_CANTFLIP    : Result := PChar('���������� ��������� ������������.');
    E2DERR_SCREEN_CANTCLEAR   : Result := PChar('���������� �������� �����.');
    E2DERR_SCREEN_CANTRESTORE : Result := PChar('���������� ������������ �����������.');
    E2DERR_SCREEN_CANTSETGAM  : Result := PChar('���������� ���������� �������.');

    E2DERR_SOUND_CREATEDS     : Result := PChar('���������� ������� ������� ������ DirectSound.');
    E2DERR_SOUND_CANTPLAY     : Result := PChar('���������� ������������� ����.');
    E2DERR_SOUND_CANTSTOP     : Result := PChar('���������� ���������� ����.');
    E2DERR_SOUND_CANTGETVOL   : Result := PChar('���������� �������� ���������.');
    E2DERR_SOUND_CANTSETVOL   : Result := PChar('���������� ���������� ���������.');
    E2DERR_SOUND_CANTGETPAN   : Result := PChar('���������� �������� ��������.');
    E2DERR_SOUND_CANTSETPAN   : Result := PChar('���������� ���������� ��������.');

    E2DERR_INPUT_CREATEDI     : Result := PChar('���������� ������� ������� ������ DirectInput.');
    E2DERR_INPUT_CREATEDEV    : Result := PChar('���������� ������� ����������.');
    E2DERR_INPUT_SETDATAFMT   : Result := PChar('���������� ������ ������ ������.');
    E2DERR_INPUT_CANTACQR     : Result := PChar('���������� ��������� ����������.');
    E2DERR_INPUT_GETSTATE     : Result := PChar('���������� �������� ������.');

    // � ��������� ������ ���������� "����������� ������".
    else                        Result := PChar('����������� ��� ������.');
  end; { case }
end; { E2D_ErrorString }

end.
