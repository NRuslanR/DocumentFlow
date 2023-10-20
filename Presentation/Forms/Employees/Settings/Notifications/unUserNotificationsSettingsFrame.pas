unit unUserNotificationsSettingsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxLayoutControlAdapters, dxLayoutLookAndFeels, dxLayoutControl, ExtCtrls,
  StdCtrls, UserNotificationProfileService, UserNotificationsSettingsFormViewModel,
  UserNotificationsSettingsFormViewModelMapper, UserNotificationProfile,
  Disposable, LayoutManager, EmployeesReferenceFormUnit, VariantListUnit,
  VerticalBoxLayoutManager;

type

  TUserNotificationsSettingsFrame = class(TFrame)

  NotificationsReceivingEnabledCheckBox: TCheckBox;
    OwnNotificationsReceivingUsersLayoutControlGroup_Root: TdxLayoutGroup;
    OwnNotificationsReceivingUsersLayoutControl: TdxLayoutControl;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    OwnNotificationsReceivingUsersLayoutControlGroup1: TdxLayoutGroup;
    OwnNotificationsReceivingUsersLayoutControlItem1: TdxLayoutItem;
    OwnNotificationsReceivingUsersFormPanel: TPanel;
    dxLayoutStandardLookAndFeel1: TdxLayoutStandardLookAndFeel;

  private

    FUserNotificationProfileService: IUserNotificationProfileService;
    FViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
    FViewModel: TUserNotificationsSettingsFormViewModel;
    FUserId: Variant;

    FOwnNotificationsReceivingEmployeesReferenceForm: TEmployeesReferenceForm;
   
    procedure SetViewModel(const Value: TUserNotificationsSettingsFormViewModel);

    procedure UpdateControlsBy(ViewModel: TUserNotificationsSettingsFormViewModel);
    procedure UpdateOwnNotificationsReceivingEmployeesReferenceFormBy(ViewModel: TUserNotificationsSettingsFormViewModel);
    procedure UpdateViewModelByControls;
    procedure UpdateViewModelByUserNotificationProfile;
    procedure UpdateUserNotificationProfileByViewModel;

    procedure UpdateLayout;

  private

    procedure OnOwnNotificationsUserSetRefreshedEventHandler(Sender: TObject);

  private

    procedure SelectOwnNotificationsUsersReferenceFormRecords(
      OwnNotificationsReceivingUsersReferenceForm: TEmployeesReferenceForm;
      SelectedOwnNotificationsReceivingUserIds: TVariantList
    );

  public

    destructor Destroy; override;
    
    constructor Create(
      Owner: TComponent;
      UserNotificationProfileService: IUserNotificationProfileService;
      ViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
      UserId: Variant
    );

    procedure UpdateViewModel;
    procedure SaveUserNotificationProfile;

    property ViewModel: TUserNotificationsSettingsFormViewModel
    read FViewModel write SetViewModel;
    
  end;

implementation

uses BoxLayoutManager, DBDataTableFormUnit, AuxWindowsFunctionsUnit;

constructor TUserNotificationsSettingsFrame.Create(
  Owner: TComponent;
  UserNotificationProfileService: IUserNotificationProfileService;
  ViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
  UserId: Variant
);
begin

  inherited Create(Owner);

  FUserNotificationProfileService := UserNotificationProfileService;
  FViewModelMapper := ViewModelMapper;
  FUserId := UserId;
  
end;

destructor TUserNotificationsSettingsFrame.Destroy;
begin

  if Assigned(FOwnNotificationsReceivingEmployeesReferenceForm) then
    FOwnNotificationsReceivingEmployeesReferenceForm.SafeDestroy;
  
  FreeAndNil(FViewModelMapper);
  FreeAndNil(FViewModel);

  inherited;

end;

procedure TUserNotificationsSettingsFrame.OnOwnNotificationsUserSetRefreshedEventHandler(
  Sender: TObject);
begin

  SelectOwnNotificationsUsersReferenceFormRecords(
    TEmployeesReferenceForm(Sender),
    ViewModel.SelectedOwnNotificationsReceivingUserIds
  );

end;

procedure TUserNotificationsSettingsFrame.SaveUserNotificationProfile;
begin

  UpdateViewModelByControls;
  UpdateUserNotificationProfileByViewModel;
  
end;

procedure TUserNotificationsSettingsFrame.SelectOwnNotificationsUsersReferenceFormRecords(
  OwnNotificationsReceivingUsersReferenceForm: TEmployeesReferenceForm;
  SelectedOwnNotificationsReceivingUserIds: TVariantList);
begin

  with OwnNotificationsReceivingUsersReferenceForm do begin

    SelectRecordsByIds(SelectedOwnNotificationsReceivingUserIds);

    if not SelectedOwnNotificationsReceivingUserIds.IsEmpty then
      FocusedRecordId := SelectedOwnNotificationsReceivingUserIds.First;

  end;

end;

procedure TUserNotificationsSettingsFrame.SetViewModel(
  const Value: TUserNotificationsSettingsFormViewModel);
begin

  if FViewModel = Value then Exit;

  FreeAndNil(FViewModel);

  FViewModel := Value;

  UpdateControlsBy(FViewModel);

