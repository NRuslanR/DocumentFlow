{ refactor: make GetViewModel method idempotential without side-effects }
unit ExtendedDocumentMainInformationFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentMainInformationFrameUnit, StdCtrls, ValidateEditUnit,
  RegExprValidateEditUnit, ComCtrls, ExtCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons, ValidateMemoUnit,
  RegExprValidateMemoUnit,
  DocumentMainInformationFormViewModelUnit,
  DBDataTableFormUnit, HorizontalBoxLayoutManager, VerticalBoxLayoutManager,
  ColumnarCellAlignedLayoutManager, LayoutManager, ValidateRichEdit,
  RegExprValidateRichEdit, EmployeesReferenceFormUnit, EmployeeSetHolder,
  dxSkinsCore, dxSkinsDefaultPainters, BoxLayoutManager, Spin;

type

  TOnDocumentSignersReferenceRequestedEventHandler =
    procedure (
      Sender: TObject;
      var DocumentSignersReference: TEmployeesReferenceForm
    ) of object;

  TOnDocumentResponsiblesReferenceRequestedEventHandler =
    procedure (
      Sender: TObject;
      var DocumentResponsiblesReference: TEmployeesReferenceForm
    ) of object;

  TExtendedDocumentMainInformationFrame = class(TDocumentMainInformationFrame)
    PerformerDepartmentCodeEdit: TRegExprValidateEdit;
    PerformerDepartmentShortNameEdit: TRegExprValidateEdit;
    PerformerLabel: TLabel;
    PerformerFullNameEdit: TRegExprValidateEdit;
    ChooseDocumentPerformerButton: TcxButton;
    PerformerTelephoneNumberLabel: TLabel;
    PerformerTelephoneNumberEdit: TRegExprValidateEdit;
    DocumentSignerLabel: TLabel;
    SignerNameEdit: TRegExprValidateEdit;
    SignerChooseButton: TcxButton;
    SignerDepartmentShortNameEdit: TRegExprValidateEdit;
    SignerDepartmentCodeEdit: TRegExprValidateEdit;
    SigningDateTimeLabel: TLabel;
    SigningDateTimePicker: TDateTimePicker;
    SignedLabel: TLabel;
    ActualSignerNameLabel: TLabel;
    SignerNameAndSigningDateSeparator: TLabel;
    SigningDateLabel: TLabel;
    ProductCodeLabel: TLabel;
    ProductCodeEdit: TRegExprValidateEdit;
    
    procedure SignerChooseButtonClick(Sender: TObject);
    procedure ChooseDocumentPerformerButtonClick(Sender: TObject);
    procedure DocumentInfoPanelResize(Sender: TObject);

  protected

    FOnDocumentSignersReferenceRequestedEventHandler:
      TOnDocumentSignersReferenceRequestedEventHandler;

    FOnDocumentResponsiblesReferenceRequestedEventHandler:
      TOnDocumentResponsiblesReferenceRequestedEventHandler;

    procedure SubscribeOnEvents;

    procedure OnSelfDocumentSignersReferenceRequestedEventHandler(
      Sender: TObject;
      var DocumentSignersReference: TEmployeesReferenceForm
    ); virtual;

    procedure OnDocumentSignerRecordsRefreshRequestedEventHandler(
      Sender: TObject
    ); virtual;

    procedure OnSelfDocumentResponsiblesReferenceRequestedEventHandler(
      Sender: TObject;
      var DocumentResponsiblesReference: TEmployeesReferenceForm
    ); virtual;

    procedure OnDocumentResponsibleRecordsRefreshRequestedEventHandler(
      Sender: TObject
    ); virtual;

  protected

    function GetDocumentResponsibleSetHolder: TEmployeeSetHolder; virtual;
    function GetDocumentSignerSetHolder: TEmployeeSetHolder; virtual;

  protected

    function GetChooseDocumentSigningDateEnabled: Boolean;
    procedure SetChooseDocumentSigningDateEnabled(const Value: Boolean);
    
  protected

    procedure Initialize; override;
    
  protected

    function GetViewModel: TDocumentMainInformationFormViewModel; override;
    procedure SetViewModel(ViewModel: TDocumentMainInformationFormViewModel); override;

  protected

    procedure ChooseSignersFromReference;
    procedure FillSignerUIElementsFromSelectedEmployeeRecord(
      SelectedEmployeeRecord: TDBDataTableRecord
    );

    procedure ChooseDocumentResponsibleFromReference;

    procedure FillDocumentResponsibleUIElementsFromSelectedEmployeeRecord(
      SelectedEmployeeRecord: TDBDataTableRecord
    );

  protected
  
    function GetHorizontalScrollingMinWidth: Integer; override;
    function GetVerticalScrollingMinHeight: Integer; override;

    function CreateLayoutManager: TLayoutManager; override;

    procedure OnFontChanged(var Message: TMessage); message CM_FONTCHANGED;

    procedure SetNotAllowedForEditingControls(Controls:  TList); override;

  protected

    procedure ArrangeRowInfoAboutSignedEmployeeAfterAssignedSignerFullName;

    procedure UpdateActualSignerControlsVisibility;
    
  public

    function IsDataChanged: Boolean; override;

  public

    function ValidateInput: Boolean; override;

  published

    property ChooseDocumentSigningDateEnabled: Boolean
    read GetChooseDocumentSigningDateEnabled
    write SetChooseDocumentSigningDateEnabled;

  published

    property OnDocumentSignersReferenceRequestedEventHandler:
      TOnDocumentSignersReferenceRequestedEventHandler
    read FOnDocumentSignersReferenceRequestedEventHandler
    write FOnDocumentSignersReferenceRequestedEventHandler;

    property OnDocumentResponsiblesReferenceRequestedEventHandler:
      TOnDocumentResponsiblesReferenceRequestedEventHandler
    read FOnDocumentResponsiblesReferenceRequestedEventHandler
    write FOnDocumentResponsiblesReferenceRequestedEventHandler;

  end;

