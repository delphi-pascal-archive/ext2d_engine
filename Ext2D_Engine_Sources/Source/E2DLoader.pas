(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DLoader.pas                                                           *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 07.05.06                                                                *)
(* Информация : Модуль содержит функции для загрузки в память изображений из *.eif      *)
(*              файлов, звуков из *.esf файлов и шрифтов из *.eff файлов.               *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DLoader;

interface

uses
  E2DTypes;

  { Функция для загрузки изобоажений из файлов в память. Параметры :
      FileName  : имя файла изображения для загрузки (*.eif файлы);
      ImageData : адрес буфера для сохранения данных изображения;
      ImageInfo : указатель на структуру E2D_TImageInfo для сохранения информации о
                  загруженном изображении (высота, ширина, размер данных).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_LoadImage(FileName : PChar; var ImageData : Pointer;
                         ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall; export;

  { Функция для загрузки звуков из файлов в память. Параметры :
      FileName  : имя файла звука для загрузки (*.esf файлы);
      SoundData : адрес буфера для сохранения данных звука;
      SoundInfo : указатель на структуру E2D_TSoundInfo для сохранения информации о
                  загруженном звуке (количество каналов, частота дискретизации и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_LoadSound(FileName : PChar; var SoundData : Pointer;
                         SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall; export;

  { Функция для загрузки шрифтов из файлов в память. Параметры :
      FileName : имя файла шрифта для загрузки (*.eff файлы);
      FontData : адрес буфера для сохранения данных шрифта;
      FontInfo : указатель на структуру E2D_TFontInfo для сохранения информации о
                 загруженном шрифте (размер, информация о символах и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_LoadFont(FileName : PChar; var FontData : Pointer;
                        FontInfo : E2D_PFontInfo) : E2D_Result; stdcall; export;

  { Функция  для освобождения памяти, выделенной для данных изображения, звука или шрифта.
    Параметры :
      Data : адрес буфера, в котором сохранены данные изображения, звука или шрифта.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_FreeMem(var Data : Pointer) : E2D_Result; stdcall; export;

implementation

uses
  E2DConsts, { Для костант ошибок }
  E2DStream, { Для файловых потоков }
  Zlib;      { Для декомпрессии }

type
  { Заголовок EIF файла изображения }
  TEIFHeader = packed record
    Signature : Longword;       { Сигнатура файла, должна быть "EIF_" }
    ImageInfo : E2D_TImageInfo; { Информация об изображении  }
    Data      : Longword;       { Строка начала данных, должна быть "data" }
  end; { TEIFHeader }

  { Заголовок ESF файла звука }
  TESFHeader = packed record
    Signature : Longword;       { Сигнатура файла, должна быть "ESF_" }
    SoundInfo : E2D_TSoundInfo; { Информация о звуке }
    Data      : Longword;       { Строка начала данных, должна быть "data" }
  end; { TESFHeader }

  { Заголовок EFF файла шрифта }
  TEFFHeader = packed record
    Signature : Longword;      { Сигнатура файла, должна быть "EFF_" }
    FontInfo  : E2D_TFontInfo; { Информация о шрифте }
    Data      : Longword;      { Строка начала данных, должна быть "data" }
  end; { TEFFHeader }

const
  { Общие костанты }
  sData = $61746164; { Строка начала данных в файле }

  { Костанты EIF файла изображения }
  EIFHeaderSize = SizeOf(TEIFHeader); { Размер заголовка EIF файла изображения }
  EIFSignature  = $5F464945;          { Сигнатура EIF файла изображения }

  { Костанты ESF файла звука }
  ESFHeaderSize = SizeOf(TESFHeader); { Размер заголовка ESF файла звука }
  ESFSignature  = $5F465345;          { Сигнатура ESF файла звука }

  { Костанты EFF файла шрифта }
  EFFHeaderSize = SizeOf(TEFFHeader); { Размер заголовка EFF файла шрифта }
  EFFSignature  = $5F464645;          { Сигнатура EFF файла шрифта }

{$WARNINGS OFF}

function E2D_LoadImage;
var
  fs : TFileStream;          { Поток файла изображения }
  ds : TDecompressionStream; { Поток для декомпрессии данных }
  hd : TEIFHeader;           { Заголовок файла изображения }
  br : Longword;             { Количество прочитанных байт из потока }
begin { E2D_LoadImage }
  // Создаем обьект потока.
  fs := TFileStream.Create;
  // Пытаемся открыть файл изображения.
  if not fs.OpenFile(FileName) then begin
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTOPEN;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся прочесть заголовок файла изображения.
    br := fs.Read(hd, EIFHeaderSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTREAD;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  // Прверяем количество прочитанных байт, сигнатуру файла изображения и строку начала
  // данных.
  if (br <> EIFHeaderSize) or (hd.Signature <> EIFSignature) or
     (hd.Data <> sData) then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_INVALID;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию об изображении.
    ImageInfo^ := hd.ImageInfo;
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_INVPOINTER;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся выделить память для данных изображения.
    GetMem(ImageData, hd.ImageInfo.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  // Создаем поток для декомпрессии.
  ds := TDecompressionStream.Create(fs);

  try
    // Пытаемся извлечь данные изображения в память.
    br := ds.Read(ImageData^, hd.ImageInfo.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTREAD;
    // освобождаем поток для декомпрессии,
    ds.Free;
    // освобождаем файл,
    fs.Free;
    // освобождаем память для данных изображения
    Dispose(ImageData);
    // и выходим из функции.
    Exit;
  end; { try }

  // Проверяем количество прочитанных байт.
  if br <> hd.ImageInfo.DataSize then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_DECOMPRESS;
    // освобождаем поток для декомпрессии,
    ds.Free;
    // освобождаем файл,
    fs.Free;
    // освобождаем память для данных изображения
    Dispose(ImageData);
    // и выходим из функции.
    Exit;
  end; { if }

  // Освобождаем поток для декомпрессии.
  ds.Free;
  // Освобождаем файл.
  fs.Free;

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_LoadImage }

function E2D_LoadSound;
var
  fs : TFileStream;          { Поток файла звука }
  ds : TDecompressionStream; { Поток для декомпрессии данных }
  hd : TESFHeader;           { Заголовок файла звука }
  br : Longword;             { Количество прочитанных байт из потока }
begin { E2D_LoadSound }
  // Создаем обьект потока. 
  fs := TFileStream.Create;
  //  Пытаемся открыть файл звука.
  if not fs.OpenFile(FileName) then begin
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTOPEN;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся прочесть заголовок файла звука.
    br := fs.Read(hd, ESFHeaderSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTREAD;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  // Прверяем количество прочитанных байт, сигнатуру файла звука и строку начала данных.
  if (br <> ESFHeaderSize) or (hd.Signature <> ESFSignature) or
     (hd.Data <> sData) then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_INVALID;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию о звуке.
    SoundInfo^ := hd.SoundInfo;
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_INVPOINTER;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся выделить память для данных звука.
    GetMem(SoundData, hd.SoundInfo.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  // Создаем поток для декомпрессии.
  ds := TDecompressionStream.Create(fs);

  try
    // Пытаемся извлечь данные звука в память.
    br := ds.Read(SoundData^, hd.SoundInfo.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTREAD;
    // освобождаем поток для декомпрессии,
    ds.Free;
    // освобождаем файл,
    fs.Free;
    // освобождаем память для данных звука
    Dispose(SoundData);
    // и выходим из функции.
    Exit;
  end; { try }

  // Проверяем количество прочитанных байт.
  if br <> hd.SoundInfo.DataSize then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_DECOMPRESS;
    // освобождаем поток для декомпрессии,
    ds.Free;
    // освобождаем файл,
    fs.Free;
    // освобождаем память для данных звука
    Dispose(SoundData);
    // и выходим из функции.
    Exit;
  end; { if }

  // Освобождаем поток для декомпрессии.
  ds.Free;
  // Освобождаем файл.
  fs.Free;

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_LoadSound }

function E2D_LoadFont;
var
  fs : TFileStream;          { Поток файла шрифта }
  ds : TDecompressionStream; { Поток для декомпрессии данных }
  hd : TEFFHeader;           { Заголовок файла шрифта }
  br : Longword;             { Количество прочитанных байт из потока }
begin { E2D_LoadFont }
  // Создаем обьект потока.
  fs := TFileStream.Create;
  // Пытаемся открыть файл шрифта.
  if not fs.OpenFile(FileName) then begin
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTOPEN;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся прочесть заголовок файла шрифта.
    br := fs.Read(hd, EFFHeaderSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTREAD;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  // Прверяем количество прочитанных байт, сигнатуру файла шрифта и строку начала данных.
  if (br <> EFFHeaderSize) or (hd.Signature <> EFFSignature) or
     (hd.Data <> sData) then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_INVALID;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию о шрифте.
    FontInfo^ := hd.FontInfo;
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_INVPOINTER;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся выделить память для данных шрифта.
    GetMem(FontData, hd.FontInfo.Image.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // освобождаем файл
    fs.Free;
    // и выходим из функции.
    Exit;
  end; { try }

  // Создаем поток для декомпрессии.
  ds := TDecompressionStream.Create(fs);

  try
    // Пытаемся извлечь данные шрифта в память.
    br := ds.Read(FontData^, hd.FontInfo.Image.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_CANTREAD;
    // освобождаем поток для декомпрессии,
    ds.Free;
    // освобождаем файл,
    fs.Free;
    // освобождаем память для данных шрифта
    Dispose(FontData);
    // и выходим из функции.
    Exit;
  end; { try }

  // Проверяем количество прочитанных байт.
  if br <> hd.FontInfo.Image.DataSize then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_LOAD_DECOMPRESS;
    // освобождаем поток для декомпрессии,
    ds.Free;
    // освобождаем файл,
    fs.Free;
    // освобождаем память для данных шрифта
    Dispose(FontData);
    // и выходим из функции.
    Exit;
  end; { if }

  // Освобождаем поток для декомпрессии.
  ds.Free;
  // Освобождаем файл.
  fs.Free;

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_LoadFont }

{$WARNINGS ON}

function E2D_FreeMem;
begin { E2D_FreeMem }
  // Делаем результат успешным.
  Result := E2DERR_OK;

  try
    // Пытаемся освободить память.
    Dispose(Data);
  except
    // Если не получилось помещаем код ошибки в результат.
    Result := E2DERR_SYSTEM_INVPOINTER;
  end; { try }
end; { E2D_FreeMem }

end.
