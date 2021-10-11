(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DManager.pas                                                          *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 22.10.06                                                                *)
(* Информация : Модуль содержит функции для управления изображениями, звуками и         *)
(*              шрифтами.                                                               *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DManager;

interface

uses
  E2DTypes, DirectDraw, DirectSound;

  { Функция для загрузки изображений из файлов и создания из них поверхности. Параметры :
      FileName  : имя файла изображения для загрузки (*.eif файлы);
      ImageInfo : указатель на структуру E2D_TImageInfo для сохранения информации о
                  загруженном изображении (высота, ширина, размер данных); данный параметр
                  может быть nil, если информация не нужна;
      ImageID   : переменная для сохранения идентификатора загруженного изображения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddImageFromFile(FileName : PChar; ImageInfo : E2D_PImageInfo;
                                var ImageID : E2D_TImageID) : E2D_Result; stdcall; export;

  { Функция для создания поверхности. Параметры :
      Surface   : поверхность, которую необходимо создать;
      ImageInfo : указатель на структуру E2D_TImageInfo, где сохранена информация об
                  изображении (высота, ширина, размер данных);
    Возвращаемое значение : если функция выполнилась успешно - DD_OK, если неудачно - код
                            ошибки. }
  function CreateSurface(var Surface : IDirectDrawSurface7;
                         ImageInfo : E2D_PImageInfo) : HRESULT; register;

  { Функция для загрузки изображений из памяти и создания из них поверхности. Параметры :
      ImageData : адрес буфера, где сохранены данные изображения;
      ImageInfo : указатель на структуру E2D_TImageInfo, где сохранена информация об
                  изображении (высота, ширина, размер данных);
      ImageID   : переменная для сохранения идентификатора загруженного изображения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddImageFromMem(ImageData : Pointer; ImageInfo : E2D_PImageInfo;
                               var ImageID : E2D_TImageID) : E2D_Result; stdcall; export;

  { Процедура для удаления загруженных изображений. Параметры :
      FirstImage : идентификатор изображения, с которого необходимо начать удаление (будут
                   удалены все изображения загруженные после данного); для удаления всех
                   изображений данный параметр должен быть равен E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteImages(FirstImage : E2D_TImageID); stdcall; export;

  { Функция для получения информации о загруженном изображении. Параметры :
      ImageID   : идентификатор изображения, информацию о котором необходимо получить;
      ImageInfo : указатель на структуру E2D_TImageInfo для сохранения информации (высота,
                  ширина, размер данных).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetImageInfo(ImageID : E2D_TImageID;
                            ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall; export;

  { Функция для копирования данных изображения на поверхность. Параметры :
      Surface : поверхность, на которую необходимо скопировать изображение;
      Data    : данные изображения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CopyImage(Surface : IDirectDrawSurface7;
                         Data : Pointer) : E2D_Result; register;

  { Функция для загрузки звуков из файлов и создания для них буферов. Параметры :
      FileName  : имя файла звука для загрузки (*.esf файлы);
      SoundInfo : указатель на структуру E2D_TSoundInfo для сохранения информации о
                  загруженном звуке (количество каналов, частота дискретизации и другое);
                  данный параметр может быть nil, если информация не нужна;
      SoundID   : переменная для сохранения идентификатора загруженного звука.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddSoundFromFile(FileName : PChar; SoundInfo : E2D_PSoundInfo;
                                var SoundID : E2D_TSoundID) : E2D_Result; stdcall; export;

  { Функция для загрузки звуков из памяти и создания для них буферов. Параметры :
      SoundData : адрес буфера, где сохранены данные звука;
      SoundInfo : указатель на структуру E2D_TSoundInfo, где сохранена информация о звуке
                  (количество каналов, частота дискретизации и другое);
      SoundID   : переменная для сохранения идентификатора загруженного звука.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddSoundFromMem(SoundData : Pointer; SoundInfo : E2D_PSoundInfo;
                               var SoundID : E2D_TSoundID) : E2D_Result; stdcall; export;

  { Процедура для удаления загруженных звуков. Параметры :
      FirstSound : идентификатор звука, с которого необходимо начать удаление (будут
                   удалены все звуки загруженные после данного); для удаления всех звуков
                   данный параметр должен быть равен E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteSounds(FirstSound : E2D_TSoundID); stdcall; export;

  { Функция для получения информации о загруженном звуке. Параметры :
      SoundID   : идентификатор звука, информацию о котором необходимо получить;
      SoundInfo : указатель на структуру E2D_TSoundInfo для сохранения информации
                 (количество каналов, частота дискретизации и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetSoundInfo(SoundID : E2D_TSoundID;
                            SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall; export;

  { Функция для копирования данных звука в буфер. Параметры :
      Buffer : буфер, в который необходимо скопировать звук;
      Data   : данные звука;
      Size   : размер данных.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CopySound(Buffer : IDirectSoundBuffer; Data : Pointer;
                         Size : Longword) : E2D_Result; register;

  { Функция для загрузки шрифтов из файлов и создания из них поверхности. Параметры :
      FileName : имя файла шрифта для загрузки (*.eff файлы);
      FontInfo : указатель на структуру E2D_TFontInfo для сохранения информации о
                 загруженном шрифте (размер, информация о символах и другое); данный
                 параметр может быть nil, если информация не нужна;
      FontID   : переменная для сохранения идентификатора загруженного шрифта.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddFontFromFile(FileName : PChar; FontInfo : E2D_PFontInfo;
                               var FontID : E2D_TFontID) : E2D_Result; stdcall; export;

  { Функция для загрузки изображений из памяти и создания из них поверхности. Параметры :
      FontData : адрес буфера, где сохранены данные шрифта;
      FontInfo : указатель на структуру E2D_TFontInfo, где сохранена информация о шрифте
                 (размер, информация о символах и другое);
      FontID   : переменная для сохранения идентификатора загруженного шрифта.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddFontFromMem(FontData : Pointer; FontInfo : E2D_PFontInfo;
                              var FontID : E2D_TFontID) : E2D_Result; stdcall; export;

  { Процедура для удаления загруженных шрифтов. Параметры :
      FirstFont : идентификатор шрифта, с которого необходимо начать удаление (будут
                  удалены все шрифты загруженные после данного); для удаления всех
                  шрифтов данный параметр должен быть равен E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteFonts(FirstFont : E2D_TFontID); stdcall; export;

  { Функция для получения информации о загруженном шрифте. Параметры :
      FontID   : идентификатор шрифта, информацию о котором необходимо получить;
      FontInfo : указатель на структуру E2D_TFontInfo для сохранения информации (размер,
                 информация о символах и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetFontInfo(FontID : E2D_TFontID;
                           FontInfo : E2D_PFontInfo) : E2D_Result; stdcall; export;

implementation

uses
  Windows,   { Для обнуления памяти }
  E2DLoader, { Для загрузки файлов в память }
  E2DSound,  { Для громкости }
  E2DConsts, { Для констант ошибок и управления }
  E2DVars;   { Для глобальных переменных }

function E2D_AddImageFromFile;
var
  ImgData : Pointer;        { Буфер для данных изображения }
  ImgInfo : E2D_TImageInfo; { Информация об изображении }
label
  FreeData; { Освобождение данных изображения }
begin { E2D_AddImageFromFile }
  // Загружаем изображение в память.
  Result := E2D_LoadImage(FileName, ImgData, @ImgInfo);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then
    // Если не получилось выходим из функции.
    Exit;

  // Добавляем изображение из памяти.
  Result := E2D_AddImageFromMem(ImgData, @ImgInfo, ImageID);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then
    // Если не получилось освобождаем данные изображения.
    goto FreeData;

  // Проверяем, надо ли вернуть информацию о загруженном изображении.
  if ImageInfo <> nil then
    try
      // Если надо пытаемся сохранить информацию.
      ImageInfo^ := ImgInfo;
    except
      // Если не получилось помещаем код ошибки в результат,
      Result := E2DERR_SYSTEM_INVPOINTER;
      // освобождаем данные изображения,
      Dispose(ImgData);
      // удаляем созданное изображение
      E2D_DeleteImages(ImageID);
      // и выходим из функции.
      Exit;
    end; { try }

  // Делаем результат успешным.
  Result := E2DERR_OK;

FreeData :
  // Освобождаем данные изображения.
  Dispose(ImgData);
end; { E2D_AddImageFromFile }

function CreateSurface;
var
  ddsd : TDDSurfaceDesc2; { Структура для описания поверхности }
  ddck : TDDColorKey;     { Цветовой ключ }
begin { CreateSurface }
  // Обнуляем структуру.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // Заполняем поля структуры описания поверхности :
  with ddsd do begin { with }
    // размер структуры,
    dwSize         := SizeOf(ddsd);
    // флаги,
    dwFlags        := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    // свойства,
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_VIDEOMEMORY;
    // ширину
    dwWidth        := ImageInfo^.Width;
    // и высоту поверности.
    dwHeight       := ImageInfo^.Height;
  end; { with }

  // Создаем поверхность в видеопамяти.
  Result := DD_Main.CreateSurface(ddsd, Surface, nil);

  // Проверяем результат выполнения.
  if Result = DDERR_OUTOFVIDEOMEMORY then begin { if }
    // Если не получилось устанавливаем новые свойства поверхности.
    ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_SYSTEMMEMORY;
    // Создаем поверхность в системной памяти.
    Result := DD_Main.CreateSurface(ddsd, Surface, nil);
  end; { if }

  // Проверяем результат выполнения.
  if Result = DD_OK then begin { if }
    // Если получилось устанавливаем нижнюю
    ddck.dwColorSpaceLowValue  := E2D_SCREEN_COLORKEY;
    // и верхнюю границы цветового ключа
    ddck.dwColorSpaceHighValue := E2D_SCREEN_COLORKEY;
    // и устанавливаем его.
    Result := Surface.SetColorKey(DDCKEY_SRCBLT, @ddck);
  end; { if }
end; { CreateSurface }

function E2D_AddImageFromMem;
begin { E2D_AddImageFromMem }
  // Проверяем количество загруженных изображений.
  if NumImages >= E2D_MANAGE_MAXIMAGES then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_OUTOFMEM;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию об изображении.
    Images[NumImages].Info := ImageInfo^;
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Создаем поверхность.
  if CreateSurface(Images[NumImages].Surface, ImageInfo) <> DD_OK then begin  { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_CREATESURF;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся выделить память для данных изображения.
    GetMem(Images[NumImages].Data, ImageInfo^.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // удаляем поверхность
    Images[NumImages].Surface := nil;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся скопировать данные изображения.
    CopyMemory(Images[NumImages].Data, ImageData, ImageInfo^.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // удаляем поверхность,
    Images[NumImages].Surface := nil;
    // освобождаем память для данных изображения
    Dispose(Images[NumImages].Data);
    // и выходим из функции.
    Exit;
  end; { try }

  // Копируем изображение на поверхность.
  Result := E2D_CopyImage(Images[NumImages].Surface, Images[NumImages].Data);
  // Проверяем результат выполнения.
  if Result = E2DERR_OK then begin { if }
    // Если получилось сохраняем идентификатор изображения
    ImageID := NumImages;
    // и увеличиваем счетчик изображений.
    NumImages := NumImages + 1
  end else begin { else }
    // Если не получилось удаляем поверхность
    Images[NumImages].Surface := nil;
    // и освобождаем память для данных изображения
    Dispose(Images[NumImages].Data);
  end; { else }
end; { E2D_AddImageFromMem }

procedure E2D_DeleteImages;
var
  i : Longword; { Счетчик цикла }
begin { E2D_DeleteImages }
  // Проверяем индекс изображения.
  if FirstImage >= NumImages then
    // Если он больше количества изображений выходим из функции.
    Exit;

  // Удаляем все необходимые изображения.
  for i := FirstImage to NumImages - 1 do begin { for }
    // Удаляем поверхность изображения.
    Images[i].Surface := nil;
    // Освобождаем память для данных изображения.
    Dispose(Images[i].Data);
    // Обнуляем все поля записи.
    ZeroMemory(@Images[i], SizeOf(E2D_TImage));
  end; { for }

  // Устанавливаем новое количество изображений.
  NumImages := FirstImage;
end; { E2D_DeleteImages }

function E2D_GetImageInfo;
begin { E2D_GetImageInfo }
  // Проверяем идентификатор изображения.
  if ImageID >= NumImages then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию об изображении.
    ImageInfo^ := Images[ImageID].Info;
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_GetImageInfo }

function E2D_CopyImage;
var
  ddsd : TDDSurfaceDesc2; { Структура для описания поверхности }
  i    : Longword;        { Счетчик цикла }
begin { E2D_CopyImage }
  // Обнуляем структуру.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // Заполняем поле размера структуры описания поверхности.
  ddsd.dwSize := SizeOf(ddsd);
  // Блокируем всю поверхность.
  if Surface.Lock(nil, ddsd, DDLOCK_WAIT, 0) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_CANTLOCK;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся скопировать изображение.
    for i := 0 to ddsd.dwHeight - 1 do
      {$WARNINGS OFF}
      // Копирум очередную строку изображения.
      CopyMemory(Pointer(Longword(ddsd.lpSurface) + i * ddsd.lPitch),
                 Pointer(Longword(Data) + i * ddsd.dwWidth * E2D_SCREEN_BYTESPP),
                 ddsd.dwWidth * E2D_SCREEN_BYTESPP);
      {$WARNINGS ON}
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // отпираем поверхность
    Surface.Unlock(nil);
    // и выходим из функции.
    Exit;
  end; { try }

  // Отпираем поверхность.
  Surface.Unlock(nil);

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_CopyImage }

function E2D_AddSoundFromFile;
var
  SndData : Pointer;        { Буфер для данных звука }
  SndInfo : E2D_TSoundInfo; { Информация о звуке }
label
  FreeData; { Освобождение данных звука }
begin { E2D_AddSoundFromFile }
  // Загружаем звук в память.
  Result := E2D_LoadSound(FileName, SndData, @SndInfo);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then
    // Если не получилось выходим из функции.
    Exit;

  // Добавляем звук из памяти.
  Result := E2D_AddSoundFromMem(SndData, @SndInfo, SoundID);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then
    // Если не получилось освобождаем данные изображения.
    goto FreeData;

  // Проверяем, надо ли вернуть информацию о загруженном звуке.
  if SoundInfo <> nil then
    try
      // Если надо пытаемся сохранить информацию.
      SoundInfo^ := SndInfo;
    except
      // Если не получилось помещаем код ошибки в результат,
      Result := E2DERR_SYSTEM_INVPOINTER;
      // освобождаем данные звука,
      Dispose(SndData);
      // удаляем созданный звук
      E2D_DeleteSounds(SoundID);
      // и выходим из функции.
      Exit;
    end; { try }

  // Делаем результат успешным.
  Result := E2DERR_OK;

FreeData :
  // Освобождаем данные звука.
  Dispose(SndData);
end; { E2D_AddSoundFromFile }

{ Функция для создания буфера. Параметры :
    Buffer    : буфер, который необходимо создать;
    SoundInfo : указатель на структуру E2D_TSoundInfo, где сохранена информация о звуке
               (количество каналов, частота дискретизации и другое);
  Возвращаемое значение : если функция выполнилась успешно - DD_OK, если неудачно - код
                          ошибки. }
function CreateBuffer(var Buffer : IDirectSoundBuffer;
                      SoundInfo : E2D_PSoundInfo) : HRESULT; register;
var
  dsbd : TDSBufferDesc; { Структура для описания буфера }
  wf   : TWaveFormatEx; { Структура для описания формата буфера }
begin { CreateBuffer }
  // Заполняем поля структуры описания формата буфера :
  with wf do begin { with }
    // формат,
    wFormatTag      := 1;
    // количество каналов,
    nChannels       := SoundInfo^.Channels;
    // частота дискретизации,
    nSamplesPerSec  := SoundInfo^.SamplesPerSec;
    // блочное выравнивание,
    nBlockAlign     := SoundInfo^.BlockAlign;
    // качество
    wBitsPerSample  := SoundInfo^.BitsPerSample;
    // и битрейт (в байтах) буфера.
    nAvgBytesPerSec := SoundInfo^.SamplesPerSec * SoundInfo^.BlockAlign;
  end; { with }

  // Обнуляем структуру.
  ZeroMemory(@dsbd, SizeOf(dsbd));
  // Заполняем поля структуры описания буфера :
  with dsbd do begin { with }
    // размер структуры,
    dwSize        := SizeOf(dsbd);
    // флаги,
    dwFlags       := DSBCAPS_CTRLPAN or DSBCAPS_STATIC or
                     DSBCAPS_LOCHARDWARE or DSBCAPS_CTRLVOLUME;
    // размер
    dwBufferBytes := SoundInfo^.DataSize;
    // и формат буфера.
    lpwfxFormat   := @wf;
  end; { with }

  // Создаем буфер.
  Result := DS_Main.CreateSoundBuffer(dsbd, Buffer, nil);
end; { CreateBuffer }

function E2D_AddSoundFromMem;
begin { E2D_AddSoundFromMem }
  // Проверяем количество загруженных шрифтов.
  if NumSounds >= E2D_MANAGE_MAXSOUNDS then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_OUTOFMEM;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию о звуке.
    Sounds[NumSounds].Info := SoundInfo^;
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Создаем буфер.
  if CreateBuffer(Sounds[NumSounds].Buffer, SoundInfo) <> DS_OK then begin  { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_CREATEBUF;
    // и выходим из функции.
    Exit;
  end; { if }

  // Копируем звук в буфер.
  Result := E2D_CopySound(Sounds[NumSounds].Buffer, SoundData,
                          Sounds[NumSounds].Info.DataSize);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then begin { if }
    // Если не получилось удаляем буфер
    Sounds[NumSounds].Buffer := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Сохраняем идентификатор звука
  SoundID := NumSounds;
  // и увеличиваем счетчик звуков.
  NumSounds := NumSounds + 1;

  // Устанавливаем громкость.
  E2D_SetSoundVolume(SoundID, Volume_Global);
end; { E2D_AddSoundFromMem }

procedure E2D_DeleteSounds;
var
  i : Longword; { Счетчик цикла }
begin { E2D_DeleteSounds }
  // Проверяем индекс звука.
  if FirstSound >= NumSounds then
    // Если он больше количества звуков выходим из функции.
    Exit;

  // Удаляем все необходимые звуки.
  for i := FirstSound to NumSounds - 1 do begin { for }
    // Удаляем буфер звука.
    Sounds[i].Buffer := nil;
    // Обнуляем все поля записи.
    ZeroMemory(@Sounds[i], SizeOf(E2D_TSound));
  end; { for }

  // Устанавливаем новое количество звуков.
  NumSounds := FirstSound;
end; { E2D_DeleteSounds }

function E2D_GetSoundInfo;
begin { E2D_GetSoundInfo }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию о звуке.
    SoundInfo^ := Sounds[SoundID].Info;
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_GetSoundInfo }

function E2D_CopySound;
var
  ap1, ap2 : Pointer;  { Указатели на данные звука }
  ab1, ab2 : Longword; { Размеры данных }
begin { E2D_CopySound }
  // Блокируем весь буфер.
  if Buffer.Lock(0, Size, ap1, ab1, ap2, ab2,
                 DSBLOCK_ENTIREBUFFER) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_CANTLOCK;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся скопировать данные звука.
    CopyMemory(ap1, Data, Size);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // отпираем буфер
    Buffer.Unlock(ap1, ab1, ap2, ab2);
    // и выходим из функции.
    Exit;
  end; { try }

  // Отпираем буфер.
  Buffer.Unlock(ap1, ab1, ap2, ab2);

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_CopySound }

function E2D_AddFontFromFile;
var
  FntData : Pointer;       { Буфер для данных шрифта }
  FntInfo : E2D_TFontInfo; { Информация о шрифте }
label
  FreeData; { Освобождение данных шрифта }
begin { E2D_AddFontFromFile }
  // Загружаем шрифт в память.
  Result := E2D_LoadFont(FileName, FntData, @FntInfo);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then
    // Если не получилось выходим из функции.
    Exit;

  // Добавляем шрифт из памяти.
  Result := E2D_AddFontFromMem(FntData, @FntInfo, FontID);
  // Проверяем результат выполнения.
  if Result <> E2DERR_OK then
    // Если не получилось освобождаем данные шрифта.
    goto FreeData;

  // Проверяем, надо ли вернуть информацию о загруженном шрифте.
  if FontInfo <> nil then
    try
      // Если надо пытаемся сохранить информацию.
      FontInfo^ := FntInfo;
    except
      // Если не получилось помещаем код ошибки в результат,
      Result := E2DERR_SYSTEM_INVPOINTER;
      // освобождаем данные шрифта,
      Dispose(FntData);
      // удаляем созданный шрифт
      E2D_DeleteFonts(FontID);
      // и выходим из функции.
      Exit;
    end; { try }

  
  Result := E2DERR_OK;

FreeData :
  // Освобождаем данные шрифта.
  Dispose(FntData);
end; { E2D_AddFontFromFile }

function E2D_AddFontFromMem;
begin { E2D_AddFontFromMem }
  // Проверяем количество загруженных шрифтов.
  if NumFonts >= E2D_MANAGE_MAXFONTS then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_OUTOFMEM;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию о шрифте.
    Fonts[NumFonts].Info := FontInfo^;
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Создаем поверхность.
  if CreateSurface(Fonts[NumFonts].Surface, @FontInfo^.Image) <> DD_OK then begin  { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_CREATESURF;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся выделить память для данных шрифта.
    GetMem(Fonts[NumFonts].Data, FontInfo^.Image.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTGETMEM;
    // удаляем поверхность
    Fonts[NumFonts].Surface := nil;
    // и выходим из функции.
    Exit;
  end; { try }

  try
    // Пытаемся скопировать данные шрифта.
    CopyMemory(Fonts[NumFonts].Data, FontData, FontInfo^.Image.DataSize);
  except
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_CANTCOPYMEM;
    // удаляем поверхность,
    Fonts[NumFonts].Surface := nil;
    // освобождаем память для данных шрифта
    Dispose(Fonts[NumFonts].Data);
    // и выходим из функции.
    Exit;
  end; { try }

  // Копируем изображение на поверхность.
  Result := E2D_CopyImage(Fonts[NumFonts].Surface, Fonts[NumFonts].Data);
  // Проверяем результат выполнения.
  if Result = E2DERR_OK then begin { if }
    // Если получилось сохраняем идентификатор шрифта
    FontID := NumFonts;
    // и увеличиваем счетчик шрифтов.
    NumFonts := NumFonts + 1
  end else begin { else }
    // Если не получилось удаляем поверхность
    Fonts[NumFonts].Surface := nil;
    // и освобождаем память для данных шрифта
    Dispose(Fonts[NumFonts].Data);
  end; { else }
end; { E2D_AddFontFromMem }

procedure E2D_DeleteFonts;
var
  i : Longword; { Счетчик цикла }
begin { E2D_DeleteFonts }
  // Проверяем индекс шрифта.
  if FirstFont >= NumFonts then
    // Если он больше количества шрифтов выходим из функции.
    Exit;

  // Удаляем все необходимые шрифты.
  for i := FirstFont to NumFonts - 1 do begin { for }
    // Удаляем поверхность шрифта.
    Fonts[i].Surface := nil;
    // Освобождаем память для данных шрифта.
    Dispose(Fonts[i].Data);
    // Обнуляем все поля записи.
    ZeroMemory(@Fonts[i], SizeOf(E2D_TFont));
  end; { for }

  // Устанавливаем новое количество изображений.
  NumFonts := FirstFont;
end; { E2D_DeleteFonts }

function E2D_GetFontInfo;
begin { E2D_GetFontInfo }
  // Проверяем идентификатор шрифта.
  if FontID >= NumFonts then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся сохранить информацию о шрифте.
    FontInfo^ := Fonts[FontID].Info;
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_GetFontInfo }

end.