var
  ExtendedDocumentMainInformationFrame: TExtendedDocumentMainInformationFrame;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  DocumentSignerViewModelUnit,
  DocumentSignersReferenceFormUnit,
  DocumentResponsiblesReferenceFormUnit,
  DocumentResponsibleViewModelUnit,
  DocumentResponsibleSetReadService,
  DocumentSignerSetReadService,
  ApplicationServiceRegistries,
  WorkingEmployeeUnit;

{$R *.dfm}

{ TServiceNoteMainInformationFrame }

procedure TExtendedDocumentMainInformationFrame.SignerChooseButtonClick(
  Sender: TObject);
begin

  ChooseSignersFromReference;

end;

procedure TExtendedDocumentMainInformationFrame.SubscribeOnEvents;
begin

  OnDocumentSignersReferenceRequestedEventHandler :=
    OnSelfDocumentSignersReferenceRequestedEventHandler;

  OnDocumentResponsiblesReferenceRequestedEventHandler :=
    OnSelfDocumentResponsiblesReferenceRequestedEventHandler;
    
end;

procedure TExtendedDocumentMainInformationFrame.UpdateActualSignerControlsVisibility;
begin

  SignedLabel.Visible :=
    Assigned(ViewModel)
    and not VarIsNull(ViewModel.SigningDate)
    and not ChooseDocumentSigningDateEnabled;

  ActualSignerNameLabel.Visible := SignedLabel.Visible;
  SignerNameAndSigningDateSeparator.Visible := SignedLabel.Visible;
  SigningDateLabel.Visible := SignedLabel.Visible;

end;

procedure TExtendedDocumentMainInformationFrame.ChooseSignersFromReference;
var
    SignersReference: TEmployeesReferenceForm;
