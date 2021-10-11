unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TAboutForm = class(TForm)
    ProgramIcon: TImage;
    labName: TLabel;
    labInfo: TLabel;
    bev1: TBevel;
    btnOK: TButton;
    bev2: TBevel;
    labAuthor: TLabel;
    labVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  ProgramIcon.Picture.Icon := Application.Icon;
end;

procedure TAboutForm.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
