(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DSelect.pas                                                           *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 21.10.06                                                                *)
(* Информация : Модуль содежит функции для осуществления выбора обьектов.               *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DSelect;

interface

uses
  E2DTypes, Windows;

  { Функция для создания поверхности выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateSelection : E2D_Result; stdcall; export;

  { Функция для вывода изображения на поверхность выбора. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода (для вывода всего изображения данный
                параметр может быть nil);
      Place   : место расположения изображения на поверхности выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawImageToSelect(ImageID : E2D_TImageID; ImgRect : PRect;
                                 Place : PPoint) : E2D_Result; stdcall; export;

  { Функция для рисования прямоугольника на поверхности выбора. Параметры :
      Color : цвет прямоугольника;
      Rect  : прямоугольник.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_DrawRectToSelect(Color : E2D_TColor;
                                Rect : PRect) : E2D_Result; stdcall; export;

  { Функция для очистки поверхности выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_ClearSelect : E2D_Result; stdcall; export;

  { Функция для подготовки к выбору.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_BeginSelection : E2D_Result; stdcall; export;

  { Функция для завершения выбора.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EndSelection : E2D_Result; stdcall; export;
  
  { Функция для осуществления выбора. Параметры :
      X, Y : координаты точки, для которой осуществляется выбор.
    Возвращаемое значение : цвет пиксела поверхности. }
  function E2D_GetSelectionVal(X, Y : Longword) : E2D_TColor; stdcall; export;

implementation

uses
  E2DConsts,  { Для констант ошибок }
  E2DVars,    { Для переменных выбора }
  E2DManager, { Для создания поверхности }
  E2DScreen,  { Для восстановления поверхностей }
  DirectDraw; { Для функций DirectDraw }

var
  { Указатель на поверхность выбора }
  SS_Pointer : Pointer = nil;
  { Размер строки заднего поверхности выбора в памяти }
  SS_Pitch : Longword = 0;

function E2D_CreateSelection;
var
  ii : E2D_TImageInfo; { Размеры поверхности }
begin { E2D_CreateSelection }
  // Сохраняем ширину
  ii.Width := Screen_Width;
  // и высоту поверхности.
  ii.Height := Screen_Height;

  // Создаем поверхность.
  if CreateSurface(DDS_Selection, @ii) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_MANAGE_CREATESURF;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_CreateSelection }

function E2D_DrawImageToSelect;
var
  Rect   : TRect;  { Точный прямоугольник изображения }
  Point  : TPoint; { Точное положение на поверхности выбора }
begin { E2D_DrawImageToSelect }
  // Проверяем идентификатор изображения.
  if ImageID >= NumImages then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Сохраняем прямоугольник изображения
  Rect  := ImgRect^;
  // и его положение на на поверхности выбора.
  Point := Place^;

  // Проверяем прямоугольник вывода.
  if not CorrectRectS(@Rect, @Point) then
    //  Если его видно выводим изображение на поверхность выбора.
    if DDS_Selection.BltFast(Point.X, Point.Y, Images[ImageID].Surface, @Rect,
                             DDBLTFAST_WAIT or
                             DDBLTFAST_SRCCOLORKEY) <> DD_OK then begin { if }
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_SCREEN_CANTDRAW;
      // и выходим из функции.
      Exit;
    end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_DrawImageToSelect }

function E2D_DrawRectToSelect;
var
  blt   : TDDBltFX; { Структура для заполнения прямоугольника }
  cRect : TRect;    { Точный прямоугольник }
begin { E2D_DrawRectToSelect }
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
    if DDS_Selection.Blt(@cRect, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                         @blt) <> DD_OK then begin { if }
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_SCREEN_CANTDRAW;
      // и выходим из функции.
      Exit;
    end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_DrawRectToSelect }

function E2D_ClearSelect;
var
  blt : TDDBltFX; { Структура для очистки поверхности выбора }
begin { E2D_ClearSelect }
  // Обнуляем структуру.
  ZeroMemory(@blt, SizeOf(blt));
  // Заполняем поля свойств структуры блиттинга : рамер
  blt.dwSize := SizeOf(blt);
  // и цвет заполнения.
  blt.dwFillColor := E2D_SCREEN_COLORKEY;

  // Очищаем поверхность выбора.
  if DDS_Selection.Blt(nil, nil, nil, DDBLT_WAIT or DDBLT_COLORFILL,
                       @blt) <> DD_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SCREEN_CANTCLEAR;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_ClearSelect }

function E2D_BeginSelection;
var
  ddsd : TDDSurfaceDesc2; { Структура для описания поверхности }
begin { E2D_BeginSelection }
  // Обнуляем структуру.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // Заполняем поле размера структуры описания поверхности.
  ddsd.dwSize := SizeOf(ddsd);

  // Блокируем поверхность выбора.
  if DDS_Selection.Lock(nil, ddsd, DDLOCK_WAIT, 0) = DD_OK then begin { if }
    // Если получилось сохраняем указатель на поверхность выбора,
    SS_Pointer := ddsd.lpSurface;
    // размер строки в памяти
    SS_Pitch := ddsd.lPitch;
    // и делаем результат успешным.
    Result := E2DERR_OK;
  end else { if }
    // Если не получилось помещаем код ошибки в результат.
    Result := E2DERR_MANAGE_CANTLOCK;
end; { E2D_BeginSelection }

function E2D_EndSelection;
begin { E2D_EndSelection }
  // Удаляем указатель на поверхность выбора.
  SS_Pointer := nil;
  // Обнуляем размер строки в памяти.
  SS_Pitch := 0;
  // Отпираем поверхность выбора.
  DDS_Selection.Unlock(nil);
  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_EndSelection }

function E2D_GetSelectionVal;
begin { E2D_GetSelectionVal }
  // Проверяем не вышли ли за границы поверхности.
  if (X >= Screen_Width) or (Y >= Screen_Height) then
    // Если вышли помещаем в результат 0.
    Result := 0
  else
    // Если нет помещаем в результат цвет пиксела.
    Result := E2D_PColor(Longword(SS_Pointer) + Y * SS_Pitch + X * E2D_SCREEN_BYTESPP)^;
end; { E2D_GetSelectionVal }

end.
