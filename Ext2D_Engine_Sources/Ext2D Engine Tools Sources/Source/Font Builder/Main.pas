unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Menus, ToolWin, ComCtrls, StdCtrls, ExtCtrls;

type
  TBuilderForm = class(TForm)
    MainMenu: TMainMenu;
    MenuImages: TImageList;
    miFile: TMenuItem;
    miCreateFont: TMenuItem;
    miSaveAs: TMenuItem;
    sep1: TMenuItem;
    miExit: TMenuItem;
    Tools: TToolBar;
    tbCreateFont: TToolButton;
    tbSaveAs: TToolButton;
    tbSep1: TToolButton;
    FontPanel: TScrollBox;
    FontImage: TImage;
    miFont: TMenuItem;
    miBorders: TMenuItem;
    miAbout: TMenuItem;
    labFontPreview: TLabel;
    FontDialog: TFontDialog;
    Status: TStatusBar;
    tbSep2: TToolButton;
    SaveDialog: TSaveDialog;
    miManual: TMenuItem;
    sep2: TMenuItem;
    tbManual: TToolButton;
    tbSep3: TToolButton;
    procedure miAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miCreateFontClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure miManualClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetMenuState(st : Boolean);
  end;

type
  TCharRect = packed record
    X, Y : Word;
    Width : Word;
  end;

var
  BuilderForm: TBuilderForm;
  CharsInfo : array [0..255] of TCharRect;
  FontSize : Longword = 0;
  FontBitmap : TBitmap;

implementation

uses
  Manual, About, Zlib;

{$R *.dfm}

procedure CreateFont(Font : TFont);
var
  i, j : Integer;
  CharRect : TRect;
  CurrentWidth, MaxWidth : Integer;
  CurrentHeight : Integer;
  CharHeight, CharWidth : Integer;
begin
  BuilderForm.Status.Panels[0].Text := 'Создание шрифта...';
  Application.ProcessMessages;
  FontBitmap.Width              := 0;
  FontBitmap.Height             := 0;
  FontBitmap.PixelFormat        := pf24bit;
  FontBitmap.Canvas.Font        := Font;
  FontBitmap.Canvas.Brush.Style := bsSolid;
  FontBitmap.Canvas.Brush.Color := clBlack;
  MaxWidth := 0;
  CurrentHeight := 0;
  CharHeight := FontBitmap.Canvas.TextHeight('A');
  FontSize := CharHeight;
  for i := 0 to 255 do begin
    if (i mod 20) = 0 then begin
      CurrentHeight := FontBitmap.Height;
      FontBitmap.Height := CurrentHeight + CharHeight;
      CurrentWidth := 0;
    end;
    CharWidth  := FontBitmap.Canvas.TextWidth(Chr(i));
    if CurrentWidth + CharWidth > MaxWidth then begin
      FontBitmap.Width := CurrentWidth + CharWidth;
      MaxWidth := CurrentWidth + CharWidth;
    end;
    SetRect(CharRect, CurrentWidth, CurrentHeight, CurrentWidth + CharWidth,
            CurrentHeight + CharHeight);
    CharsInfo[i].X      := CurrentWidth;
    CharsInfo[i].Y      := CurrentHeight;
    CharsInfo[i].Width  := CharWidth;
    FontBitmap.Canvas.TextRect(CharRect, CurrentWidth, CurrentHeight, Chr(i));
    CurrentWidth := CurrentWidth + CharWidth;
  end;
  if BuilderForm.miBorders.Checked then begin
    FontBitmap.Monochrome  := True;
    FontBitmap.PixelFormat := pf24bit;
    for j := 0 to FontBitmap.Height - 1 do
      for i := 0 to FontBitmap.Width - 1 do
        if FontBitmap.Canvas.Pixels[i, j] = clWhite then
          FontBitmap.Canvas.Pixels[i, j] := clBlack
        else
          FontBitmap.Canvas.Pixels[i, j] := Font.Color;
  end;
  BuilderForm.Status.Panels[0].Text := 'Шрифт создан.';