begin

  SignersReference := nil;

  try

    if not Assigned(FOnDocumentSignersReferenceRequestedEventHandler)
    then Exit;
    
    FOnDocumentSignersReferenceRequestedEventHandler(
      Self,
      SignersReference
    );

    if not Assigned(SignersReference) then Exit;

    SignersReference.EnableMultiSelectionMode := False;
    
    if SignersReference.ShowModal <> mrOk then Exit;

    FillSignerUIElementsFromSelectedEmployeeRecord(
      SignersReference.SelectedRecords[0]
    );
    
  finally

    FreeAndNil(SignersReference);
    
  end;

end;

function TExtendedDocumentMainInformationFrame.CreateLayoutManager: TLayoutManager;
var
    RowLayoutItem: TBoxLayoutManager;
begin

  Result := inherited CreateLayoutManager;

  Result.InsertControlAfter(DocumentSignerLabel,DocumentTypeLabel.Name);

  with
    TBoxedLayoutItemVisualSettingsHolder(
      Result.FindVisualSettingsHolderByLayoutItemId(DocumentSignerLabel.Name)
    )
  do begin

    Gap := 8;

  end;
  
  Result.InsertControlAfter(
    PerformerLabel,
    DocumentSignerLabel.Name
  );

  with
    TBoxedLayoutItemVisualSettingsHolder(
      Result.FindVisualSettingsHolderByLayoutItemId(PerformerLabel.Name)
    )
  do begin

    Gap := 8;
    
  end;

  RowLayoutItem :=
    TBoxLayoutManager(
      THorizontalBoxLayoutManagerBuilder.Create.AddControls(
        [
          SignerChooseButton,
          SignerDepartmentCodeEdit,
          SignerDepartmentShortNameEdit,
          SignerNameEdit,
          ProductCodeLabel,
          ProductCodeEdit
        ],
        [-1, 5, 5, 10]
      )
      .SetId('SignerRow')
      .BuildAndDestroy
    );

  Result.InsertLayoutManagerAfter(RowLayoutItem, 'DocumentTypeRow');

  with
    TBoxedLayoutItemVisualSettingsHolder(
      Result.FindVisualSettingsHolderFor(RowLayoutItem)
    )
  do begin

    Gap := 8;

  end;

  RowLayoutItem :=
    TBoxLayoutManager(
      THorizontalBoxLayoutManagerBuilder.Create.AddControls(
        [
          ChooseDocumentPerformerButton,
          PerformerDepartmentCodeEdit,
          PerformerDepartmentShortNameEdit,
          PerformerFullNameEdit,
          PerformerTelephoneNumberLabel,
          PerformerTelephoneNumberEdit
        ],
        [-1, 5, 5, 10]
      )
      .SetId('PerformerRow')
      .BuildAndDestroy
    );

  Result.InsertLayoutManagerAfter(RowLayoutItem, 'SignerRow');

  with
    TBoxedLayoutItemVisualSettingsHolder(
      Result.FindVisualSettingsHolderFor(RowLayoutItem)
    )
  do begin

    Gap := 8;

  end;
  
  if ChooseDocumentSigningDateEnabled then begin

    Result.InsertLayoutManagerAfter(
      THorizontalBoxLayoutManagerBuilder.Create.AddControls(
        [
          SigningDateTimeLabel,
          SigningDateTimePicker
        ],                                                    
        [5, 5]
      ).BuildAndDestroy,
      DocumentCreationDateTimePicker.Name
    );

    SetAnchorsToControls([akRight, akTop], [SigningDateTimeLabel, SigningDateTimePicker]);

  end

  else begin

    Result.InsertLayoutManagerAfter(
      THorizontalBoxLayoutManagerBuilder.Create.AddControls(
        [
          SignedLabel,
          ActualSignerNameLabel,
          SignerNameAndSigningDateSeparator,
          SigningDateLabel
        ]
      ).BuildAndDestroy,
      SignerNameEdit.Name
    );
    
  end;

end;

procedure TExtendedDocumentMainInformationFrame.DocumentInfoPanelResize(
  Sender: TObject);
