unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForms, StdCtrls, ActnList;

type
  TMainForm = class(TBaseForm)
    ActionList1: TActionList;
    acCreateEventsForm: TAction;
    acShowEventsForm: TAction;
    acCloseEventsForm: TAction;
    acCloseQueryEventsForm: TAction;
    acHideEventsForm: TAction;
    acEventsFormVisible: TAction;
    acDestroyEventsForm: TAction;
    acShowModalEventsForm: TAction;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    memBkLog: TMemo;
    Button1: TButton;
    Button6: TButton;
    btnClearEventsFormLog: TButton;
    Button7: TButton;
    chkLogActivateEvents: TCheckBox;
    procedure acXXXUpdate(Sender: TObject);
    procedure acCreateEventsFormExecute(Sender: TObject);
    procedure acShowEventsFormExecute(Sender: TObject);
    procedure acHideEventsFormExecute(Sender: TObject);
    procedure acDestroyEventsFormExecute(Sender: TObject);
    procedure acEventsFormVisibleExecute(Sender: TObject);
    procedure acCloseEventsFormExecute(Sender: TObject);
    procedure acCloseQueryEventsFormExecute(Sender: TObject);
    procedure btnClearEventsFormLogClick(Sender: TObject);
    procedure acShowModalEventsFormExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;


  procedure LogEF(const Msg: string);
  procedure LogEFA(const Msg: string);

  function CloseActionToString(const CloseAction: TCloseAction): string;
  function MouseActivateToString(const MouseActivate: TMouseActivate): string;
  function ModalResultToString(const ModalResult: TModalResult): string;

implementation

{$R *.dfm}

uses
  frmEvents;


  procedure LogEF(const Msg: string);
  begin
    if Assigned(MainForm) then
      MainForm.memBkLog.Lines.Add(Msg);
  end;

  procedure LogEFA(const Msg: string);
  begin
    if Assigned(MainForm) and MainForm.chkLogActivateEvents.Checked then
      LogEF(Msg);
  end;

  function CloseActionToString(const CloseAction: TCloseAction): string;
  const
    SCloseAction: array [TCloseAction] of string = ('caNone', 'caHide', 'caFree', 'caMinimize');
  begin
    Result := SCloseAction[CloseAction];
  end;

  function MouseActivateToString(const MouseActivate: TMouseActivate): string;
  const
    SMouseActivate: array [TMouseActivate] of string = ('maDefault', 'maActivate', 'maActivateAndEat', 'maNoActivate', 'maNoActivateAndEat');
  begin
    Result := SMouseActivate[MouseActivate];
  end;

  function ModalResultToString(const ModalResult: TModalResult): string;
  begin
    case ModalResult of
      mrNone:
        Result := 'mrNone';
      mrOk:
        Result := 'mrOk';
      mrCancel:
        Result := 'mrCancel';
      mrAbort:
        Result := 'mrAbort';
      mrRetry:
        Result := 'mrRetry';
      mrIgnore:
        Result := 'mrIgnore';
      mrYes:
        Result := 'mrYes';
      mrNo:
        Result := 'mrNo';
      mrAll:
        Result := 'mrAll';
      mrNoToAll:
        Result := 'mrNoToAll';
      mrYesToAll:
        Result := 'mrYesToAll';
      mrClose:
        Result := 'mrClose';
    else
      Result := IntToStr(ModalResult);
    end;
  end;

{ TMainForm }

procedure TMainForm.acXXXUpdate(Sender: TObject);
var
  Flag: Boolean;
begin
  if Sender = acCreateEventsForm
    then Flag := not Assigned(EventsForm)
    else Flag := Assigned(EventsForm);

  if Sender = acShowModalEventsForm then
    Flag := Flag and not EventsForm.Visible;

  (Sender as TAction).Enabled := Flag;

  if (Sender = acEventsFormVisible) then
    (Sender as TAction).Checked := Flag and EventsForm.Visible;
end;

procedure TMainForm.acEventsFormVisibleExecute(Sender: TObject);
begin
  LogEF('-- toggle visible click --');
  EventsForm.Visible := not EventsForm.Visible;
end;

procedure TMainForm.acCloseEventsFormExecute(Sender: TObject);
begin
  LogEF('-- close click --');
  EventsForm.Close;
end;

procedure TMainForm.acCloseQueryEventsFormExecute(Sender: TObject);
var
  CloseQueryResult: Boolean;
begin
  LogEF('-- close query click --');
  CloseQueryResult := EventsForm.CloseQuery;
  LogEF('-- close query result = ' + BoolToStr(CloseQueryResult, True) + ' --');
end;

procedure TMainForm.acCreateEventsFormExecute(Sender: TObject);
begin
  LogEF('-- create click --');
  Application.CreateForm(TEventsForm, EventsForm);
  //EventsForm := TEventsForm.Create(Self);
  //EventsForm := TEventsForm.Create(Application);
end;

procedure TMainForm.acDestroyEventsFormExecute(Sender: TObject);
begin
  LogEF('-- destroy click --');
  FreeAndNil(EventsForm);
end;

procedure TMainForm.acHideEventsFormExecute(Sender: TObject);
begin
  LogEF('-- hide click --');
  EventsForm.Hide;
end;

procedure TMainForm.acShowEventsFormExecute(Sender: TObject);
begin
  LogEF('-- show click --');
  EventsForm.Show;
end;

procedure TMainForm.acShowModalEventsFormExecute(Sender: TObject);
var
  ModalResult: TModalResult;
begin
  LogEF('-- show modal click --');
  ModalResult := EventsForm.ShowModal;
  LogEF('-- show modal result = ' + ModalResultToString(ModalResult) + ' --');
end;

procedure TMainForm.btnClearEventsFormLogClick(Sender: TObject);
begin
  memBkLog.Clear;
end;


end.
