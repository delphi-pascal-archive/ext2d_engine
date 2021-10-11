(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DVars.pas                                                             *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 04.06.06                                                                *)
(* Информация : Модуль содежит глобальные переменные.                                   *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DVars;

interface

uses
  E2DTypes, E2DConsts,  DirectDraw, DirectSound, DirectInput8;

var
  { Переменные DirectDraw }
  DD_Main        : IDirectDraw7            = nil; { Главный обьект }
  DDS_Primary    : IDirectDrawSurface7     = nil; { Первичная поверхность }
  DDS_BackBuffer : IDirectDrawSurface7     = nil; { Задний буфер }
  DDG_Main       : IDirectDrawGammaControl = nil; { Обьект яркости }

  { Переменные DirectSound }
  DS_Main : IDirectSound8 = nil; { Главный обьект }

  { Переменные DirectInput }
  DI_Main      : IDirectInput8       = nil; { Главный обьект }
  DID_Keyboard : IDirectInputDevice8 = nil; { Клавиатура }
  DID_Mouse    : IDirectInputDevice8 = nil; { Мышь }

  { Переменные выбора }
  DDS_Selection : IDirectDrawSurface7 = nil; { Поверхность }

  { Системные переменные }
  Window_Handle : Longword = 0; { Ссылка на окно приложения }

  { Переменные экрана }
  Screen_Width  : Longword   = 0;   { Ширина }
  Screen_Height : Longword   = 0;   { Высота }
  Screen_Gamma  : E2D_TGamma = 256; { Яркость }

  { Переменные звуков }
  Volume_Global : Byte = E2D_SOUND_MAXVOLUME; { Глобальная громкость }

  { Переменные ввода }
  Keyboard_Data : array [0..255] of Byte; { Данные клавиатуры }
  Mouse_Data    : TDIMouseState2;         { Данные мыши }
  Cursor_X      : Longword = 0;           { Позиция курсора по горизонтали }
  Cursor_Y      : Longword = 0;           { Позиция курсора по вертикали }
  Cursor_dX     : Longint  = 0;           { Приращение позиции курсора по горизонтали }
  Cursor_dY     : Longint  = 0;           { Приращение позиции курсора по вертикали }

  { Переменные управления }
  Images : array [0..E2D_MANAGE_MAXIMAGES - 1] of E2D_TImage; { Изображения }
  Sounds : array [0..E2D_MANAGE_MAXSOUNDS - 1] of E2D_TSound; { Звуки }
  Fonts  : array [0..E2D_MANAGE_MAXFONTS  - 1] of E2D_TFont;  { Шрифты }

  { Счетчики обьектов }
  NumImages : Longword = 0; { Текущее количество изображений }
  NumSounds : Longword = 0; { Текущее количество звуков }
  NumFonts  : Longword = 0; { Текущее количество шрифтов }

implementation

end.
