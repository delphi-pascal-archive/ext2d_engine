(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DPhysic.pas                                                           *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 27.08.06                                                                *)
(* Информация : Модуль содежит функции для орпеделения столкновений.                    *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DPhysic;

interface

uses
  E2DTypes, Windows;

  { Функция для определения столкновения. Параметры :
      Image1ID, Image2ID  : идентификаторы изображений, для обьектов которых необходимо
                            определить столкновение;
      Place1, Place2      : место расположения изображения на экране;
      Collision           : переменная для сохранения результата столкновения.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetCollision(Image1ID, Image2ID : E2D_TImageID;
                            ImageRect1, ImageRect2 : PRect; Place1, Place2 : PPoint;
                            var Collision : Boolean) : E2D_Result; stdcall; export;

implementation

uses
  E2DConsts, { Для констант ошибок и экрана }
  E2DVars;   { Для изображений }

function E2D_GetCollision;
var
  ir         : TRect;      { Прямоугольник пересечения на экране }
  sr1, sr2   : TRect;      { Прямоугольники на экране }
  ir1, ir2   : TRect;      { Прямоугольники пересечения }
  cv1, cv2   : E2D_TColor; { Цвета пикселов }
  i, j       : Longword;   { Счетчики цикла }
  ofs1, ofs2 : Longword;   { Смещения адресов }
label
  OnOK; { Завершение функции }
begin { E2D_GetCollision }
  // Устанавливаем столкновение.
  Collision := False;

  // Проверяем идентификаторы изображений.
  if (Image1ID >= NumImages) or (Image2ID >= NumImages) then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  try
    // Пытаемся вычислить прямоугольники на экране для первого
    SetRect(sr1, Place1^.X, Place1^.Y, Place1^.X + ImageRect1^.Right - ImageRect1^.Left,
            Place1^.Y + ImageRect1^.Bottom - ImageRect1^.Top);
    // и второго изображений
    SetRect(sr2, Place2^.X, Place2^.Y, Place2^.X + ImageRect2^.Right - ImageRect2^.Left,
            Place2^.Y + ImageRect2^.Bottom - ImageRect2^.Top);

    // и пересечь прямоугольники на экране.
    IntersectRect(ir, sr1, sr2);
  except
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVPOINTER;
    // и выходим из функции.
    Exit;
  end; { try }

  // Проверяем пересечение.
  if (ir.Left = 0) and (ir.Right = 0) and (ir.Top = 0) and (ir.Bottom = 0) then
    // Если пересечения нет завершаем функцию.
    goto OnOK;

  // Запоминаем прямоугольники пересечения для первого
  ir1 := ir;
  // и второго обьекта.
  ir2 := ir;

  // Сдвигаем прямоугольники для первого
  OffsetRect(ir1, -Place1^.X, -Place1^.Y);
  // и второго обьекта.
  OffsetRect(ir2, -Place2^.X, -Place2^.Y);

  {$WARNINGS OFF}
  // Вычисляем базовые смещения для первого
  ofs1 := Longword(Images[Image1ID].Data) + (ImageRect1^.Top + ir1.Top) *
                   E2D_SCREEN_BYTESPP * Images[Image1ID].Info.Width;
  // и второго обьектов.
  ofs2 := Longword(Images[Image2ID].Data) + (ImageRect2^.Top + ir2.Top) *
                   E2D_SCREEN_BYTESPP * Images[Image2ID].Info.Width;

  // Пытаемся проверить значения пикселов в прямоугольнике.
  for j := 0 to ir.Bottom - ir.Top - 1 do begin { for }
    // Вычисляем новые смещения для первого
    ofs1 := ofs1 + (ImageRect1^.Left + ir1.Left) * E2D_SCREEN_BYTESPP;
    // и второго обьектов.
    ofs2 := ofs2 + (ImageRect2^.Left + ir2.Left) * E2D_SCREEN_BYTESPP;

    // Проверяем значения пикселов в прямоугольнике.
    for i := 0 to ir.Right - ir.Left - 1 do begin { for }
      // Получаем пикселы для первого
      cv1 := E2D_PColor(ofs1)^;
      // и второго обьектов.
      cv2 := E2D_PColor(ofs2)^;

      // Сравниваем значения пикселов.
      if (cv1 <> E2D_SCREEN_COLORKEY) and (cv2 <> E2D_SCREEN_COLORKEY) then begin { if }
        // Если они оба отличны от цвета фона устанавливаем столкновение
        Collision := True;
        // и выходим из цикла.
        goto OnOK;
      end; { if }

      // Увеличиваем смещения порвого
      ofs1 := ofs1 + E2D_SCREEN_BYTESPP;
      // и второго обьектов.
      ofs2 := ofs2 + E2D_SCREEN_BYTESPP;
    end; { for }

    // Вычисляем новые смещения для первого
    ofs1 := ofs1 + (ImageRect1^.Right - ir1.Right +
                    Images[Image1ID].Info.Width - ImageRect1^.Right) * E2D_SCREEN_BYTESPP;
    // и второго обьектов.
    ofs2 := ofs2 + (ImageRect2^.Right - ir2.Right +
                    Images[Image2ID].Info.Width - ImageRect2^.Right) * E2D_SCREEN_BYTESPP;
    {$WARNINGS ON}
  end; { for }

OnOK :
  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_GetCollision }

end.