end;

procedure TBuilderForm.miAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TBuilderForm.FormCreate(Sender: TObject);
begin
  FontBitmap := TBitmap.Create;
end;

procedure TBuilderForm.FormDestroy(Sender: TObject);
begin
  FontBitmap.Free;
end;

procedure TBuilderForm.miCreateFontClick(Sender: TObject);
begin
  if FontDialog.Execute then begin
    SetMenuState(False);
    CreateFont(FontDialog.Font);
    FontImage.Picture.Bitmap := FontBitmap;
    SetMenuState(True);
  end;
end;

procedure TBuilderForm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TBuilderForm.SetMenuState(st: Boolean);
begin
  miCreateFont.Enabled := st;
  miSaveAs.Enabled     := st;
  miBorders.Enabled    := st;
  tbCreateFont.Enabled := st;
  tbSaveAs.Enabled     := st;
end;

procedure TBuilderForm.miSaveAsClick(Sender: TObject);
var
  dst : TFileStream;
  zcs : TCompressionStream;
  wrkC, wrk : Cardinal;
  r, g, b : Byte;
  wrkW : Word;
  i, j : Integer;
begin
  SaveDialog.FileName := FontDialog.Font.Name + ',' + IntToStr(FontSize);
  if SaveDialog.Execute then begin
    SetMenuState(False);
    Status.Panels[0].Text := 'Сохранение ' + SaveDialog.FileName;
    Application.ProcessMessages;
    try
      dst := TFileStream.Create(SaveDialog.FileName, fmCreate);
    except
      Application.MessageBox(PChar('Невозможно создать файл!'), PChar('Ошибка'), MB_ICONSTOP);
      Status.Panels[0].Text := 'Ошибка сохранения.';
      SetMenuState(True);
      Exit;
    end;
    try
      wrkC := $5F464645;
      dst.Write(wrkC, 4);
      wrkC := FontBitmap.Width;
      dst.Write(wrkC, 4);
      wrkC := FontBitmap.Height;
      dst.Write(wrkC, 4);
      wrkC := FontBitmap.Width * FontBitmap.Height * 2;
      dst.Write(wrkC, 4);
      wrkC := FontSize;
      dst.Write(wrkC, 4);
      for i := 0 to 255 do begin
        wrkW := CharsInfo[i].X;
        dst.Write(wrkW, 2);
        wrkW := CharsInfo[i].Y;
        dst.Write(wrkW, 2);
        wrkW := CharsInfo[i].Width;
        dst.Write(wrkW, 2);
      end;
      wrkC := $61746164;
      dst.Write(wrkC, 4);
      zcs := TCompressionStream.Create(clMax, dst);
      for j := 0 to FontBitmap.Height - 1 do
        for i := 0 to  FontBitmap.Width- 1 do begin
          wrk := FontBitmap.Canvas.Pixels[i, j];
          r := GetRValue(wrk);
          g := GetGValue(wrk);
          b := GetBValue(wrk);
          wrkW := (Round(b / 255 * $1F) or (Round(g / 255 * $3F) shl 5) or (Round(r / 255 * $1F) shl 11));
          zcs.WriteBuffer(wrkW, 2);
        end;
    except
      Application.MessageBox(PChar('Невозможно сохранить файл!'), PChar('Ошибка'), MB_ICONSTOP);
      Status.Panels[0].Text := 'Ошибка сохранения.';
      if Assigned(zcs) then
        zcs.Free;
      dst.Free;
      SetMenuState(True);
      Exit;
    end;
    zcs.Free;
    dst.Free;
    Status.Panels[0].Text := 'Файл сохранен.';
    SetMenuState(True);
  end;
end;

procedure TBuilderForm.miManualClick(Sender: TObject);
begin
  ManualForm.Show;
end;

end.
