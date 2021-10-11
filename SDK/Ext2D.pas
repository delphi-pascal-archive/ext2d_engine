(************************************* Ext2D Engine *************************************)
(* ������     : Ext2D.pas                                                               *)
(* �����      : ���� ��������                                                           *)
(* ������     : 03.11.06                                                                *)
(* ���������� : ������ �������� ������������ ������ ��� ���������� Ext2D Engine.        *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit Ext2D;

interface

uses
  Windows;

type
  { ��� ���������� ������� }
  E2D_Result = Longword;

  { ���������� �� ����������� }
  E2D_TImageInfo = packed record
    Width    : Longword; { ������ }
    Height   : Longword; { ������ }
    DataSize : Longword; { ������ ������ }
  end;
  { ��������� �� ���������� �� ����������� }
  E2D_PImageInfo = ^E2D_TImageInfo;

  { ���������� � ����� }
  E2D_TSoundInfo = packed record
    Channels      : Word;     { ���������� ������� }
    SamplesPerSec : Longword; { ������� ������������� }
    BlockAlign    : Word;     { ������� ������������ }
    BitsPerSample : Word;     { �������� }
    DataSize      : Longword; { ������ ������ }
  end;
  { ��������� �� ���������� � ����� }
  E2D_PSoundInfo = ^E2D_TSoundInfo;

  { ���������� � ������� }
  E2D_TCharInfo = packed record
    X     : Word; { ������� �� ����������� }
    Y     : Word; { ������� �� ��������� }
    Width : Word; { ������ }
  end;

  { ���������� � ������ }
  E2D_TFontInfo = packed record
    Image     : E2D_TImageInfo;                  { ����������� ������ }
    Size      : Longword;                        { ������ }
    CharsInfo : array [0..255] of E2D_TCharInfo; { ���������� � �������� }
  end; 
  { ��������� �� ���������� � ������ }
  E2D_PFontInfo = ^E2D_TFontInfo;

  { ��� �������������� ����������� }
  E2D_TImageID = Longword;
  { ��� �������������� ������ }
  E2D_TSoundID = Longword;
  { ��� �������������� ������� }
  E2D_TFontID  = Longword;

  { �������� ���������� ������ }
  E2D_TDeviceDesc = packed record
    Name    : PChar;    { ��� }
    tVidMem : Longword; { ����� ����������� }
    aVidMem : Longword; { �������� ����������� }
    Gamma   : Boolean;  { ��������� ������� }
  end; 
  { ��������� �� �������� ���������� ������ }
  E2D_PDeviceDesc = ^E2D_TDeviceDesc;

  { ������� }
  E2D_TGamma = 0..256;
  { ���� }
  E2D_TColor = Word;
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
  E2D_SCREEN_FRECDEF  = $0;  { ������� ���������� �������� �� ��������� }
  E2D_SCREEN_COLORKEY = $0;  { �������� ���� }

  { ��������� ������ }
  E2D_SOUND_MAXVOLUME = 0;      { ������������ ��������� }
  E2D_SOUND_MINVOLUME = -10000; { ����������� ��������� }
  E2D_SOUND_PANLEFT   = -10000; { ������ : ����� }
  E2D_SOUND_PANRIGHT  = 10000;  { ������ : ������ }
  E2D_SOUND_PANCENTER = $0;     { ������ : ����� }

  { ������ ���� }
  E2D_INPUT_MBLEFT   = 0; { ����� }
  E2D_INPUT_MBRIGHT  = 1; { ������ }
  E2D_INPUT_MBMIDDLE = 2; { ������� }
  E2D_INPUT_MBADD1   = 3; { �������������� 1 }
  E2D_INPUT_MBADD2   = 4; { �������������� 2 }
  E2D_INPUT_MBADD3   = 5; { �������������� 3 }
  E2D_INPUT_MBADD4   = 6; { �������������� 4 }

  { ��������� ��� ��������� �������������. ��������� :
      WindowHandle : ������ �� ���� ����������. }
  procedure E2D_InitEngine(WindowHandle : Longword); stdcall;

  { ��������� ��� �������� ���� ��������� �������� � ������������ ������� ��������. }
  procedure E2D_FreeEngine; stdcall;

  { ������� ��� ��������� ������ ���������� Ext2D Engine.
    ������������ �������� : ������� ���� �������� ����� - �������� ������, ������� ���� -
                            �������������� ������; ������� ���� �������� ����� - �����,
                            ������� ���� - ����. }
  function E2D_GetEngineVersion : Longword; stdcall;

  { ������� ��� �������� ����������� �� ������ � ������. ��������� :
      FileName  : ��� ����� ����������� ��� �������� (*.eif �����);
      ImageData : ����� ������ ��� ���������� ������ �����������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo ��� ���������� ���������� �
                  ����������� ����������� (������, ������, ������ ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_LoadImage(FileName : PChar; var ImageData : Pointer;
                         ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall;

  { ������� ��� �������� ������ �� ������ � ������. ��������� :
      FileName  : ��� ����� ����� ��� �������� (*.esf �����);
      SoundData : ����� ������ ��� ���������� ������ �����;
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo ��� ���������� ���������� �
                  ����������� ����� (���������� �������, ������� ������������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_LoadSound(FileName : PChar; var SoundData : Pointer;
                         SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall;

  { ������� ��� �������� ������� �� ������ � ������. ��������� :
      FileName : ��� ����� ������ ��� �������� (*.eff �����);
      FontData : ����� ������ ��� ���������� ������ ������;
      FontInfo : ��������� �� ��������� E2D_TFontInfo ��� ���������� ���������� �
                 ����������� ������ (������, ���������� � �������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_LoadFont(FileName : PChar; var FontData : Pointer;
                        FontInfo : E2D_PFontInfo) : E2D_Result; stdcall;

  { �������  ��� ������������ ������, ���������� ��� ������ �����������, ����� ��� ������.
    ��������� :
      Data : ����� ������, � ������� ��������� ������ �����������, ����� ��� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_FreeMem(var Data : Pointer) : E2D_Result; stdcall;

  { ������� ��� �������� ����������� �� ������ � �������� �� ��� �����������. ��������� :
      FileName  : ��� ����� ����������� ��� �������� (*.eif �����);
      ImageInfo : ��������� �� ��������� E2D_TImageInfo ��� ���������� ���������� �
                  ����������� ����������� (������, ������, ������ ������); ������ ��������
                  ����� ���� nil, ���� ���������� �� �����;
      ImageID   : ���������� ��� ���������� �������������� ������������ �����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddImageFromFile(FileName : PChar; ImageInfo : E2D_PImageInfo;
                                var ImageID : E2D_TImageID) : E2D_Result; stdcall;

  { ������� ��� �������� ����������� �� ������ � �������� �� ��� �����������. ��������� :
      ImageData : ����� ������, ��� ��������� ������ �����������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo, ��� ��������� ���������� ��
                  ����������� (������, ������, ������ ������);
      ImageID   : ���������� ��� ���������� �������������� ������������ �����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddImageFromMem(ImageData : Pointer; ImageInfo : E2D_PImageInfo;
                               var ImageID : E2D_TImageID) : E2D_Result; stdcall;

  { ��������� ��� �������� ����������� �����������. ��������� :
      FirstImage : ������������� �����������, � �������� ���������� ������ �������� (�����
                   ������� ��� ����������� ����������� ����� �������); ��� �������� ����
                   ����������� ������ �������� ������ ���� ����� E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteImages(FirstImage : E2D_TImageID); stdcall;

  { ������� ��� ��������� ���������� � ����������� �����������. ��������� :
      ImageID   : ������������� �����������, ���������� � ������� ���������� ��������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo ��� ���������� ���������� (������,
                  ������, ������ ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetImageInfo(ImageID : E2D_TImageID;
                            ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall;

  { ������� ��� �������� ������ �� ������ � �������� ��� ��� �������. ��������� :
      FileName  : ��� ����� ����� ��� �������� (*.esf �����);
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo ��� ���������� ���������� �
                  ����������� ����� (���������� �������, ������� ������������� � ������);
                  ������ �������� ����� ���� nil, ���� ���������� �� �����;
      SoundID   : ���������� ��� ���������� �������������� ������������ �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddSoundFromFile(FileName : PChar; SoundInfo : E2D_PSoundInfo;
                                var SoundID : E2D_TSoundID) : E2D_Result; stdcall;

  { ������� ��� �������� ������ �� ������ � �������� ��� ��� �������. ��������� :
      SoundData : ����� ������, ��� ��������� ������ �����;
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo, ��� ��������� ���������� � �����
                  (���������� �������, ������� ������������� � ������);
      SoundID   : ���������� ��� ���������� �������������� ������������ �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddSoundFromMem(SoundData : Pointer; SoundInfo : E2D_PSoundInfo;
                               var SoundID : E2D_TSoundID) : E2D_Result; stdcall; 

  { ��������� ��� �������� ����������� ������. ��������� :
      FirstSound : ������������� �����, � �������� ���������� ������ �������� (�����
                   ������� ��� ����� ����������� ����� �������); ��� �������� ���� ������
                   ������ �������� ������ ���� ����� E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteSounds(FirstSound : E2D_TSoundID); stdcall;

  { ������� ��� ��������� ���������� � ����������� �����. ��������� :
      SoundID   : ������������� �����, ���������� � ������� ���������� ��������;
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo ��� ���������� ����������
                 (���������� �������, ������� ������������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetSoundInfo(SoundID : E2D_TSoundID;
                            SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall;

  { ������� ��� �������� ������� �� ������ � �������� �� ��� �����������. ��������� :
      FileName : ��� ����� ������ ��� �������� (*.eff �����);
      FontInfo : ��������� �� ��������� E2D_TFontInfo ��� ���������� ���������� �
                 ����������� ������ (������, ���������� � �������� � ������); ������
                 �������� ����� ���� nil, ���� ���������� �� �����;
      FontID   : ���������� ��� ���������� �������������� ������������ ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddFontFromFile(FileName : PChar; FontInfo : E2D_PFontInfo;
                               var FontID : E2D_TFontID) : E2D_Result; stdcall; 

  { ������� ��� �������� ����������� �� ������ � �������� �� ��� �����������. ��������� :
      FontData : ����� ������, ��� ��������� ������ ������;
      FontInfo : ��������� �� ��������� E2D_TFontInfo, ��� ��������� ���������� � ������
                 (������, ���������� � �������� � ������);
      FontID   : ���������� ��� ���������� �������������� ������������ ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddFontFromMem(FontData : Pointer; FontInfo : E2D_PFontInfo;
                              var FontID : E2D_TFontID) : E2D_Result; stdcall;

  { ��������� ��� �������� ����������� �������. ��������� :
      FirstFont : ������������� ������, � �������� ���������� ������ �������� (�����
                  ������� ��� ������ ����������� ����� �������); ��� �������� ����
                  ������� ������ �������� ������ ���� ����� E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteFonts(FirstFont : E2D_TFontID); stdcall;

  { ������� ��� ��������� ���������� � ����������� ������. ��������� :
      FontID   : ������������� ������, ���������� � ������� ���������� ��������;
      FontInfo : ��������� �� ��������� E2D_TFontInfo ��� ���������� ���������� (������,
                 ���������� � �������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetFontInfo(FontID : E2D_TFontID;
                           FontInfo : E2D_PFontInfo) : E2D_Result; stdcall;

  { ������� ��� �������� �������� DirectDraw � �������� � ������������� ����������.
    ��������� :
      ScreenWidth  : ������ ������;
      ScreenHeight : ������ ������;
      Frec         : ������� ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateFullscreen(ScreenWidth, ScreenHeight,
                                Frec : Longword) : E2D_Result; stdcall;

  { ������� ��� ��������� �������� ��������� ������. ��������� :
      Desc : ��������� �� ��������� E2D_TDeviceDesc ��� ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetDeviceDesc(Desc : E2D_PDeviceDesc) : E2D_Result; stdcall;

  { ������� ��� ������ ����������� �� �����. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������;
      Place   : ����� ������������ ����������� �� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawImage(ImageID : E2D_TImageID; ImgRect : PRect;
                         Place : PPoint) : E2D_Result; stdcall;

  { ������� ��� ������ ����������� ����������� �� �����. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������ (��� ������ ����� ����������� ������
                �������� ����� ���� nil);
      DstRect : ������������� ����������� �� ������ (��� ������ ����������� �� ���� �����
                ������ �������� ����� ���� nil).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_StretchDraw(ImageID : E2D_TImageID;
                           ImgRect, DstRect : PRect) : E2D_Result; stdcall;

  { ������� ��� ������ �� ����� ������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_ShowBuffer : E2D_Result; stdcall;

  { ������� ��� ������� ������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_ClearBuffer : E2D_Result; stdcall;

  { ������� ��� �������������� ������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_RestoreSurfaces : E2D_Result; stdcall;

  { ������� ��� ������ ������. ��������� :
      FontID : ������������� ������, ������� ���������� ������� �����;
      Text   : ��������� �� ������, ������� ���������� �������;
      X, Y   : ������� ������ �� ������;
      Size   : ����� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawText(FontID : E2D_TFontID; Text : PChar; X, Y : Longword;
                        Size : Longword) : E2D_Result; stdcall;

  { ������� ��� ��������� ��������������. ��������� :
      Color : ���� ��������������;
      Rect  : �������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawRect(Color : E2D_TColor; Rect : PRect) : E2D_Result; stdcall;

  { ������� ��� ��������� ������� ������.
    ������������ �������� : �������. }
  function E2D_GetGamma : E2D_TGamma; stdcall;

  { ������� ��� ��������� ������� ������. ��������� :
      Gamma : �������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetGamma(Gamma : E2D_TGamma) : E2D_Result; stdcall;

  { ������� ��� ��������� ������� �������� ������������. ��������� :
      R, G, B : ������� ��������, �������� � ������ �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetRGBGamma(R, G, B : E2D_TGamma) : E2D_Result; stdcall;

  { ������� ��� ����������� ��������� �����������. ��������� :
      ImageID : ������������� �����������, ������� ���������� ��������;
      FlipHor : ��������� �� ����������� (����� �������);
      FlipVer : ��������� �� ��������� (������ ����).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_FlipImage(ImageID : E2D_TImageID;
                         FlipHor, FlipVer : Boolean) : E2D_Result; stdcall;

  { ������� ��� �������� �������� DirectSound.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateSound : E2D_Result; stdcall;

  { ������� ��� ��������������� �����. ��������� :
      SoundID : ������������� �����, ������� ���������� �������������;
      Loop    : ����, ��������������� ���� �� ��������� ���������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_PlaySound(SoundID : E2D_TSoundID; Loop : Boolean) : E2D_Result; stdcall;

  { ������� ��� ��������� ��������������� �����. ��������� :
      SoundID : ������������� �����, ������� ���������� ����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_StopSound(SoundID : E2D_TSoundID) : E2D_Result; stdcall;

  { ������� ��� ��������� ��������� �����. ��������� :
      SoundID : ������������� �����, ��������� ������� ���������� ��������;
      Volume  : ���������� ��� ���������� ���������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetSoundVolume(SoundID : E2D_TSoundID;
                              var Volume : E2D_TSoundVolume) : E2D_Result; stdcall;

  { ������� ��� ������������ ��������� �����. ��������� :
      SoundID : ������������� �����, ��������� ������� ���������� ����������;
      Volume  : ���������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetSoundVolume(SoundID : E2D_TSoundID;
                              Volume : E2D_TSoundVolume) : E2D_Result; stdcall;

  { ������� ��� ��������� ���������� ���������.
    ������������ �������� : ���������. }
  function E2D_GetGlobalVolume : E2D_TSoundVolume; stdcall;

  { ������� ��� ������������ ���������� ���������. ��������� :
      Volume : ���������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetGlobalVolume(Volume : E2D_TSoundVolume) : E2D_Result; stdcall;

  { ������� ��� ��������� �������� �����. ��������� :
      SoundID : ������������� �����, �������� ������� ���������� ��������;
      Pan     : ���������� ��� ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetSoundPan(SoundID : E2D_TSoundID;
                           var Pan : E2D_TSoundPan) : E2D_Result; stdcall;

  { ������� ��� ������������ �������� �����. ��������� :
      SoundID : ������������� �����, �������� ������� ���������� ����������;
      Pan     : ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetSoundPan(SoundID : E2D_TSoundID;
                           Pan : E2D_TSoundPan) : E2D_Result; stdcall;

  { ������� ��� �������� �������� DirectInput.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateInput : E2D_Result; stdcall;

  { ������� ��� �������� ���������� ����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddKeyboard : E2D_Result; stdcall; 

  { ������� ��� �������� ���������� ����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddMouse : E2D_Result; stdcall;

  { ������� ��� ���������� ������ ����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_UpdateKeyboard : E2D_Result; stdcall; 

  { ������� ��� ���������� ������ ����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_UpdateMouse : E2D_Result; stdcall;

  { ������� ��� ��������� ���������� � ���, ������ �� ������� �� ����������. ��������� :
      Key : ��� �������, ���������� � ������� ���������� ��������.
    ������������ �������� : ���� ������� ������ - True, ���� ��� - False. }
  function E2D_IsKeyboardKeyDown(Key : Byte) : Boolean; stdcall; 

  { ��������� ��� ��������� ������� �������. ��������� :
      CursorPos : ���������� ��� ���������� ������� �������. }
  procedure E2D_GetCursorPosition(var CursorPos : TPoint); stdcall; 

  { ��������� ��� ��������� ���������� ������� �������. ��������� :
      CursorDeltas : ���������� ��� ���������� ���������� ������� �������. }
  procedure E2D_GetCursorDelta(var CursorDeltas : TPoint); stdcall;

  { ������� ��� ��������� ���������� � ���, ������ �� ������ ����. ��������� :
      Button : ������, ���������� � ������� ���������� ��������.
    ������������ �������� : ���� ������� ������ - True, ���� ��� - False. }
  function E2D_IsMouseButtonDown(Button : E2D_TMouseButton) : Boolean; stdcall;

  { ������� ��� �������� ����������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateSelection : E2D_Result; stdcall;

  { ������� ��� ������ ����������� �� ����������� ������. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������;
      Place   : ����� ������������ ����������� �� ����������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawImageToSelect(ImageID : E2D_TImageID; ImgRect : PRect;
                                 Place : PPoint) : E2D_Result; stdcall;

  { ������� ��� ��������� �������������� �� ����������� ������. ��������� :
      Color : ���� ��������������;
      Rect  : �������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_DrawRectToSelect(Color : E2D_TColor; Rect : PRect) : E2D_Result; stdcall;

  { ������� ��� ������� ����������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_ClearSelect : E2D_Result; stdcall;

  { ������� ��� ���������� � ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_BeginSelection : E2D_Result; stdcall;

  { ������� ��� ���������� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EndSelection : E2D_Result; stdcall;

  { ������� ��� ������������� ������. ��������� :
      X, Y : ���������� �����, ��� ������� �������������� �����.
    ������������ �������� : ���� ������� �����������. }
  function E2D_GetSelectionVal(X, Y : Longword) : E2D_TColor; stdcall;

  { ������� ��� ����������� ������������. ��������� :
      Image1ID, Image2ID  : �������������� �����������, ��� �������� ������� ����������
                            ���������� ������������;
      Place1, Place2      : ����� ������������ ����������� �� ������;
      Collision           : ���������� ��� ���������� ���������� ������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetCollision(Image1ID, Image2ID : E2D_TImageID;
                            ImageRect1, ImageRect2 : PRect; Place1, Place2 : PPoint;
                            var Collision : Boolean) : E2D_Result; stdcall;

  { ������� ��� ���������� � ������ ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_BeginEffects : E2D_Result; stdcall; 

  { ������� ��� ���������� ������ ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EndEffects : E2D_Result; stdcall;

  { ������� ��� ������ ����������� ����������� �� �����. ��������� :
      ImageID : ������������� �����������, ������� ���������� �������;
      ImgRect : ������������� ����������� ��� ������;
      Place   : ����� ������������ ����������� �� ������;
      Alpha   : ����������� ������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EffectBlend(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                           Alpha : E2D_TAlpha) : E2D_Result; stdcall;

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
                               Place, MaskPlace : PPoint) : E2D_Result; stdcall;

  { ������� ��� ������ ����������� �� ����� � �������������� ����������������� �������.
    ��������� :
      ImageID     : ������������� �����������, ������� ���������� �������;
      ImgRect     : ������������� ����������� ��� ������;
      Place       : ����� ������������ ����������� �� ������;
      ColorCalc   : ������� ��� ���������� ����� �������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_EffectUser(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                          ColorCalc : E2D_TColorCalcFunc) : E2D_Result; stdcall;

  { ��������� ��� ������ �� ����� �����. ��������� :
      X, Y  : ����� ������������ ����� �� ������;
      Color : ���� �����. }
  procedure E2D_PutPoint(X, Y : Longword; Color : E2D_TColor); stdcall;

  { ������� ���������� ���������� �� ������. ��������� :
      ErrorCode : ��� ��������� ������.
    ������������ �������� : ��������� �� ������ � ��������� ������. }
  function E2D_ErrorString(ErrorCode : E2D_Result) : PChar; stdcall;

implementation

const
  Ext2DDLL = 'Ext2D.dll';

procedure E2D_InitEngine;        external Ext2DDLL;
procedure E2D_FreeEngine;        external Ext2DDLL;
function  E2D_GetEngineVersion;  external Ext2DDLL;
function  E2D_LoadImage;         external Ext2DDLL;
function  E2D_LoadSound;         external Ext2DDLL;
function  E2D_LoadFont;          external Ext2DDLL;
function  E2D_FreeMem;           external Ext2DDLL;
function  E2D_AddImageFromFile;  external Ext2DDLL;
function  E2D_AddImageFromMem;   external Ext2DDLL;
procedure E2D_DeleteImages;      external Ext2DDLL;
function  E2D_GetImageInfo;      external Ext2DDLL;
function  E2D_AddSoundFromFile;  external Ext2DDLL;
function  E2D_AddSoundFromMem;   external Ext2DDLL;
procedure E2D_DeleteSounds;      external Ext2DDLL;
function  E2D_GetSoundInfo;      external Ext2DDLL;
function  E2D_AddFontFromFile;   external Ext2DDLL;
function  E2D_AddFontFromMem;    external Ext2DDLL;
procedure E2D_DeleteFonts;       external Ext2DDLL;
function  E2D_GetFontInfo;       external Ext2DDLL;
function  E2D_CreateFullscreen;  external Ext2DDLL;
function  E2D_GetDeviceDesc;     external Ext2DDLL;
function  E2D_DrawImage;         external Ext2DDLL;
function  E2D_StretchDraw;       external Ext2DDLL;
function  E2D_ShowBuffer;        external Ext2DDLL;
function  E2D_ClearBuffer;       external Ext2DDLL;
function  E2D_RestoreSurfaces;   external Ext2DDLL;
function  E2D_DrawText;          external Ext2DDLL;
function  E2D_DrawRect;          external Ext2DDLL;
function  E2D_GetGamma;          external Ext2DDLL;
function  E2D_SetGamma;          external Ext2DDLL;
function  E2D_SetRGBGamma;       external Ext2DDLL;
function  E2D_FlipImage;         external Ext2DDLL;
function  E2D_CreateSound;       external Ext2DDLL;
function  E2D_PlaySound;         external Ext2DDLL;
function  E2D_StopSound;         external Ext2DDLL;
function  E2D_GetSoundVolume;    external Ext2DDLL;
function  E2D_SetSoundVolume;    external Ext2DDLL;
function  E2D_GetGlobalVolume;   external Ext2DDLL;
function  E2D_SetGlobalVolume;   external Ext2DDLL;
function  E2D_GetSoundPan;       external Ext2DDLL;
function  E2D_SetSoundPan;       external Ext2DDLL;
function  E2D_CreateInput;       external Ext2DDLL;
function  E2D_AddKeyboard;       external Ext2DDLL;
function  E2D_AddMouse;          external Ext2DDLL;
function  E2D_UpdateKeyboard;    external Ext2DDLL;
function  E2D_UpdateMouse;       external Ext2DDLL;
function  E2D_IsKeyboardKeyDown; external Ext2DDLL;
procedure E2D_GetCursorPosition; external Ext2DDLL;
procedure E2D_GetCursorDelta;    external Ext2DDLL;
function  E2D_IsMouseButtonDown; external Ext2DDLL;
function  E2D_CreateSelection;   external Ext2DDLL;
function  E2D_DrawImageToSelect; external Ext2DDLL;
function  E2D_DrawRectToSelect;  external Ext2DDLL;
function  E2D_ClearSelect;       external Ext2DDLL;
function  E2D_BeginSelection;    external Ext2DDLL;
function  E2D_EndSelection;      external Ext2DDLL;
function  E2D_GetSelectionVal;   external Ext2DDLL;
function  E2D_GetCollision;      external Ext2DDLL;
function  E2D_BeginEffects;      external Ext2DDLL;
function  E2D_EndEffects;        external Ext2DDLL;
function  E2D_EffectBlend;       external Ext2DDLL;
function  E2D_EffectAlphaMask;   external Ext2DDLL;
function  E2D_EffectUser;        external Ext2DDLL;
procedure E2D_PutPoint;          external Ext2DDLL;
function  E2D_ErrorString;       external Ext2DDLL;

end.


