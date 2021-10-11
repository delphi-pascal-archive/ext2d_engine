program FntBuilder;

uses
  Forms,
  Main in 'Main.pas' {BuilderForm},
  About in 'About.pas' {AboutForm},
  Manual in 'Manual.pas' {ManualForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ׁמחהאעוכü רנטפעמג הכÿ Ext2D Engine';
  Application.CreateForm(TBuilderForm, BuilderForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TManualForm, ManualForm);
  Application.Run;
end.
