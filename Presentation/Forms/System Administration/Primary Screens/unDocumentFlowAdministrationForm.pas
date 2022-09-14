unit unDocumentFlowAdministrationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSystemAdministrationForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, DB,
  cxInplaceContainer, cxDBTL, cxTLData, ExtCtrls,
  SectionStackedFormViewModel, DocumentFlowAdminFormViewModelMapper,
  DocumentFlowAdministrationService,
  SystemAdministrationFormViewModelMapperInterface, SectionRecordViewModel,
  DocumentFlowAdminPrivileges, DocumentFlowAdminPrivilegeServices,
  DocumentsAdminPrivilegeServices, DocumentFlowAuthorizationService,
  AppEvnts, unAdminDocumentCardListFrame, unSelectionDepartmentsReferenceForm;

type
  TDocumentFlowAdministrationForm = class(TSystemAdministrationForm)
    procedure FormShow(Sender: TObject);

  private

    FClientId: Variant;
    FDocumentFlowAdministrationService: IDocumentFlowAdministrationService;
    FDocumentFlowAdminFormViewModelMapper: TDocumentFlowAdminFormViewModelMapper;
    FFreeDocumentFlowAdminFormViewModelMapper: ISystemAdministrationFormViewModelMapper;

  private

    procedure HandleSectionControlRequestedEvent(
      Sender: TObject;
      SectionRecordViewModel: TSectionRecordViewModel;
      var Control: TControl;
      var Success: Boolean
    );


  private

    FReplacementsListSectionId: Variant;
    FReplacementsListControl: TControl;
    
    procedure OnEmployeesReplacementsRefreshedEventHandler;

  private

    procedure Initialize;
    procedure UpdateByAdministrationPrivileges;

    function GetAdminSectionContentControl(const SectionId: Variant): TControl;

    function GetDocumentKindSectionContentControlBy(
      DocumentsAdminPrivilegeServices: TDocumentsAdminPrivilegeServices
    ): TControl;
    
  public

    constructor Create(
      Owner: TComponent;
      ClientId: Variant;
      DocumentFlowAdministrationService: IDocumentFlowAdministrationService;
      DocumentFlowAdminFormViewModelMapper: TDocumentFlowAdminFormViewModelMapper
    );
    
  end;

var
  DocumentFlowAdministrationForm: TDocumentFlowAdministrationForm;

implementation

uses

  DocumentKindDto,
  NativeDocumentKindDto,
  GlobalDocumentKindDto,
  unSectionStackedForm,
  ApplicationServiceRegistries,
  DepartmentsAdminPrivilegeServices,
  EmployeesAdminPrivilegeServices,
  DocumentNumeratorsAdminPrivilegeServices,
  SynchronizationDataAdminPrivilegeServices,
  EmployeesReplacementsAdminPrivilegeServices,
  EmployeeStaffsAdminPrivilegeServices,
  EmployeesWorkGroupsAdminPrivilegeServices,
  DepartmentsAdminReferenceControlService,
  EmployeesAdminReferenceControlService,
  EmployeesReplacementsAdminReferenceControlService,
  PersonnelOrderEmployeesAdminPrivilegeServices,
  PersonnelOrderControlGroupsAdminPrivilegeServices,
  PersonnelOrderKindApproversAdminPrivilegeServices,
  PersonnelOrderSignersAdminPrivilegeServices,
  EmployeeStaffsAdminReferenceControlService,
  EmployeesWorkGroupsAdminReferenceControlService,
  DocumentsReferenceViewModelFactory,
  DocumentsReferenceFormFactory,
  GlobalDocumentKindsReadService,
  StandardUINativeDocumentKindResolver,
  StandardUIDocumentKindResolver,
  OperationalDocumentKindInfo,
  StandardUIDocumentKindMapper,
  StandardDocumentsReferenceFormPresenter,
  DocumentsReferenceFormProcessorFactory,
  DepartmentDocumentsReferenceFormProcessorFactory,
  DocumentKinds;

{$R *.dfm}

{ TDocumentFlowAdministrationForm }

constructor TDocumentFlowAdministrationForm.Create(
  Owner: TComponent;
  ClientId: Variant;
  DocumentFlowAdministrationService: IDocumentFlowAdministrationService;
  DocumentFlowAdminFormViewModelMapper: TDocumentFlowAdminFormViewModelMapper
);
begin

  inherited Create(Owner);

  FClientId := ClientId;
  FDocumentFlowAdministrationService := DocumentFlowAdministrationService;
  FDocumentFlowAdminFormViewModelMapper := DocumentFlowAdminFormViewModelMapper;
  FFreeDocumentFlowAdminFormViewModelMapper := DocumentFlowAdminFormViewModelMapper;

  Initialize;

end;

procedure TDocumentFlowAdministrationForm.Initialize;
begin

  OnSectionControlRequestedEventHandler :=
    HandleSectionControlRequestedEvent;
  
end;

