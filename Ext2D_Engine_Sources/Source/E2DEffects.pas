(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DEffects.pas                                                          *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 23.10.06                                                                *)
(* Информация : Модуль содежит функции для вывода графики на экран с использованием     *)
(*              визуальных эффектов.                                                    *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DEffects;

interface

uses
  E2DTypes, Windows;

  { Функция для подготовки к выводу визуальных эффектов.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_BeginEffects : E2D_Result; stdcall; export;

  { Функция для завершения вывода визуальных эффектов.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EndEffects : E2D_Result; stdcall; export;

  { Функция для вывода прозрачного изображения на экран. Параметры :
      ImageID : идентификатор изображения, которое необходимо вывести;
      ImgRect : прямоугольник изображения для вывода;
      Place   : место расположения изображения на экране;
      Alpha   : коэффициент прозрачности.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EffectBlend(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                           Alpha : E2D_TAlpha) : E2D_Result; stdcall; export;

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
                               Place, MaskPlace : PPoint) : E2D_Result; stdcall; export;

  { Функция для вывода изображения на экран с использованием пользовательского эффекта.
    Параметры :
      ImageID   : идентификатор изображения, которое необходимо вывести;
      ImgRect   : прямоугольник изображения для вывода;
      Place     : место расположения изображения на экране;
      ColorCalc : функция для вычисления цвета пиксела.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_EffectUser(ImageID : E2D_TImageID; ImgRect : PRect; Place : PPoint;
                          ColorCalc : E2D_TColorCalcFunc) : E2D_Result; stdcall; export;

  { Процедура для вывода на экран точки. Параметры :
      X, Y  : место расположения точки на экране;
      Color : цвет точки. }
  procedure E2D_PutPoint(X, Y : Longword; Color : E2D_TColor); stdcall; export;

implementation

uses
  E2DScreen,  { Для проверки прямоугольников }
  E2DConsts,  { Для констант ошибок }
  E2DVars,    { Для переменных DirectDraw и экрана }
  DirectDraw; { Для функций DirectDraw }

var
  { Прямоугольник экрана }
  ScreenRect : TRect;
  { Указатель на задний буфер }
  BB_Pointer : Pointer = nil;
  { Размер строки заднего буфера в памяти }
  BB_Pitch : Longword = 0;

function E2D_BeginEffects;
var
  ddsd : TDDSurfaceDesc2; { Структура для описания поверхности }
begin { E2D_BeginEffects }
  // Задаем прямоугольник экрана.
  SetRect(ScreenRect, 0, 0, Screen_Width, Screen_Height);

  // Обнуляем структуру.
  ZeroMemory(@ddsd, SizeOf(ddsd));
  // Заполняем поле размера структуры описания поверхности.
  ddsd.dwSize := SizeOf(ddsd);

  // Блокируем задний буфер.
  if DDS_BackBuffer.Lock(@ScreenRect, ddsd, DDLOCK_WAIT, 0) = DD_OK then begin { if }
    // Если получилось сохраняем указатель на задний буфер,
    BB_Pointer := ddsd.lpSurface;
    // размер строки в памяти
    BB_Pitch := ddsd.lPitch;
    // и делаем результат успешным.
    Result := E2DERR_OK;
  end else { if }
    // Если не получилось помещаем код ошибки в результат.
    Result := E2DERR_MANAGE_CANTLOCK;
end; { E2D_BeginEffects }

function E2D_EndEffects;
begin { E2D_EndEffects }
  // Удаляем указатель на задний буфер.
  BB_Pointer := nil;
  // Обнуляем размер строки в памяти.
  BB_Pitch := 0;
  // Отпираем задний буфер.
  DDS_BackBuffer.Unlock(@ScreenRect);
  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_EndEffects }

var
  a : E2D_TAlpha;

function E2D_EffectBlend;

  { Функция для вычисления цвета пиксела. Параметры :
      SrcColor : цвет источника;
      DstColor : цвет приемника.
    Возвращаемое значение : цвет пиксела с учетом прозрачности. }
  function CalcBlend(SrcColor, DstColor : E2D_TColor) : E2D_TColor; assembler; stdcall;
  asm
    PUSH ESI
    PUSH EDI

    MOV ESI, DWORD(DstColor)
    AND ESI, $1F
    MOV EDI, DWORD(SrcColor)
    AND EDI, $1F

    SUB  EDI, ESI
    MOV  EAX, DWORD(a)
    IMUL EDI
    SHR  EAX, 8
    ADD  EAX, ESI
    PUSH EAX

    MOV ESI, DWORD(DstColor)
    SHR ESI, 5
    AND ESI, $3F
    MOV EDI, DWORD(SrcColor)
    SHR EDI, 5
    AND EDI, $3F

    SUB  EDI, ESI
    MOV  EAX, DWORD(a)
    IMUL EDI
    SHR  EAX, 8
    ADD  EAX, ESI
    SHL  EAX, 5
    PUSH EAX

    MOV ESI, DWORD(DstColor)
    SHR ESI, 11
    AND ESI, $1F
    MOV EDI, DWORD(SrcColor)
    SHR EDI, 11
    AND EDI, $1F

    SUB  EDI, ESI
    MOV  EAX, DWORD(a)
    IMUL EDI
    SHR  EAX, 8
    ADD  EAX, ESI
    SHL  EAX, 11

    POP EDI
    ADD EAX, EDI
    POP EDI
    ADD EAX, EDI

    POP EDI
    POP ESI
  end; { asm }

begin { E2D_EffectBlend }
  // Сохраняем коэффициент.
  a := Alpha;
  // Выводим прозрачное изображение.
  Result := E2D_EffectUser(ImageID, ImgRect, Place, @CalcBlend);
end; { E2D_EffectBlend }

function E2D_EffectAlphaMask;
var
  i, j       : Longword;   { Счетчики цикла }
  sC, dC, aC : E2D_TColor; { Значения пикселов источника, приемника и альфа маски }
  sB, dB, B  : Byte;       { Синяя составляющая пикселов }
  sG, dG, G  : Byte;       { Зеленая составляющая пикселов }
  sR, dR, R  : Byte;       { Красная составляющая пикселов }
  Alpha      : E2D_TAlpha; { Коэффициент прозрачности }
  iofs, aofs : Longword;   { Смещения адресов }
  wrkP       : E2D_PColor; { Указатель на пиксел }
  Rect       : TRect;      { Точный прямоугольник изображения }
  ImgPoint   : TPoint;     { Точное положение на экране изображения }
  MaskPoint  : TPoint;     { Точное положение изображения альфа маски }
label
  OnOK; { Завершение функции }
begin { E2D_EffectAlphaMask }
  // Проверяем идентификаторы изображений.
  if (ImageID >= NumImages) or (MaskImageID >= NumImages) then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Сохраняем прямоугольник изображения
  Rect      := ImgRect^;
  // и его положение на экране
  ImgPoint  := Place^;
  // и расположение изображения альфа маски.
  MaskPoint := MaskPlace^;

  // Проверяем прямоугольник вывода.
  if CorrectRectS(@Rect, @ImgPoint) then
    // Если его не нужно выводить завершаем функцию.
    goto OnOK;
  // Вычисляем новое расположение изображения альфа маски по горизонтали
  MaskPoint.X := MaskPoint.X + (Rect.Left - ImgRect^.Left);
  // и вертикали.
  MaskPoint.Y := MaskPoint.Y + (Rect.Top - ImgRect^.Top);

  {$WARNINGS OFF}
  // Вычисляем базовые смещения изображения
  iofs := Longword(Images[ImageID].Data) +
          Rect.Top * E2D_SCREEN_BYTESPP * Images[ImageID].Info.Width;
  // и альфа маски.
  aofs := Longword(Images[MaskImageID].Data) +
          MaskPoint.Y * E2D_SCREEN_BYTESPP * Images[MaskImageID].Info.Width;

  // Попиксельно выводим прозрачное изображение.
  for j := 0 to Rect.Bottom - Rect.Top - 1 do begin { for }
    // Вычисляем новые смещения изображения
    iofs := iofs + Rect.Left * E2D_SCREEN_BYTESPP;
    // и альфа маски.
    aofs := aofs + MaskPoint.X * E2D_SCREEN_BYTESPP;

    // Попиксельно выводим прозрачное изображение.
    for i := 0 to Rect.Right - Rect.Left - 1 do begin { for }
      // Получаем пиксел источника.
      sC := E2D_PColor(iofs)^;

      // Проверяем надо ли выводить данный пиксел.
      if sC <> E2D_SCREEN_COLORKEY then begin { if }
        // Если надо запоминаем указатель
        wrkP := E2D_PColor(Longword(BB_Pointer) + (ImgPoint.Y + j) * BB_Pitch +
                           (ImgPoint.X + i) * E2D_SCREEN_BYTESPP);
        // и получаем пиксел приемника.
        dC := wrkP^;

        // Получаем синюю составляющую источника
        sB := sC and $1F;
        // и приемника,
        dB := dC and $1F;
        // зеленую составляющую источника
        sG := (sC shr 5) and $3F;
        // и приемника
        dG := (dC shr 5) and $3F;
        // и красную составляющую источника
        sR := (sC shr 11) and $1F;
        // и приемника.
        dR := (dC shr 11) and $1F;

        // Получаем пиксел альфа маски.
        aC := E2D_PColor(aofs)^;
        // Вычисляем коэффициент прозрачности для пиксела.
        Alpha := Trunc(aC / High(E2D_TColor) * High(E2D_TAlpha));

        // Вычисляем новые значения синей,
        B := (Alpha * (sB - dB) shr 8) + dB;
        // зеленой
        G := (Alpha * (sG - dG) shr 8) + dG;
        // и красной составляющей.
        R := (Alpha * (sR - dR) shr 8) + dR;

        // Устанавливаем новый пиксел приемника.
        wrkP^ := B or (G shl 5) or (R shl 11);
      end; { if }

      // Увеличиваем смещение изображения
      iofs := iofs + E2D_SCREEN_BYTESPP;
      // и альфа маски.
      aofs := aofs + E2D_SCREEN_BYTESPP;
    end; { for }

    // Вычисляем новые смещения изображения
    iofs := iofs + (Images[ImageID].Info.Width - Rect.Right) * E2D_SCREEN_BYTESPP;
    // и альфа маски.
    aofs := aofs + (Images[MaskImageID].Info.Width - Rect.Right) * E2D_SCREEN_BYTESPP;
    {$WARNINGS ON}
  end; { for }

OnOK :
  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_EffectAlphaMask }

function E2D_EffectUser;
var
  ofs, ofsS : Longword; { Смещение адреса }
  Rect      : TRect;    { Точный прямоугольник изображения }
  Point     : TPoint;   { Точное положение на экране }
  irw, irh  : Longword; { Размеры изображения }
  iw        : Longword; { Ширина изображения }
label                    
  OnOK; { Завершение функции }
begin { E2D_EffectUser }
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
  if CorrectRectS(@Rect, @Point) then
    // Если его не нужно выводить завершаем функцию.
    goto OnOK;

  {$WARNINGS OFF}
  // Вычисляем базовое смещение.
  ofs := Longword(Images[ImageID].Data) +
         Rect.Top * E2D_SCREEN_BYTESPP * Images[ImageID].Info.Width;
  // Вычисляем базовое смещение для экрана.
  ofsS := Longword(BB_Pointer) + Point.Y * BB_Pitch;

  // Сохраняем ширину
  irw := Rect.Right - Rect.Left;
  // и высоту прямоугольника изображения
  irh := Rect.Bottom - Rect.Top;
  // и ширину исходного изображения.
  iw  := Images[ImageID].Info.Width;

  asm
    MOV ESI, ofs
    MOV EDI, ofsS

    XOR EBX, EBX
  @@CycleY :
    CMP EBX, irh
    JE  OnOK

    MOV EAX, E2D_SCREEN_BYTESPP
    MUL Rect.Left
    ADD ESI, EAX

    PUSH EBX
    XOR ECX, ECX
  @@CycleX :
    CMP ECX, irw
    JE  @@DoneX

    MOV  BX, WORD PTR [ESI]
    CMP  BX, E2D_SCREEN_COLORKEY
    JE   @@IsColorKey

    PUSH EDI
    MOV  EAX, Point.X
    ADD  EAX, ECX
    ADD  EDI, EAX
    ADD  EDI, EAX

    PUSH ESI
    MOV  SI, WORD PTR [EDI]
    PUSH EBX
    PUSH ESI
    CALL ColorCalc
    MOV  WORD PTR [EDI], AX
    POP  ESI
    POP  EDI

  @@IsColorKey :
    ADD ESI, E2D_SCREEN_BYTESPP
    INC ECX
    JMP @@CycleX

  @@DoneX :
    POP EBX
    MOV EAX, iw
    SUB EAX, Rect.Right
    ADD ESI, EAX
    ADD ESI, EAX
    ADD EDI, BB_Pitch
    INC EBX
    JMP @@CycleY
  end; { asm }

OnOK :
  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_EffectUser }

procedure E2D_PutPoint;
begin { E2D_PutPoint }
  // Проверяем, не вышли ли за границы экрана.
  if (X < Screen_Width) and (Y < Screen_Height) then
    // Если нет устанавливаем новый цвет точки.
    E2D_PColor(Longword(BB_Pointer) + Y * BB_Pitch + X * E2D_SCREEN_BYTESPP)^ := Color;
end; { E2D_PutPoint }

end.
