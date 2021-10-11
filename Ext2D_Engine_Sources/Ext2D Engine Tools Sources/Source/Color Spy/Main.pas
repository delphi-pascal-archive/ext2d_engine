unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  TSpyForm = class(TForm)
    sbSelectColor: TSpeedButton;
    sbAbout: TSpeedButton;
    ColorView: TShape;
    labColor: TLabel;
    eColor: TEdit;
    labRed: TLabel;
    bev1: TBevel;
    labGreen: TLabel;
    labBlue: TLabel;
    eRed: TEdit;
    eGreen: TEdit;
    eBlue: TEdit;
    ColorDialog: TColorDialog;
    procedure sbAboutClick(Sender: TObject);
    procedure sbSelectColorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SpyForm: TSpyForm;

implementation

{$R *.dfm}

uses
  About;

procedure TSpyForm.sbAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TSpyForm.sbSelectColorClick(Sender: TObject);
var
  col : TColor;
  ec  : Word;
  r, g, b : Byte;
begin
  if ColorDialog.Execute then begin
    col := ColorDialog.Color;
    r := Round(GetRValue(col) / 255 * $1F);
    g := Round(GetGValue(col) / 255 * $3F);
    b := Round(GetBValue(col) / 255 * $1F);
    ec := b or (g shl 5) or (r shl 11);
    eColor.Text := '$' + IntToHex(ec, 4);
    eRed.Text := '$' + IntToHex(r, 2);
    eGreen.Text := '$' + IntToHex(g, 2);
    eBlue.Text := '$' + IntToHex(b, 2);
    ColorView.Brush.Color := col;
  end;
end;

end.