procedure TDocumentFlowAdministrationForm.OnEmployeesReplacementsRefreshedEventHandler;
begin

  ChangeControlOfSection(FReplacementsListSectionId, FReplacementsListControl);
  
  FReplacementsListSectionId := Null;
  FReplacementsListControl := nil;

end;

procedure TDocumentFlowAdministrationForm.UpdateByAdministrationPrivileges;
var
    DocumentFlowAdminPrivileges: TDocumentFlowAdminPrivileges;
begin

  DocumentFlowAdminPrivileges :=
    FDocumentFlowAdministrationService
      .GetAllDocumentFlowAdministrationPrivileges(FClientId);

  ViewModel :=
    FDocumentFlowAdminFormViewModelMapper.MapDocumentFlowAdminFormViewModelFrom(
      DocumentFlowAdminPrivileges
    );

  SectionsTreeList.Root.Expand(True);

end;

procedure TDocumentFlowAdministrationForm.HandleSectionControlRequestedEvent(
  Sender: TObject;
  SectionRecordViewModel: TSectionRecordViewModel;
  var Control: TControl;
  var Success: Boolean
);

begin

  if not SectionRecordViewModel.MustBeContent then Exit;

  Control := GetAdminSectionContentControl(SectionRecordViewModel.Id);

  if Control is TForm then begin

    TForm(Control).BorderStyle := bsNone;

    {
    if Control is TTableViewerForm then begin

      FReplacementsListSectionId := SectionRecordViewModel.Id;
      FReplacementsListControl := Control;

      TTableViewerForm(Control).OnRefreshComplete :=
        OnEmployeesReplacementsRefreshedEventHandler;

      Success := False;

    end; }

  end;

end;

procedure TDocumentFlowAdministrationForm.FormShow(Sender: TObject);
begin

  inherited;

  try

    UpdateByAdministrationPrivileges;

  except

    on E: Exception do begin

      Close;

      Raise;
      
    end;

  end;

end;

function TDocumentFlowAdministrationForm.GetAdminSectionContentControl(
  const SectionId: Variant
): TControl;
var
    AdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  AdminPrivilegeServices :=
    FDocumentFlowAdministrationService
      .GetDocumentFlowAdministrationPrivilegeServices(
        FClientId, SectionId
      );

  try

    { refactor: use SectionControlFactories to avoid the bloating if-based spagetti-code }

    if AdminPrivilegeServices is TDocumentsAdminPrivilegeServices
    then begin

      Result :=
        GetDocumentKindSectionContentControlBy(
          TDocumentsAdminPrivilegeServices(AdminPrivilegeServices)
        );
        
    end

    else if AdminPrivilegeServices is TDocumentNumeratorsAdminPrivilegeServices
    then begin

      Result :=
        TDocumentNumeratorsAdminPrivilegeServices(AdminPrivilegeServices)
          .DocumentNumeratorsAdminReferenceControlService
            .GetDocumentNumeratorsAdminReferenceControl(FClientId);
    end
         

    else if AdminPrivilegeServices is TDepartmentsAdminPrivilegeServices
    then begin

      Result :=
        TDepartmentsAdminPrivilegeServices(AdminPrivilegeServices)
          .DepartmentsAdminReferenceControlService
            .GetDepartmentsAdminReferenceControl(FClientId);
            
    end

    else if AdminPrivilegeServices is TEmployeesAdminPrivilegeServices
    then begin

      Result :=
        TEmployeesAdminPrivilegeServices(AdminPrivilegeServices)
          .EmployeesAdminReferenceControlService
            .GetEmployeesAdminReferenceControl(FClientId);

    end

    else if AdminPrivilegeServices is TEmployeesReplacementsAdminPrivilegeServices
    then begin

      Result :=
        TEmployeesReplacementsAdminPrivilegeServices(AdminPrivilegeServices)
          .EmployeesReplacementsAdminReferenceControlService
            .GetEmployeesReplacementsAdminReferenceControl(FClientId);

    end

    else if AdminPrivilegeServices is TEmployeeStaffsAdminPrivilegeServices
    then begin

      Result :=
        TEmployeeStaffsAdminPrivilegeServices(AdminPrivilegeServices)
          .EmployeeStaffsAdminReferenceControlService
            .GetEmployeeStaffsAdminReferenceControl(FClientId);
            
    end

    else if AdminPrivilegeServices is TEmployeesWorkGroupsAdminPrivilegeServices
    then begin

      Result :=
        TEmployeesWorkGroupsAdminPrivilegeServices(AdminPrivilegeServices)
          .EmployeesWorkGroupsAdminReferenceControlService
            .GetEmployeesWorkGroupsAdminReferenceControl(FClientId);

    end

    else if AdminPrivilegeServices is TSynchronizationDataAdminPrivilegeServices
    then begin

      Result :=
        TSynchronizationDataAdminPrivilegeServices(AdminPrivilegeServices)
          .SynchronizationDataControlService
            .GetSynchronizationDataControl(FClientId);
            
    end

    else if AdminPrivilegeServices is TPersonnelOrderEmployeesAdminPrivilegeServices
    then begin

      Result :=
        TPersonnelOrderEmployeesAdminPrivilegeServices(AdminPrivilegeServices)
          .PersonnelOrderEmployeesControlService
            .CreatePersonnelOrderEmployeesControl(FClientId);

    end

    else if AdminPrivilegeServices is TPersonnelOrderControlGroupsAdminPrivilegeServices
    then begin

      Result :=
        TPersonnelOrderControlGroupsAdminPrivilegeServices(AdminPrivilegeServices)
          .PersonnelOrderControlGroupsControlService
            .CreatePersonnelOrderControlGroupsControlService(FClientId);

    end

    else if AdminPrivilegeServices is TPersonnelOrderKindApproversAdminPrivilegeServices
    then begin

      Result :=
        TPersonnelOrderKindApproversAdminPrivilegeServices(AdminPrivilegeServices)
          .PersonnelOrderKindApproversControlService
            .CreatePersonnelOrderKindApproversControl(FClientId);

    end

    else if AdminPrivilegeServices is TPersonnelOrderSignersAdminPrivilegeServices
    then begin

      Result :=
        TPersonnelOrderSignersAdminPrivilegeServices(AdminPrivilegeServices)
          .PersonnelOrderSignersControlService
            .CreatePersonnelOrderSignersControl(FClientId);
    end

    else Result := nil;
    
  finally

    FreeAndNil(AdminPrivilegeServices);
      
  end;

