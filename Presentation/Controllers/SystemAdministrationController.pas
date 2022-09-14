unit SystemAdministrationController;

interface

uses

  Forms,
  SystemAdministrationFormUnit,
  SystemAdministrationFormViewModel,
  SystemAdminPrivileges,
  SystemAdminPrivilegeManageableObjects,
  SystemAdministrationSectionViewModel,
  SystemAdministrationSectionContentFormViewModel,
  SystemAdministrationService,
  Controller,
  SysUtils,
  Classes;

type

  TSystemAdministrationController = class (TController)
    private


    protected

      FWorkingEmployeeId: Variant;

      procedure SetWorkingEmployeeId(const Value: Variant);

      function MapSystemAdministrationFormViewModelFrom(
        SystemAdminPrivileges: TSystemAdminPrivileges
      ): TSystemAdministrationFormViewModel;

      function MapSystemAdministrationSectionContentFormViewModelFrom(
        SystemAdminPrivilegeManageableObjects:
          TSystemAdminPrivilegeManageableObjects
      ): TSystemAdministrationSectionContentFormViewModel;

      function CreateSystemAdministrationSectionContentFormFrom(
        SystemAdministrationSectionContentFormViewModel:
          TSystemAdministrationSectionContentFormViewModel
      ): TForm;

    public

      constructor Create;
      
      function CreateForm(Owner: TComponent): TForm; override;
      
      procedure HandleAdministrationSectionFocusedEvent(
        Sender: TObject;
        FocusedSection: TSystemAdministrationSectionViewModel;
        var FocusedSectionContentForm: TForm
      );

    published

      property WorkingEmployeeId: Variant
      read FWorkingEmployeeId write SetWorkingEmployeeId;
      
  end;

implementation

uses

  WorkingEmployeeUnit,
  ApplicationServiceRegistries;
  
{ TSystemAdministrationController }

constructor TSystemAdministrationController.Create;
begin

  inherited;

end;

function TSystemAdministrationController.CreateForm(Owner: TComponent): TForm;
var SystemAdministrationService: ISystemAdministrationService;
    SystemAdminPrivileges: TSystemAdminPrivileges;
    SystemAdministrationFormViewModel: TSystemAdministrationFormViewModel;
    SystemAdministrationForm: TSystemAdministrationForm;
begin

  SystemAdminPrivileges :=
    SystemAdministrationService.GetAllSystemAdminPrivilegesForEmployee(
      WorkingEmployeeId
    );

  SystemAdministrationFormViewModel :=
    MapSystemAdministrationFormViewModelFrom(SystemAdminPrivileges);

  SystemAdministrationForm := nil;

  try

    SystemAdministrationForm := TSystemAdministrationForm.Create(Owner);

    SystemAdministrationForm.ViewModel := SystemAdministrationFormViewModel;

    Result := SystemAdministrationForm;

  except

    on e: Exception do begin

      if not Assigned(SystemAdministrationForm) then
        FreeAndNil(SystemAdministrationFormViewModel)

      else
        FreeAndNil(SystemAdministrationForm);

      raise;
      
    end;

  end;

end;

function TSystemAdministrationController.
  CreateSystemAdministrationSectionContentFormFrom(
    SystemAdministrationSectionContentFormViewModel:
      TSystemAdministrationSectionContentFormViewModel
  ): TForm;
begin

end;

procedure TSystemAdministrationController.
  HandleAdministrationSectionFocusedEvent(
    Sender: TObject;
    FocusedSection: TSystemAdministrationSectionViewModel;
    var FocusedSectionContentForm: TForm
  );
var SystemAdministrationService: ISystemAdministrationService;
    SystemAdminPrivilegeManageableObjects: TSystemAdminPrivilegeManageableObjects;
    SystemAdministrationSectionContentFormViewModel: TSystemAdministrationSectionContentFormViewModel;
begin

  if Assigned(FocusedSectionContentForm)
     and (FocusedSectionContentForm.ClassType <> TForm)

  then Exit;

  SystemAdminPrivilegeManageableObjects :=
    SystemAdministrationService.
      GetSystemAdminPrivilegeManageableObjectsForEmployee(
        WorkingEmployeeId,
        FocusedSection.Id
      );

  SystemAdministrationSectionContentFormViewModel :=
    MapSystemAdministrationSectionContentFormViewModelFrom(
      SystemAdminPrivilegeManageableObjects
    );

  FocusedSectionContentForm :=
    CreateSystemAdministrationSectionContentFormFrom(
      SystemAdministrationSectionContentFormViewModel
    );
  
end;


function TSystemAdministrationController.
  MapSystemAdministrationFormViewModelFrom(
    SystemAdminPrivileges: TSystemAdminPrivileges
  ): TSystemAdministrationFormViewModel;
begin

end;

function TSystemAdministrationController.
  MapSystemAdministrationSectionContentFormViewModelFrom(
    SystemAdminPrivilegeManageableObjects:
      TSystemAdminPrivilegeManageableObjects
  ): TSystemAdministrationSectionContentFormViewModel;
begin

end;

procedure TSystemAdministrationController.SetWorkingEmployeeId(
  const Value: Variant);
begin

  FWorkingEmployeeId := Value;

end;

end.
