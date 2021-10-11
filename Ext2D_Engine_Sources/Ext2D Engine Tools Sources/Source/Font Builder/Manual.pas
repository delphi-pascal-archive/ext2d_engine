unit Manual;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, StdCtrls,
  Buttons, Mask, RzEdit, Dialogs, ExtDlgs, ClipBrd, zlib;

type
  TManualForm = class(TForm)
    DataPanel: TScrollBox;
    ImagePanel: TScrollBox;
    ToolsPanel: TPanel;
    AddImagePanel: TGroupBox;
    btnFromClipbrd: TBitBtn;
    btnFromFile: TBitBtn;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    bev1: TBevel;
    bev2: TBevel;
    labSymbols: TLabel;
    PrevImage: TImage;
    CharShape: TShape;
    OpenBitmap: TOpenPictureDialog;
    FontPanel: TGroupBox;
    labFontSize: TLabel;
    EditSize: TRzNumericEdit;
    btnOpenFont: TBitBtn;
    OpenFont: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure EditSizeChange(Sender: TObject);
    procedure btnFromFileClick(Sender: TObject);
    procedure btnFromClipbrdClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnOpenFontClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnEditEnter(Sender : TObject);
    procedure OnEditXChange(Sender : TObject);
    procedure OnEditYChange(Sender : TObject);
    procedure OnEditWChange(Sender : TObject);
  end;

var
  ManualForm: TManualForm;

implementation

uses
  Main;

{$R *.dfm}

var
  bmp : TBitmap;
  lastID : Byte = 0;

procedure TManualForm.FormCreate(Sender: TObject);
var
  i : Byte;
  ne : TRzNumericEdit;
  l : TLabel;
begin
  for i := 0 to 255 do begin
    l := TLabel.Create(Self);
    l.Parent := DataPanel;
    l.Name := 'lab' + IntToStr(i);
    l.Caption := IntToStr(i) + ' :';
    l.Top := i * 15;
    l.Hint := 'Символ : ' + Chr(i);
    l.Width := 34;
    l.Left := 5;
    l.Height := 15;

    ne := TRzNumericEdit.Create(Self);
    ne.Parent := DataPanel;
    ne.OnEnter := OnEditEnter;
    ne.Name := 'neX' + IntToStr(i);
    ne.CheckRange := True;
    ne.AutoSize := False;
    ne.Min := 0;
    ne.Max := 65535;
    ne.FrameVisible := True;
    ne.Top := i * 15;
    ne.Left := 40;
    ne.Width := 40;
    ne.Height := 16;
    ne.Tag := i;

    ne := TRzNumericEdit.Create(Self);
    ne.Parent := DataPanel;
    ne.OnEnter := OnEditEnter;
    ne.Name := 'neY' + IntToStr(i);
    ne.CheckRange := True;
    ne.AutoSize := False;
    ne.Min := 0;
    ne.Max := 65535;
    ne.FrameVisible := True;
    ne.Top := i * 15;
    ne.Left := 79;
    ne.Width := 40;
    ne.Height := 16;
    ne.Tag := i;

    ne := TRzNumericEdit.Create(Self);
    ne.Parent := DataPanel;
    ne.OnEnter := OnEditEnter;
    ne.Name := 'neW' + IntToStr(i);
    ne.CheckRange := True;
    ne.AutoSize := False;
    ne.Min := 0;
    ne.Max := 65535;
    ne.FrameVisible := True;
    ne.Top := i * 15;
    ne.Left := 118;
    ne.Width := 40;
    ne.Height := 16;
    ne.Tag := i;
    
    Application.ProcessMessages;
  end;
  bmp := TBitmap.Create;
end;

procedure TManualForm.FormDestroy(Sender: TObject);
var
  i : Byte;
  ne : TRzNumericEdit;
  l : TLabel;
begin
  for i := 255 downto 0 do begin
    l := TLabel(FindComponent('lab' + IntToStr(i)));
    l.Free;
    ne := TRzNumericEdit(FindComponent('neX' + IntToStr(i)));
    ne.Free;
    ne := TRzNumericEdit(FindComponent('neY' + IntToStr(i)));
    ne.Free;
    ne := TRzNumericEdit(FindComponent('neW' + IntToStr(i)));
    ne.Free;
    Application.ProcessMessages;
  end;
  bmp.Free;
end;

procedure TManualForm.FormShow(Sender: TObject);
var
  i : Byte;
  ne : TRzNumericEdit;