end;

procedure TUserNotificationsSettingsFrame.UpdateControlsBy(
  ViewModel: TUserNotificationsSettingsFormViewModel
);
begin

  with ViewModel do begin

    NotificationsReceivingEnabledCheckBox.Checked := ReceiveNotifications;

    UpdateOwnNotificationsReceivingEmployeesReferenceFormBy(ViewModel);
    
  end;

  UpdateLayout;
  
end;

procedure TUserNotificationsSettingsFrame.UpdateLayout;
var
    LayoutManager: TLayoutManager;
begin

  if ViewModel.OwnNotificationsReceivingUsersEditingVisible then begin

    LayoutManager :=
      TVerticalBoxLayoutManagerBuilder
        .Create
          .AddControls(
            [
              NotificationsReceivingEnabledCheckBox,
              OwnNotificationsReceivingUsersLayoutControl
            ],
            [10, 15]
          )
          .BuildAndDestroy;

  end

  else begin

    LayoutManager :=
      TVerticalBoxLayoutManagerBuilder
        .Create
          .AddControl(NotificationsReceivingEnabledCheckBox, 15)
          .BuildAndDestroy;

  end;

  try

    LayoutManager.Left := 10;
    LayoutManager.Top := 10;
    
    LayoutManager.ApplyLayout;

    ClientHeight := LayoutManager.Height + 10;

  finally

    FreeAndNil(LayoutManager);

  end;

end;

procedure TUserNotificationsSettingsFrame.
  UpdateOwnNotificationsReceivingEmployeesReferenceFormBy(
    ViewModel: TUserNotificationsSettingsFormViewModel
  );
begin

  OwnNotificationsReceivingUsersLayoutControl.Visible := ViewModel.OwnNotificationsReceivingUsersEditingVisible;

  if not ViewModel.OwnNotificationsReceivingUsersEditingVisible then Exit;

  if not Assigned(FOwnNotificationsReceivingEmployeesReferenceForm) then begin

    FOwnNotificationsReceivingEmployeesReferenceForm :=
      TEmployeesReferenceForm.Create(OwnNotificationsReceivingUsersFormPanel);

    with FOwnNotificationsReceivingEmployeesReferenceForm do begin

      EnableSelectionColumn := True;

      Parent := OwnNotificationsReceivingUsersFormPanel;

      BorderStyle := bsNone;

      ChooseRecordActionVisible := False;
      ExportDataActionVisible := False;
      EnableRecordGroupingByColumnsOption := False;

      Align := alClient;

      Show;

    end;

  end;

  with FOwnNotificationsReceivingEmployeesReferenceForm do begin

    OnRecordsRefreshedEventHandler :=
      OnOwnNotificationsUserSetRefreshedEventHandler;

    FOwnNotificationsReceivingEmployeesReferenceForm.DataSetHolder :=
      ViewModel.OwnNotificationsReceivingUserSet;

    SelectOwnNotificationsUsersReferenceFormRecords(
      FOwnNotificationsReceivingEmployeesReferenceForm,
      ViewModel.SelectedOwnNotificationsReceivingUserIds
    );

  end;

end;

procedure TUserNotificationsSettingsFrame.UpdateUserNotificationProfileByViewModel;
var
    UserNotificationProfile: TUserNotificationProfile;
    Free: IDisposable;
begin

  Screen.Cursor := crHourGlass;

  try

    UserNotificationProfile :=
      FUserNotificationProfileService.GetNotificationProfileForUser(FUserId);

    Free := UserNotificationProfile;

    FViewModelMapper.UpdateUserNotificationProfileByViewModel(
      UserNotificationProfile, ViewModel
    );

    FUserNotificationProfileService.SaveUserNotificationProfile(UserNotificationProfile);

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TUserNotificationsSettingsFrame.UpdateViewModel;
begin

  UpdateViewModelByUserNotificationProfile;
  
end;

procedure TUserNotificationsSettingsFrame.UpdateViewModelByControls;
begin

  if not Assigned(ViewModel) then
    FViewModel := TUserNotificationsSettingsFormViewModel.Create;

  with FViewModel do begin

    ReceiveNotifications := NotificationsReceivingEnabledCheckBox.Checked;

    if Assigned(FOwnNotificationsReceivingEmployeesReferenceForm) then begin

      SelectedOwnNotificationsReceivingUserIds :=
        FOwnNotificationsReceivingEmployeesReferenceForm
          .ChoosenEmployeeRecords
            .FetchEmployeeIdValues;

    end;

  end;

end;

procedure TUserNotificationsSettingsFrame.UpdateViewModelByUserNotificationProfile;
var
    UserNotificationProfile: TUserNotificationProfile;
    Free: IDisposable;
begin

  Screen.Cursor := crHourGlass;

  try

    UserNotificationProfile :=
      FUserNotificationProfileService.GetNotificationProfileForUser(FUserId);

    Free := UserNotificationProfile;

    ViewModel :=
      FViewModelMapper
        .MapUserNotificationsSettingsFormViewModelFrom(UserNotificationProfile);

  finally

    Screen.Cursor := crDefault;

  end;

end;

{$R *.dfm}

end.