begin

  inherited;

  ArrangeRowInfoAboutSignedEmployeeAfterAssignedSignerFullName;
    
end;

procedure TExtendedDocumentMainInformationFrame.
  ArrangeRowInfoAboutSignedEmployeeAfterAssignedSignerFullName;
var
    SignerNameWidth: Integer;
    AncestorCanvas: TCanvas;
begin

  if SignedLabel.Visible then begin

    if Trim(SignerNameEdit.Text) = '' then
      SignerNameEdit.Width := SignedLabel.Left - SignerNameEdit.Left - 5

    else begin

      AncestorCanvas := GetAncestorCanvasFor(Self);

      SignerNameWidth := AncestorCanvas.TextWidth(SignerNameEdit.Text);

      SignerNameEdit.Width := SignerNameWidth + 15;

      SignedLabel.Left := SignerNameEdit.Left + SignerNameEdit.Width + 5;
      ActualSignerNameLabel.Left := SignedLabel.Left + SignedLabel.Width + 5;

      SignerNameAndSigningDateSeparator.Left :=
        ActualSignerNameLabel.Left + ActualSignerNameLabel.Width + 5;

      SigningDateLabel.Left :=
        SignerNameAndSigningDateSeparator.Left +
        SignerNameAndSigningDateSeparator.Width + 5;

    end;

  end

  else begin

    SignerNameEdit.Width :=
      PerformerFullNameEdit.Left + PerformerFullNameEdit.Width - SignerNameEdit.Left;
    
  end;
  
end;

procedure TExtendedDocumentMainInformationFrame.ChooseDocumentPerformerButtonClick(
  Sender: TObject);
begin

  ChooseDocumentResponsibleFromReference;
  
end;

procedure TExtendedDocumentMainInformationFrame.ChooseDocumentResponsibleFromReference;
var DocumentResponsiblesReferenceForm: TEmployeesReferenceForm;
begin

  DocumentResponsiblesReferenceForm := nil;

  try

    if not Assigned(FOnDocumentResponsiblesReferenceRequestedEventHandler)
    then Exit;

    FOnDocumentResponsiblesReferenceRequestedEventHandler(
      Self, DocumentResponsiblesReferenceForm
    );

    if not Assigned(DocumentResponsiblesReferenceForm) then Exit;

    DocumentResponsiblesReferenceForm.EnableMultiSelectionMode := False;

    if DocumentResponsiblesReferenceForm.ShowModal <> mrOk then Exit;

    FillDocumentResponsibleUIElementsFromSelectedEmployeeRecord(
      DocumentResponsiblesReferenceForm.SelectedRecords[0]
    );
    
  finally

    FreeAndNil(DocumentResponsiblesReferenceForm);

  end;
  
end;

procedure TExtendedDocumentMainInformationFrame.FillSignerUIElementsFromSelectedEmployeeRecord(
  SelectedEmployeeRecord: TDBDataTableRecord
);
begin

  FViewModel.DocumentSignerViewModel.Id :=
    SelectedEmployeeRecord['id'];

    { Employee Reference отнаследовать от DBTableRecord и
    определить там свойства, которые будут обращаться к полям по имени }
  SignerNameEdit.Text :=
    SelectedEmployeeRecord['surname'] + ' ' +
    SelectedEmployeeRecord['name'] + ' ' +
    SelectedEmployeeRecord['patronymic'];

  {
  SignerSpecialityEdit.Text :=
    SelectedEmployeeRecord['speciality'];   }

  SignerDepartmentCodeEdit.Text :=
    SelectedEmployeeRecord['department_code'];
    
  SignerDepartmentShortNameEdit.Text :=
    SelectedEmployeeRecord['department_short_name'];
  {
  SignerPersonnelNumberEdit.Text :=
    SelectedEmployeeRecord['personnel_number'];   }

end;

procedure TExtendedDocumentMainInformationFrame.FillDocumentResponsibleUIElementsFromSelectedEmployeeRecord(
  SelectedEmployeeRecord: TDBDataTableRecord);
