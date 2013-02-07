unit BaseFormsDesign;

interface

procedure Register;

implementation

{$R 'BaseFormsDesign.dcr'}

uses
  BaseForms,
  Classes, SysUtils, Windows, Graphics,
  DesignIntf, DesignEditors, ToolsApi, WCtlForm, TypInfo;

{ misc }

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

{ TCustomBaseFormWizard }
type
  TCustomBaseFormWizard = class(TNotifierObject, IOTARepositoryWizard, IOTARepositoryWizard60, IOTARepositoryWizard80,
                            IOTAWizard, IOTAProjectWizard, IOTAFormWizard)
  protected
    function ThisFormClass: TComponentClass; virtual; abstract;
    function ThisUnitName: string;
    function ThisAncestorName: string;
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
    // IOTAProjectWizard
    // IOTAFormWizard
  end;

  TBaseFormWizard = class(TCustomBaseFormWizard)
  protected
    function ThisFormClass: TComponentClass; override;
  public
    function GetName: string; override;
  end;

  TBaseFormModule = class(TCustomModule)
    class function DesignClass: TComponentClass; override;
  end;

  TBaseFrameWizard = class(TCustomBaseFormWizard)
  protected
    function ThisFormClass: TComponentClass; override;
  public
    function GetName: string; override;
  end;

  TBaseFrameModule = class(TWinControlCustomModule)
  public
    function Nestable: Boolean; override;
  end;

procedure Register;
begin
  RegisterCustomModule(TBaseForm, TBaseFormModule);
  RegisterPackageWizard(TBaseFormWizard.Create);

  RegisterCustomModule(TBaseFrame, TBaseFrameModule);
  RegisterPackageWizard(TBaseFrameWizard.Create);
end;

{ TBaseFormCreator }

type
  TBaseFormCreator = class(TInterfacedObject, IOTACreator, IOTAModuleCreator)
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
    constructor Create(const AncestorName: string);
  end;

constructor TBaseFormCreator.Create(const AncestorName: string);
begin
  inherited Create;
  FAncestorName := AncestorName;
end;

procedure TBaseFormCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
end;

function TBaseFormCreator.GetAncestorName: string;
begin
  Result := FAncestorName;
end;

function TBaseFormCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

function TBaseFormCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TBaseFormCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TBaseFormCreator.GetFormName: string;
begin
  Result := '';
end;

function TBaseFormCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TBaseFormCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TBaseFormCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

function TBaseFormCreator.GetOwner: IOTAModule;
begin
  Result := GetActiveProject;
end;

function TBaseFormCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TBaseFormCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TBaseFormCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

function TBaseFormCreator.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TBaseFormCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TBaseFormCreator.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

{ TCustomBaseFormWizard }

function TCustomBaseFormWizard.ThisUnitName: string;
begin
  Result := string(GetTypeData(PTypeInfo(ThisFormClass.ClassInfo)).UnitName);
end;

function TCustomBaseFormWizard.ThisAncestorName: string;
begin
  Result := ThisFormClass.ClassName;
  Delete(Result, 1, 1); // drop the 'T'
end;

function TCustomBaseFormWizard.ThisFormIconName: string;
begin
  Result := UpperCase(ThisFormClass.ClassName);
end;

function TCustomBaseFormWizard.GetAuthor: string;
begin
  Result := 'DelphiNotes.ru';
end;

function TCustomBaseFormWizard.GetComment: string;
begin
  Result := '';
end;

function TCustomBaseFormWizard.GetPage: string;
begin
  Result := 'New';
end;

function TCustomBaseFormWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, PChar(ThisFormIconName));
end;

function TCustomBaseFormWizard.GetDesigner: string;
begin
  Result := dVCL;
end;

function TCustomBaseFormWizard.GetGalleryCategory: IOTAGalleryCategory;
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

function TCustomBaseFormWizard.GetPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TCustomBaseFormWizard.GetIDString: string;
begin
  Result := 'DN.Create_' + ThisAncestorName + '.Wizard';
end;

function TCustomBaseFormWizard.GetName: string;
begin
  Result := ThisAncestorName;
end;

function TCustomBaseFormWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TCustomBaseFormWizard.Execute;
var
  ModuleServices: IOTAModuleServices;
  Creator: IOTACreator;
  Module: IOTAModule;
begin
  ModuleServices := (BorlandIDEServices as IOTAModuleServices);
  Creator := TBaseFormCreator.Create(ThisAncestorName);
  Module := ModuleServices.CreateModule(Creator);
  AddUnitToUses(Module, ThisUnitName);
end;

{ TBaseFormWizard }

function TBaseFormWizard.ThisFormClass: TComponentClass;
begin
  Result := TBaseForm;
end;

function TBaseFormWizard.GetName: string;
begin
  Result := 'DN Base Form';
end;

{ TBaseFormModule }

class function TBaseFormModule.DesignClass: TComponentClass;
begin
  Result := TBaseForm;
end;

{ TBaseFrameModule }

function TBaseFrameModule.Nestable: Boolean;
begin
  Result := True;
end;

{ TBaseFrameWizard }

function TBaseFrameWizard.ThisFormClass: TComponentClass;
begin
  Result := TBaseFrame;
end;

function TBaseFrameWizard.GetName: string;
begin
  Result := 'DN Base Frame';
end;

end.
