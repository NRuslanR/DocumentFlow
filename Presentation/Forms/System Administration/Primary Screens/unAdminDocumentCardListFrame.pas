unit unAdminDocumentCardListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardListFrame, StdCtrls, ExtCtrls, DocumentKinds,
  DocumentStorageService,
  DocumentSetHolder,
  unSelectionDepartmentsReferenceForm,
  DepartmentRecordViewModel,
  VariantListUnit,
  EmployeeDocumentSetReadService;

type
  TAdminDocumentCardListFrame = class(TDocumentCardListFrame)
    SplitterBetweenDocumentsAndDepartments: TSplitter;
    DepartmentsPanel: TPanel;
    DepartmentsLabel: TLabel;
    DepartmentsChooseFormPanel: TPanel;
    DepartmentsLabelPanel: TPanel;
    procedure FrameResize(Sender: TObject);
    procedure DepartmentsLabelPanelResize(Sender: TObject);

  private

    FSelectedDepartmentIds: TVariantList;
    FSelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm;

    procedure SetSelectionDepartmentsReferenceForm(
      SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
    );
    
    procedure InflateAndShowSelectionDepartmentsReferenceForm(
      SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
    );

    procedure SubscribeOnSelectionDepartmentsReferenceFormEvents(
      SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
    );

  private

    procedure OnDepartmentSelectionChangedEventHandler(
      Sender: TObject;
      DepartmentRecordViewModel: TDepartmentRecordViewModel
    );

  protected

    procedure Initialize; override;

  protected

    function GetDocumentSetHolder(
      const ServiceDocumentKind: TDocumentKindClass;
      const EmployeeId: Variant;
      const Options: IEmployeeDocumentSetReadOptions = nil
    ): TDocumentSetHolder; override;

    function GetDocumentSetByIds(
      const DocumentKindId: Variant;
      DocumentIds: array of Variant
    ): TDocumentSetHolder; override;

    function GetDocumentStorageService(
      const ServiceDocumentKind: TDocumentKindClass
    ): IDocumentStorageService; override;

  protected

    procedure ApplyUIStyles; override;

    procedure OnClose; override;
    procedure OnShow; override;
    
  public

    destructor Destroy; override;
    
    constructor Create(
      AOwner: TComponent;
      SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
    ); overload;

    constructor Create(
      AOwner: TComponent;
      const RestoreUIControlPropertiesOnCreate: Boolean;
      const SaveUIControlPropertiesOnDestroy: Boolean;
      SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
    ); overload;

  end;

var
  AdminDocumentCardListFrame: TAdminDocumentCardListFrame;

implementation

uses

  AdminDocumentStorageService,
  AdminDocumentSetReadService,
  ApplicationServiceRegistries,
  CommonControlStyles,
  AuxWindowsFunctionsUnit, SystemServiceRegistry;

{$R *.dfm}

{ TAdminDocumentCardListFrame }

constructor TAdminDocumentCardListFrame.Create(
  AOwner: TComponent;
  SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
);
begin

  inherited Create(AOwner);

  SetSelectionDepartmentsReferenceForm(SelectionDepartmentsReferenceForm);
  
end;

procedure TAdminDocumentCardListFrame.ApplyUIStyles;
begin

  inherited ApplyUIStyles;

  DepartmentsPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;

  DepartmentsLabelPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;

  DepartmentsChooseFormPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;
    
end;

constructor TAdminDocumentCardListFrame.Create(
  AOwner: TComponent;
  const RestoreUIControlPropertiesOnCreate,
  SaveUIControlPropertiesOnDestroy: Boolean;
  SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
);
begin

  inherited Create(
    AOwner,
    RestoreUIControlPropertiesOnCreate,
    SaveUIControlPropertiesOnDestroy
  );

  SetSelectionDepartmentsReferenceForm(SelectionDepartmentsReferenceForm);

end;

procedure TAdminDocumentCardListFrame.DepartmentsLabelPanelResize(
  Sender: TObject);
begin

  inherited;

  CenterWindowRelativeByHorz(DepartmentsLabel, DepartmentsLabelPanel);

end;

destructor TAdminDocumentCardListFrame.Destroy;
begin

  if Assigned(FSelectionDepartmentsReferenceForm) then begin

    FSelectionDepartmentsReferenceForm.Parent.RemoveControl(FSelectionDepartmentsReferenceForm);

    if Assigned(FSelectionDepartmentsReferenceForm.Owner) then
      FSelectionDepartmentsReferenceForm.Owner.RemoveComponent(FSelectionDepartmentsReferenceForm);

    FSelectionDepartmentsReferenceForm.SafeDestroy;
    
  end;

  FreeAndNil(FSelectedDepartmentIds);

  inherited;
  