begin

  FViewModel.DocumentResponsibleViewModel.Id := SelectedEmployeeRecord['id'];

  PerformerFullNameEdit.Text :=
    SelectedEmployeeRecord['surname'] + ' ' +
    SelectedEmployeeRecord['name'] + ' ' +
    SelectedEmployeeRecord['patronymic'];

  PerformerDepartmentCodeEdit.Text :=
    SelectedEmployeeRecord['department_code'];
 {
  PerformerPersonnelNumberEdit.Text :=
    SelectedEmployeeRecord['personnel_number']; }

  if not VarIsNull(SelectedEmployeeRecord['telephone_number'])
  then begin

    PerformerTelephoneNumberEdit.Text :=
      SelectedEmployeeRecord['telephone_number'];

  end

  else PerformerTelephoneNumberEdit.Text := '';
  
  PerformerDepartmentShortNameEdit.Text :=
    SelectedEmployeeRecord['department_short_name'];
    
end;

function TExtendedDocumentMainInformationFrame.GetChooseDocumentSigningDateEnabled: Boolean;
begin

  Result := SigningDateTimePicker.Visible;
  
end;

function TExtendedDocumentMainInformationFrame.
  GetDocumentResponsibleSetHolder: TEmployeeSetHolder;

var DocumentResponsibleSetReadService: IDocumentResponsibleSetReadService;
begin

  { Refactor: в контроллер ! }

  try

    DocumentResponsibleSetReadService :=
      TApplicationServiceRegistries.
      Current.
      GetPresentationServiceRegistry.
      GetDocumentResponsibleSetReadService(ServiceDocumentKind);

    Result:=
      DocumentResponsibleSetReadService.
        GetDocumentResponsibleSetForEmployee(
          WorkingEmployeeId
        );

  finally

  end;

end;

function TExtendedDocumentMainInformationFrame.
  GetDocumentSignerSetHolder: TEmployeeSetHolder;
var DocumentSignerSetReadService: IDocumentSignerSetReadService;
begin

  { Refactor: вынести в отдельный контроллер данного фрейма }

  DocumentSignerSetReadService :=
    TApplicationServiceRegistries.
    Current.
    GetPresentationServiceRegistry.
    GetDocumentSignerSetReadService(ServiceDocumentKind);

  Result :=
    DocumentSignerSetReadService.
      FindAllPossibleDocumentSignerSetForEmployee(WorkingEmployeeId);

end;

function TExtendedDocumentMainInformationFrame.GetHorizontalScrollingMinWidth: Integer;
begin

  Result := inherited GetHorizontalScrollingMinWidth;
  
end;

function TExtendedDocumentMainInformationFrame.GetVerticalScrollingMinHeight: Integer;
begin

  Result :=  inherited GetVerticalScrollingMinHeight;
  
end;

procedure TExtendedDocumentMainInformationFrame.Initialize;
begin

  inherited;

  SubscribeOnEvents;

  ChooseDocumentSigningDateEnabled := False;
  
end;

function TExtendedDocumentMainInformationFrame.IsDataChanged: Boolean;
begin

  if
    Assigned(FInitialViewModel)
    and not VarIsNull(FInitialViewModel.DocumentId)
  then begin
  
    Result :=
      Assigned(FInitialViewModel)
      and (
        inherited IsDataChanged or
        (PerformerFullNameEdit.Text <> FInitialViewModel.DocumentResponsibleViewModel.Name) or
        (PerformerTelephoneNumberEdit.Text <> FInitialViewModel.DocumentResponsibleViewModel.TelephoneNumber) or
        (SignerNameEdit.Text <> FInitialViewModel.DocumentSignerViewModel.Name) or
        (not VarIsNull(FInitialViewModel.ProductCode) and (ProductCodeEdit.Text <> FInitialViewModel.ProductCode))
      );

  end

  else begin

    Result :=
      inherited IsDataChanged or
      (Trim(PerformerFullNameEdit.Text) <> '') or
      (Trim(PerformerTelephoneNumberEdit.Text) <> '') or
      (Trim(SignerNameEdit.Text) <> '') or
      (Trim(ProductCodeEdit.Text) <> '');
  
  end;

