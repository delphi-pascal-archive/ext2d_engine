(************************************* Ext2D Engine *************************************)
(* ������     : E2DManager.pas                                                          *)
(* �����      : ���� ��������                                                           *)
(* ������     : 22.10.06                                                                *)
(* ���������� : ������ �������� ������� ��� ���������� �������������, ������� �         *)
(*              ��������.                                                               *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DManager;

interface

uses
  E2DTypes, DirectDraw, DirectSound;

  { ������� ��� �������� ����������� �� ������ � �������� �� ��� �����������. ��������� :
      FileName  : ��� ����� ����������� ��� �������� (*.eif �����);
      ImageInfo : ��������� �� ��������� E2D_TImageInfo ��� ���������� ���������� �
                  ����������� ����������� (������, ������, ������ ������); ������ ��������
                  ����� ���� nil, ���� ���������� �� �����;
      ImageID   : ���������� ��� ���������� �������������� ������������ �����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddImageFromFile(FileName : PChar; ImageInfo : E2D_PImageInfo;
                                var ImageID : E2D_TImageID) : E2D_Result; stdcall; export;

  { ������� ��� �������� �����������. ��������� :
      Surface   : �����������, ������� ���������� �������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo, ��� ��������� ���������� ��
                  ����������� (������, ������, ������ ������);
    ������������ �������� : ���� ������� ����������� ������� - DD_OK, ���� �������� - ���
                            ������. }
  function CreateSurface(var Surface : IDirectDrawSurface7;
                         ImageInfo : E2D_PImageInfo) : HRESULT; register;

  { ������� ��� �������� ����������� �� ������ � �������� �� ��� �����������. ��������� :
      ImageData : ����� ������, ��� ��������� ������ �����������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo, ��� ��������� ���������� ��
                  ����������� (������, ������, ������ ������);
      ImageID   : ���������� ��� ���������� �������������� ������������ �����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddImageFromMem(ImageData : Pointer; ImageInfo : E2D_PImageInfo;
                               var ImageID : E2D_TImageID) : E2D_Result; stdcall; export;

  { ��������� ��� �������� ����������� �����������. ��������� :
      FirstImage : ������������� �����������, � �������� ���������� ������ �������� (�����
                   ������� ��� ����������� ����������� ����� �������); ��� �������� ����
                   ����������� ������ �������� ������ ���� ����� E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteImages(FirstImage : E2D_TImageID); stdcall; export;

  { ������� ��� ��������� ���������� � ����������� �����������. ��������� :
      ImageID   : ������������� �����������, ���������� � ������� ���������� ��������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo ��� ���������� ���������� (������,
                  ������, ������ ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetImageInfo(ImageID : E2D_TImageID;
                            ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall; export;

  { ������� ��� ����������� ������ ����������� �� �����������. ��������� :
      Surface : �����������, �� ������� ���������� ����������� �����������;
      Data    : ������ �����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CopyImage(Surface : IDirectDrawSurface7;
                         Data : Pointer) : E2D_Result; register;

  { ������� ��� �������� ������ �� ������ � �������� ��� ��� �������. ��������� :
      FileName  : ��� ����� ����� ��� �������� (*.esf �����);
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo ��� ���������� ���������� �
                  ����������� ����� (���������� �������, ������� ������������� � ������);
                  ������ �������� ����� ���� nil, ���� ���������� �� �����;
      SoundID   : ���������� ��� ���������� �������������� ������������ �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddSoundFromFile(FileName : PChar; SoundInfo : E2D_PSoundInfo;
                                var SoundID : E2D_TSoundID) : E2D_Result; stdcall; export;

  { ������� ��� �������� ������ �� ������ � �������� ��� ��� �������. ��������� :
      SoundData : ����� ������, ��� ��������� ������ �����;
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo, ��� ��������� ���������� � �����
                  (���������� �������, ������� ������������� � ������);
      SoundID   : ���������� ��� ���������� �������������� ������������ �����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddSoundFromMem(SoundData : Pointer; SoundInfo : E2D_PSoundInfo;
                               var SoundID : E2D_TSoundID) : E2D_Result; stdcall; export;

  { ��������� ��� �������� ����������� ������. ��������� :
      FirstSound : ������������� �����, � �������� ���������� ������ �������� (�����
                   ������� ��� ����� ����������� ����� �������); ��� �������� ���� ������
                   ������ �������� ������ ���� ����� E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteSounds(FirstSound : E2D_TSoundID); stdcall; export;

  { ������� ��� ��������� ���������� � ����������� �����. ��������� :
      SoundID   : ������������� �����, ���������� � ������� ���������� ��������;
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo ��� ���������� ����������
                 (���������� �������, ������� ������������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetSoundInfo(SoundID : E2D_TSoundID;
                            SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall; export;

  { ������� ��� ����������� ������ ����� � �����. ��������� :
      Buffer : �����, � ������� ���������� ����������� ����;
      Data   : ������ �����;
      Size   : ������ ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CopySound(Buffer : IDirectSoundBuffer; Data : Pointer;
                         Size : Longword) : E2D_Result; register;

  { ������� ��� �������� ������� �� ������ � �������� �� ��� �����������. ��������� :
      FileName : ��� ����� ������ ��� �������� (*.eff �����);
      FontInfo : ��������� �� ��������� E2D_TFontInfo ��� ���������� ���������� �
                 ����������� ������ (������, ���������� � �������� � ������); ������
                 �������� ����� ���� nil, ���� ���������� �� �����;
      FontID   : ���������� ��� ���������� �������������� ������������ ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddFontFromFile(FileName : PChar; FontInfo : E2D_PFontInfo;
                               var FontID : E2D_TFontID) : E2D_Result; stdcall; export;

  { ������� ��� �������� ����������� �� ������ � �������� �� ��� �����������. ��������� :
      FontData : ����� ������, ��� ��������� ������ ������;
      FontInfo : ��������� �� ��������� E2D_TFontInfo, ��� ��������� ���������� � ������
                 (������, ���������� � �������� � ������);
      FontID   : ���������� ��� ���������� �������������� ������������ ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddFontFromMem(FontData : Pointer; FontInfo : E2D_PFontInfo;
                              var FontID : E2D_TFontID) : E2D_Result; stdcall; export;

  { ��������� ��� �������� ����������� �������. ��������� :
      FirstFont : ������������� ������, � �������� ���������� ������ �������� (�����
                  ������� ��� ������ ����������� ����� �������); ��� �������� ����
                  ������� ������ �������� ������ ���� ����� E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteFonts(FirstFont : E2D_TFontID); stdcall; export;

  { ������� ��� ��������� ���������� � ����������� ������. ��������� :
      FontID   : ������������� ������, ���������� � ������� ���������� ��������;
      FontInfo : ��������� �� ��������� E2D_TFontInfo ��� ���������� ���������� (������,
                 ���������� � �������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetFontInfo(FontID : E2D_TFontID;
                           FontInfo : E2D_PFontInfo) : E2D_Result; stdcall; export;

implementation

uses
  Windows,   { ��� ��������� ������ }
  E2DLoader, { ��� �������� ������ � ������ }
  E2DSound,  { ��� ��������� }
  E2DConsts, { ��� �������� ������ � ���������� }
  E2DVars;   { ��� ���������� ���������� }

function E2D_AddImageFromFile;
var
  ImgData : Pointer;        { ����� ��� ������ ����������� }
  ImgInfo : E2D_TImageInfo; { ���������� �� ����������� }
label
  FreeData; { ������������ ������ ����������� }
begin { E2D_AddImageFromFile }
  // ��������� ����������� � ������.
  Result := E2D_LoadImage(FileName, ImgData, @ImgInfo);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then
    // ���� �� ���������� ������� �� �������.
    Exit;

  // ��������� ����������� �� ������.
  Result := E2D_AddImageFromMem(ImgData, @ImgInfo, ImageID);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then
    // ���� �� ���������� ����������� ������ �����������.
    goto FreeData;

  // ���������, ���� �� ������� ���������� � ����������� �����������.
  if ImageInfo <> nil then
    try
      // ���� ���� �������� ��������� ����������.
      ImageInfo^ := ImgInfo;
    except
      // ���� �� ���������� �������� ��� ������ � ���������,
      Result := E2DERR_SYSTEM_INVPOINTER;
      // ����������� ������ �����������,
      Dispose(ImgData);
      // ������� ��������� �����������
      E2D_DeleteImages(ImageID);
      // � ������� �� �������.
      Exit;
    end; { try }

  // ������ ��������� ��������.
  Result := E2DERR_OK;

FreeData :
  // ����������� ������ �����������.
  Dispose(ImgData);
end; { E2D_AddImageFromFile }

function CreateSurface;
var
  ddsd : TDDSurfaceDesc2; { ��������� ��� �������� ����������� }
  ddck : TDDColorKey;     { �������� ���� }
begin { CreateSurface }
  // �������� ���������.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // ��������� ���� ��������� �������� ����������� :
  with ddsd do begin { with }
    // ������ ���������,
    dwSize         := SizeOf(ddsd);
    // �����,
    dwFlags        := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    // ��������,
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_VIDEOMEMORY;
    // ������
    dwWidth        := ImageInfo^.Width;
    // � ������ ����������.
    dwHeight       := ImageInfo^.Height;
  end; { with }

  // ������� ����������� � �����������.
  Result := DD_Main.CreateSurface(ddsd, Surface, nil);

  // ��������� ��������� ����������.
  if Result = DDERR_OUTOFVIDEOMEMORY then begin { if }
    // ���� �� ���������� ������������� ����� �������� �����������.
    ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_SYSTEMMEMORY;
    // ������� ����������� � ��������� ������.
    Result := DD_Main.CreateSurface(ddsd, Surface, nil);
  end; { if }

  // ��������� ��������� ����������.
  if Result = DD_OK then begin { if }
    // ���� ���������� ������������� ������
    ddck.dwColorSpaceLowValue  := E2D_SCREEN_COLORKEY;
    // � ������� ������� ��������� �����
    ddck.dwColorSpaceHighValue := E2D_SCREEN_COLORKEY;
    // � ������������� ���.
    Result := Surface.SetColorKey(DDCKEY_SRCBLT, @ddck);
  end; { if }
end; { CreateSurface }

function E2D_AddImageFromMem;
begin { E2D_AddImageFromMem }
  // ��������� ���������� ����������� �����������.
  if NumImages >= E2D_MANAGE_MAXIMAGES then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_OUTOFMEM;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� �� �����������.
    Images[NumImages].Info := ImageInfo^;
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������� �����������.
  if CreateSurface(Images[NumImages].Surface, ImageInfo) <> DD_OK then begin  { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_CREATESURF;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� �������� ������ ��� ������ �����������.
    GetMem(Images[NumImages].Data, ImageInfo^.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // ������� �����������
    Images[NumImages].Surface := nil;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� ����������� ������ �����������.
    CopyMemory(Images[NumImages].Data, ImageData, ImageInfo^.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // ������� �����������,
    Images[NumImages].Surface := nil;
    // ����������� ������ ��� ������ �����������
    Dispose(Images[NumImages].Data);
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� ����������� �� �����������.
  Result := E2D_CopyImage(Images[NumImages].Surface, Images[NumImages].Data);
  // ��������� ��������� ����������.
  if Result = E2DERR_OK then begin { if }
    // ���� ���������� ��������� ������������� �����������
    ImageID := NumImages;
    // � ����������� ������� �����������.
    NumImages := NumImages + 1
  end else begin { else }
    // ���� �� ���������� ������� �����������
    Images[NumImages].Surface := nil;
    // � ����������� ������ ��� ������ �����������
    Dispose(Images[NumImages].Data);
  end; { else }
end; { E2D_AddImageFromMem }

procedure E2D_DeleteImages;
var
  i : Longword; { ������� ����� }
begin { E2D_DeleteImages }
  // ��������� ������ �����������.
  if FirstImage >= NumImages then
    // ���� �� ������ ���������� ����������� ������� �� �������.
    Exit;

  // ������� ��� ����������� �����������.
  for i := FirstImage to NumImages - 1 do begin { for }
    // ������� ����������� �����������.
    Images[i].Surface := nil;
    // ����������� ������ ��� ������ �����������.
    Dispose(Images[i].Data);
    // �������� ��� ���� ������.
    ZeroMemory(@Images[i], SizeOf(E2D_TImage));
  end; { for }

  // ������������� ����� ���������� �����������.
  NumImages := FirstImage;
end; { E2D_DeleteImages }

function E2D_GetImageInfo;
begin { E2D_GetImageInfo }
  // ��������� ������������� �����������.
  if ImageID >= NumImages then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� �� �����������.
    ImageInfo^ := Images[ImageID].Info;
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_GetImageInfo }

function E2D_CopyImage;
var
  ddsd : TDDSurfaceDesc2; { ��������� ��� �������� ����������� }
  i    : Longword;        { ������� ����� }
begin { E2D_CopyImage }
  // �������� ���������.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // ��������� ���� ������� ��������� �������� �����������.
  ddsd.dwSize := SizeOf(ddsd);
  // ��������� ��� �����������.
  if Surface.Lock(nil, ddsd, DDLOCK_WAIT, 0) <> DD_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_CANTLOCK;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ����������� �����������.
    for i := 0 to ddsd.dwHeight - 1 do
      {$WARNINGS OFF}
      // ������� ��������� ������ �����������.
      CopyMemory(Pointer(Longword(ddsd.lpSurface) + i * ddsd.lPitch),
                 Pointer(Longword(Data) + i * ddsd.dwWidth * E2D_SCREEN_BYTESPP),
                 ddsd.dwWidth * E2D_SCREEN_BYTESPP);
      {$WARNINGS ON}
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // �������� �����������
    Surface.Unlock(nil);
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� �����������.
  Surface.Unlock(nil);

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_CopyImage }

function E2D_AddSoundFromFile;
var
  SndData : Pointer;        { ����� ��� ������ ����� }
  SndInfo : E2D_TSoundInfo; { ���������� � ����� }
label
  FreeData; { ������������ ������ ����� }
begin { E2D_AddSoundFromFile }
  // ��������� ���� � ������.
  Result := E2D_LoadSound(FileName, SndData, @SndInfo);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then
    // ���� �� ���������� ������� �� �������.
    Exit;

  // ��������� ���� �� ������.
  Result := E2D_AddSoundFromMem(SndData, @SndInfo, SoundID);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then
    // ���� �� ���������� ����������� ������ �����������.
    goto FreeData;

  // ���������, ���� �� ������� ���������� � ����������� �����.
  if SoundInfo <> nil then
    try
      // ���� ���� �������� ��������� ����������.
      SoundInfo^ := SndInfo;
    except
      // ���� �� ���������� �������� ��� ������ � ���������,
      Result := E2DERR_SYSTEM_INVPOINTER;
      // ����������� ������ �����,
      Dispose(SndData);
      // ������� ��������� ����
      E2D_DeleteSounds(SoundID);
      // � ������� �� �������.
      Exit;
    end; { try }

  // ������ ��������� ��������.
  Result := E2DERR_OK;

FreeData :
  // ����������� ������ �����.
  Dispose(SndData);
end; { E2D_AddSoundFromFile }

{ ������� ��� �������� ������. ��������� :
    Buffer    : �����, ������� ���������� �������;
    SoundInfo : ��������� �� ��������� E2D_TSoundInfo, ��� ��������� ���������� � �����
               (���������� �������, ������� ������������� � ������);
  ������������ �������� : ���� ������� ����������� ������� - DD_OK, ���� �������� - ���
                          ������. }
function CreateBuffer(var Buffer : IDirectSoundBuffer;
                      SoundInfo : E2D_PSoundInfo) : HRESULT; register;
var
  dsbd : TDSBufferDesc; { ��������� ��� �������� ������ }
  wf   : TWaveFormatEx; { ��������� ��� �������� ������� ������ }
begin { CreateBuffer }
  // ��������� ���� ��������� �������� ������� ������ :
  with wf do begin { with }
    // ������,
    wFormatTag      := 1;
    // ���������� �������,
    nChannels       := SoundInfo^.Channels;
    // ������� �������������,
    nSamplesPerSec  := SoundInfo^.SamplesPerSec;
    // ������� ������������,
    nBlockAlign     := SoundInfo^.BlockAlign;
    // ��������
    wBitsPerSample  := SoundInfo^.BitsPerSample;
    // � ������� (� ������) ������.
    nAvgBytesPerSec := SoundInfo^.SamplesPerSec * SoundInfo^.BlockAlign;
  end; { with }

  // �������� ���������.
  ZeroMemory(@dsbd, SizeOf(dsbd));
  // ��������� ���� ��������� �������� ������ :
  with dsbd do begin { with }
    // ������ ���������,
    dwSize        := SizeOf(dsbd);
    // �����,
    dwFlags       := DSBCAPS_CTRLPAN or DSBCAPS_STATIC or
                     DSBCAPS_LOCHARDWARE or DSBCAPS_CTRLVOLUME;
    // ������
    dwBufferBytes := SoundInfo^.DataSize;
    // � ������ ������.
    lpwfxFormat   := @wf;
  end; { with }

  // ������� �����.
  Result := DS_Main.CreateSoundBuffer(dsbd, Buffer, nil);
end; { CreateBuffer }

function E2D_AddSoundFromMem;
begin { E2D_AddSoundFromMem }
  // ��������� ���������� ����������� �������.
  if NumSounds >= E2D_MANAGE_MAXSOUNDS then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_OUTOFMEM;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� � �����.
    Sounds[NumSounds].Info := SoundInfo^;
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������� �����.
  if CreateBuffer(Sounds[NumSounds].Buffer, SoundInfo) <> DS_OK then begin  { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_CREATEBUF;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� ���� � �����.
  Result := E2D_CopySound(Sounds[NumSounds].Buffer, SoundData,
                          Sounds[NumSounds].Info.DataSize);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then begin { if }
    // ���� �� ���������� ������� �����
    Sounds[NumSounds].Buffer := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ��������� ������������� �����
  SoundID := NumSounds;
  // � ����������� ������� ������.
  NumSounds := NumSounds + 1;

  // ������������� ���������.
  E2D_SetSoundVolume(SoundID, Volume_Global);
end; { E2D_AddSoundFromMem }

procedure E2D_DeleteSounds;
var
  i : Longword; { ������� ����� }
begin { E2D_DeleteSounds }
  // ��������� ������ �����.
  if FirstSound >= NumSounds then
    // ���� �� ������ ���������� ������ ������� �� �������.
    Exit;

  // ������� ��� ����������� �����.
  for i := FirstSound to NumSounds - 1 do begin { for }
    // ������� ����� �����.
    Sounds[i].Buffer := nil;
    // �������� ��� ���� ������.
    ZeroMemory(@Sounds[i], SizeOf(E2D_TSound));
  end; { for }

  // ������������� ����� ���������� ������.
  NumSounds := FirstSound;
end; { E2D_DeleteSounds }

function E2D_GetSoundInfo;
begin { E2D_GetSoundInfo }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� � �����.
    SoundInfo^ := Sounds[SoundID].Info;
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_GetSoundInfo }

function E2D_CopySound;
var
  ap1, ap2 : Pointer;  { ��������� �� ������ ����� }
  ab1, ab2 : Longword; { ������� ������ }
begin { E2D_CopySound }
  // ��������� ���� �����.
  if Buffer.Lock(0, Size, ap1, ab1, ap2, ab2,
                 DSBLOCK_ENTIREBUFFER) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_CANTLOCK;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ����������� ������ �����.
    CopyMemory(ap1, Data, Size);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // �������� �����
    Buffer.Unlock(ap1, ab1, ap2, ab2);
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� �����.
  Buffer.Unlock(ap1, ab1, ap2, ab2);

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_CopySound }

function E2D_AddFontFromFile;
var
  FntData : Pointer;       { ����� ��� ������ ������ }
  FntInfo : E2D_TFontInfo; { ���������� � ������ }
label
  FreeData; { ������������ ������ ������ }
begin { E2D_AddFontFromFile }
  // ��������� ����� � ������.
  Result := E2D_LoadFont(FileName, FntData, @FntInfo);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then
    // ���� �� ���������� ������� �� �������.
    Exit;

  // ��������� ����� �� ������.
  Result := E2D_AddFontFromMem(FntData, @FntInfo, FontID);
  // ��������� ��������� ����������.
  if Result <> E2DERR_OK then
    // ���� �� ���������� ����������� ������ ������.
    goto FreeData;

  // ���������, ���� �� ������� ���������� � ����������� ������.
  if FontInfo <> nil then
    try
      // ���� ���� �������� ��������� ����������.
      FontInfo^ := FntInfo;
    except
      // ���� �� ���������� �������� ��� ������ � ���������,
      Result := E2DERR_SYSTEM_INVPOINTER;
      // ����������� ������ ������,
      Dispose(FntData);
      // ������� ��������� �����
      E2D_DeleteFonts(FontID);
      // � ������� �� �������.
      Exit;
    end; { try }

  
  Result := E2DERR_OK;

FreeData :
  // ����������� ������ ������.
  Dispose(FntData);
end; { E2D_AddFontFromFile }

function E2D_AddFontFromMem;
begin { E2D_AddFontFromMem }
  // ��������� ���������� ����������� �������.
  if NumFonts >= E2D_MANAGE_MAXFONTS then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_OUTOFMEM;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� � ������.
    Fonts[NumFonts].Info := FontInfo^;
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������� �����������.
  if CreateSurface(Fonts[NumFonts].Surface, @FontInfo^.Image) <> DD_OK then begin  { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_MANAGE_CREATESURF;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� �������� ������ ��� ������ ������.
    GetMem(Fonts[NumFonts].Data, FontInfo^.Image.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // ������� �����������
    Fonts[NumFonts].Surface := nil;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� ����������� ������ ������.
    CopyMemory(Fonts[NumFonts].Data, FontData, FontInfo^.Image.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // ������� �����������,
    Fonts[NumFonts].Surface := nil;
    // ����������� ������ ��� ������ ������
    Dispose(Fonts[NumFonts].Data);
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� ����������� �� �����������.
  Result := E2D_CopyImage(Fonts[NumFonts].Surface, Fonts[NumFonts].Data);
  // ��������� ��������� ����������.
  if Result = E2DERR_OK then begin { if }
    // ���� ���������� ��������� ������������� ������
    FontID := NumFonts;
    // � ����������� ������� �������.
    NumFonts := NumFonts + 1
  end else begin { else }
    // ���� �� ���������� ������� �����������
    Fonts[NumFonts].Surface := nil;
    // � ����������� ������ ��� ������ ������
    Dispose(Fonts[NumFonts].Data);
  end; { else }
end; { E2D_AddFontFromMem }

procedure E2D_DeleteFonts;
var
  i : Longword; { ������� ����� }
begin { E2D_DeleteFonts }
  // ��������� ������ ������.
  if FirstFont >= NumFonts then
    // ���� �� ������ ���������� ������� ������� �� �������.
    Exit;

  // ������� ��� ����������� ������.
  for i := FirstFont to NumFonts - 1 do begin { for }
    // ������� ����������� ������.
    Fonts[i].Surface := nil;
    // ����������� ������ ��� ������ ������.
    Dispose(Fonts[i].Data);
    // �������� ��� ���� ������.
    ZeroMemory(@Fonts[i], SizeOf(E2D_TFont));
  end; { for }

  // ������������� ����� ���������� �����������.
  NumFonts := FirstFont;
end; { E2D_DeleteFonts }

function E2D_GetFontInfo;
begin { E2D_GetFontInfo }
  // ��������� ������������� ������.
  if FontID >= NumFonts then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� � ������.
    FontInfo^ := Fonts[FontID].Info;
  except
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVPOINTER;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_GetFontInfo }

end.
