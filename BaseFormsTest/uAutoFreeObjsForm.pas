unit uAutoFreeObjsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForms;

type
  TLogObject = class(TObject)
    constructor Create;
    destructor Destroy; override;
  end;

  TTestAutoFree = class(TBaseForm)
    procedure BaseFormCreate(Sender: TObject);
    procedure BaseFormShow(Sender: TObject);
    procedure BaseFormClose(Sender: TObject; var Action: TCloseAction);
    procedure BaseFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BaseFormHide(Sender: TObject);
    procedure BaseFormDestroy(Sender: TObject);
  private
    { Private declarations }
    FA, FB, FC: TLogObject;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  uMainForm;

{ TLogObject }

constructor TLogObject.Create;
begin
  LogAF(Format('  %d created', [Integer(Self)]));
end;

destructor TLogObject.Destroy;
begin
  LogAF(Format('  %d destroyed', [Integer(Self)]));
  inherited;
end;

{ TTestAutoFree }

procedure TTestAutoFree.BaseFormClose(Sender: TObject; var Action: TCloseAction);
begin
  LogAF('Form.OnClose');
end;

procedure TTestAutoFree.BaseFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  LogAF('Form.OnCloseQuery');
end;

procedure TTestAutoFree.BaseFormCreate(Sender: TObject);
begin
  LogAF('Form.OnCreate');
  FA := AutoFree(TLogObject.Create);
  FB := AutoFree(TLogObject.Create);
end;

procedure TTestAutoFree.BaseFormDestroy(Sender: TObject);
begin
  LogAF('Form.OnDestroy');
end;

procedure TTestAutoFree.BaseFormHide(Sender: TObject);
begin
  LogAF('Form.OnHide');
end;

procedure TTestAutoFree.BaseFormShow(Sender: TObject);
begin
  LogAF('Form.OnShow');
  FC := AutoFree(TLogObject.Create);
end;


end.
