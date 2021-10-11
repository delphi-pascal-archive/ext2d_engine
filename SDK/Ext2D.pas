(************************************* Ext2D Engine *************************************)
(* Модуль     : Ext2D.pas                                                               *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 03.11.06                                                                *)
(* Информация : Модуль является заголовочным файлом для библиотеки Ext2D Engine.        *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit Ext2D;

interface

uses
  Windows;

type
  { Тип результата функций }
  E2D_Result = Longword;

  { Информация об изображении }
  E2D_TImageInfo = packed record
    Width    : Longword; { Выстоа }
    Height   : Longword; { Ширина }
    DataSize : Longword; { Размер данных }
  end;
  { Указатель на информацию об изображении }
  E2D_PImageInfo = ^E2D_TImageInfo;

  { Информация о звуке }
  E2D_TSoundInfo = packed record
    Channels      : Word;     { Количество каналов }
    SamplesPerSec : Longword; { Частота дискретизации }
    BlockAlign    : Word;     { Блочное выравнивание }
    BitsPerSample : Word;     { Качество }
    DataSize      : Longword; { Размер данных }
  end;
  { Указатель на информацию о звуке }
  E2D_PSoundInfo = ^E2D_TSoundInfo;

  { Информвция о символе }
  E2D_TCharInfo = packed record
    X     : Word; { Позиция по горизонтали }
    Y     : Word; { Позиция по вертикали }
    Width : Word; { Ширина }
  end;

  { Информация о шрифте }
  E2D_TFontInfo = packed record
    Image     : E2D_TImageInfo;                  { Изобоажение шрифта }
    Size      : Longword;                        { Размер }
    CharsInfo : array [0..255] of E2D_TCharInfo; { Информация о символах }
  end; 
  { Указатель на информацию о шрифте }
  E2D_PFontInfo = ^E2D_TFontInfo;

  { Тип идентификатора изображений }
  E2D_TImageID = Longword;
  { Тип идентификатора звуков }
  E2D_TSoundID = Longword;
  { Тип идентификатора шрифтов }
  E2D_TFontID  = Longword;

  { Описание устройства вывода }
  E2D_TDeviceDesc = packed record
    Name    : PChar;    { Имя }
    tVidMem : Longword; { Всего видеопамяти }
    aVidMem : Longword; { Доступно видеопамяти }
    Gamma   : Boolean;  { Поддержка яркости }
  end; 
  { Указатель на описание устройства вывода }
  E2D_PDeviceDesc = ^E2D_TDeviceDesc;

  { Яркость }
  E2D_TGamma = 0..256;
  { Цвет }
  E2D_TColor = Word;
  { Прозрачность }
  E2D_TAlpha = 0..256;

  { Громкость }
  E2D_TSoundVolume = -10000..0;
  { Панорама }
  E2D_TSoundPan = -10000..10000;

  { Кнопки мыши }
  E2D_TMouseButton = 0..7;

  { Функция для вычисления цвета пиксела }
  E2D_TColorCalcFunc = function (SrcColor, DstColor : E2D_TColor) : E2D_TColor; stdcall;

const
  { Общие константы }
  E2DERR_OK = $00000000; { Нет ошибок }

  { Константы системных ошибок }
  E2DERR_SYSTEM_INVPOINTER  = $00000101; { Неправильный указатель }
  E2DERR_SYSTEM_CANTGETMEM  = $00000102; { Невозможно выделить память }
  E2DERR_SYSTEM_CANTCOPYMEM = $00000103; { Невозможно копировать память }
  E2DERR_SYSTEM_INVALIDID   = $00000104; { Неправильный идентификатор }
  E2DERR_SYSTEM_SETCOOPLVL  = $00000105; { Невозможно установить уровень кооперации }

  { Константы ошибок загрузки }
  E2DERR_LOAD_CANTOPEN   = $00000201; { Невозможно открыть файл }
  E2DERR_LOAD_CANTREAD   = $00000202; { Невозможно выполнить чтение из файла }
  E2DERR_LOAD_INVALID    = $00000203; { Файл неправильный или поврежден }
  E2DERR_LOAD_DECOMPRESS = $00000204; { Ошибка декомпрессии }

  { Константы ошибок управления }
  E2DERR_MANAGE_OUTOFMEM   = $00000301; { Недостаточно памяти массива }
  E2DERR_MANAGE_CREATESURF = $00000302; { Невозможно создать поверхность }
  E2DERR_MANAGE_CREATEBUF  = $00000303; { Невозможно создать буфер }
  E2DERR_MANAGE_CANTLOCK   = $00000304; { Невозможно заблокировать обьект }

  { Константы ошибок экрана }
  E2DERR_SCREEN_CREATEDD    = $00000401; { Невозможно создать главный обьект DirectDraw }
  E2DERR_SCREEN_SETDISPMD   = $00000402; { Невозможно установить видеорежим }
  E2DERR_SCREEN_GETDESCR    = $00000403; { Невозможно получить описание устройства }
  E2DERR_SCREEN_CREATEGAM   = $00000404; { Невозможно создать гамма контроль }
  E2DERR_SCREEN_CREATESURF  = $00000405; { Невозможно создать поверхность }
  E2DERR_SCREEN_CANTDRAW    = $00000406; { Невозможно выполнить вывод }
  E2DERR_SCREEN_CANTFLIP    = $00000407; { Невозможно выполнить переключение }
  E2DERR_SCREEN_CANTCLEAR   = $00000408; { Невозможно очистить буфер }
  E2DERR_SCREEN_CANTRESTORE = $00000409; { Невозможно восстановить поверхность }
  E2DERR_SCREEN_CANTSETGAM  = $00000410; { Невозможно установить яркость }

  { Константы ошибок звука }
  E2DERR_SOUND_CREATEDS   = $00000501; { Невозможно создать главный обьект DirectSound }
  E2DERR_SOUND_CANTPLAY   = $00000502; { Невозможно воспроизвести звук }
  E2DERR_SOUND_CANTSTOP   = $00000503; { Невозможно остановить звук }
  E2DERR_SOUND_CANTGETVOL = $00000504; { Невозможно получить громкость }
  E2DERR_SOUND_CANTSETVOL = $00000505; { Невозможно установить громкость }
  E2DERR_SOUND_CANTGETPAN = $00000506; { Невозможно получить панораму }
  E2DERR_SOUND_CANTSETPAN = $00000507; { Невозможно установить панораму }

  { Константы ошибок ввода }
  E2DERR_INPUT_CREATEDI   = $00000601; { Невозможно создать главный обьект DirectInput }
  E2DERR_INPUT_CREATEDEV  = $00000602; { Невозможно создать устройство }
  E2DERR_INPUT_SETDATAFMT = $00000603; { Невозможно задать формат данных }
  E2DERR_INPUT_CANTACQR   = $00000604; { Невозможно захватить устройство }
  E2DERR_INPUT_GETSTATE   = $00000605; { Невозможно получить данные }

  { Константы управления }
  E2D_MANAGE_MAXIMAGES = $10000; { Максимальное количество изображений }
  E2D_MANAGE_MAXSOUNDS = $10000; { Максимальное количество звуков }
  E2D_MANAGE_MAXFONTS  = $100;   { Максимальное количество шрифтов }
  E2D_MANAGE_DELETEALL = $0;     { Удалить все }

  { Константы параметров экрана }
  E2D_SCREEN_BITSPP   = $10; { Глубина цвета (бит на пиксел) }
  E2D_SCREEN_FRECDEF  = $0;  { Частота обновления монитора по умолчанию }
  E2D_SCREEN_COLORKEY = $0;  { Цветовой ключ }

  { Константы звуков }
  E2D_SOUND_MAXVOLUME = 0;      { Максимальная громкость }
  E2D_SOUND_MINVOLUME = -10000; { Минимальная громкость }
  E2D_SOUND_PANLEFT   = -10000; { Баланс : слева }
  E2D_SOUND_PANRIGHT  = 10000;  { Баланс : справа }
  E2D_SOUND_PANCENTER = $0;     { Баланс : центр }

  { Кнопки мыши }
  E2D_INPUT_MBLEFT   = 0; { Левая }
  E2D_INPUT_MBRIGHT  = 1; { Правая }
  E2D_INPUT_MBMIDDLE = 2; { Средняя }
  E2D_INPUT_MBADD1   = 3; { Дополнительная 1 }
  E2D_INPUT_MBADD2   = 4; { Дополнительная 2 }
  E2D_INPUT_MBADD3   = 5; { Дополнительная 3 }
  E2D_INPUT_MBADD4   = 6; { Дополнительная 4 }

  { Процедура для начальной инициализации. Параметры :
      WindowHandle : ссылка на окно приложения. }
  procedure E2D_InitEngine(WindowHandle : Longword); stdcall;

  { Процедура для удаления всех созданных обьектов и освобождения занятых ресерсов. }
  procedure E2D_FreeEngine; stdcall;

  { Функция для получения версии библиотеки Ext2D Engine.
    Возвращаемое значение : старший байт старшего слова - основная версия, младший байт -
                            дополнительная версия; старший байт младшего слова - релиз,
                            младший байт - билд. }
  function E2D_GetEngineVersion : Longword; stdcall;

  { Функция для загрузки изобоажений из файлов в память. Параметры :
      FileName  : имя файла изображения для загрузки (*.eif файлы);
      ImageData : адрес буфера для сохранения данных изображения;
      ImageInfo : указатель на структуру E2D_TImageInfo для сохранения информации о
                  загруженном изображении (высота, ширина, размер данных).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_LoadImage(FileName : PChar; var ImageData : Pointer;
                         ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall;

  { Функция для загрузки звуков из файлов в память. Параметры :
      FileName  : имя файла звука для загрузки (*.esf файлы);
      SoundData : адрес буфера для сохранения данных звука;
      SoundInfo : указатель на структуру E2D_TSoundInfo для сохранения информации о
                  загруженном звуке (количество каналов, частота дискретизации и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_LoadSound(FileName : PChar; var SoundData : Pointer;
                         SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall;

  { Функция для загрузки шрифтов из файлов в память. Параметры :
      FileName : имя файла шрифта для загрузки (*.eff файлы);
      FontData : адрес буфера для сохранения данных шрифта;
      FontInfo : указатель на структуру E2D_TFontInfo для сохранения информации о
                 загруженном шрифте (размер, информация о символах и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_LoadFont(FileName : PChar; var FontData : Pointer;
                        FontInfo : E2D_PFontInfo) : E2D_Result; stdcall;

  { Функция  для освобождения памяти, выделенной для данных изображения, звука или шрифта.
    Параметры :
      Data : адрес буфера, в котором сохранены данные изображения, звука или шрифта.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_FreeMem(var Data : Pointer) : E2D_Result; stdcall;

  { Функция для загрузки изображений из файлов и создания из них поверхности. Параметры :
      FileName  : имя файла изображения для загрузки (*.eif файлы);
      ImageInfo : указатель на структуру E2D_TImageInfo для сохранения информации о
                  загруженном изображении (высота, ширина, размер данных); данный параметр
                  может быть nil, если информация не нужна;
      ImageID   : переменная для сохранения идентификатора загруженного изображения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddImageFromFile(FileName : PChar; ImageInfo : E2D_PImageInfo;
                                var ImageID : E2D_TImageID) : E2D_Result; stdcall;

  { Функция для загрузки изображений из памяти и создания из них поверхности. Параметры :
      ImageData : адрес буфера, где сохранены данные изображения;
      ImageInfo : указатель на структуру E2D_TImageInfo, где сохранена информация об
                  изображении (высота, ширина, размер данных);
      ImageID   : переменная для сохранения идентификатора загруженного изображения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddImageFromMem(ImageData : Pointer; ImageInfo : E2D_PImageInfo;
                               var ImageID : E2D_TImageID) : E2D_Result; stdcall;

  { Процедура для удаления загруженных изображений. Параметры :
      FirstImage : идентификатор изображения, с которого необходимо начать удаление (будут
                   удалены все изображения загруженные после данного); для удаления всех
                   изображений данный параметр должен быть равен E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteImages(FirstImage : E2D_TImageID); stdcall;

  { Функция для получения информации о загруженном изображении. Параметры :
      ImageID   : идентификатор изображения, информацию о котором необходимо получить;
      ImageInfo : указатель на структуру E2D_TImageInfo для сохранения информации (высота,
                  ширина, размер данных).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetImageInfo(ImageID : E2D_TImageID;
                            ImageInfo : E2D_PImageInfo) : E2D_Result; stdcall;

  { Функция для загрузки звуков из файлов и создания для них буферов. Параметры :
      FileName  : имя файла звука для загрузки (*.esf файлы);
      SoundInfo : указатель на структуру E2D_TSoundInfo для сохранения информации о
                  загруженном звуке (количество каналов, частота дискретизации и другое);
                  данный параметр может быть nil, если информация не нужна;
      SoundID   : переменная для сохранения идентификатора загруженного звука.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddSoundFromFile(FileName : PChar; SoundInfo : E2D_PSoundInfo;
                                var SoundID : E2D_TSoundID) : E2D_Result; stdcall;

  { Функция для загрузки звуков из памяти и создания для них буферов. Параметры :
      SoundData : адрес буфера, где сохранены данные звука;
      SoundInfo : указатель на структуру E2D_TSoundInfo, где сохранена информация о звуке
                  (количество каналов, частота дискретизации и другое);
      SoundID   : переменная для сохранения идентификатора загруженного звука.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddSoundFromMem(SoundData : Pointer; SoundInfo : E2D_PSoundInfo;
                               var SoundID : E2D_TSoundID) : E2D_Result; stdcall; 

  { Процедура для удаления загруженных звуков. Параметры :
      FirstSound : идентификатор звука, с которого необходимо начать удаление (будут
                   удалены все звуки загруженные после данного); для удаления всех звуков
                   данный параметр должен быть равен E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteSounds(FirstSound : E2D_TSoundID); stdcall;

  { Функция для получения информации о загруженном звуке. Параметры :
      SoundID   : идентификатор звука, информацию о котором необходимо получить;
      SoundInfo : указатель на структуру E2D_TSoundInfo для сохранения информации
                 (количество каналов, частота дискретизации и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetSoundInfo(SoundID : E2D_TSoundID;
                            SoundInfo : E2D_PSoundInfo) : E2D_Result; stdcall;

  { Функция для загрузки шрифтов из файлов и создания из них поверхности. Параметры :
      FileName : имя файла шрифта для загрузки (*.eff файлы);
      FontInfo : указатель на структуру E2D_TFontInfo для сохранения информации о
                 загруженном шрифте (размер, информация о символах и другое); данный
                 параметр может быть nil, если информация не нужна;
      FontID   : переменная для сохранения идентификатора загруженного шрифта.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddFontFromFile(FileName : PChar; FontInfo : E2D_PFontInfo;
                               var FontID : E2D_TFontID) : E2D_Result; stdcall; 

  { Функция для загрузки изображений из памяти и создания из них поверхности. Параметры :
      FontData : адрес буфера, где сохранены данные шрифта;
      FontInfo : указатель на структуру E2D_TFontInfo, где сохранена информация о шрифте
                 (размер, информация о символах и другое);
      FontID   : переменная для сохранения идентификатора загруженного шрифта.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddFontFromMem(FontData : Pointer; FontInfo : E2D_PFontInfo;
                              var FontID : E2D_TFontID) : E2D_Result; stdcall;

  { Процедура для удаления загруженных шрифтов. Параметры :
      FirstFont : идентификатор шрифта, с которого необходимо начать удаление (будут
                  удалены все шрифты загруженные после данного); для удаления всех
                  шрифтов данный параметр должен быть равен E2D_MANAGE_DELETEALL. }
  procedure E2D_DeleteFonts(FirstFont : E2D_TFontID); stdcall;

  { Функция для получения информации о загруженном шрифте. Параметры :
      FontID   : идентификатор шрифта, информацию о котором необходимо получить;
      FontInfo : указатель на структуру E2D_TFontInfo для сохранения информации (размер,
                 информация о символах и другое).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetFontInfo(FontID : E2D_TFontID;
                           FontInfo : E2D_PFontInfo) : E2D_Result; stdcall;

  { Функция для создания обьектов DirectDraw и перехода в полноэкранный видеорежим.
    Параметры :
      ScreenWidth  : ширина экрана;
      ScreenHeight : высота экрана;
      Frec         : частота обновления монитора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateFullscreen(ScreenWidth, ScreenHeight,
                                Frec : Longword) : E2D_Result; stdcall;

  { Функция для получения описания утройства вывода. Параметры :
      Desc : указатель на структуру E2D_TDeviceDesc для сохранения описания.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetDeviceDesc(Desc : E2D_PDeviceDesc) : E2D_Result; stdcall;

  { Функция для вывода изображения на экран. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода;
      Place   : место расположения изображения на экране.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawImage(ImageID : E2D_TImageID; ImgRect : PRect;
                         Place : PPoint) : E2D_Result; stdcall;

  { Функция для вывода растянутого изображения на экран. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода (для вывода всего изображения данный
                параметр может быть nil);
      DstRect : прямоугольник изображения на экране (для вывода изображения на весь экран
                данный параметр может быть nil).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_StretchDraw(ImageID : E2D_TImageID;
                           ImgRect, DstRect : PRect) : E2D_Result; stdcall;

  { Функция для вывода на экран заднего буфера.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_ShowBuffer : E2D_Result; stdcall;

  { Функция для очистки заднего буфера.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_ClearBuffer : E2D_Result; stdcall;

  { Функция для восстановления поверхностей.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_RestoreSurfaces : E2D_Result; stdcall;

  { Функция для вывода текста. Параметры :
      FontID : идентификатор шрифта, которым необходимо вывести текст;
      Text   : указатель на строку, которую необходимо вывести;
      X, Y   : позиция текста на экране;
      Size   : длина строки.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawText(FontID : E2D_TFontID; Text : PChar; X, Y : Longword;
                        Size : Longword) : E2D_Result; stdcall;

  { Функция для рисования прямоугольника. Параметры :
      Color : цвет прямоугольника;
      Rect  : прямоугольник.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawRect(Color : E2D_TColor; Rect : PRect) : E2D_Result; stdcall;

  { Функция для получения яркости экрана.
    Возвращаемое значение : яркость. }
  function E2D_GetGamma : E2D_TGamma; stdcall;

  { Функция для установки яркости экрана. Параметры :
      Gamma : яркость.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetGamma(Gamma : E2D_TGamma) : E2D_Result; stdcall;

  { Функция для установки яркости цветовых составляющих. Параметры :
      R, G, B : яркость красного, зеленого и синего цвета.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetRGBGamma(R, G, B : E2D_TGamma) : E2D_Result; stdcall;

  { Функция для зеркального отражения изображения. Параметры :
      ImageID : идентификатор изображения, которое необходимо отразить;
      FlipHor : отражение по горизонтали (слева направо);
      FlipVer : отражение по вертикали (сверху вниз).
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_FlipImage(ImageID : E2D_TImageID;
                         FlipHor, FlipVer : Boolean) : E2D_Result; stdcall;

  { Функция для создания обьектов DirectSound.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateSound : E2D_Result; stdcall;

  { Функция для воспроизведения звука. Параметры :
      SoundID : идентификатор звука, который необходимо воспроизвести;
      Loop    : флаг, сигнализирующий надо ли зациклить воспроизведение.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_PlaySound(SoundID : E2D_TSoundID; Loop : Boolean) : E2D_Result; stdcall;

  { Функция для остановки воспроизведения звука. Параметры :
      SoundID : идентификатор звука, который необходимо остановить.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_StopSound(SoundID : E2D_TSoundID) : E2D_Result; stdcall;

  { Функция для получения громкости звука. Параметры :
      SoundID : идентификатор звука, громкость которго необходимо получить;
      Volume  : переменная для сохранения громкости.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetSoundVolume(SoundID : E2D_TSoundID;
                              var Volume : E2D_TSoundVolume) : E2D_Result; stdcall;

  { Функция для установления громкости звука. Параметры :
      SoundID : идентификатор звука, громкость которго необходимо установить;
      Volume  : громкость.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetSoundVolume(SoundID : E2D_TSoundID;
                              Volume : E2D_TSoundVolume) : E2D_Result; stdcall;

  { Функция для получения глобальной громкости.
    Возвращаемое значение : громкость. }
  function E2D_GetGlobalVolume : E2D_TSoundVolume; stdcall;

  { Функция для установления глобальной громкости. Параметры :
      Volume : громкость.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetGlobalVolume(Volume : E2D_TSoundVolume) : E2D_Result; stdcall;

  { Функция для получения панорамы звука. Параметры :
      SoundID : идентификатор звука, панораму которго необходимо получить;
      Pan     : переменная для сохранения панорамы.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetSoundPan(SoundID : E2D_TSoundID;
                           var Pan : E2D_TSoundPan) : E2D_Result; stdcall;

  { Функция для установления панорамы звука. Параметры :
      SoundID : идентификатор звука, панораму которго необходимо установить;
      Pan     : панорама.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetSoundPan(SoundID : E2D_TSoundID;
                           Pan : E2D_TSoundPan) : E2D_Result; stdcall;

  { Функция для создания обьектов DirectInput.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateInput : E2D_Result; stdcall;

  { Функция для создания устройства клавиатуры.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddKeyboard : E2D_Result; stdcall; 

  { Функция для создания устройства мыши.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddMouse : E2D_Result; stdcall;

  { Функция для обновления данных клавиатуры.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_UpdateKeyboard : E2D_Result; stdcall; 

  { Функция для обновления данных мыши.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_UpdateMouse : E2D_Result; stdcall;

  { Функция для получения информации о том, нажата ли клавиша на клавиатуре. Параметры :
      Key : код клавиши, информацию о которой необходимо получить.
    Возвращаемое значение : если клавиша нажата - True, если нет - False. }
  function E2D_IsKeyboardKeyDown(Key : Byte) : Boolean; stdcall; 

  { Процедура для получения позиции курсора. Параметры :
      CursorPos : переменная для сохранения позиции курсора. }
  procedure E2D_GetCursorPosition(var CursorPos : TPoint); stdcall; 

  { Процедура для получения приращения позиции курсора. Параметры :
      CursorDeltas : переменная для сохранения приращений позиции курсора. }
  procedure E2D_GetCursorDelta(var CursorDeltas : TPoint); stdcall;

  { Функция для получения информации о том, нажата ли кнопка мыши. Параметры :
      Button : кнопка, информацию о которой необходимо получить.
    Возвращаемое значение : если клавиша нажата - True, если нет - False. }
  function E2D_IsMouseButtonDown(Button : E2D_TMouseButton) : Boolean; stdcall;

  { Функция для создания поверхности выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateSelection : E2D_Result; stdcall;

  { Функция для вывода изображения на поверхность выбора. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода;
      Place   : место расположения изображения на поверхности выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawImageToSelect(ImageID : E2D_TImageID; ImgRect : PRect;
                                 Place : PPoint) : E2D_Result; stdcall;

  { Функция для рисования прямоугольника на поверхности выбора. Параметры :
      Color : цвет прямоугольника;
      Rect  : прямоугольник.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawRectToSelect(Color : E2D_TColor; Rect : PRect) : E2D_Result; stdcall;

  { Функция для очистки поверхности выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_ClearSelect : E2D_Result; stdcall;

  { Функция для подготовки к выбору.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_BeginSelection : E2D_Result; stdcall;

  { Функция для завершения выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EndSelection : E2D_Result; stdcall;

  { Функция для осуществления выбора. Параметры :
      X, Y : координаты точки, для которой осуществляется выбор.
    Возвращаемое значение : цвет пиксела поверхности. }
  function E2D_GetSelectionVal(X, Y : Longword) : E2D_TColor; stdcall;

  { Функция для определения столкновения. Параметры :
      Image1ID, Image2ID  : идентификаторы изображений, для обьектов которых необходимо
                            определить столкновение;
      Place1, Place2      : место расположения изображения на экране;
      Collision           : переменная для сохранения результата столкновения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetCollision(Image1ID, Image2ID : E2D_TImageID;
                            ImageRect1, ImageRect2 : PRect; Place1, Place2 : PPoint;
                            var Collision : Boolean) : E2D_Result; stdcall;

  { Функция для подготовки к выводу визуальных эффектов.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_BeginEffects : E2D_Result; stdcall; 

  { Функция для завершения вывода визуальных эффектов.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EndEffects : E2D_Result; stdcall;

  { Функция для вывода прозрачного изображения на экран. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода;
      Place   : место расположения изображения на экране;
      Alpha   : коэффициент прозрачности.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EffectBlend(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                           Alpha : E2D_TAlpha) : E2D_Result; stdcall;

  { Функция для вывода прозрачного изображения на экран с использованием альфа маски.
    Параметры :
      ImageID     : идентификатор изображения, которое необходимо вывести;
      MaskImageID : идентификатор изображения альфа маски;
      ImgRect     : прямоугольник изображения для вывода;
      Place       : место расположения изображения на экране;
      MaskPlace   : место расположения изображения альфа маски.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EffectAlphaMask(ImageID, MaskImageID : E2D_TImageID; ImgRect : PRect;
                               Place, MaskPlace : PPoint) : E2D_Result; stdcall;

  { Функция для вывода изображения на экран с использованием пользовательского эффекта.
    Параметры :
      ImageID     : идентификатор изображения, которое необходимо вывести;
      ImgRect     : прямоугольник изображения для вывода;
      Place       : место расположения изображения на экране;
      ColorCalc   : функция для вычисления цвета пиксела.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EffectUser(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                          ColorCalc : E2D_TColorCalcFunc) : E2D_Result; stdcall;

  { Процедура для вывода на экран точки. Параметры :
      X, Y  : место расположения точки на экране;
      Color : цвет точки. }
  procedure E2D_PutPoint(X, Y : Longword; Color : E2D_TColor); stdcall;

  { Функция возвращает информацию об ошибке. Параметры :
      ErrorCode : код возникшей ошибки.
    Возвращаемое значение : указатель на строку с описанием ошибки. }
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


