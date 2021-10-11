(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DMain.pas                                                             *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 21.10.06                                                                *)
(* Информация : Модуль содежит функции инициализации и освобождения ресурсов, занятых   *)
(*              Ext2D Engine.                                                           *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DMain;

interface

  { Процедура для начальной инициализации. Параметры :
      WindowHandle : ссылка на окно приложения. }
  procedure E2D_InitEngine(WindowHandle : Longword); stdcall; export;

  { Процедура для удаления всех созданных обьектов и освобождения занятых ресерсов. }
  procedure E2D_FreeEngine; stdcall; export;

  { Функция для получения версии библиотеки Ext2D Engine.
    Возвращаемое значение : старший байт старшего слова - основная версия, младший байт -
                            дополнительная версия; старший байт младшего слова - релиз,
                            младший байт - билд. }
  function E2D_GetEngineVersion : Longword; stdcall; export;

implementation

uses
  E2DConsts,  { Для констант управления }
  E2DVars,    { Для переменных экрана }
  E2DManager, { Для удаления обьектов }
  Windows;    { Для управления курсором }

procedure E2D_InitEngine;
begin { E2D_InitEngine }
  // Сохраняем ссылку на окно.
  Window_Handle := WindowHandle;
end; { E2D_InitEngine }

procedure E2D_FreeEngine;
begin { E2D_FreeEngine }
  // Удаляем звуки.
  E2D_DeleteSounds(E2D_MANAGE_DELETEALL);
  // Удаляем изображения.
  E2D_DeleteImages(E2D_MANAGE_DELETEALL);
  // Удаляем шрифты.
  E2D_DeleteFonts(E2D_MANAGE_DELETEALL);

  // Удаляем мышь,
  DID_Mouse    := nil;
  // клавиатуру
  DID_Keyboard := nil;
  // и главный обьект DirectInput.
  DI_Main      := nil;

  // Удаляем главный обьект DirectSound.
  DS_Main := nil;

  // Удаляем поверхность выбора.
  DDS_Selection := nil;

  // Удаляем обьект яркости,
  DDG_Main       := nil;
  // задний буфер,
  DDS_BackBuffer := nil;
  // первичную поверхность
  DDS_Primary    := nil;
  // и главный обьект DirectDraw.
  DD_Main        := nil;

  // Обнуляем позицию курсора по горизонтали
  Cursor_X  := 0;
  // и вертикали.
  Cursor_Y  := 0;
  // Обнуляем приращение позиции курсора по горизонтали
  Cursor_dX := 0;
  // и вертикали.
  Cursor_dY := 0;
  // Обнуляем данные клавиатуры
  ZeroMemory(@Keyboard_Data, SizeOf(Keyboard_Data));
  // и мыши.
  ZeroMemory(@Mouse_Data, SizeOf(Mouse_Data));

  // Устанавливаем глобальную громкость.
  Volume_Global := E2D_SOUND_MAXVOLUME;

  // Обнуляем ширину
  Screen_Width  := 0;
  // и высоту
  Screen_Height := 0;
  // и устанавливаем яркость экрана.
  Screen_Gamma  := 256;

  // Обнуляем ссылку на окно.
  Window_Handle := 0;

  // Включаем курсор.
  ShowCursor(True);
end; { E2D_FreeEngine }

function E2D_GetEngineVersion;
begin { E2D_GetEngineVersion }
  // Помещаем в результат версию Ext2D Engine.
  Result := $01000054;
end; { E2D_GetEngineVersion }

end.