begin
  DataPanel.VertScrollBar.Position := 0;
  EditSize.Value := FontSize;
  DataPanel.Enabled := (FontSize > 0);
  CharShape.Width := 0;
  CharShape.Height := 0;
  if FontSize > 0 then begin
    for i := 0 to 255 do begin
      ne := TRzNumericEdit(FindComponent('neX' + IntToStr(i)));
      ne.Value := CharsInfo[i].X;
      ne := TRzNumericEdit(FindComponent('neY' + IntToStr(i)));
      ne.Value := CharsInfo[i].Y;
      ne := TRzNumericEdit(FindComponent('neW' + IntToStr(i)));
      ne.Value := CharsInfo[i].Width;
      Application.ProcessMessages;
    end;
    Previmage.Picture.Bitmap := FontBitmap;
    bmp.Width := FontBitmap.Width;
    bmp.Height := FontBitmap.Height;
    bmp.PixelFormat := pf24bit;
    bmp.Canvas.CopyRect(Rect(0, 0, bmp.Width, bmp.Height), FontBitmap.Canvas,
                        Rect(0, 0, bmp.Width, bmp.Height));
    SetFocusedControl(TRzNumericEdit(FindComponent('neX0')));
    lastID := 0;
  end else begin
    Previmage.Picture.Bitmap := nil;
    for i := 0 to 255 do begin
      ne := TRzNumericEdit(FindComponent('neX' + IntToStr(i)));
      ne.Value := 0;
      ne := TRzNumericEdit(FindComponent('neY' + IntToStr(i)));
      ne.Value := 0;
      ne := TRzNumericEdit(FindComponent('neW' + IntToStr(i)));
      ne.Value := 0;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TManualForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TManualForm.OnEditEnter(Sender : TObject);
var
  id : byte;
begin
  TLabel(FindComponent('lab' + IntToStr(lastID))).Color := clBtnFace;
  TRzNumericEdit(FindComponent('neX' + IntToStr(lastID))).Color := clWindow;
  TRzNumericEdit(FindComponent('neY' + IntToStr(lastID))).Color := clWindow;
  TRzNumericEdit(FindComponent('neW' + IntToStr(lastID))).Color := clWindow;
  id := TRzNumericEdit(Sender).Tag;
  TLabel(FindComponent('lab' + IntToStr(id))).Color := clGreen;
  TRzNumericEdit(FindComponent('neX' + IntToStr(id))).Color := clGreen;
  TRzNumericEdit(FindComponent('neY' + IntToStr(id))).Color := clGreen;
  TRzNumericEdit(FindComponent('neW' + IntToStr(id))).Color := clGreen;
  CharShape.Left := Trunc(TRzNumericEdit(FindComponent('neX' + IntToStr(id))).Value) -
                    ImagePanel.HorzScrollBar.Position;
  CharShape.Top := Trunc(TRzNumericEdit(FindComponent('neY' + IntToStr(id))).Value) -
                   ImagePanel.VertScrollBar.Position;
  CharShape.Width := Trunc(TRzNumericEdit(FindComponent('neW' + IntToStr(id))).Value);
  CharShape.Height := Trunc(EditSize.Value);
  lastID := id;
end;

procedure TManualForm.OnEditWChange(Sender : TObject);
begin
  CharShape.Left := Trunc(TRzNumericEdit(Sender).Value);
end;

procedure TManualForm.OnEditXChange(Sender : TObject);
begin
  CharShape.Top := Trunc(TRzNumericEdit(Sender).Value);
end;

procedure TManualForm.OnEditYChange(Sender : TObject);
begin
  CharShape.Width := Trunc(TRzNumericEdit(Sender).Value);
end;

procedure TManualForm.EditSizeChange(Sender: TObject);
begin
  CharShape.Height := Trunc(EditSize.Value);
end;

procedure TManualForm.btnFromFileClick(Sender: TObject);
begin
  if OpenBitmap.Execute then begin
    try
      bmp.LoadFromFile(OpenBitmap.FileName);
    except
      Application.MessageBox(PChar('Невозможно открыть файл!'), PChar('Ошибка'), MB_ICONSTOP);
      Exit;
    end;
    PrevImage.Picture.Bitmap := bmp;
    DataPanel.Enabled := True;
    SetFocusedControl(TRzNumericEdit(FindComponent('neX0')));
  end;
end;

procedure TManualForm.btnFromClipbrdClick(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_BITMAP) then begin
    bmp.PixelFormat := pf24bit;
    bmp.LoadFromClipboardFormat(CF_BITMAP, Clipboard.GetAsHandle(CF_BITMAP), 0);
    PrevImage.Picture.Bitmap := bmp;
    DataPanel.Enabled := True;
    SetFocusedControl(TRzNumericEdit(FindComponent('neX0')));
  end else
    Application.MessageBox(PChar('В буфере обмена отсутствует изображение!'),
                                 PChar('Ошибка'), MB_ICONSTOP);
end;

procedure TManualForm.btnOKClick(Sender: TObject);
var
  i : Byte;
