(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DScreen.pas                                                           *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 30.10.06                                                                *)
(* Информация : Модуль содежит функции для вывода графики на экран.                     *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DScreen;

interface

uses
  E2DTypes, Windows, DirectDraw;

  { Функция для создания обьектов DirectDraw и перехода в полноэкранный видеорежим.
    Параметры :
      ScreenWidth  : ширина экрана;
      ScreenHeight : высота экрана;
      Frec         : частота обновления монитора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateFullscreen(ScreenWidth, ScreenHeight,
                                Frec : Longword) : E2D_Result; stdcall; export;

  { Функция для получения описания утройства вывода. Параметры :
      Desc : указатель на структуру E2D_TDeviceDesc для сохранения описания.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetDeviceDesc(Desc : E2D_PDeviceDesc) : E2D_Result; stdcall; export;

  { Функция для проверки правильности прямоугольника вывода. Параметры :
      Rect  : прямоугольник, который необходимо проверить;
      Place : расположение прямоугольника на экране.
    Возвращаемое значение : если функция выполнилась успешно - True, если неудачно -
                            False. }
  function CorrectRectS(Rect : PRect; Place : PPoint) : Boolean; register;

  { Функция для проверки правильности прямоугольника. Параметры :
      Rect : прямоугольник, который необходимо проверить.
    Возвращаемое значение : если функция выполнилась успешно - True, если неудачно -
                            False. }
  function CorrectRectR(Rect : PRect) : Boolean; register;

  { Функция для вывода изображения на экран. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода (для вывода всего изображения данный
                параметр может быть nil);
      Place   : место расположения изображения на экране.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawImage(ImageID : E2D_TImageID; ImgRect : PRect;
                         Place : PPoint) : E2D_Result; stdcall; export;

  { Функция для вывода растянутого изображения на экран. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода (для вывода всего изображения данный
                параметр может быть nil);
      DstRect : прямоугольник изображения на экране (для вывода изображения на весь экран
                данный параметр может быть nil).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_StretchDraw(ImageID : E2D_TImageID;
                           ImgRect, DstRect : PRect) : E2D_Result; stdcall; export;

  { Функция для вывода на экран заднего буфера.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_ShowBuffer : E2D_Result; stdcall; export;


  { Функция для очистки заднего буфера.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_ClearBuffer : E2D_Result; stdcall; export;

  { Функция для восстановления поверхностей.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_RestoreSurfaces : E2D_Result; stdcall; export;

  { Функция для вывода текста. Параметры :
      FontID : идентификатор шрифта, которым необходимо вывести текст;
      Text   : указатель на строку, которую необходимо вывести;
      X, Y   : позиция текста на экране;
      Size   : длина строки.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawText(FontID : E2D_TFontID; Text : PChar; X, Y : Longword;
                        Size : Longword) : E2D_Result; stdcall; export;

  { Функция для рисования прямоугольника. Параметры :
      Color : цвет прямоугольника;
      Rect  : прямоугольник.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawRect(Color : E2D_TColor; Rect : PRect) : E2D_Result; stdcall; export;

  { Функция для получения яркости экрана.
    Возвращаемое значение : яркость. }
  function E2D_GetGamma : E2D_TGamma; stdcall; export;

  { Функция для установки яркости экрана. Параметры :
      Gamma : яркость.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetGamma(Gamma : E2D_TGamma) : E2D_Result; stdcall; export;

  { Функция для установки яркости цветовых составляющих. Параметры :
      R, G, B : яркость красного, зеленого и синего цвета.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetRGBGamma(R, G, B : E2D_TGamma) : E2D_Result; stdcall; export;

  { Функция для зеркального отражения изображения. Параметры :
      ImageID : идентификатор изображения, которое необходимо отразить;
      FlipHor : отражение по горизонтали (слева направо);
      FlipVer : отражение по вертикали (сверху вниз).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_FlipImage(ImageID : E2D_TImageID;
                         FlipHor, FlipVer : Boolean) : E2D_Result; stdcall; export;

implementation

uses
  E2DVars,    { Для переменных экрана }
  E2DConsts,  { Для констант ошибок }
  E2DManager; { Для копирования изображений }

function E2D_CreateFullscreen;
var
  ddsd : TDDSurfaceDesc2; { Структура для описания поверхности }
  caps : TDDSCaps2;       { Структура для описания заднего буфера }
  rect : TRect;           { Прямоугольник экрана }

  { Процедура для удаления обьектов DirectDraw. }
  procedure ClearDDObjects;
  begin { ClearDDObjects }
    // Удаляем задний буфер.
    DDS_BackBuffer := nil;
    // Удаляем первичную поверхность.
    DDS_Primary    := nil;
    // Удаляем главный обьект DirectDraw.
    DD_Main        := nil;
  end; { ClearDDObjects }

begin { E2D_CreateFullscreen }
  // Создаем главный обьект DirectDraw.
  if DirectDrawCreateEx(nil, DD_Main, IID_IDirectDraw7, nil) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_CREATEDD;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем уровень кооперации.
  if DD_Main.SetCooperativeLevel(Window_Handle, DDSCL_EXCLUSIVE or
                                 DDSCL_FULLSCREEN) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // удаляем главный обьект DirectDraw
    DD_Main := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Переходим в новый водеорежим.
  if DD_Main.SetDisplayMode(ScreenWidth, ScreenHeight, E2D_SCREEN_BITSPP, Frec,
                            0) <> DD_OK then begin  { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SCREEN_SETDISPMD;
    // удаляем главный обьект DirectDraw
    DD_Main := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Обнуляем структуру.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // Заполняем поля структуры описания поверхности :
  with ddsd do begin { with }
    // размер структуры,
    dwSize            := SizeOf(ddsd);
    // флаги,
    dwFlags           := DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
    // свойства поверхности
    ddsCaps.dwCaps    := DDSCAPS_PRIMARYSURFACE or DDSCAPS_FLIP or DDSCAPS_COMPLEX;
    // и количество задних буферов.
    dwBackBufferCount := 1;
  end; { with }

  // Создаем первичную поверхность.
  if DD_Main.CreateSurface(ddsd, DDS_Primary, nil) <> DD_OK then begin  { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SCREEN_CREATESURF;
    // удаляем главный обьект DirectDraw
    DD_Main := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Обнуляем структуру.
  ZeroMemory(@caps, SizeOf(caps));
  // Заполняем поле свойств структуры описания заднего буфера.
  caps.dwCaps := DDSCAPS_BACKBUFFER;

  // Создаем задний буфер.
  if DDS_Primary.GetAttachedSurface(caps, DDS_BackBuffer) <> DD_OK then begin  { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SCREEN_CREATESURF;
    // удаляем первичную поверхность,
    DDS_Primary := nil;
    // удаляем главный обьект DirectDraw
    DD_Main     := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем прямоугольник экрана.
  SetRect(rect, 0, 0, ScreenWidth, ScreenHeight);

  // Создаем обьект гамма контроля.
  if DDS_Primary.QueryInterface(IID_IDirectDrawGammaControl,
                                DDG_Main) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SCREEN_CREATEGAM;
    // удаляем обьекты DirectDraw
    ClearDDObjects;
    // и выходим из функции.
    Exit;
  end; { if }

  // Сохраняем ширину
  Screen_Width  := ScreenWidth;
  // и высоту экрана.
  Screen_Height := ScreenHeight;
  // Отключаем курсор.
  ShowCursor(False);

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_CreateFullscreen }

function E2D_GetDeviceDesc;
var
  ddcaps : TDDCaps;              { Структура описания свойств главного обьекта }
  dddi   : TDDDeviceIdentifier2; { Структура описания главного обьекта }
begin { E2D_GetDeviceDesc }
  // Обнуляем структуру.
  ZeroMemory(@ddcaps, SizeOf(ddcaps));
  // Заполняем поле размера структуры описания свойств.
  ddcaps.dwSize := SizeOf(ddcaps);
  // Получаем свойства главного обьекта.
  if DD_Main.GetCaps(@ddcaps, nil) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_GETDESCR;
    // и выходим из функции.
    Exit;
  end; { if }

  // Получаем описание главного обьекта.
  if DD_Main.GetDeviceIdentifier(dddi, 0) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_GETDESCR;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Выделяем память для имени.
    GetMem(Desc^.Name, MAX_DDDEVICEID_STRING);
    // Пытаемся сохранить имя,
    CopyMemory(Desc^.Name, @dddi.szDescription, MAX_DDDEVICEID_STRING);
    // общий
    Desc^.tVidMem := ddcaps.dwVidMemTotal;
    // и доступный оьбем водепамяти
    Desc^.aVidMem := ddcaps.dwVidMemFree;
    // и поддержку гамма контроля устройства.
    Desc^.Gamma := ((ddcaps.dwCaps2 and DDCAPS2_PRIMARYGAMMA) <> 0);
  except
     // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end;

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_GetDeviceDesc }

function CorrectRectS;
var
  irw, irh : Longword; { Размеры прямоугольника }
begin { CorrectRectS }
  // Делаем результат неудачным.
  Result := False;
  // Сохраняем ширину
  irw := Rect^.Right - Rect^.Left;
  // и высоту прямоугольника изображения.
  irh := Rect^.Bottom - Rect^.Top;

  // Проверяем не вышли ли за левую границу экрана.
  if Place^.X < 0 then
    // Если вышли проверяем полностью или нет.
    if Place^.X < - irw then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else begin { else }
      // Если нет вычисляем новый размер прямоугольника
      Rect^.Left := Rect^.Left - Place^.X;
      // и его положение по горизонтали.
      Place^.X := 0;
    end; { else }

  {$WARNINGS OFF}
  // Проверяем не вышли ли за правую границу экрана.
  if Place^.X > Screen_Width - irw then
    // Если вышли проверяем полностью или нет.
    if Place^.X > Screen_Width then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else { if }
      // Если нет вычисляем новый размер прямоугольника.
      Rect^.Right := Rect^.Right - (Place^.X + irw - Screen_Width);

  // Проверяем не вышли ли за верхнюю границу экрана.
  if Place^.Y < 0 then
    // Если вышли проверяем полностью или нет.
    if Place^.Y < - irh then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else begin { else }
      // Если нет вычисляем новый размер прямоугольника
      Rect^.Top  := Rect^.Top - Place^.Y;
      // и его положение по вертикали.
      Place^.Y := 0;
    end; { else }

  // Проверяем не вышли ли за верхнюю границу экрана.
  if Place^.Y > Screen_Height - irh then
    // Если вышли проверяем полностью или нет.
    if Place^.Y > Screen_Height then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else { if }
      // Если нет вычисляем новый размер прямоугольника.
      Rect^.Bottom := Rect^.Bottom - (Place^.Y + irh - Screen_Height);
  {$WARNINGS ON}
end; { CorrectRectS }

function CorrectRectR;
begin { CorrectRectR }
  // Делаем результат неудачным.
  Result := False;

  // Проверяем не вышли ли за левую границу экрана.
  if Rect^.Left < 0 then
    // Если вышли проверяем полностью или нет.
    if Rect^.Right < 0 then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else { if }
      // Если нет устанавливаем новый размер прямоугольника.
      Rect^.Left := 0;

  {$WARNINGS OFF}
  // Проверяем не вышли ли за правую границу экрана.
  if Rect^.Right > Screen_Width then
    // Если вышли проверяем полностью или нет.
    if Rect^.Left > Screen_Width then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else { if }
      // Если нет устанавливаем новый размер прямоугольника.
      Rect^.Right := Screen_Width;

  // Проверяем не вышли ли за верхнюю границу экрана.
  if Rect^.Top < 0 then
    // Если вышли проверяем полностью или нет.
    if Rect^.Bottom < 0 then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else { if }
      // Если нет устанавливаем новый размер прямоугольника.
      Rect^.Top := 0;

  // Проверяем не вышли ли за нижнюю границу экрана.
  if Rect^.Bottom > Screen_Height then
    // Если вышли проверяем полностью или нет.
    if Rect^.Top > Screen_Height then begin { if }
      // Если да делаем резуьтат успешным
      Result := True;
      // и выходим из функции.
      Exit;
    end else { if }
      // Если нет устанавливаем новый размер прямоугольника.
      Rect^.Bottom := Screen_Height;
  {$WARNINGS ON}
end; { CorrectRectR }

function E2D_DrawImage;
var
  Rect  : TRect;  { Точный прямоугольник изображения }
  Point : TPoint; { Точное положение на экране }
begin { E2D_DrawImage }
  // Проверяем идентификатор изображения.
  if ImageID >= NumImages then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Сохраняем прямоугольник изображения
  Rect  := ImgRect^;
  // и его положение на экране.
  Point := Place^;
  
  // Проверяем прямоугольник вывода.
  if not CorrectRectS(@Rect, @Point) then
    // Если его видно выводим изображение в задний буфер.
    if DDS_BackBuffer.BltFast(Point.X, Point.Y, Images[ImageID].Surface, @Rect,
                              DDBLTFAST_WAIT or
                              DDBLTFAST_SRCCOLORKEY) <> DD_OK then begin { if }
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_SCREEN_CANTDRAW;
      // и выходим из функции.
      Exit;
    end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_DrawImage }

function E2D_StretchDraw;
begin { E2D_StretchDraw }
  // Проверяем идентификатор изображения.
  if ImageID >= NumImages then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Выводим изображение в задний буфер.
  if DDS_BackBuffer.Blt(DstRect, Images[ImageID].Surface, ImgRect,
                        DDBLT_WAIT or DDBLT_KEYSRC, nil) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_CANTDRAW;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_StretchDraw }

function E2D_ShowBuffer;
var
  res : HRESULT; { Переменная для сохранения результата }
begin { E2D_ShowBuffer }
  // Выполняем переключение страниц.
  res := DDS_Primary.Flip(nil, DDFLIP_WAIT or DDFLIP_NOVSYNC);
  // Проверяем результат выполнения.
  if res <> DD_OK then
    // Если не получилось проверяем результат выполнения.
    if res = DDERR_SURFACELOST then begin { if }
      // Если необходимо восстанавливаем поверхности
      Result := E2D_RestoreSurfaces;
      // и выходим из функции.
      Exit;
    end else begin { else }
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_SCREEN_CANTFLIP;
      // и выходим из функции.
      Exit;
    end; { else }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_ShowBuffer }

function E2D_ClearBuffer;
var
  blt : TDDBltFX; { Структура для очистки буфера }
begin { E2D_ClearBuffer }
  // Обнуляем структуру.
  ZeroMemory(@blt, SizeOf(blt));
  // Заполняем поля свойств структуры блиттинга : рамер
  blt.dwSize := SizeOf(blt);
  // и цвет заполнения.
  blt.dwFillColor := E2D_SCREEN_COLORKEY;

  // Очищаем задний буфер.
  if DDS_BackBuffer.Blt(nil, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                        @blt) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_CANTCLEAR;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_ClearBuffer }

function E2D_RestoreSurfaces;
var
  i : Longword; { Счетчик цикла }
begin { E2D_RestoreSurfaces }
  // Восстанавливаем все поверхности.
  if DD_Main.RestoreAllSurfaces <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат.
    Result := E2DERR_SCREEN_CANTRESTORE;
    // и выходим из функции.
    Exit;
  end; { if }

  // Проверяем количество загруженных изображений.
  if NumImages > 0 then
    // Если есть загруженные пытаемся их восстановить.
    for i := 0 to NumImages - 1 do begin { for }
      // Копируем изображение на поверхность.
      Result := E2D_CopyImage(Images[i].Surface, Images[i].Data);
      // Проверяем результат выполнения.
      if Result <> E2DERR_OK then
        // Если не получилось выходим из функции.
        Exit;
    end; { for }

  // Проверяем количество загруженных шрифтов.
  if NumFonts > 0 then
    // Если есть загруженные пытаемся их восстановить.
    for i := 0 to NumFonts - 1 do begin { for }
      // Копируем изображение на поверхность.
      Result := E2D_CopyImage(Fonts[i].Surface, Fonts[i].Data);
      // Проверяем результат выполнения.
      if Result <> E2DERR_OK then
        // Если не получилось выходим из функции.
        Exit;
    end; { for }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_RestoreSurfaces }

function E2D_DrawText;
var
  i   : Longword;      { Счетчик цикла }
  cr  : TRect;         { Прямоугольник символа }
  ci  : E2D_TCharInfo; { Информация о символе }
  cw  : Longword;      { Текущая длина строки }
begin { E2D_DrawText }
  // Проверяем идентификатор шрифта.
  if FontID >= NumFonts then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Обнуляем длину строки.
  cw := 0;

  // Проверяем длину строки.
  if Size > 0 then
    // Если необходимо выводим поочередно все символы.
    for i := 0 to Size - 1 do begin { for }
      try
        // Пытаемся сохранить информацию о символе.
        ci := Fonts[FontID].Info.CharsInfo[PByte(Longword(Text) + i)^];
      except
        // Если не получилось помещаем код ошибки в результат
        Result := E2DERR_SYSTEM_INVPOINTER;
        // и выходим из функции.
        Exit;
      end;

      // Задаем прямоугольник символа.
      SetRect(cr, ci.X, ci.Y, ci.X + ci.Width, ci.Y + Fonts[FontID].Info.Size);

      // Выводим символ.
      if DDS_BackBuffer.BltFast(X + cw, Y, Fonts[FontID].Surface, @cr,
                                DDBLTFAST_WAIT or
                                DDBLTFAST_SRCCOLORKEY) <> DD_OK then begin { if }
        // Если не получилось помещаем код ошибки в результат
        Result := E2DERR_SCREEN_CANTDRAW;
        // и выходим из функции.
        Exit;
      end; { if }

      cw := cw + ci.Width;
    end; { for }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_DrawText }

function E2D_DrawRect;
var
  blt   : TDDBltFX; { Структура для заполнения прямоугольника }
  cRect : TRect;    { Точный прямоугольник }
begin { E2D_DrawRect }
  // Обнуляем структуру.
  ZeroMemory(@blt, SizeOf(blt));
  // Заполняем поля свойств структуры блиттинга : рамер
  blt.dwSize := SizeOf(blt);
  // и цвет заполнения.
  blt.dwFillColor := Color;

  // Сохраняем прямоугольник.
  cRect := Rect^;

  // Проверяем прямоугольник.
  if not CorrectRectR(@cRect) then
    // Если его видно рисуем прямоугольник.
    if DDS_BackBuffer.Blt(@cRect, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                          @blt) <> DD_OK then begin { if }
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_SCREEN_CANTDRAW;
      // и выходим из функции.
      Exit;
    end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_DrawRect }

function E2D_GetGamma;
begin { E2D_GetGamma }
  // Помещаем в результат яркость.
  Result := Screen_Gamma;
end; { E2D_GetGamma }

function E2D_SetGamma;
begin { E2D_SetGamma }
  // Устанавливаем яркость экрана.
  Result := E2D_SetRGBGamma(Gamma, Gamma, Gamma);
  // Проверяем результат выполнения.
  if Result = E2DERR_OK then
    // Если получилось сохраняем яркость.
    Screen_Gamma := Gamma;
end; { E2D_SetGamma }

function E2D_SetRGBGamma;
var
  ramp : TDDGammaRamp; { Структура для сохранения яркостей }
  i    : Longword;     { Счетчик цикла }
begin { E2D_SetRGBGamma }
  // Устанавливаем яркость цветовых составляющих :
  for i := 0 to 255 do begin { for }
    // красной,
    ramp.red[i]   := R * i;
    // зеленой
    ramp.green[i] := G * i;
    // и синей.
    ramp.blue[i]  := B * i;
  end; { for }

  // Устанавливаем яркость.
  if DDG_Main.SetGammaRamp(0, ramp) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_CANTSETGAM;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_SetRGBGamma }

function E2D_FlipImage;
var
  i, j   : Longword;        { Счетчики циклов }
  c1, c2 : E2D_TColor;      { Значения пикселов }
  iw, ih : Longword;        { Размеры изображения }
  adr    : Longword;        { Адрес данных }
begin { E2D_FlipImage }
  // Проверяем идентификатор изображения.
  if ImageID >= NumImages then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Сохраняем ширину,
  iw := Images[ImageID].Info.Width;
  // высоту
  ih := Images[ImageID].Info.Height;
  // и адрес данных изображения.
  adr := Longword(Images[ImageID].Data);

  // Если необходимо отобразить изображение по горизонтали
  if FlipHor then try
    // пытаемся попиксельно выполнить отображение.
    for j := 0 to ih - 1 do
      for i := 0 to (iw div 2) - 1 do begin { for }
        // Запоминаем значения пикселов.
        c1 := E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^;
        c2 := E2D_PColor(adr + (j * iw + iw - 1 - i) * E2D_SCREEN_BYTESPP)^;

        // Меняем пикселы местами.
        E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^ := c2;
        E2D_PColor(adr + (j * iw + iw - 1 - i) * E2D_SCREEN_BYTESPP)^ := c1;
      end; { for }
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Если необходимо отобразить изображение по вертикали
  if FlipVer then try
    // пытаемся попиксельно выполнить отображение.
    for i := 0 to iw - 1 do
      for j := 0 to (ih div 2) - 1 do begin { for }
        // Запоминаем значения пикселов.
        c1 := E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^;
        c2 := E2D_PColor(adr + ((ih - 1 - j) * iw + i) * E2D_SCREEN_BYTESPP)^;

        // Меняем пикселы местами.
        E2D_PColor(adr + (j * iw + i) * E2D_SCREEN_BYTESPP)^ := c2;
        E2D_PColor(adr + ((ih - 1 - j) * iw + i) * E2D_SCREEN_BYTESPP)^ := c1;
      end; { for }
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Копируем изображение на поверхность.
  Result := E2D_CopyImage(Images[ImageID].Surface, Images[ImageID].Data);
end; { E2D_FlipImage }

end.
