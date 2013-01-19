unit BaseFormsDesign;

interface

procedure Register;

implementation

{$R 'BaseFormsDesign.dcr'}

uses
  BaseForms,
  Classes, SysUtils, Windows, Graphics,
  DesignIntf, DesignEditors, ToolsApi, WCtlForm, TypInfo;

type
  TdnCustomFormWizard = class(TNotifierObject, IOTARepositoryWizard, IOTARepositoryWizard60,
                            IOTARepositoryWizard80, IOTAWizard, IOTAFormWizard, IOTAProjectWizard)
  protected
    function ThisFormClass: TComponentClass; virtual; abstract;
    function ThisFormName: string;
    function ThisFormIconName: string;
  public
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    function GetGlyph: Cardinal;
    // IOTARepositoryWizard60
    function GetDesigner: string;
    // IOTARepositoryWizard80
    function GetGalleryCategory: IOTAGalleryCategory;
    function GetPersonality: string;
    // IOTAWizard
    function GetIDString: string;
    function GetName: string; virtual;
    function GetState: TWizardState;
    procedure Execute;
    // IOTAFormWizard
    // IOTAProjectWizard
  end;

  TdnFormWizard = class(TdnCustomFormWizard)
  protected
    function ThisFormClass: TComponentClass; override;
  public
    function GetName: string; override;
  end;

  TdnFormCustomModule = class(TCustomModule)
    class function DesignClass: TComponentClass; override;
  end;

  TdnFrameWizard = class(TdnCustomFormWizard)
  protected
    function ThisFormClass: TComponentClass; override;
  public
    function GetName: string; override;
  end;

  TdnFrameCustomModule = class(TWinControlCustomModule)
  public
    function Nestable: Boolean; override;
  end;

procedure Register;
begin
  RegisterCustomModule(TBaseForm, TdnFormCustomModule);
  RegisterPackageWizard(TdnFormWizard.Create);

  RegisterCustomModule(TBaseFrame, TdnFrameCustomModule);
  RegisterPackageWizard(TdnFrameWizard.Create);
end;

{ TdnNewFormCreator }

type
  TdnNewFormCreator = class(TInterfacedObject, IOTACreator, IOTAModuleCreator)
  private
    FAncestorName: string;
  public
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAModuleCreator
    function GetAncestorName: string;
    function GetImplFileName: string;
    function GetIntfFileName: string;
    function GetFormName: string;
    function GetMainForm: Boolean;
    function GetShowForm: Boolean;
    function GetShowSource: Boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    procedure FormCreated(const FormEditor: IOTAFormEditor);
  public
    constructor Create(const FormName, AncestorName: string);
  end;

constructor TdnNewFormCreator.Create(const FormName, AncestorName: string);
begin
  inherited Create;
  FAncestorName := AncestorName;
end;

procedure TdnNewFormCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
end;

function TdnNewFormCreator.GetAncestorName: string;
begin
  Result := FAncestorName;
end;

function TdnNewFormCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

function TdnNewFormCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TdnNewFormCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TdnNewFormCreator.GetFormName: string;
begin
  Result := '';
end;

function TdnNewFormCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TdnNewFormCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TdnNewFormCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

function TdnNewFormCreator.GetOwner: IOTAModule;
begin
  Result := nil;//GetActiveProject;
end;

function TdnNewFormCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TdnNewFormCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TdnNewFormCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

function TdnNewFormCreator.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TdnNewFormCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TdnNewFormCreator.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

{ TdnCustomFormWizard }

function TdnCustomFormWizard.ThisFormName: string;
begin
  Result := ThisFormClass.ClassName;
  Delete(Result, 1, 1); // drop the 'T'
end;

function TdnCustomFormWizard.ThisFormIconName: string;
begin
  Result := UpperCase(ThisFormClass.ClassName);
end;

function TdnCustomFormWizard.GetAuthor: string;
begin
  Result := 'DelphiNotes.ru';
end;

function TdnCustomFormWizard.GetComment: string;
begin
  Result := '';
end;

function TdnCustomFormWizard.GetPage: string;
begin
  Result := 'New';
end;

function TdnCustomFormWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, PChar(ThisFormIconName));
end;

function TdnCustomFormWizard.GetDesigner: string;
begin
  Result := dVCL;
end;

function TdnCustomFormWizard.GetGalleryCategory: IOTAGalleryCategory;
var
  Category: IOTAGalleryCategory;
  CatManager: IOTAGalleryCategoryManager;
begin
  CatManager := (BorlandIDEServices as IOTAGalleryCategoryManager);
  Assert(Assigned(CatManager));
  Category := CatManager.FindCategory(sCategoryDelphiNewFiles);
  Assert(Assigned(Category));
  Result := Category;
end;

function TdnCustomFormWizard.GetPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TdnCustomFormWizard.GetIDString: string;
begin
  Result := 'DN.Create_' + ThisFormName + '.Wizard';
end;

function TdnCustomFormWizard.GetName: string;
begin
  Result := ThisFormName;
end;

function TdnCustomFormWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure AddUnitToUses(Module: IOTAModule; UnitName: string);
const
  UnitFileSize = 8192; // 8k ought to be enough for everybody! (we're dealing with a new default unit)
var
  Editor: IOTASourceEditor;
  Reader: IOTAEditReader;
  Writer: IOTAEditWriter;
  Buffer, P: PAnsiChar;
  StartPos: Integer;
begin
  Buffer := AnsiStrAlloc(UnitFileSize);
  Editor := (Module.GetModuleFileEditor(0)) as IOTASourceEditor;
  try
    Reader := Editor.CreateReader;
    try
      StartPos := Reader.GetText(0, Buffer, UnitFileSize);
      P := StrPos(Buffer, 'uses'); // Locate uses
      P := StrPos(P, ';'); // Locate the semi-colon afterwards
      if Assigned(P) then
        StartPos := Integer(P - Buffer)
      else
        StartPos := -1;
    finally
      Reader := nil; { get rid of reader before we use writer }
    end;
    if StartPos <> -1 then
    begin
      Writer := Editor.CreateWriter;
      try
        Writer.CopyTo(StartPos);
        Writer.Insert(PAnsiChar(AnsiString(', ' + UnitName)));
      finally
        Writer := nil;
      end;
    end;
  finally
    Editor := nil;
    StrDispose(Buffer);
  end;
end;

procedure TdnCustomFormWizard.Execute;
var
  Module: IOTAModule;
begin
  Module := (BorlandIDEServices as IOTAModuleServices).CreateModule(TdnNewFormCreator.Create('', ThisFormName));
  AddUnitToUses(Module, string(GetTypeData(PTypeInfo(ThisFormClass.ClassInfo)).UnitName));
end;

{ TdnFormWizard }

function TdnFormWizard.ThisFormClass: TComponentClass;
begin
  Result := TBaseForm;
end;

function TdnFormWizard.GetName: string;
begin
  Result := 'DN Base Form';
end;

{ TdnFormCustomModule }

class function TdnFormCustomModule.DesignClass: TComponentClass;
begin
  Result := TBaseForm;
end;

{ TdnFrameCustomModule }

function TdnFrameCustomModule.Nestable: Boolean;
begin
  Result := True;
end;

{ TdnFrameWizard }

function TdnFrameWizard.ThisFormClass: TComponentClass;
begin
  Result := TBaseFrame;
end;

function TdnFrameWizard.GetName: string;
begin
  Result := 'DN Base Frame';
end;

end.