end;

{ refactor: set up all AdminDocumentCardListFrame dependencies otherwise }
function TDocumentFlowAdministrationForm.GetDocumentKindSectionContentControlBy(
  DocumentsAdminPrivilegeServices: TDocumentsAdminPrivilegeServices
): TControl;
var
    SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm;
    AdminDocumentCardListFrame: TAdminDocumentCardListFrame;
    GlobalDocumentKindsReadService: IGlobalDocumentKindsReadService;
    GlobalDocumentKindDtos: TGlobalDocumentKindDtos;
    CurrentOperationDocumentKindInfo: TOperationalDocumentKindInfo;
    ServiceDocumentType: TDocumentKindClass;
begin


  SelectionDepartmentsReferenceForm :=
    TSelectionDepartmentsReferenceForm.Create(Self);

  AdminDocumentCardListFrame :=
    TAdminDocumentCardListFrame.Create(Self, SelectionDepartmentsReferenceForm);

  AdminDocumentCardListFrame.WorkingEmployeeId := FClientId;

  AdminDocumentCardListFrame.DocumentsReferenceViewModelFactory :=
    TDocumentsReferenceViewModelFactory.Create;

  AdminDocumentCardListFrame.DocumentsReferenceFormFactory :=
    TDocumentsReferenceFormFactory.Create(
      TDepartmentDocumentsReferenceFormProcessorFactory.Create
    );

  GlobalDocumentKindsReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetGlobalDocumentKindsReadService;

  GlobalDocumentKindDtos :=
    GlobalDocumentKindsReadService.GetGlobalDocumentKindDtos(FClientId);

  AdminDocumentCardListFrame.GlobalDocumentKindDtos := GlobalDocumentKindDtos;
  AdminDocumentCardListFrame.NativeDocumentKindDtos := GlobalDocumentKindDtos.FetchNativeDocumentKindDtos;

  AdminDocumentCardListFrame.UINativeDocumentKindResolver :=
    TStandardUINativeDocumentKindResolver.Create(
      TStandardUIDocumentKindMapper.Create,
      AdminDocumentCardListFrame.NativeDocumentKindDtos
    );

  AdminDocumentCardListFrame.UIDocumentKindResolver :=
    TStandardUIDocumentKindResolver.Create(
      TStandardUIDocumentKindMapper.Create,
      AdminDocumentCardListFrame.GlobalDocumentKindDtos
    );

  ServiceDocumentType :=
    AdminDocumentCardListFrame.NativeDocumentKindDtos.FindByIdOrRaise(
      DocumentsAdminPrivilegeServices.WorkingPrivilegeId
    ).ServiceType;
      
  CurrentOperationDocumentKindInfo :=
    TOperationalDocumentKindInfo.Create(
      GlobalDocumentKindDtos.FindByServiceType(ServiceDocumentType).Id,
      DocumentsAdminPrivilegeServices.WorkingPrivilegeId,
      ServiceDocumentType,
      AdminDocumentCardListFrame.UINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
        DocumentsAdminPrivilegeServices.WorkingPrivilegeId
      )
    );

  AdminDocumentCardListFrame.DocumentsReferenceFormPresenter :=
    TStandardDocumentsReferenceFormPresenter.Create;

  AdminDocumentCardListFrame.CurrentDocumentKindInfo := CurrentOperationDocumentKindInfo;

  AdminDocumentCardListFrame.OnShow;
  
  Result := AdminDocumentCardListFrame;  

end;

end.