begin
  if (EditSize.Value > 0) and (DataPanel.Enabled) then begin
    FontSize := Trunc(EditSize.Value);
    FontBitmap.Width := bmp.Width;
    FontBitmap.Height := bmp.Height;
    FontBitmap.Canvas.CopyRect(Rect(0, 0, bmp.Width, bmp.Height), bmp.Canvas,
                               Rect(0, 0, bmp.Width, bmp.Height));
    for i := 0 to 255 do begin
      CharsInfo[i].X := Trunc(TRzNumericEdit(FindComponent('neX' + IntToStr(i))).Value);
      CharsInfo[i].Y := Trunc(TRzNumericEdit(FindComponent('neY' + IntToStr(i))).Value);
      CharsInfo[i].Width := Trunc(TRzNumericEdit(FindComponent('neW' + IntToStr(i))).Value);
      Application.ProcessMessages;
    end;
    BuilderForm.FontImage.Picture.Bitmap := FontBitmap;
    BuilderForm.Status.Panels[0].Text := 'Шрифт создан.';
    BuilderForm.miSaveAs.Enabled := True;
    Close;
  end else
    Application.MessageBox(PChar('Отсутствует некоторые данные либо изображение!'),
                                 PChar('Ошибка'), MB_ICONSTOP);
end;

procedure TManualForm.btnOpenFontClick(Sender: TObject);
type
  TEFFHeader = packed record
    Signature : Longword;
    Width     : Longword;
    Height    : Longword;
    DataSize  : Longword;
    Size      : Longword;
    CharsInf  : array [0..255] of TCharRect;
    Data      : Longword;
  end;

var
  fs : TFileStream;
  hd : TEFFHeader;
  i, j : Longword;
  p : Pointer;
  col : Word;
  dpe : Boolean;
  zds : TDecompressionStream;
begin
  if OpenFont.Execute then begin
    try
      fs := TFileStream.Create(OpenFont.FileName, fmOpenRead);
    except
      Application.MessageBox(PChar('Невозможно открыть файл!'), PChar('Ошибка'), MB_ICONSTOP);
      Exit;
    end;
    dpe := DataPanel.Enabled;
    ToolsPanel.Enabled := False;
    DataPanel.Enabled := False;
    try
      fs.Read(hd, SizeOf(hd));
    except
      Application.MessageBox(PChar('Невозможно прочесть файл!'), PChar('Ошибка'), MB_ICONSTOP);
      ToolsPanel.Enabled := True;
      DataPanel.Enabled := dpe;
      fs.Free;
      Exit;
    end;
    if (hd.Signature <> $5F464645) or (hd.Data <> $61746164) then begin
      Application.MessageBox(PChar('Неправильный файл!'), PChar('Ошибка'), MB_ICONSTOP);
      ToolsPanel.Enabled := True;
      DataPanel.Enabled := dpe;
      fs.Free;
      Exit;
    end;
    GetMem(p, hd.DataSize);
    zds := TDecompressionStream.Create(fs);
    try
      zds.Read(p^, hd.DataSize);
    except
      Application.MessageBox(PChar('Невозможно прочесть файл!'), PChar('Ошибка'), MB_ICONSTOP);
      ToolsPanel.Enabled := True;
      DataPanel.Enabled := dpe;
      FreeMem(p, hd.DataSize);
      zds.Free;
      fs.Free;
      Exit;
    end;
    bmp.Width := hd.Width;
    bmp.Height := hd.Height;
    bmp.PixelFormat := pf24bit;
    for j := 0 to hd.Height - 1 do begin
      for i := 0 to hd.Width - 1 do begin
        col := PWord(Longword(p) + (j * hd.Width + i) * 2)^;
        bmp.Canvas.Pixels[i, j] := RGB(Round(((col shr 11) and $1F) / $1F * 255),
                                       Round(((col shr 5) and $3F) / $3F * 255),
                                       Round((col and $1F) / $1F * 255));
      end;
      Application.ProcessMessages;
    end;
    FreeMem(p, hd.DataSize);
    zds.Free;
    fs.Free;
    for i := 0 to 255 do begin
      TRzNumericEdit(FindComponent('neX' + IntToStr(i))).Value := hd.CharsInf[i].X;
      TRzNumericEdit(FindComponent('neY' + IntToStr(i))).Value := hd.CharsInf[i].Y;
      TRzNumericEdit(FindComponent('neW' + IntToStr(i))).Value := hd.CharsInf[i].Width;
    end;
    PrevImage.Picture.Bitmap := bmp;
    SetFocusedControl(TRzNumericEdit(FindComponent('neX0')));
    EditSize.Value := hd.Size;
    ToolsPanel.Enabled := True;
    DataPanel.Enabled := True;
  end;
end;

end.