end;

procedure TExtendedDocumentMainInformationFrame.
  OnDocumentResponsibleRecordsRefreshRequestedEventHandler(
    Sender: TObject
  );
var DocumentResponsibleReferenceForm: TDocumentResponsiblesReferenceForm;
begin

  try

    Screen.Cursor := crHourGlass;

    DocumentResponsibleReferenceForm :=
      Sender as TDocumentResponsiblesReferenceForm;

    DocumentResponsibleReferenceForm.DataSetHolder :=
      GetDocumentResponsibleSetHolder;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TExtendedDocumentMainInformationFrame.
  OnDocumentSignerRecordsRefreshRequestedEventHandler(
    Sender: TObject
  );
var DocumentSignersReferenceForm: TDocumentSignersReferenceForm;
begin

  Screen.Cursor := crHourGlass;

  try

    DocumentSignersReferenceForm :=
      Sender as TDocumentSignersReferenceForm;

    DocumentSignersReferenceForm.DataSetHolder := GetDocumentSignerSetHolder;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TExtendedDocumentMainInformationFrame.OnFontChanged(var Message: TMessage);
begin

  inherited;

  ChooseDocumentPerformerButton.Height := PerformerDepartmentCodeEdit.Height;
  SignerChooseButton.Height := SignerDepartmentCodeEdit.Height;
  
end;

procedure TExtendedDocumentMainInformationFrame.
  OnSelfDocumentResponsiblesReferenceRequestedEventHandler(
    Sender: TObject;
    var DocumentResponsiblesReference: TEmployeesReferenceForm
  );
begin

  try

    Screen.Cursor := crHourGlass;
    
    DocumentResponsiblesReference :=
      TDocumentResponsiblesReferenceForm.Create(Self);

    DocumentResponsiblesReference.
      OnEmployeeRecordsRefreshRequestedEventHandler :=
        OnDocumentResponsibleRecordsRefreshRequestedEventHandler;

    DocumentResponsiblesReference.DataSetHolder :=
      GetDocumentResponsibleSetHolder;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TExtendedDocumentMainInformationFrame.
  OnSelfDocumentSignersReferenceRequestedEventHandler(
    Sender: TObject;
    var DocumentSignersReference: TEmployeesReferenceForm
  );
begin

  try

    Screen.Cursor := crHourGlass;
    
    DocumentSignersReference := TDocumentSignersReferenceForm.Create(Self);

    DocumentSignersReference.OnEmployeeRecordsRefreshRequestedEventHandler :=
      OnDocumentSignerRecordsRefreshRequestedEventHandler;

    DocumentSignersReference.DataSetHolder := GetDocumentSignerSetHolder;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TExtendedDocumentMainInformationFrame.SetChooseDocumentSigningDateEnabled(
  const Value: Boolean);
begin

  SigningDateTimeLabel.Visible := Value;
  SigningDateTimePicker.Visible := Value;
  SigningDateTimePicker.Enabled := Value;

  SigningDateTimePicker.DateTime := Now;

  BuildLayout;
  
end;

procedure TExtendedDocumentMainInformationFrame.
  SetNotAllowedForEditingControls(
    Controls: TList
  );
begin

  inherited;
  
  Controls.Add(PerformerDepartmentCodeEdit);
  Controls.Add(PerformerDepartmentShortNameEdit);
  Controls.Add(PerformerFullNameEdit);
  Controls.Add(SignerDepartmentCodeEdit);
  Controls.Add(SignerDepartmentShortNameEdit);
  Controls.Add(SignerNameEdit);

end;

