(************************************* Ext2D Engine *************************************)
(* ������     : E2DLoader.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 07.05.06                                                                *)
(* ���������� : ������ �������� ������� ��� �������� � ������ ����������� �� *.eif      *)
(*              ������, ������ �� *.esf ������ � ������� �� *.eff ������.               *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DLoader;

interface

uses
  E2DTypes;

  { ������� ��� �������� ����������� �� ������ � ������. ��������� :
      FileName  : ��� ����� ����������� ��� �������� (*.eif �����);
      ImageData : ����� ������ ��� ���������� ������ �����������;
      ImageInfo : ��������� �� ��������� E2D_TImageInfo ��� ���������� ���������� �
                  ����������� ����������� (������, ������, ������ ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_LoadImage(FileName : PChar; var ImageData : Pointer;
                         ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall; export;

  { ������� ��� �������� ������ �� ������ � ������. ��������� :
      FileName  : ��� ����� ����� ��� �������� (*.esf �����);
      SoundData : ����� ������ ��� ���������� ������ �����;
      SoundInfo : ��������� �� ��������� E2D_TSoundInfo ��� ���������� ���������� �
                  ����������� ����� (���������� �������, ������� ������������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_LoadSound(FileName : PChar; var SoundData : Pointer;
                         SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall; export;

  { ������� ��� �������� ������� �� ������ � ������. ��������� :
      FileName : ��� ����� ������ ��� �������� (*.eff �����);
      FontData : ����� ������ ��� ���������� ������ ������;
      FontInfo : ��������� �� ��������� E2D_TFontInfo ��� ���������� ���������� �
                 ����������� ������ (������, ���������� � �������� � ������).
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_LoadFont(FileName : PChar; var FontData : Pointer;
                        FontInfo : E2D_PFontInfo) : E2D_Result; stdcall; export;

  { �������  ��� ������������ ������, ���������� ��� ������ �����������, ����� ��� ������.
    ��������� :
      Data : ����� ������, � ������� ��������� ������ �����������, ����� ��� ������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_FreeMem(var Data : Pointer) : E2D_Result; stdcall; export;

implementation

uses
  E2DConsts, { ��� ������� ������ }
  E2DStream, { ��� �������� ������� }
  Zlib;      { ��� ������������ }

type
  { ��������� EIF ����� ����������� }
  TEIFHeader = packed record
    Signature : Longword;       { ��������� �����, ������ ���� "EIF_" }
    ImageInfo : E2D_TImageInfo; { ���������� �� �����������  }
    Data      : Longword;       { ������ ������ ������, ������ ���� "data" }
  end; { TEIFHeader }

  { ��������� ESF ����� ����� }
  TESFHeader = packed record
    Signature : Longword;       { ��������� �����, ������ ���� "ESF_" }
    SoundInfo : E2D_TSoundInfo; { ���������� � ����� }
    Data      : Longword;       { ������ ������ ������, ������ ���� "data" }
  end; { TESFHeader }

  { ��������� EFF ����� ������ }
  TEFFHeader = packed record
    Signature : Longword;      { ��������� �����, ������ ���� "EFF_" }
    FontInfo  : E2D_TFontInfo; { ���������� � ������ }
    Data      : Longword;      { ������ ������ ������, ������ ���� "data" }
  end; { TEFFHeader }

const
  { ����� �������� }
  sData = $61746164; { ������ ������ ������ � ����� }

  { �������� EIF ����� ����������� }
  EIFHeaderSize = SizeOf(TEIFHeader); { ������ ��������� EIF ����� ����������� }
  EIFSignature  = $5F464945;          { ��������� EIF ����� ����������� }

  { �������� ESF ����� ����� }
  ESFHeaderSize = SizeOf(TESFHeader); { ������ ��������� ESF ����� ����� }
  ESFSignature  = $5F465345;          { ��������� ESF ����� ����� }

  { �������� EFF ����� ������ }
  EFFHeaderSize = SizeOf(TEFFHeader); { ������ ��������� EFF ����� ������ }
  EFFSignature  = $5F464645;          { ��������� EFF ����� ������ }

{$WARNINGS OFF}

function E2D_LoadImage;
var
  fs : TFileStream;          { ����� ����� ����������� }
  ds : TDecompressionStream; { ����� ��� ������������ ������ }
  hd : TEIFHeader;           { ��������� ����� ����������� }
  br : Longword;             { ���������� ����������� ���� �� ������ }
begin { E2D_LoadImage }
  // ������� ������ ������.
  fs := TFileStream.Create;
  // �������� ������� ���� �����������.
  if not fs.OpenFile(FileName) then begin
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTOPEN;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� �������� ��������� ����� �����������.
    br := fs.Read(hd, EIFHeaderSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTREAD;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� ���������� ����������� ����, ��������� ����� ����������� � ������ ������
  // ������.
  if (br <> EIFHeaderSize) or (hd.Signature <> EIFSignature) or
     (hd.Data <> sData) then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_INVALID;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� �� �����������.
    ImageInfo^ := hd.ImageInfo;
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_INVPOINTER;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� �������� ������ ��� ������ �����������.
    GetMem(ImageData, hd.ImageInfo.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������� ����� ��� ������������.
  ds := TDecompressionStream.Create(fs);

  try
    // �������� ������� ������ ����������� � ������.
    br := ds.Read(ImageData^, hd.ImageInfo.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTREAD;
    // ����������� ����� ��� ������������,
    ds.Free;
    // ����������� ����,
    fs.Free;
    // ����������� ������ ��� ������ �����������
    Dispose(ImageData);
    // � ������� �� �������.
    Exit;
  end; { try }

  // ��������� ���������� ����������� ����.
  if br <> hd.ImageInfo.DataSize then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_DECOMPRESS;
    // ����������� ����� ��� ������������,
    ds.Free;
    // ����������� ����,
    fs.Free;
    // ����������� ������ ��� ������ �����������
    Dispose(ImageData);
    // � ������� �� �������.
    Exit;
  end; { if }

  // ����������� ����� ��� ������������.
  ds.Free;
  // ����������� ����.
  fs.Free;

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_LoadImage }

function E2D_LoadSound;
var
  fs : TFileStream;          { ����� ����� ����� }
  ds : TDecompressionStream; { ����� ��� ������������ ������ }
  hd : TESFHeader;           { ��������� ����� ����� }
  br : Longword;             { ���������� ����������� ���� �� ������ }
begin { E2D_LoadSound }
  // ������� ������ ������. 
  fs := TFileStream.Create;
  //  �������� ������� ���� �����.
  if not fs.OpenFile(FileName) then begin
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTOPEN;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� �������� ��������� ����� �����.
    br := fs.Read(hd, ESFHeaderSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTREAD;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� ���������� ����������� ����, ��������� ����� ����� � ������ ������ ������.
  if (br <> ESFHeaderSize) or (hd.Signature <> ESFSignature) or
     (hd.Data <> sData) then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_INVALID;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� � �����.
    SoundInfo^ := hd.SoundInfo;
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_INVPOINTER;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� �������� ������ ��� ������ �����.
    GetMem(SoundData, hd.SoundInfo.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������� ����� ��� ������������.
  ds := TDecompressionStream.Create(fs);

  try
    // �������� ������� ������ ����� � ������.
    br := ds.Read(SoundData^, hd.SoundInfo.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTREAD;
    // ����������� ����� ��� ������������,
    ds.Free;
    // ����������� ����,
    fs.Free;
    // ����������� ������ ��� ������ �����
    Dispose(SoundData);
    // � ������� �� �������.
    Exit;
  end; { try }

  // ��������� ���������� ����������� ����.
  if br <> hd.SoundInfo.DataSize then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_DECOMPRESS;
    // ����������� ����� ��� ������������,
    ds.Free;
    // ����������� ����,
    fs.Free;
    // ����������� ������ ��� ������ �����
    Dispose(SoundData);
    // � ������� �� �������.
    Exit;
  end; { if }

  // ����������� ����� ��� ������������.
  ds.Free;
  // ����������� ����.
  fs.Free;

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_LoadSound }

function E2D_LoadFont;
var
  fs : TFileStream;          { ����� ����� ������ }
  ds : TDecompressionStream; { ����� ��� ������������ ������ }
  hd : TEFFHeader;           { ��������� ����� ������ }
  br : Longword;             { ���������� ����������� ���� �� ������ }
begin { E2D_LoadFont }
  // ������� ������ ������.
  fs := TFileStream.Create;
  // �������� ������� ���� ������.
  if not fs.OpenFile(FileName) then begin
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTOPEN;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� �������� ��������� ����� ������.
    br := fs.Read(hd, EFFHeaderSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTREAD;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  // �������� ���������� ����������� ����, ��������� ����� ������ � ������ ������ ������.
  if (br <> EFFHeaderSize) or (hd.Signature <> EFFSignature) or
     (hd.Data <> sData) then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_INVALID;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { if }

  try
    // �������� ��������� ���������� � ������.
    FontInfo^ := hd.FontInfo;
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_INVPOINTER;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  try
    // �������� �������� ������ ��� ������ ������.
    GetMem(FontData, hd.FontInfo.Image.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // ����������� ����
    fs.Free;
    // � ������� �� �������.
    Exit;
  end; { try }

  // ������� ����� ��� ������������.
  ds := TDecompressionStream.Create(fs);

  try
    // �������� ������� ������ ������ � ������.
    br := ds.Read(FontData^, hd.FontInfo.Image.DataSize);
  except
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_CANTREAD;
    // ����������� ����� ��� ������������,
    ds.Free;
    // ����������� ����,
    fs.Free;
    // ����������� ������ ��� ������ ������
    Dispose(FontData);
    // � ������� �� �������.
    Exit;
  end; { try }

  // ��������� ���������� ����������� ����.
  if br <> hd.FontInfo.Image.DataSize then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_LOAD_DECOMPRESS;
    // ����������� ����� ��� ������������,
    ds.Free;
    // ����������� ����,
    fs.Free;
    // ����������� ������ ��� ������ ������
    Dispose(FontData);
    // � ������� �� �������.
    Exit;
  end; { if }

  // ����������� ����� ��� ������������.
  ds.Free;
  // ����������� ����.
  fs.Free;

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_LoadFont }

{$WARNINGS ON}

function E2D_FreeMem;
begin { E2D_FreeMem }
  // ������ ��������� ��������.
  Result := E2DERR_OK;

  try
    // �������� ���������� ������.
    Dispose(Data);
  except
    // ���� �� ���������� �������� ��� ������ � ���������.
    Result := E2DERR_SYSTEM_INVPOINTER;
  end; { try }
end; { E2D_FreeMem }

end.
