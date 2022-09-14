unit unApplicationMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, ActnList, Menus,
  cxInplaceContainer, cxDBTL, cxTLData, StdCtrls, ExtCtrls,
  DB,
  DepartmentViewModel,
  DocumentRecordsPanelSettingsFormUnit, cxButtons, SDBaseTableFormUnit,
  SDApplicationDataModuleUnit, EquipmentsWithIPAdressesReferenceTableFormUnit,
  EquipmentTypesReferenceTableFormUnit, EquipmentReferenceTableFormUnit,
  SDApplicationStarter, ApplicationDataModuleUnit, MainFormUnit, cxTextEdit,
  UIControlsTrackingStylist, DBDataTableFormStyle, SDHelperUnit,
  ApplicationSettingsResetService,
  unDocumentCardListFrame, unScrollableFrame, unDocumentFlowInformationFrame,
  unDocumentKindsFrame, unDocumentFlowWorkingFrame, unApplicationMainFrame,
  unUserNotificationsSettingsForm, UserNotificationsSettingsFormViewModelMapper,
  StandardDocumentFlowStyle, UserInterfaceSwitch;

type

  TApplicationMainForm = class(TForm)
    MainMenu: TMainMenu;
    ActionList1: TActionList;
    FileMenuItem: TMenuItem;
    SettingsMenuItem: TMenuItem;
    actChangeFont: TAction;
    actExitFromProgram: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    N1: TMenuItem;
    actCreateNotPerformedDocumentsReport: TAction;
    N2: TMenuItem;
    actShowDocumentRecordsPanelSettingsForm: TAction;
    N5: TMenuItem;
    AdministrationMenu: TMenuItem;
    actAdministration: TAction;
    actResetAppSettings: TAction;
    N6: TMenuItem;
    actMailNotifications: TAction;
    N7: TMenuItem;
    actSetNewUI: TAction;
    actSetOldUI: TAction;
    UserInterfaceMenuItem: TMenuItem;
    SetOldUITool: TMenuItem;
    SetNewUITool: TMenuItem;
    actOpenVersionsList: TAction;
    N8: TMenuItem;

    procedure actChangeFontExecute(Sender: TObject);
    procedure actExitFromProgramExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actCreateNotPerformedDocumentsReportExecute(Sender: TObject);
    procedure actShowDocumentRecordsPanelSettingsFormExecute(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actAdministrationExecute(Sender: TObject);
    procedure actResetAppSettingsExecute(Sender: TObject);
    procedure actMailNotificationsExecute(Sender: TObject);
    procedure actSetNewUIExecute(Sender: TObject);
    procedure actSetOldUIExecute(Sender: TObject);
    procedure actOpenVersionsListExecute(Sender: TObject);
    
  private

    FApplicationMainFrame: TApplicationMainFrame;

    FDocumentRecordsPanelSettignsForm: TDocumentRecordsPanelSettingsForm;

    FUIControlsTrackingStylist: TUIControlsTrackingStylist;

    { refactor: inject facade interface object that deal with
      application settings providing the methods such as
      reset settings, change font, change document list panel settings and etc..
      Implementation of this interface must delegate responsibility to
      appropriate internal services
    }
    FApplicationSettignsResetService: IApplicatonSettingsResetService;
    
    procedure OnDocumentRecordsPanelSettingsApplyingRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentRecordsPanelSettingsFormDeleteEventHandler(
      Sender: TObject
    );

    procedure OnDocumentCardListUpdatedEventHandler(Sender: TObject);

  private
    
    procedure ExitFromProgram;
    procedure ChangeApplicationFontViaFontDialog;

    procedure ShowDocumentRecordsPanelSettingsForm;

    procedure CreateNotPerformedDocumentsReportFromWithDialogForm(
      DepartmentsViewModel: TDepartmentsViewModel
    );

    procedure EnsureThatCurrentWorkingEmployeeIsSystemAdmin;

  private

    procedure SubscribeOnApplicationMainFrameEvents(FApplicationMainFrame: TApplicationMainFrame);
    
    procedure CreateAndCustomizeUIControlsTrackingStylist;
    
  private

    procedure OnCurrentReferenceChangedEventHandler(Sender: TObject; CurrentReferenceTableForm: TSDBaseTableForm);

    procedure InflateApplicationMainFrame(FApplicationMainFrame: TApplicationMainFrame);

  private

    procedure SwitchUserInterfaceTo(Value: TUserInterfaceKind);
    
  private

    procedure SetupAdministrationActionVisible;
    procedure ShowDocumentFlowAdministrationForm;
    procedure SetApplicationMainFrame(const Value: TApplicationMainFrame);

    function GetFont: TFont;
    procedure SetFont(const Value: TFont);

  public
 
    destructor Destroy; override;

    constructor Create(AOwner: TComponent); overload; override;
    
    constructor Create(
      AOwner: TComponent;
      ApplicationMainFrame: TApplicationMainFrame
    ); overload;

    property ApplicationSettignsResetService: IApplicatonSettingsResetService
    read FApplicationSettignsResetService write FApplicationSettignsResetService;

    property ApplicationMainFrame: TApplicationMainFrame
    read FApplicationMainFrame write SetApplicationMainFrame;

    property Font: TFont
    read GetFont write SetFont;
    
  end;

var
  ApplicationMainForm: TApplicationMainForm;

implementation

uses

  AuxDebugFunctionsUnit,
  ApplicationPropertiesStorageRegistry,
  AuxWindowsFunctionsUnit,
  DocumentReportPresenterRegistry,
  IDocumentReportPresenterRegistryUnit,
  NotPerformedDocumentsReportPresenter,
  NotPerformedDocumentsReportDataService,
  CommonControlStyles,
  NotPerformedDocumentsReportShowCustomizeFormUnit,
  NotPerformedDocumentsReportData,
  ApplicationServiceRegistries,
  UserNotificationProfileService,
  EmployeeSetReadService,
  EmployeeSetHolder,
  UIDocumentKinds,
  DocumentFlowAuthorizationService,
  WorkingEmployeeUnit,
  UIControlStyle,
  EmployeeDepartmentManagementService,
  DepartmentInfoDTO,
  DBDataTableFormUnit,
  DocumentFlowAdminFormViewModelMapper,
  unDocumentFlowAdministrationForm,
  Disposable,
  VariantFunctions,
  UIApplicationConfigurator, ManagementServiceRegistry,
  unVersionInfosForm,
  ApplicationVersionInfoService,
  NotificationRegistry,
  VersionInfoDTOs;

{$R app_resources.res}
{$R *.dfm}

procedure TApplicationMainForm.actAdministrationExecute(Sender: TObject);
begin

  ShowDocumentFlowAdministrationForm;
  
end;

procedure TApplicationMainForm.actChangeFontExecute(Sender: TObject);
begin

  ChangeApplicationFontViaFontDialog;

end;

procedure TApplicationMainForm.actCreateNotPerformedDocumentsReportExecute(
  Sender: TObject);
var EmployeeDepartmentManagementService: IEmployeeDepartmentManagementService;
    DepartmentsViewModel: TDepartmentsViewModel;
    DepartmentsInfoDTO: TDepartmentsInfoDTO;

  function MapDepartmentsViewModelFrom(
    DepartmentsInfoDTO: TDepartmentsInfoDTO
  ): TDepartmentsViewModel;
  var DepartmentInfoDTO: TDepartmentInfoDTO;
      DepartmentViewModel: TDepartmentViewModel;
  begin

    Result := TDepartmentsViewModel.Create;

    for DepartmentInfoDTO in DepartmentsInfoDTO do begin

      DepartmentViewModel := TDepartmentViewModel.Create;

      Result.Add(DepartmentViewModel);

      DepartmentViewModel.Id := DepartmentInfoDTO.Id;
      DepartmentViewModel.ShortName := DepartmentInfoDTO.Name;

    end;
      
  end;

begin

  EmployeeDepartmentManagementService :=
    TApplicationServiceRegistries.
    Current.
    GetManagementServiceRegistry.
    GetEmployeeDepartmentManagementService;

  DepartmentsInfoDTO :=
    EmployeeDepartmentManagementService.
      FindAllKindredDepartmentsBeginningWithEmployeeDepartment(
        TWorkingEmployee.Current.Id
      );

  try

    CreateNotPerformedDocumentsReportFromWithDialogForm(
      MapDepartmentsViewModelFrom(DepartmentsInfoDTO)
    );

  finally

    FreeAndNil(DepartmentsInfoDTO);
    
  end;

end;

procedure TApplicationMainForm.actExitFromProgramExecute(Sender: TObject);
begin

  ExitFromProgram;

end;

procedure TApplicationMainForm.actMailNotificationsExecute(Sender: TObject);
var
    UserNotificationsSettingsForm: TUserNotificationsSettingsForm;
    UserNotificationProfileService: IUserNotificationProfileService;
begin

  UserNotificationProfileService :=
    TApplicationServiceRegistries
      .Current
        .GetManagementServiceRegistry
          .GetUserNotificationProfileService;

  UserNotificationsSettingsForm :=
    TUserNotificationsSettingsForm.Create(
      Self,
      UserNotificationProfileService,
      TUserNotificationsSettingsFormViewModelMapper.Create(
        UserNotificationProfileService
      ),
      TWorkingEmployee.Current.Id
    );

  try

    UserNotificationsSettingsForm.ShowModal;

  finally

    FreeAndNil(UserNotificationsSettingsForm);

  end;

end;

procedure TApplicationMainForm.actOpenVersionsListExecute(Sender: TObject);
var
  VersionInfoForm: TVersionInfosForm;
  VersionInfoService: IApplicationVersionInfoService;
  VersionsDTOs: TVersionInfoDTOs;
begin

  VersionInfoService :=
    TApplicationServiceRegistries.Current.
      GetNotificationRegistry.
        GetApplicationVersionInfoService;

  VersionsDTOs := VersionInfoService.GetAllVersionsChanges;

  if VersionsDTOs <> nil then
  begin

    VersionInfoForm :=
      TVersionInfosForm.Create(
          Self,
          VersionsDTOs
        );

    VersionInfoForm.ShowModal;
  end;

end;

procedure TApplicationMainForm.actResetAppSettingsExecute(Sender: TObject);
begin

  Screen.Cursor := crHourGlass;

  try

    { refactor: call sequence extract to separate object }

    FApplicationSettignsResetService.ResetApplicationSettings;

    DebugOutput(FApplicationMainFrame.UserInterfaceKind);

    ApplicationMainFrame.RestoreDefaultUIControlProperties;
    
    ShowInfoMessage(
      Self.Handle,
      'Настройки программы успешно сброшены',
      'Сообщение'
    );

    DebugOutput(FApplicationMainFrame.UserInterfaceKind);

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TApplicationMainForm.actSetNewUIExecute(Sender: TObject);
begin

  SwitchUserInterfaceTo(uiNew);

end;

procedure TApplicationMainForm.actSetOldUIExecute(Sender: TObject);
begin

  SwitchUserInterfaceTo(uiOld);
  
end;

procedure TApplicationMainForm.actShowDocumentRecordsPanelSettingsFormExecute(
  Sender: TObject);
begin

  ShowDocumentRecordsPanelSettingsForm;

end;

procedure TApplicationMainForm.ChangeApplicationFontViaFontDialog;
var FontDialog: TFontDialog;
begin

  FontDialog := TFontDialog.Create(nil);

  try

    FontDialog.Font := Font;

    if not FontDialog.Execute then Exit;

    Font := FontDialog.Font;
    
  finally

    FreeAndNil(FontDialog);

  end;

end;

constructor TApplicationMainForm.Create(
  AOwner: TComponent;
  ApplicationMainFrame: TApplicationMainFrame
);
begin

  Create(AOwner);

  Self.ApplicationMainFrame := ApplicationMainFrame;

end;

constructor TApplicationMainForm.Create(AOwner: TComponent);
begin

  inherited;

  CreateAndCustomizeUIControlsTrackingStylist;

end;

procedure TApplicationMainForm.
  CreateAndCustomizeUIControlsTrackingStylist;
var
    StandardDocumentFlowStyle: IUIControlStyle;
begin

  FUIControlsTrackingStylist :=
    TUIControlsTrackingStylist.Create;

  StandardDocumentFlowStyle := TStandardDocumentFlowStyle.Create;

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TSDBaseTableForm, StandardDocumentFlowStyle
  );

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TUserNotificationsSettingsForm, StandardDocumentFlowStyle
  );
  
  FUIControlsTrackingStylist.RunTracking;

