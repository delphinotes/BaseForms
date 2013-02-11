program FormEvents;

uses
  Forms,
  frmMain in 'frmMain.pas' {MainForm},
  frmEvents in 'frmEvents.pas' {EventsForm: TBaseForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