function TExtendedDocumentMainInformationFrame.GetViewModel: TDocumentMainInformationFormViewModel;
begin

  Result := inherited GetViewModel;

  if not Assigned(Result) then Exit;

  with Result do begin

    ProductCode := ProductCodeEdit.Text;

    begin

      DocumentSignerViewModel.Name :=
        SignerNameEdit.Text;

      DocumentSignerViewModel.DepartmentCode :=
        SignerDepartmentCodeEdit.Text;
        
      DocumentSignerViewModel.DepartmentShortName :=
        SignerDepartmentShortNameEdit.Text;

      ActualSignerName :=
        ActualSignerNameLabel.Caption;

      if ChooseDocumentSigningDateEnabled then
        SigningDate := SigningDateTimePicker.DateTime
        
    end;

    begin

      DocumentResponsibleViewModel.Name := PerformerFullNameEdit.Text;

      DocumentResponsibleViewModel.TelephoneNumber :=
        PerformerTelephoneNumberEdit.Text;

      DocumentResponsibleViewModel.DepartmentCode :=
        PerformerDepartmentCodeEdit.Text;

      DocumentResponsibleViewModel.DepartmentShortName :=
        PerformerDepartmentShortNameEdit.Text;

    end;
    
  end;
  
end;

procedure TExtendedDocumentMainInformationFrame.SetViewModel(
  ViewModel: TDocumentMainInformationFormViewModel
);
begin

  inherited SetViewModel(ViewModel);

  ProductCodeEdit.Text := VarToStr(ViewModel.ProductCode);
  
  begin
  
    PerformerFullNameEdit.Text :=
      ViewModel.DocumentResponsibleViewModel.Name;

    PerformerDepartmentCodeEdit.Text :=
      ViewModel.DocumentResponsibleViewModel.DepartmentCode;

    PerformerDepartmentShortNameEdit.Text :=
      ViewModel.DocumentResponsibleViewModel.DepartmentShortName;

    PerformerTelephoneNumberEdit.Text :=
      ViewModel.DocumentResponsibleViewModel.TelephoneNumber;

  end;

  begin

    SignerNameEdit.Text :=
      ViewModel.DocumentSignerViewModel.Name;

    SignerDepartmentCodeEdit.Text :=
      ViewModel.DocumentSignerViewModel.DepartmentCode;

    SignerDepartmentShortNameEdit.Text :=
      ViewModel.DocumentSignerViewModel.DepartmentShortName;

    ActualSignerNameLabel.Caption := ViewModel.ActualSignerName;

    if ChooseDocumentSigningDateEnabled then begin

      if not VarIsNull(ViewModel.SigningDate) then
        SigningDateTimePicker.DateTime := ViewModel.SigningDate

    end

    else if not VarIsNull(ViewModel.SigningDate) then
      SigningDateLabel.Caption :=  DateTimeToStr(ViewModel.SigningDate)

    else SigningDateLabel.Caption := '';

    UpdateActualSignerControlsVisibility;
    
    ArrangeRowInfoAboutSignedEmployeeAfterAssignedSignerFullName;

  end;

end;

function TExtendedDocumentMainInformationFrame.ValidateInput: Boolean;
var IsSignerNameValid: Boolean;
    IsPerformerTelephoneNumberValid: Boolean;
    IsProductCodeValid: Boolean;
begin

  SignerDepartmentCodeEdit.IsValid;
  SignerDepartmentShortNameEdit.IsValid;

  IsSignerNameValid :=
    SignerNameEdit.IsValid;

  IsPerformerTelephoneNumberValid :=
    PerformerTelephoneNumberEdit.IsValid;

  IsProductCodeValid := ProductCodeEdit.IsValid;
  
  PerformerDepartmentCodeEdit.IsValid;
  PerformerDepartmentShortNameEdit.IsValid;
  PerformerFullNameEdit.IsValid;
  
  Result :=
    inherited ValidateInput
    and IsSignerNameValid
    and IsPerformerTelephoneNumberValid
    and IsProductCodeValid;

end;

end.