end;

procedure TApplicationMainForm.
  CreateNotPerformedDocumentsReportFromWithDialogForm(
    DepartmentsViewModel: TDepartmentsViewModel
  );

var
    NotPerformedDocumentsReportDataService:
      INotPerformedDocumentsReportDataService;

    NotPerformedDocumentsReportPresenter:
      INotPerformedDocumentsReportPresenter;

    NotPerformedDocumentsReportShowCustomizeForm:
      TNotPerformedDocumentsReportShowCustomizeForm;

    NotPerformedDocumentsReportData: TNotPerformedDocumentsReportData;
begin

  NotPerformedDocumentsReportShowCustomizeForm := nil;
  NotPerformedDocumentsReportData := nil;

  try

    NotPerformedDocumentsReportShowCustomizeForm :=
      TNotPerformedDocumentsReportShowCustomizeForm.Create(Self);

    NotPerformedDocumentsReportShowCustomizeForm.DepartmentsViewModel :=
      DepartmentsViewModel;
      
    if NotPerformedDocumentsReportShowCustomizeForm.ShowModal <> mrOk then
      Exit;

    Screen.Cursor := crHourGlass;

    NotPerformedDocumentsReportDataService :=

      TApplicationServiceRegistries.
      Current.
      GetReportingServiceRegistry.
      GetNotPerformedDocumentsReportDataService;
      
    NotPerformedDocumentsReportData :=
    
      NotPerformedDocumentsReportDataService.
        GetNotPerformedServiceNotesReportDataForEmployee(

          TWorkingEmployee.Current.Id,

          NotPerformedDocumentsReportShowCustomizeForm.
            SelectedDepartmentViewModel.Id,
            
          NotPerformedDocumentsReportShowCustomizeForm.PeriodStart,
          NotPerformedDocumentsReportShowCustomizeForm.PeriodEnd
        );

    Screen.Cursor := crDefault;

    NotPerformedDocumentsReportPresenter :=
      TDocumentReportPresenterRegistry
        .Current
          .GetNotPerformedDocumentsReportPresenter(
            TUIOutcomingServiceNoteKind
          );

    NotPerformedDocumentsReportPresenter.PresentReportBy(
      NotPerformedDocumentsReportData
    );

  finally

    Screen.Cursor := crDefault;
    
    FreeAndNil(NotPerformedDocumentsReportData);
    FreeAndNil(NotPerformedDocumentsReportShowCustomizeForm);

  end;

