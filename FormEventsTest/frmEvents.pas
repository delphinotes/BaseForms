unit frmEvents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForms, StdCtrls, ExtCtrls;

type
  TEventsForm = class(TBaseForm)
    GroupBox1: TGroupBox;
    chkCloseByEscape: TCheckBox;
    chkFreeOnClose: TCheckBox;
    GroupBox2: TGroupBox;
    chkCanClose: TCheckBox;
    rgCloseAction: TRadioGroup;
    btnOk: TButton;
    btnHide: TButton;
    btnClose: TButton;
    rgMouseActivate: TRadioGroup;
    GroupBox3: TGroupBox;
    chkErrorOnCloseQuery: TCheckBox;
    chkErrorOnClose: TCheckBox;
    chkErrorOnHide: TCheckBox;
    chkErrorOnDestroy: TCheckBox;
    chkErrorOnShow: TCheckBox;
    procedure BaseFormActivate(Sender: TObject);
    procedure BaseFormClose(Sender: TObject; var Action: TCloseAction);
    procedure BaseFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BaseFormCreate(Sender: TObject);
    procedure BaseFormDeactivate(Sender: TObject);
    procedure BaseFormDestroy(Sender: TObject);
    procedure BaseFormHide(Sender: TObject);
    procedure BaseFormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure BaseFormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure chkCloseByEscapeClick(Sender: TObject);
    procedure chkFreeOnCloseClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckBoxNotCheckedCheck(CheckBox: TCheckBox);
  public
    { Public declarations }
  end;

var
  EventsForm: TEventsForm;

implementation

{$R *.dfm}

uses
  frmMain;

procedure TEventsForm.BaseFormActivate(Sender: TObject);
begin
  LogEFA('.OnActivate');
end;

procedure TEventsForm.BaseFormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckBoxNotCheckedCheck(chkErrorOnClose);
  if (rgCloseAction.ItemIndex >= Ord(Low(TCloseAction))) and (rgCloseAction.ItemIndex <= Ord(High(TCloseAction))) then
    Action := TCloseAction(rgCloseAction.ItemIndex);
  LogEF('.OnClose: Action = ' + CloseActionToString(Action));
end;

procedure TEventsForm.BaseFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CheckBoxNotCheckedCheck(chkErrorOnCloseQuery);
  CanClose := chkCanClose.Checked;
  LogEF('.OnCloseQuery: CanClose = ' + BoolToStr(CanClose, True));
end;

procedure TEventsForm.BaseFormCreate(Sender: TObject);
begin
  LogEF('.OnCreate');
  chkFreeOnClose.Checked := FreeOnClose;
  chkCloseByEscape.Checked := CloseByEscape;
end;

procedure TEventsForm.BaseFormDeactivate(Sender: TObject);
begin
  LogEFA('.OnDeactivate');
end;

procedure TEventsForm.BaseFormDestroy(Sender: TObject);
begin
  CheckBoxNotCheckedCheck(chkErrorOnDestroy);
  LogEF('.OnDestroy');
  if Self = EventsForm then
    EventsForm := nil;
end;

procedure TEventsForm.BaseFormHide(Sender: TObject);
begin
  CheckBoxNotCheckedCheck(chkErrorOnHide);
  LogEF('.OnHide');
end;

procedure TEventsForm.BaseFormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y,
  HitTest: Integer; var MouseActivate: TMouseActivate);
begin
  if (rgMouseActivate.ItemIndex >= Ord(Low(TMouseActivate))) and (rgMouseActivate.ItemIndex <= Ord(High(TMouseActivate))) then
    MouseActivate := TMouseActivate(rgMouseActivate.ItemIndex);
  LogEFA('.OnMouseActivate: MouseActivate = ' + MouseActivateToString(MouseActivate));
end;

procedure TEventsForm.BaseFormShow(Sender: TObject);
begin
  CheckBoxNotCheckedCheck(chkErrorOnShow);
  LogEF('.OnShow');
  btnHide.Enabled := not (fsModal in FormState);
end;

procedure TEventsForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TEventsForm.btnHideClick(Sender: TObject);
begin
  Hide;
end;

procedure TEventsForm.CheckBoxNotCheckedCheck(CheckBox: TCheckBox);
begin
  if CheckBox.Checked then
    raise Exception.Create('Some error ' + CheckBox.Caption);
end;

procedure TEventsForm.chkCloseByEscapeClick(Sender: TObject);
begin
  CloseByEscape := chkCloseByEscape.Checked;
end;

procedure TEventsForm.chkFreeOnCloseClick(Sender: TObject);
begin
  FreeOnClose := chkFreeOnClose.Checked;
end;

end.
