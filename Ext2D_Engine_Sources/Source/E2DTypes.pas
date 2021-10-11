(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DTypes.pas                                                            *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 03.11.06                                                                *)
(* Информация : Модуль содержит описание основных типов.                                *)
(* Изменения  : no changes.                                                             *)
(****************************************************************************************)

unit E2DTypes;

interface

uses
  DirectDraw, DirectSound;

type
  { Тип результата функций }
  E2D_Result = Longword;

  { Информация об изображении }
  E2D_TImageInfo = packed record
    Width    : Longword; { Выстоа }
    Height   : Longword; { Ширина }
    DataSize : Longword; { Размер данных }
  end; { E2D_TImageInfo }
  { Указатель на информацию об изображении }
  E2D_PImageInfo = ^E2D_TImageInfo;

  { Информация о звуке }
  E2D_TSoundInfo = packed record
    Channels      : Word;     { Количество каналов }
    SamplesPerSec : Longword; { Частота дискретизации }
    BlockAlign    : Word;     { Блочное выравнивание }
    BitsPerSample : Word;     { Качество }
    DataSize      : Longword; { Размер данных }
  end; { E2D_TSoundInfo }
  { Указатель на информацию о звуке }
  E2D_PSoundInfo = ^E2D_TSoundInfo;

  { Информвция о символе }
  E2D_TCharInfo = packed record
    X     : Word; { Позиция по горизонтали }
    Y     : Word; { Позиция по вертикали }
    Width : Word; { Ширина }
  end; { E2D_TCharInfo }

  { Информация о шрифте }
  E2D_TFontInfo = packed record
    Image     : E2D_TImageInfo;                  { Изображение шрифта }
    Size      : Longword;                        { Размер }
    CharsInfo : array [0..255] of E2D_TCharInfo; { Информация о символах }
  end; { E2D_TFontInfo }
  { Указатель на информацию о шрифте }
  E2D_PFontInfo = ^E2D_TFontInfo;

  { Тип идентификатора изображений }
  E2D_TImageID = Longword;
  { Тип идентификатора звуков }
  E2D_TSoundID = Longword;
  { Тип идентификатора шрифтов }
  E2D_TFontID  = Longword;

  { Изображение }
  E2D_TImage = packed record
    Surface : IDirectDrawSurface7; { Поверхность }
    Info    : E2D_TImageInfo;      { Информация }
    Data    : Pointer;             { Данные }
  end; { E2D_TImage }

  { Звук }
  E2D_TSound = packed record
    Buffer : IDirectSoundBuffer; { Буфер }
    Info   : E2D_TSoundInfo;     { Информация }
  end; { E2D_TSound }

  { Шрифт }
  E2D_TFont = packed record
    Surface : IDirectDrawSurface7; { Поверхность }
    Info    : E2D_TFontInfo;       { Информация }
    Data    : Pointer;             { Данные }
  end; { E2D_TFont }

  { Описание устройства вывода }
  E2D_TDeviceDesc = packed record
    Name    : PChar;    { Имя }
    tVidMem : Longword; { Всего видеопамяти }
    aVidMem : Longword; { Доступно видеопамяти }
    Gamma   : Boolean;  { Поддержка яркости }
  end; { E2D_TDeviceDesc }
  { Указатель на описание устройства вывода }
  E2D_PDeviceDesc = ^E2D_TDeviceDesc;

  { Яркость }
  E2D_TGamma = 0..256;
  { Цвет }
  E2D_TColor = Word;
  { Указатель на цвет }
  E2D_PColor = ^E2D_TColor;
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

implementation

end.