end;

procedure TApplicationMainForm.cxButton1Click(Sender: TObject);
begin
  inherited;
  Close;
end;

destructor TApplicationMainForm.Destroy;
begin

  FreeAndNil(FDocumentRecordsPanelSettignsForm);
  FreeAndNil(FUIControlsTrackingStylist);
  
  inherited;

end;

procedure TApplicationMainForm.EnsureThatCurrentWorkingEmployeeIsSystemAdmin;
var
    DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;
    EmployeeSystemRoleFlags: TDocumentFlowSystemRoleFlags;
    Free: IDisposable;
begin

  DocumentFlowAuthorizationService :=
    TApplicationServiceRegistries.
    Current.
    GetSystemServiceRegistry.
    GetDocumentFlowAuthorizationService;

  EmployeeSystemRoleFlags := TDocumentFlowSystemRoleFlags.Create;

  Free := EmployeeSystemRoleFlags;

  EmployeeSystemRoleFlags.HasAdminViewRole := True;
  
  try

    DocumentFlowAuthorizationService.EnsureEmployeeHasSystemRoles(
      TWorkingEmployee.Current.Id, EmployeeSystemRoleFlags
    );

  except

    on e: Exception do begin

      actAdministration.Visible := False;
      AdministrationMenu.Visible := False;
      
      Raise;

    end;

  end;