end;

procedure TAdminDocumentCardListFrame.FrameResize(Sender: TObject);
begin

  inherited;

  PanelForDocumentRecordsAndCard.Width :=
    ClientWidth - FSelectionDepartmentsReferenceForm.Constraints.MinWidth;

  CenterWindowRelativeByHorz(DepartmentsLabel, DepartmentsChooseFormPanel);

  DepartmentsLabel.Font.Style := [fsBold];
  
end;

function TAdminDocumentCardListFrame.GetDocumentSetByIds(
  const DocumentKindId: Variant;
  DocumentIds: array of Variant
): TDocumentSetHolder;
var
    AdminDocumentSetReadService: IAdminDocumentSetReadService;
begin

  AdminDocumentSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetSystemServiceRegistry
          .GetAdminDocumentSetReadService(
            GetDocumentKindFromIdForApplicationServicing(DocumentKindId)
          );

  Result :=
    AdminDocumentSetReadService.GetAdminDocumentSetByIds(
      WorkingEmployeeId,
      DocumentIds
    );
    
end;

function TAdminDocumentCardListFrame.GetDocumentSetHolder(
  const ServiceDocumentKind: TDocumentKindClass;
  const EmployeeId: Variant;
  const Options: IEmployeeDocumentSetReadOptions
): TDocumentSetHolder;
var
    AdminDocumentSetReadService: IAdminDocumentSetReadService;
begin

  AdminDocumentSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetSystemServiceRegistry
          .GetAdminDocumentSetReadService(ServiceDocumentKind);

  Result :=
    AdminDocumentSetReadService
      .GetAdminDocumentSet(WorkingEmployeeId, FSelectedDepartmentIds);

end;

function TAdminDocumentCardListFrame.GetDocumentStorageService(
  const ServiceDocumentKind: TDocumentKindClass
): IDocumentStorageService;
begin

  Result :=
    TApplicationServiceRegistries
      .Current
        .GetSystemServiceRegistry
          .GetAdminDocumentStorageService(ServiceDocumentKind);

end;

procedure TAdminDocumentCardListFrame.InflateAndShowSelectionDepartmentsReferenceForm(
  SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
);
begin

  SelectionDepartmentsReferenceForm.Width := 200;
  DepartmentsPanel.Width := SelectionDepartmentsReferenceForm.Width;

  SelectionDepartmentsReferenceForm.Parent := DepartmentsChooseFormPanel;
  SelectionDepartmentsReferenceForm.BorderStyle := bsNone;
  SelectionDepartmentsReferenceForm.Align := alClient;
  SelectionDepartmentsReferenceForm.Show;
  
end;

procedure TAdminDocumentCardListFrame.Initialize;
begin

  inherited;

  FSelectedDepartmentIds := TVariantList.Create;
  
end;

procedure TAdminDocumentCardListFrame.OnClose;
begin

  inherited;

end;

procedure TAdminDocumentCardListFrame.OnDepartmentSelectionChangedEventHandler(
  Sender: TObject;
  DepartmentRecordViewModel: TDepartmentRecordViewModel
);
begin

  if DepartmentRecordViewModel.IsSelected then
    FSelectedDepartmentIds.Add(DepartmentRecordViewModel.Id)

  else FSelectedDepartmentIds.Remove(DepartmentRecordViewModel.Id);

  if Assigned(FBaseDocumentsReferenceForm) then
    ShowEmployeeDocumentReferenceFormForDocumentKind(CurrentDocumentKindInfo.UIDocumentKind);
  
end;

procedure TAdminDocumentCardListFrame.OnShow;
begin

  inherited;

  if not Assigned(FSelectionDepartmentsReferenceForm) then Exit;

  InflateAndShowSelectionDepartmentsReferenceForm(
    FSelectionDepartmentsReferenceForm
  );

end;

procedure TAdminDocumentCardListFrame.SetSelectionDepartmentsReferenceForm(
  SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm);
begin

  FSelectionDepartmentsReferenceForm := SelectionDepartmentsReferenceForm;

  SubscribeOnSelectionDepartmentsReferenceFormEvents(
    SelectionDepartmentsReferenceForm
  );
  
end;

procedure TAdminDocumentCardListFrame.
  SubscribeOnSelectionDepartmentsReferenceFormEvents(
    SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
  );
begin

  SelectionDepartmentsReferenceForm.OnDepartmentSelectionChangedEventHandler :=
    OnDepartmentSelectionChangedEventHandler;

end;

end.
