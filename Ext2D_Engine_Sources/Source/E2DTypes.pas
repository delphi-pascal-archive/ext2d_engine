(************************************* Ext2D Engine *************************************)
(* ������     : E2DTypes.pas                                                            *)
(* �����      : ���� ��������                                                           *)
(* ������     : 03.11.06                                                                *)
(* ���������� : ������ �������� �������� �������� �����.                                *)
(* ���������  : no changes.                                                             *)
(****************************************************************************************)

unit E2DTypes;

interface

uses
  DirectDraw, DirectSound;

type
  { ��� ���������� ������� }
  E2D_Result = Longword;

  { ���������� �� ����������� }
  E2D_TImageInfo = packed record
    Width    : Longword; { ������ }
    Height   : Longword; { ������ }
    DataSize : Longword; { ������ ������ }
  end; { E2D_TImageInfo }
  { ��������� �� ���������� �� ����������� }
  E2D_PImageInfo = ^E2D_TImageInfo;

  { ���������� � ����� }
  E2D_TSoundInfo = packed record
    Channels      : Word;     { ���������� ������� }
    SamplesPerSec : Longword; { ������� ������������� }
    BlockAlign    : Word;     { ������� ������������ }
    BitsPerSample : Word;     { �������� }
    DataSize      : Longword; { ������ ������ }
  end; { E2D_TSoundInfo }
  { ��������� �� ���������� � ����� }
  E2D_PSoundInfo = ^E2D_TSoundInfo;

  { ���������� � ������� }
  E2D_TCharInfo = packed record
    X     : Word; { ������� �� ����������� }
    Y     : Word; { ������� �� ��������� }
    Width : Word; { ������ }
  end; { E2D_TCharInfo }

  { ���������� � ������ }
  E2D_TFontInfo = packed record
    Image     : E2D_TImageInfo;                  { ����������� ������ }
    Size      : Longword;                        { ������ }
    CharsInfo : array [0..255] of E2D_TCharInfo; { ���������� � �������� }
  end; { E2D_TFontInfo }
  { ��������� �� ���������� � ������ }
  E2D_PFontInfo = ^E2D_TFontInfo;

  { ��� �������������� ����������� }
  E2D_TImageID = Longword;
  { ��� �������������� ������ }
  E2D_TSoundID = Longword;
  { ��� �������������� ������� }
  E2D_TFontID  = Longword;

  { ����������� }
  E2D_TImage = packed record
    Surface : IDirectDrawSurface7; { ����������� }
    Info    : E2D_TImageInfo;      { ���������� }
    Data    : Pointer;             { ������ }
  end; { E2D_TImage }

  { ���� }
  E2D_TSound = packed record
    Buffer : IDirectSoundBuffer; { ����� }
    Info   : E2D_TSoundInfo;     { ���������� }
  end; { E2D_TSound }

  { ����� }
  E2D_TFont = packed record
    Surface : IDirectDrawSurface7; { ����������� }
    Info    : E2D_TFontInfo;       { ���������� }
    Data    : Pointer;             { ������ }
  end; { E2D_TFont }

  { �������� ���������� ������ }
  E2D_TDeviceDesc = packed record
    Name    : PChar;    { ��� }
    tVidMem : Longword; { ����� ����������� }
    aVidMem : Longword; { �������� ����������� }
    Gamma   : Boolean;  { ��������� ������� }
  end; { E2D_TDeviceDesc }
  { ��������� �� �������� ���������� ������ }
  E2D_PDeviceDesc = ^E2D_TDeviceDesc;

  { ������� }
  E2D_TGamma = 0..256;
  { ���� }
  E2D_TColor = Word;
  { ��������� �� ���� }
  E2D_PColor = ^E2D_TColor;
  { ������������ }
  E2D_TAlpha = 0..256;

  { ��������� }
  E2D_TSoundVolume = -10000..0;
  { �������� }
  E2D_TSoundPan = -10000..10000;

  { ������ ���� }
  E2D_TMouseButton = 0..7;

  { ������� ��� ���������� ����� ������� }
  E2D_TColorCalcFunc = function (SrcColor, DstColor : E2D_TColor) : E2D_TColor; stdcall;

implementation

end.