end;

procedure TApplicationMainForm.ExitFromProgram;
begin

  Close;

end;

procedure TApplicationMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction
);
begin

  ApplicationMainFrame.OnClose;
  
end;

procedure TApplicationMainForm.FormShow(Sender: TObject);
begin

  if Assigned(ApplicationMainFrame) then begin

    ApplicationMainFrame.OnShow;
    
    if not ApplicationMainFrame.RestoreUIControlPropertiesOnCreate then
      ApplicationMainFrame.RestoreUIControlProperties;

    Font := ApplicationMainFrame.Font;
    
  end;

  SetupAdministrationActionVisible;

end;

function TApplicationMainForm.GetFont: TFont;
begin

  Result := inherited Font;
  
end;

procedure TApplicationMainForm.InflateApplicationMainFrame(
  FApplicationMainFrame: TApplicationMainFrame);
begin

  FApplicationMainFrame.Parent := Self;
  FApplicationMainFrame.Align := alClient;

  InsertComponent(FApplicationMainFrame);
  
end;

procedure TApplicationMainForm.OnCurrentReferenceChangedEventHandler(
  Sender: TObject; CurrentReferenceTableForm: TSDBaseTableForm);
begin

  TDocumentFlowCommonControlStyles
    .ApplyStylesToForm(CurrentReferenceTableForm);

end;

procedure TApplicationMainForm.OnDocumentCardListUpdatedEventHandler(
  Sender: TObject
);
begin

  inherited;

  if Assigned(FDocumentRecordsPanelSettignsForm) then begin

    FApplicationMainFrame
      .DocumentCardListFrame
        .EnableDocumentCardListGroupingTool :=
        
          FDocumentRecordsPanelSettignsForm.
            EnableDocumentRecordGroupingByColumnsOption;

  end

  else begin

    with TDocumentRecordsPanelSettingsForm.Create(nil) do begin

      try

        FApplicationMainFrame
          .DocumentCardListFrame
            .EnableDocumentCardListGroupingTool :=

              EnableDocumentRecordGroupingByColumnsOption;

      finally

        Free;

      end;

    end;

  end;

end;

procedure TApplicationMainForm.
  OnDocumentRecordsPanelSettingsApplyingRequestedEventHandler(
    Sender: TObject
  );
begin

  FApplicationMainFrame.EnableDocumentCardListGroupingTool :=
    FDocumentRecordsPanelSettignsForm.EnableDocumentRecordGroupingByColumnsOption;
        
end;

procedure TApplicationMainForm.OnDocumentRecordsPanelSettingsFormDeleteEventHandler(
  Sender: TObject);
begin

  FDocumentRecordsPanelSettignsForm := nil;

end;

procedure TApplicationMainForm.SetApplicationMainFrame(
  const Value: TApplicationMainFrame
);
begin

  FApplicationMainFrame := Value;

  SubscribeOnApplicationMainFrameEvents(FApplicationMainFrame);
  
  InflateApplicationMainFrame(FApplicationMainFrame);

end;

procedure TApplicationMainForm.SetFont(const Value: TFont);
begin

  inherited Font := Value;

  if Assigned(ApplicationMainFrame) then
    ApplicationMainFrame.Font := Value;

  if Assigned(ApplicationMainFrame.DocumentCardListFrame) then
    ApplicationMainFrame.DocumentCardListFrame.Font := Value;
    
end;

procedure TApplicationMainForm.SetupAdministrationActionVisible;
var DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;
begin
                  
  DocumentFlowAuthorizationService :=
    TApplicationServiceRegistries.
    Current.
    GetSystemServiceRegistry.
    GetDocumentFlowAuthorizationService;

  actAdministration.Visible :=
    DocumentFlowAuthorizationService.IsEmployeeAdminView(
      TWorkingEmployee.Current.Id
    );

  AdministrationMenu.Visible := actAdministration.Visible;

end;

procedure TApplicationMainForm.ShowDocumentFlowAdministrationForm;
var
    DocumentFlowAdministrationForm: TDocumentFlowAdministrationForm;
begin

  DocumentFlowAdministrationForm :=
    TDocumentFlowAdministrationForm.Create(
      Self,
      TWorkingEmployee.Current.Id,

      TApplicationServiceRegistries
        .Current
          .GetSystemServiceRegistry
            .GetDocumentFlowAdministrationService,

      TDocumentFlowAdminFormViewModelMapper.Create
    );

  try

    DocumentFlowAdministrationForm.Font := Font;
    DocumentFlowAdministrationForm.Position := poMainFormCenter;

    SetControlSizeByOtherControlSize(
      DocumentFlowAdministrationForm,
      Self,
      8 / 9,
      8 / 9
    );
    
    DocumentFlowAdministrationForm.ShowModal;

  finally

    FreeAndNil(DocumentFlowAdministrationForm);
    
  end;
  
end;

procedure TApplicationMainForm.ShowDocumentRecordsPanelSettingsForm;
begin

  if not Assigned(FDocumentRecordsPanelSettignsForm) then begin

    FDocumentRecordsPanelSettignsForm :=
      TDocumentRecordsPanelSettingsForm.Create(Self);

    FDocumentRecordsPanelSettignsForm.DeleteOnClose := True;
    
    FDocumentRecordsPanelSettignsForm.
      OnSettingsApplyingRequestedEventHandler :=
        OnDocumentRecordsPanelSettingsApplyingRequestedEventHandler;

    FDocumentRecordsPanelSettignsForm.OnDeleteEventHandler :=
      OnDocumentRecordsPanelSettingsFormDeleteEventHandler;

    FDocumentRecordsPanelSettignsForm.Show;

  end

  else FDocumentRecordsPanelSettignsForm.SetFocus;

end;

procedure TApplicationMainForm.SubscribeOnApplicationMainFrameEvents(
  FApplicationMainFrame: TApplicationMainFrame
);
begin

  FApplicationMainFrame.OnDocumentCardListUpdatedEventHandler :=
    OnDocumentCardListUpdatedEventHandler;

end;

procedure TApplicationMainForm.SwitchUserInterfaceTo(Value: TUserInterfaceKind);
begin

  if Assigned(FApplicationMainFrame) then
    FApplicationMainFrame.UserInterfaceKind := Value;

end;

end.
