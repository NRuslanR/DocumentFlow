unit DocumentFlowWorkingFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, dxSkinsCore,
  dxSkinsDefaultPainters, ActnList, Menus, StdCtrls, cxInplaceContainer,
  cxTLData, cxDBTL, ExtCtrls, cxMaskEdit,
  BaseEmployeeDocumentsReferenceFormUnit,
  unDocumentCardFrame,
  DocumentCardViewModelUnit,
  DocumentMainInformationFormViewModelUnit,
  EmployeeDocumentsReferenceFormFactoryUnit,
  EmployeeDocumentWorkStatisticsService,
  EmployeeDocumentWorkStatistics, DocumentTypesPanelController,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  VariantListUnit, UIDocumentKindResolver, UIDocumentKindMapper,
  EmployeeDocumentsReferenceViewModelFactory,
  DocumentKinds, UIDocumentKinds,
  EmployeesReferenceFormUnit,
  DocumentApprovingViewModel,
  DocumentApprovingCycleViewModel,
  AbstractDocumentDataSetHoldersFactory,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentFullInfoDTO,
  DocumentApprovingsFormViewModel,
  DocumentRecordViewModel,
  ControlParentSwitchingFormUnit,
  UINativeDocumentKindResolver,
  DocumentKindResolver,
  GlobalDocumentKindDto,
  NativeDocumentKindDto,
  EmployeeDocumentsReferenceFormPresenter,
  DBClient;

const

  DEFAULT_BACKGROUND_COLOR_OF_PANELS = $00f8e4d8;
  DEFAULT_COLOR_OF_PANEL_SEPARATORS = $00c8b594;
  WM_DESTROY_OLD_DOCUMENT_CARD = WM_USER + 1;
  WM_UPDATE_DOCUMENT_CARD_AFTER_APPROVING_COMPLETING_MESSAGE = WM_USER + 2;
  WM_DESTROY_OLD_EMPLOYEE_DOCUMENTS_REFERENCE_FORM = WM_USER + 3;
  
type

  TDocumentCardChangesConfirmingResult = (

    DocumentCardChangesConfirmed,
    DocumentCardChangesNotConfirmed

  );

  TOnRelatedDocumentSelectionFormRequestedEventHandler =
    procedure (
      Sender: TObject;
      var RelatedDocumentSelectionForm: TForm
    ) of object;

  TDocumentFlowWorkingForm = class(TForm)
    DocumentTypesPanel: TPanel;
    SeparatorBetweenDocumentTypesAndRest: TSplitter;
    PanelForDocumentRecordsAndCard: TPanel;
    DocumentListPanel: TPanel;
    SeparatorBetweenDocumentRecordsAndDocumentCard: TSplitter;
    DocumentCardPanel: TPanel;
    DocumentKindTreeList: TcxDBTreeList;
    DocumentKindsLabel: TLabel;
    DocumentListLabel: TLabel;
    DocumentRecordsGridPanel: TPanel;
    DocumentCardLabel: TLabel;
    DocumentCardFormPanel: TPanel;
    DocumentKindNameColumn: TcxDBTreeListColumn;
    DocumentKindIdColumn: TcxDBTreeListColumn;
    TopLevelDocumentKindIdColumn: TcxDBTreeListColumn;
    DocumentKindOriginalNameColumn: TcxDBTreeListColumn;
    DocumentTypesDataSource: TDataSource;

    procedure DocumentListPanelResize(Sender: TObject);
    procedure DocumentCardPanelResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DocumentKindTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure DocumentKindTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure DocumentKindTreeListResize(Sender: TObject);
    procedure FormResize(Sender: TObject);

  protected

    FRequestedFocuseableDocumentId: Variant;
    FUIDocumentKindResolver: IUIDocumentKindResolver;
    FUINativeDocumentKindResolver: IUINativeDocumentKindResolver;
    //FDocumentKindResolver: IDocumentKindResolver;
    FDocumentDataSetHoldersFactory: TAbstractDocumentDataSetHoldersFactory;

    FBaseEmployeeDocumentsReferenceForm: TBaseEmployeeDocumentsReferenceForm;

    FDetachableDocumentCardForm: TControlParentSwitchingForm;
    
    FSelectedDocumentCardFrame: TDocumentCardFrame;

    FEmployeeDocumentsReferenceFormFactory:
      TEmployeeDocumentsReferenceFormFactory;

    FEmployeeDocumentsReferenceViewModelFactory:
      TEmployeeDocumentsReferenceViewModelFactory;

    FOnRelatedDocumentSelectionFormRequestedEventHandler:
      TOnRelatedDocumentSelectionFormRequestedEventHandler;
      
    FDocumentTypesPanelController: TDocumentTypesPanelController;

    FEmployeeDocumentsReferenceFormPresenter: IEmployeeDocumentsReferenceFormPresenter;    

  private

    FNativeDocumentKindDtos: TNativeDocumentKindDtos;
    FGlobalDocumentKindDtos: TGlobalDocumentKindDtos;

  {private refactor} public
  
    procedure OnApprovingDocumentSendingRequestedEventHanlder(
      Sender: TObject
    );

    procedure OnDocumentApprovingRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentApprovingRejectingRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentSendingToSigningRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentRecordsRefreshRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentRecordsRefreshedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentInfoSavingRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentDeletingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant
    );

    procedure OnDocumentRecordDeletedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentPerformingRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentChargesPerformingRequestedEventHandler(
      Sender: TObject;
      RequestedChargeIds: TVariantList
    );
    
    procedure OnDocumentRejectingFromSigningRequestedEventHandler(
      Sender: TObject
    );
      procedure RejectSigningOfCurrentDocument;

    procedure OnNewDocumentCreatingRequestedEventHandler(
      Sender:  TObject;
      var DocumentCardFrame: TDocumentCardFrame
    );

    procedure OnNewDocumentCreatingConfirmedEventHandler(
      Sender:  TObject;
      DocumentCardFrame: TDocumentCardFrame
    );
      procedure CreateNewDocumentFrom(
        DocumentCardFrame: TDocumentCardFrame
      );

    procedure OnNewDocumentCreatingFinishedEventHandler(
      Sender: TObject;
      DocumentCardFrame: TDocumentCardFrame
    );

    procedure OnDocucmentRecordFocusedEventHandler(
      Sender: TObject;
      PreviousFocusedDocumentRecordViewModel: TDocumentRecordViewModel;
      FocusedDocumentRecordViewModel: TDocumentRecordViewModel
    );

    procedure OnDocumentRecordChangingRequestedEventHandler(
      Sender: TObject;
      DocumentRecordViewModel: TDocumentRecordViewModel
    );
    
    procedure OnSelectedDocumentRecordChangingEventHandler(
      Sender: TObject
    );
    
    procedure OnSelectedDocumentRecordChangedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentChargeSheetsChangesSavingRequestedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentRecordsLoadingSuccessEventHandler(
      Sender: TObject
    );

    procedure OnDocumentRecordsLoadingFailedEventHandler(
      Sender: TObject;
      const Error: Exception
    );

    procedure OnDocumentRecordsLoadingCanceledEventHandler(
      Sender: TObject
    );

    procedure OnDocumentFileOpeningRequestedEventHandler(
      Sender: TObject;
      const DocumentFileId: Variant;
      var DocumentFilePath: String
    );
    
    procedure OnDocumentSigningRequestedEventHandler(
      Sender: TObject
    );

    procedure OnRelatedDocumentCardOpeningRequestedEventHandler(
      Sender: TObject;
      const RelatedDocumentId, RelatedDocumentKindId: Variant;
      const SourceDocumentId, SourceDocumentKindId: Variant
    );

    procedure OnDocumentPrintFormRequestedEventHandler(
      Sender: TObject;
      DocumentCardViewModel: TDocumentCardViewModel
    );

    procedure OnDocumentApprovingChangingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      ApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure OnDocumentApprovingCycleSelectedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      SelectedCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCompletingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      CycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCycleRemovingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      CycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingsRemovingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure OnEmployeesAddingForApprovingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      EmployeeIds: TVariantList
    );

    procedure OnNewDocumentApprovingCycleCreatingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnRespondingDocumentCreatingFinishedEventHandler(
      Sender: TObject;
      RespondingDocumentCardFrame: TDocumentCardFrame
    );

    procedure SetBaseEmployeeDocumentsReferenceForm(
      const Value: TBaseEmployeeDocumentsReferenceForm);
    procedure SetCurrentDocumentKindSectionId(const Value: Variant);
    procedure SetDocumentDataSetHoldersFactory(
      const Value: TAbstractDocumentDataSetHoldersFactory);

  public

    procedure OnDetachableDocumentCardFormDeleteEventHandler(
      Sender: TObject
    );

  public
    
    function GetGlobalDocumentKindDtos: TGlobalDocumentKindDtos;
    procedure SetGlobalDocumentKindDtos(const Value: TGlobalDocumentKindDtos);

    function GetNativeDocumentKindDtos: TNativeDocumentKindDtos;
    procedure SetNativeDocumentKindDtos(const Value: TNativeDocumentKindDtos);

    property NativeDocumentKindDtos: TNativeDocumentKindDtos
    read GetNativeDocumentKindDtos write SetNativeDocumentKindDtos;
    
    property GlobalDocumentKindDtos: TGlobalDocumentKindDtos
    read GetGlobalDocumentKindDtos write SetGlobalDocumentKindDtos;

  public

    procedure InitializeLayout;
    procedure CreateRequiredComponents;
    procedure AssignColorToPanels;

    procedure RefreshDocumentTypesDataSetIfNecessary;
    
    procedure UpdateUIForCurrentDocumentKind;

    procedure ShowDocumentCardForCurrentDocumentRecord;
    procedure ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
    procedure ShowCardForDocumentAndUpdateRelatedDocumentRecord(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

    procedure ShowCardForDocumentAsSeparatedFormForViewOnly(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

    procedure CustomizeDocumentCardFrame(
      DocumentCardFrame: TDocumentCardFrame
    ); virtual;

    procedure QueueOldDocumentCardDestroyMessage;
    procedure QueueUpdateDocumentCardAfterApprovingCompletingMessageHandler;

    procedure QueueOldEmployeeDocumentsReferenceFormDestroyingMessage(
      OldEmployeeDocumentsReferenceForm: TBaseEmployeeDocumentsReferenceForm
    );

    procedure OldDocumentCardDestroyMessageHandler(
      var Message: TMessage
    ); message WM_DESTROY_OLD_DOCUMENT_CARD;

    procedure UpdateDocumentCardAfterApprovingCompletingMessageHandler(
      var Message: TMessage
    ); message WM_UPDATE_DOCUMENT_CARD_AFTER_APPROVING_COMPLETING_MESSAGE;

    procedure QueueOldEmployeeDocumentsReferenceFormDestroyingMessageHandler(
      var Message: TMessage
    ); message WM_DESTROY_OLD_EMPLOYEE_DOCUMENTS_REFERENCE_FORM;

    procedure AssignEventHandlersToDocumentCardFrame(
      DocumentCardFrame: TDocumentCardFrame
    );

    procedure ShowEmployeeDocumentReferenceFormForDocumentKind(
      UIDocumentKind: TUIDocumentKindClass
    );

    procedure CustomizeBaseEmployeeDocumentsReferenceForm(
      EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm
    ); virtual;

    procedure InflateEmployeeDocumentReferenceFormToLayout(
      EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm
    );
    
    procedure AssignEventHandlersToEmployeeDocumentReferenceForm(
      EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm
    );

    procedure
      AddNewDocumentRecordToBaseEmployeeDocumentsReferenceFormFrom(
        DocumentCardViewModel: TDocumentCardViewModel
      );

    procedure
      ChangeDocumentRecordInBaseEmployeeDocumentsReferenceFormFrom(
        DocumentCardViewModel: TDocumentCardViewModel
      );

    procedure AssignDocumentCardFrame(
      DocumentCardFrame: TDocumentCardFrame
    );

    procedure ShowEmptyNoActivedDocumentCardForCurrentDocumentKindIfDocumentsAreAbsent;
    procedure ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

    procedure ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;

    function RequestUserConfirmDocumentCardChangesIfNecessary: TDocumentCardChangesConfirmingResult;
    procedure RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

    procedure GetEmployeeDocumentWorkStatisticsAsync;

    procedure OnDocumentWorkStatisticsFetchedEventHandler(
      Sender: Tobject;
      EmployeeDocumentWorkStatisticsList:
        TEmployeeDocumentWorkStatisticsList
    );
    
    procedure OnDocumentWorkStatisticsFetchingErrorEventHandler(
      Sender: TObject;
      const Error: Exception
    );

    procedure UpdateEmployeeDocumentWorkStatistics;
    procedure UpdateCurrentEmployeeDocumentKindWorkStatistics;

    procedure UpdateEmployeeChargesWorkStatisticsForDocument(
      const DocumentId: Variant
    );

    procedure SetCurrentDocumentKindSection(
      UIDocumentKindSection: TUIDocumentKindClass
    );
    function IsCurrentDocumentKindSectionValid: Boolean;

    function GetDocumentTypesDataSet: TDataSet;
    procedure SetDocumentTypesDataSet(const Value: TDataSet);

    procedure GetCardFormViewModelAndAvailableActionListForDocument(
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      var DocumentCardViewModel: TDocumentCardViewModel;
      var AvailableActionList: TDocumentUsageEmployeeAccessRightsInfoDTO
    );

    function CreateDocumentCardFormViewModelFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentFullInfoDTO: TDocumentFullInfoDTO;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    ): TDocumentCardViewModel;

    function CreateDocumentCardFrameFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentCardFormViewModel: TDocumentCardViewModel;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    ): TDocumentCardFrame; overload;

    function CreateDocumentCardFrameFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentFullInfoDTO: TDocumentFullInfoDTO;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    ): TDocumentCardFrame; overload;

    function CreateDocumentCardFrameFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentCardFormViewModel: TDocumentCardViewModel
    ): TDocumentCardFrame; overload;
    
    function GetCardFrameForDocument(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    ): TDocumentCardFrame;

    function GetCardFrameForDocumentForViewOnly(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    ): TDocumentCardFrame;

    function SaveChangesOfCurrentDocumentCardIfNecessary: Boolean;
    function SaveApprovingsChangesOfCurrentDocumentCardIfNecessary: Boolean;
    function SaveChargeSheetsChangesForCurrentDocumentIfNecessary: Boolean;
    function SaveChargeSheetsChangesForCurrentDocumentAndUpdateUIIfNecessary: Boolean;
    procedure SaveChangesAndRefreshCurrentDocumentCardIfNecessary;
    procedure SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    procedure RefreshCurrentDocumentCardFormViewModelIfNecessary;
    procedure RefreshCurrentDocumentCardFormViewModel;

    procedure RefreshDocumentCardFormViewModel(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

    procedure SendCurrentDocumentToApproving;
    procedure RejectApprovingOfCurrentDocument;
    procedure ApproveCurrentDocument;
    procedure SendCurrentDocumentToSigning;
    procedure SignCurrentDocument;
    procedure PerformCurrentDocument;
    procedure PerformDocumentChargeSheets(
      DocumentChargeIds: TVariantList
    );

    function GetCurrentUIDocumentKind: TUIDocumentKindClass;
    function ResolveUIDocumentKindSection(const DocumentKindId: Variant): TUIDocumentKindClass;
    function GetCurrentDocumentKindId: Variant;
    function GetCurrentDocumentId: Variant;
    function GetCurrentDocumentKindSectionId: Variant;
    function GetCurrentUIDocumentKindSection: TUIDocumentKindClass;

    function GetCurrentNativeDocumentKindForApplicationServicing: TDocumentKindClass;
    function ResolveNativeDocumentKindById(const DocumentKindId: Variant): TDocumentKindClass;
    function GetCurrentGlobalDocumentKindForApplicationServicing: TDocumentKindClass;
    function GetCurrentGlobalDocumentSectionKindForApplicationServicing: TDocumentKindClass;

    function GetDocumentKindFromIdForApplicationServicing(
      const DocumentKindId: Variant
    ): TDocumentKindClass;

    procedure SetUINativeDocumentKindResolver(Value: IUINativeDocumentKindResolver);
    procedure SetUIDocumentKindResolver(Value: IUIDocumentKindResolver);
    
  public
    { Public declarations }

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    property EmployeeDocumentsReferenceForm: TBaseEmployeeDocumentsReferenceForm
    read FBaseEmployeeDocumentsReferenceForm write SetBaseEmployeeDocumentsReferenceForm;

    property DocumentCardFrame: TDocumentCardFrame
    read FSelectedDocumentCardFrame write AssignDocumentCardFrame;

    property CurrentDocumentKindSection: TUIDocumentKindClass
    read GetCurrentUIDocumentKindSection write SetCurrentDocumentKindSection;

    property CurrentDocumentKindSectionId: Variant
    read GetCurrentDocumentKindSectionId write SetCurrentDocumentKindSectionId;

    property OnRelatedDocumentSelectionFormRequestedEventHandler:
      TOnRelatedDocumentSelectionFormRequestedEventHandler

    read FOnRelatedDocumentSelectionFormRequestedEventHandler
    write FOnRelatedDocumentSelectionFormRequestedEventHandler;

    property UIDocumentKindResolver: IUIDocumentKindResolver
    read FUIDocumentKindResolver write SetUIDocumentKindResolver;

    property UINativeDocumentKindResolver: IUINativeDocumentKindResolver
    read FUINativeDocumentKindResolver write SetUINativeDocumentKindResolver;

    property DocumentTypesPanelController: TDocumentTypesPanelController
    read FDocumentTypesPanelController write FDocumentTypesPanelController;

    property DocumentDataSetHoldersFactory: TAbstractDocumentDataSetHoldersFactory
    read FDocumentDataSetHoldersFactory
    write SetDocumentDataSetHoldersFactory;

    property EmployeeDocumentsReferenceFormPresenter: IEmployeeDocumentsReferenceFormPresenter
    read FEmployeeDocumentsReferenceFormPresenter
    write FEmployeeDocumentsReferenceFormPresenter;
    
    property EmployeeDocumentsReferenceFormFactory:
      TEmployeeDocumentsReferenceFormFactory
    read FEmployeeDocumentsReferenceFormFactory
    write FEmployeeDocumentsReferenceFormFactory;

    property EmployeeDocumentsReferenceViewModelFactory:
      TEmployeeDocumentsReferenceViewModelFactory
    read FEmployeeDocumentsReferenceViewModelFactory
    write FEmployeeDocumentsReferenceViewModelFactory;

  end;

implementation

uses

  CommonControlStyles,
  EmployeeSetReadService,
  IObjectPropertiesStorageUnit,
  AuxWindowsFunctionsUnit,
  AuxDebugFunctionsUnit,
  DocumentCardFrameFactory,
  DocumentMainInformationFrameUnit,
  DocumentCardFormUnit,
  DocumentChargesFrameUnit,
  DocumentFilesFrameUnit,
  DocumentRelationsFrameUnit,
  DocumentRelationsReferenceFormUnit,
  DocumentFilesReferenceFormUnit,
  DocumentIdResolverUnit,
  WorkingEmployeeUnit,
  ApplicationPropertiesStorageRegistry,
  DocumentRecordViewModelMapperFactory,
  DocumentRecordViewModelMapper,
  ExtendedDocumentMainInformationFrameUnit,
  EmployeeDocumentChargesWorkStatisticsService,
  EmployeeDocumentChargesWorkStatistics,
  EmployeeIncomingDocumentsReferenceFormUnit,
  ApplicationMainFormUnit,
  AccountingServiceRegistry,
  DocumentViewingAccountingService,
  DocumentReportPresenterRegistry,
  PerformableDocumentCardFrameUnit,
  DocumentPrintFormPresenter,
  DocumentPerformingService,
  DocumentChargeSheetControlAppService,
  OperationalDocumentKindInfo,
  DocumentSigningRejectingService,
  DocumentSigningService,

  ApplicationServiceRegistries,
  ExternalServiceRegistry,
  IDocumentFileServiceClientUnit,
  DocumentBusinessProcessServiceRegistry,
  DocumentCardFrameFactories,
  DocumentStorageService,
  SendingDocumentToSigningService,
  DocumentCardFormViewModelMapperFactories,
  DocumentCardFormViewModelMapperFactory,
  SendingDocumentToApprovingService,
  DocumentCardFormViewModelMapper,
  ChangedDocumentInfoDTO,
  DocumentChargeSheetsChangesInfoDTO,
  NewDocumentInfoDTO,
  DocumentChargeSheetsChangesInfoDTOMapper,
  DocumentChargeSheetsChangesInfoDTOMapperFactory,
  DocumentChargeSheetsChangesInfoDTOMapperFactories,
  DocumentApprovingRejectingService,
  DocumentApprovingService,
  DocumentCreatingDefaultInfoReadService,
  DocumentCreatingDefaultInfoDTO,
  DocumentSignerViewModelMapper,
  DocumentResponsibleViewModelMapper,
  DocumentSignerViewModelUnit,
  DocumentResponsibleViewModelUnit,
  DocumentApprovingControlAppService,
  DocumentApprovingCycleDTO,
  EmployeeSetHolder,
  DocumentApprovingListCreatingAppService,
  ApplicationService,
  BusinessProcessService,
  DBDataTableFormUnit,
  AnchorableDockFormUnit,
  DocumentApprovingListDTO,
  DocumentApprovingListViewModel,
  DocumentApprovingListViewModelMapper,
  EmployeeDocumentKindAccessRightsAppService,
  EmployeeDocumentKindAccessRightsInfoDto,
  DocumentStorageServiceCommandsAndRespones,
  KindedDocumentDataSetHoldersFactory,
  RelatedDocumentStorageService,
  DocumentKindSetHolder,
  DocumentSetHolder,
  DocumentSetReadService,
  EmployeeDocumentsReferenceViewModel,
  DocumentKindWorkCycleInfoDto,
  DocumentKindWorkCycleInfoAppService,
  IncomingDocumentSetHolder,
  GlobalDocumentKindsReadService,
  StandardUIDocumentKindResolver,
  StandardUINativeDocumentKindResolver,
  StandardUIDocumentKindMapper;

{$R *.dfm}

destructor TDocumentFlowWorkingForm.Destroy;
begin

  FreeAndNil(FDocumentDataSetHoldersFactory);
  FreeAndNil(FDocumentTypesPanelController);
  FreeAndNil(FEmployeeDocumentsReferenceFormFactory);

  inherited;

end;


procedure TDocumentFlowWorkingForm.DocumentCardPanelResize(Sender: TObject);
begin

  CenterWindowRelativeByHorz(DocumentCardLabel, DocumentCardPanel);

end;

procedure TDocumentFlowWorkingForm.DocumentListPanelResize(Sender: TObject);
begin

  CenterWindowRelativeByHorz(DocumentListLabel, DocumentListPanel);

end;

procedure TDocumentFlowWorkingForm.DocumentKindTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin

  if AViewInfo.Node.Focused or AViewInfo.Selected then begin

    ACanvas.Brush.Color := $00c56a31;
    ACanvas.Font.Color := $00ffffff;

  end;

end;

procedure TDocumentFlowWorkingForm.DocumentKindTreeListFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode,
  AFocusedNode: TcxTreeListNode
);
var
  ChoosedDocumentKind: Variant;

  function SelectedDocumentKindAbsent: Boolean;
  begin

    Result := DocumentKindTreeList.SelectionCount = 0;

  end;

  function SelectedDocumentKindHasSubKinds: Boolean;
  begin

    Result := DocumentKindTreeList.Selections[0].Count > 1;

  end;

begin

  if SelectedDocumentKindAbsent or SelectedDocumentKindHasSubKinds then
  begin

    if Assigned(APrevFocusedNode) then
      DocumentKindTreeList.FocusedNode := APrevFocusedNode;

    Exit;

  end;

  try

    UpdateUIForCurrentDocumentKind;

  except

    on e: Exception do
      ShowErrorMessage(Self.Handle, e.Message, 'Ошибка');

  end;

end;

procedure TDocumentFlowWorkingForm.DocumentKindTreeListResize(Sender: TObject);
begin

  DocumentKindTreeList.Height :=
    DocumentTypesPanel.Height -
    DocumentKindTreeList.Top -
    DocumentKindTreeList.Left;
    
end;

procedure TDocumentFlowWorkingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  try

    RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

    Action := caFree;
    
  finally

  end;

end;

procedure TDocumentFlowWorkingForm.FormResize(Sender: TObject);
begin

  DocumentTypesPanel.Width := SeparatorBetweenDocumentTypesAndRest.Left;
    
end;

procedure TDocumentFlowWorkingForm.FormShow(Sender: TObject);
begin

  { ask to controller to give customizing document types tree
    and document record table of this type }

  RefreshDocumentTypesDataSetIfNecessary;

  UpdateEmployeeDocumentWorkStatistics;

  DocumentKindTreeList.Root.Expand(True);

end;

{ refactor: сократить объём кода, перенести в контроллеры }
procedure TDocumentFlowWorkingForm.GetCardFormViewModelAndAvailableActionListForDocument(
  const DocumentId, DocumentKindId: Variant;
  var DocumentCardViewModel: TDocumentCardViewModel;
  var AvailableActionList: TDocumentUsageEmployeeAccessRightsInfoDTO
);
var
    DocumentStorageService: IDocumentStorageService;
    DocumentFullInfoDTO: TDocumentFullInfoDTO;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    GettingDocumentFullInfoCommandResult: IGettingDocumentFullInfoCommandResult;
begin

  DocumentCardViewModel := nil;
  AvailableActionList := nil;
  DocumentFullInfoDTO := nil;
  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;;
  GettingDocumentFullInfoCommandResult := nil;

  try

    try

      DocumentStorageService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentStorageService(
        GetDocumentKindFromIdForApplicationServicing(DocumentKindId)
      );

      GettingDocumentFullInfoCommandResult :=
        DocumentStorageService.GetDocumentFullInfo(
          TGettingDocumentFullInfoCommand.Create(
            DocumentId,
            TWorkingEmployee.Current.Id
          )
        );

      DocumentCardViewModel :=
        CreateDocumentCardFormViewModelFor(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId),
          GettingDocumentFullInfoCommandResult.DocumentFullInfoDTO,
          GettingDocumentFullInfoCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO
        );

      AvailableActionList :=
        GettingDocumentFullInfoCommandResult.
          DocumentUsageEmployeeAccessRightsInfoDTO.Clone;

    except

      on e: Exception do begin

        FreeAndNil(DocumentCardViewModel);
        FreeAndNil(AvailableActionList);
        
        raise;

      end;

    end;

  finally

    FreeAndNil(DocumentCardFormViewModelMapperFactory);
    FreeAndNil(DocumentCardFormViewModelMapper);
    FreeAndNil(DocumentFullInfoDTO);

  end;

end;

function TDocumentFlowWorkingForm.GetCardFrameForDocument(
  const DocumentId: Variant;
  const DocumentKindId: Variant
): TDocumentCardFrame;
var
    DocumentCardFormViewModel: TDocumentCardViewModel;
    AvailableDocumentActionList: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result := nil;
  AvailableDocumentActionList := nil;

  try

    GetCardFormViewModelAndAvailableActionListForDocument(
      DocumentId,
      DocumentKindId,
      DocumentCardFormViewModel,
      AvailableDocumentActionList
    );

    try

      Result :=
        CreateDocumentCardFrameFor(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId),
          DocumentCardFormViewModel,
          AvailableDocumentActionList
        );

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;

      end;

    end;
    
  finally

    FreeAndNil(AvailableDocumentActionList);

  end;

end;

function TDocumentFlowWorkingForm.GetCardFrameForDocumentForViewOnly(
  const DocumentId: Variant;
  const DocumentKindId: Variant
): TDocumentCardFrame;
var DocumentCardFrameFactory: TDocumentCardFrameFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModel: TDocumentCardViewModel;
    DocumentFullInfoDTO: TDocumentFullInfoDTO;
    DocumentStorageService: IDocumentStorageService;
    GettingDocumentFullInfoCommandResult: IGettingDocumentFullInfoCommandResult;
begin

  DocumentCardFrameFactory := nil;
  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;
  DocumentCardFormViewModel := nil;
  DocumentFullInfoDTO := nil;
  DocumentStorageService := nil;

  try

    DocumentStorageService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentStorageService(
        GetDocumentKindFromIdForApplicationServicing(DocumentKindId)
      );

    try
    
      GettingDocumentFullInfoCommandResult :=
        DocumentStorageService.GetDocumentFullInfo(
          TGettingDocumentFullInfoCommand.Create(
            DocumentId,
            TWorkingEmployee.Current.Id)
          );

      DocumentCardFormViewModel :=
        CreateDocumentCardFormViewModelFor(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId),
          GettingDocumentFullInfoCommandResult.DocumentFullInfoDTO,
          GettingDocumentFullInfoCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO
        );

    except

      on e: Exception do begin

        FreeAndNil(DocumentCardFormViewModel);
        raise;
        
      end;

    end;

    try

      Result :=
        CreateDocumentCardFrameFor(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId),
          DocumentCardFormViewModel
        );

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;
        
      end;

    end;

  finally

    FreeAndNil(DocumentCardFrameFactory);
    FreeAndNil(DocumentFullInfoDTO);
    
  end;

end;

function TDocumentFlowWorkingForm.GetCurrentUIDocumentKindSection: TUIDocumentKindClass;
begin

  Result :=
    FUIDocumentKindResolver.ResolveUIDocumentKindFromId(
      GetCurrentDocumentKindSectionId
    );

end;

function TDocumentFlowWorkingForm.GetCurrentDocumentKindSectionId: Variant;
begin
          
  if not Assigned(DocumentKindTreeList.FocusedNode) then begin

    Result :=
      FUIDocumentKindResolver.ResolveIdForUIDocumentKind(
        TUIOutcomingServiceNoteKind
      )
  end

  else begin

    Result :=
      DocumentKindTreeList.FocusedNode.Values[
        DocumentKindIdColumn.ItemIndex
      ];

  end;
  
end;

function TDocumentFlowWorkingForm.
  GetCurrentNativeDocumentKindForApplicationServicing: TDocumentKindClass;
begin

  Result := ResolveNativeDocumentKindById(GetCurrentDocumentKindId);

end;

function TDocumentFlowWorkingForm.
  GetCurrentGlobalDocumentKindForApplicationServicing: TDocumentKindClass;
begin
     
  Result :=
    GlobalDocumentKindDtos
      .FindByIdOrRaise(GetCurrentDocumentKindId)
        .ServiceType;

end;

function TDocumentFlowWorkingForm.
  GetCurrentGlobalDocumentSectionKindForApplicationServicing: TDocumentKindClass;
begin

  Result :=
    GlobalDocumentKindDtos.FindByIdOrRaise(
      GetCurrentDocumentKindSectionId
    ).ServiceType;

end;

function TDocumentFlowWorkingForm.GetDocumentKindFromIdForApplicationServicing(
  const DocumentKindId: Variant
): TDocumentKindClass;
begin

  Result :=
    NativeDocumentKindDtos.FindByIdOrRaise(DocumentKindId).ServiceType;

end;

{ refactor: строго типизированный dataset }
function TDocumentFlowWorkingForm.GetCurrentDocumentKindId: Variant;
begin

  if not Assigned(FBaseEmployeeDocumentsReferenceForm) then
    Result := Null

  else begin

    if FBaseEmployeeDocumentsReferenceForm.DataSet.IsEmpty then
      Result := Null

    else begin

      Result :=
        FBaseEmployeeDocumentsReferenceForm.DataSet.FieldByName(
          'type_id'
        ).AsVariant;

    end;

  end;

end;

function TDocumentFlowWorkingForm.GetCurrentDocumentId: Variant;
begin

  if not Assigned(FBaseEmployeeDocumentsReferenceForm) then
    Result := Null

  else begin

    if FBaseEmployeeDocumentsReferenceForm.DataSet.IsEmpty then
      Result := Null

    else begin
    
      Result :=
        FBaseEmployeeDocumentsReferenceForm.DataSet.FieldByName(
          'id'
        ).AsVariant;

    end;

  end;

end;

function TDocumentFlowWorkingForm.GetCurrentUIDocumentKind: TUIDocumentKindClass;
begin

  Result :=
    FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
      GetCurrentDocumentKindId
    );
    
end;

function TDocumentFlowWorkingForm.GetDocumentTypesDataSet: TDataSet;
begin

  Result := DocumentKindTreeList.DataController.DataSource.DataSet;
  
end;

procedure TDocumentFlowWorkingForm.GetEmployeeDocumentWorkStatisticsAsync;

var EmployeeDocumentWorkStatisticsService:
      IEmployeeDocumentWorkStatisticsService;
begin

  EmployeeDocumentWorkStatisticsService :=

    TApplicationServiceRegistries.
    Current.
    GetStatisticsServiceRegistry.
    GetEmployeeDocumentWorkStatisticsService;

  EmployeeDocumentWorkStatisticsService.
    GetDocumentWorkStatisticsForEmployeeAsync(
      TWorkingEmployee.Current.Id,
      OnDocumentWorkStatisticsFetchedEventHandler,
      OnDocumentWorkStatisticsFetchingErrorEventHandler
    );

  FDocumentTypesPanelController.
    ShowLoadingEmployeeDocumentWorkStatisticsLabel(
      Self,
      '(...)'
    );
    
end;

function TDocumentFlowWorkingForm.GetGlobalDocumentKindDtos: TGlobalDocumentKindDtos;
begin

  Result := FGlobalDocumentKindDtos;
  
end;

function TDocumentFlowWorkingForm.GetNativeDocumentKindDtos: TNativeDocumentKindDtos;
begin

  Result := FNativeDocumentKindDtos;

end;

procedure TDocumentFlowWorkingForm.InflateEmployeeDocumentReferenceFormToLayout(
  EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm);
begin

  EmployeeDocumentReferenceForm.Parent := DocumentRecordsGridPanel;
  EmployeeDocumentReferenceForm.Align := alClient;
  EmployeeDocumentReferenceForm.BorderStyle := bsNone;

end;

procedure TDocumentFlowWorkingForm.InitializeLayout;
begin

  TDocumentFlowCommonControlStyles.ApplyStylesToForm(Self);

  AssignColorToPanels;
  
end;

function TDocumentFlowWorkingForm.IsCurrentDocumentKindSectionValid: Boolean;
begin

  try
  
    GetCurrentUIDocumentKindSection;

    Result := True;

  except

    Result := False;

  end;

end;

procedure TDocumentFlowWorkingForm.AddNewDocumentRecordToBaseEmployeeDocumentsReferenceFormFrom(
  DocumentCardViewModel: TDocumentCardViewModel
);
var 
    DocumentRecordViewModelMapper:
      TDocumentRecordViewModelMapper;
    DocumentRecordViewModel: TDocumentRecordViewModel;
begin

  DocumentRecordViewModelMapper := nil;
  DocumentRecordViewModel := nil;
  
  try

    DocumentRecordViewModelMapper :=
    
      TDocumentRecordViewModelMapperFactory.
        CreateDocumentRecordViewModelMapper(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
            DocumentCardViewModel.DocumentKindId
          )
        );

    DocumentRecordViewModel :=

      DocumentRecordViewModelMapper.
        MapDocumentRecordViewModelFrom(DocumentCardViewModel);

    DocumentRecordViewModel.AuthorId :=
      TWorkingEmployee.Current.Id;

    DocumentRecordViewModel.AuthorName :=
      TWorkingEmployee.Current.FullName;

    DocumentRecordViewModel.IsViewed := True;
    
    FBaseEmployeeDocumentsReferenceForm.AddNewDocumentRecord(
      DocumentRecordViewModel
    );

    FBaseEmployeeDocumentsReferenceForm.SelectCurrentDataRecord;
    FBaseEmployeeDocumentsReferenceForm.UpdateLayout;

  finally

    FreeAndNil(DocumentRecordViewModel);
    FreeAndNil(DocumentRecordViewModelMapper);
    
  end;

end;

procedure TDocumentFlowWorkingForm.SignCurrentDocument;
var DocumentSigningService: IDocumentSigningService;
begin

  DocumentSigningService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentSigningService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentSigningService.SignDocument(
      FSelectedDocumentCardFrame.
      ViewModel.DocumentMainInformationFormViewModel.DocumentId,
      TWorkingEmployee.Current.Id
  );

end;

procedure TDocumentFlowWorkingForm.UpdateCurrentEmployeeDocumentKindWorkStatistics;
var CurrentDocumentKind: TDocumentKindClass;
    EmployeeDocumentWorkStatisticsService:
      IEmployeeDocumentWorkStatisticsService;

    OutcommingDocumentKinds: array of Variant;
    IncommingDocumentKinds: array of Variant;

    EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList;
begin

  CurrentDocumentKind :=
    GetCurrentGlobalDocumentSectionKindForApplicationServicing;

  if not CurrentDocumentKind.InheritsFrom(TNativeDocumentKind) then Exit;
  
  EmployeeDocumentWorkStatisticsService :=
    TApplicationServiceRegistries.
    Current.
    GetStatisticsServiceRegistry.
    GetEmployeeDocumentWorkStatisticsService;


  if CurrentDocumentKind.InheritsFrom(TOutcomingDocumentKind) then begin

      EmployeeDocumentWorkStatisticsService.
        GetDocumentKindsWorkStatisticsForEmployeeAsync(
          [
            TOutcomingDocumentKindClass(CurrentDocumentKind)
          ],
          [],
          [],
          TWorkingEmployee.Current.Id,
          OnDocumentWorkStatisticsFetchedEventHandler,
          OnDocumentWorkStatisticsFetchingErrorEventHandler
        );
        
  end

  else if CurrentDocumentKind.InheritsFrom(TIncomingDocumentKind)
  then begin

    EmployeeDocumentWorkStatisticsService.
      GetDocumentKindsWorkStatisticsForEmployeeAsync(
        [],
        [],
        [
          TIncomingDocumentKindClass(CurrentDocumentKind)
        ],
        TWorkingEmployee.Current.Id,
        OnDocumentWorkStatisticsFetchedEventHandler,
        OnDocumentWorkStatisticsFetchingErrorEventHandler
      );

  end

  else if CurrentDocumentKind.InheritsFrom(TApproveableServiceNoteKind)
  then begin

    EmployeeDocumentWorkStatisticsService.
      GetDocumentKindsWorkStatisticsForEmployeeAsync(
        [],
        [
          TApproveableDocumentKindClass(CurrentDocumentKind)
        ],
        [],
        TWorkingEmployee.Current.Id,
        OnDocumentWorkStatisticsFetchedEventHandler,
        OnDocumentWorkStatisticsFetchingErrorEventHandler
      );
      
  end

  else begin

    if CurrentDocumentKind.InheritsFrom(TInternalDocumentKind) then Exit;

    ShowErrorMessage(
      Self.Handle,
      Format(
        'Не распознан вид документов ' +
        'с идентификатором %s для ' +
        'сбора статистики работ по ' +
        'документам этого вида',
        [
          GetCurrentDocumentKindId
        ]
      ),
      'Ошибка'
    );


  end;

  FDocumentTypesPanelController.
    ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
      Self,
      GetCurrentUIDocumentKindSection,
      '(...)'
    );

end;

procedure TDocumentFlowWorkingForm.
  UpdateDocumentCardAfterApprovingCompletingMessageHandler(
    var Message: TMessage
  );
begin

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
  
end;

procedure TDocumentFlowWorkingForm.
  UpdateEmployeeChargesWorkStatisticsForDocument(const DocumentId: Variant);

var EmployeeDocumentChargesWorkStatisticsService:
      IEmployeeDocumentChargesWorkStatisticsService;

    EmployeeDocumentChargesWorkStatistics:
      TEmployeeDocumentChargesWorkStatistics;
begin

  EmployeeDocumentChargesWorkStatisticsService :=

    TApplicationServiceRegistries.
    Current.
    GetStatisticsServiceRegistry.
    GetEmployeeDocumentChargesWorkStatisticsService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  EmployeeDocumentChargesWorkStatistics :=

    EmployeeDocumentChargesWorkStatisticsService.
      GetDocumentChargesWorkStatisticsFor(
        TWorkingEmployee.Current.Id,
        DocumentId
      );

  if not Assigned(EmployeeDocumentChargesWorkStatistics) then Exit;

  try

    FBaseEmployeeDocumentsReferenceForm.
      ChangeDocumentChargesWorkStatisticsRecordCell(
        DocumentId,
        EmployeeDocumentChargesWorkStatistics
      );

    FBaseEmployeeDocumentsReferenceForm.UpdateLayout;

  finally

    FreeAndNil(EmployeeDocumentChargesWorkStatistics);
    
  end;

end;

procedure TDocumentFlowWorkingForm.UpdateEmployeeDocumentWorkStatistics;
begin

  GetEmployeeDocumentWorkStatisticsAsync;

end;

procedure TDocumentFlowWorkingForm.UpdateUIForCurrentDocumentKind;
var
    CurrentDocumentKindSection: TUIDocumentKindClass;
    Stub: TOperationalDocumentKindInfo;
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

  FEmployeeDocumentsReferenceFormPresenter.ShowEmployeeDocumentsReferenceForm(
    Self,
    Stub
  );

end;

procedure TDocumentFlowWorkingForm.
  ChangeDocumentRecordInBaseEmployeeDocumentsReferenceFormFrom(
    DocumentCardViewModel: TDocumentCardViewModel
  );
var WorkingUIDocumentKind: TUIDocumentKindClass;
    DocumentRecordViewModelMapper: TDocumentRecordViewModelMapper;
    DocumentRecordViewModel: TDocumentRecordViewModel;
    DocumentViewingAccountingService: IDocumentViewingAccountingService;
begin

  DocumentRecordViewModelMapper := nil;
  DocumentRecordViewModel := nil;

  try

    WorkingUIDocumentKind :=
      FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
        DocumentCardViewModel.DocumentKindId
      );

    DocumentRecordViewModelMapper :=

      TDocumentRecordViewModelMapperFactory.
        CreateDocumentRecordViewModelMapper(WorkingUIDocumentKind);

    DocumentRecordViewModel :=

      DocumentRecordViewModelMapper.
        MapDocumentRecordViewModelFrom(DocumentCardViewModel);

    if not FBaseEmployeeDocumentsReferenceForm.IsCurrentDocumentRecordViewed
    then begin

      DocumentViewingAccountingService :=

      TApplicationServiceRegistries.
      Current.
      GetAccountingServiceRegistry.
      GetDocumentViewingAccountingService(
        GetDocumentKindFromIdForApplicationServicing(
          DocumentCardViewModel.DocumentKindId
        )
      );

      DocumentViewingAccountingService.
        MarkDocumentAsViewedByEmployeeIfItIsNotViewed(
          DocumentCardViewModel.DocumentId,
          TWorkingEmployee.Current.Id,
          Now
        );

    end;

    DocumentRecordViewModel.IsViewed := True;

    FBaseEmployeeDocumentsReferenceForm.ChangeDocumentRecordByViewModel(
      DocumentRecordViewModel
    );

    FBaseEmployeeDocumentsReferenceForm.SelectCurrentDataRecord;
    FBaseEmployeeDocumentsReferenceForm.UpdateLayout;

  finally

    FreeAndNil(DocumentRecordViewModel);
    FreeAndNil(DocumentRecordViewModelMapper);
    
  end;

end;

procedure TDocumentFlowWorkingForm.ApproveCurrentDocument;
var DocumentApprovingService: IDocumentApprovingService;
begin

  DocumentApprovingService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentApprovingService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentApprovingService.ApproveDocument(

    FSelectedDocumentCardFrame.
    ViewModel.
    DocumentMainInformationFormViewModel.
    DocumentId,

    TWorkingEmployee.Current.Id
  );

end;

procedure TDocumentFlowWorkingForm.AssignColorToPanels;
begin

  DocumentTypesPanel.Color := DEFAULT_BACKGROUND_COLOR_OF_PANELS;
  DocumentListPanel.Color := DEFAULT_BACKGROUND_COLOR_OF_PANELS;
  DocumentRecordsGridPanel.Color := DEFAULT_BACKGROUND_COLOR_OF_PANELS;
  DocumentCardPanel.Color := DEFAULT_BACKGROUND_COLOR_OF_PANELS;
  DocumentCardFormPanel.Color := DEFAULT_BACKGROUND_COLOR_OF_PANELS;

end;

procedure TDocumentFlowWorkingForm.AssignDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame
);
begin

  QueueOldDocumentCardDestroyMessage;

  if not Assigned(DocumentCardFrame) then begin

    FSelectedDocumentCardFrame := nil;
    Exit;

  end;

  DocumentCardFrame.Parent := DocumentCardFormPanel;
  DocumentCardFrame.Align := alClient;

  DocumentCardFrame.PartitionSpaceEvenlyBetweenDocumentInfoAreas;

  AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

  DocumentCardFrame.RaisePendingEvents;

  if Assigned(FSelectedDocumentCardFrame) then
    DocumentCardFrame.CopyUISettings(FSelectedDocumentCardFrame);
    
  FSelectedDocumentCardFrame := DocumentCardFrame;

  if Assigned(FDetachableDocumentCardForm) then begin

    FDetachableDocumentCardForm.InternalControl :=
      FSelectedDocumentCardFrame;

    FDetachableDocumentCardForm.SetFocus;
    
  end;
  
end;

{ refactor document card frame, event handlers mechanism }
procedure TDocumentFlowWorkingForm.AssignEventHandlersToDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame
);
begin

  DocumentCardFrame.OnApprovingDocumentSendingRequestedEventHanlder :=
    OnApprovingDocumentSendingRequestedEventHanlder;

  DocumentCardFrame.OnDocumentApprovingRequestedEventHandler :=
    OnDocumentApprovingRequestedEventHandler;

  DocumentCardFrame.OnDocumentApprovingRejectingRequestedEventHandler :=
    OnDocumentApprovingRejectingRequestedEventHandler;
    
  DocumentCardFrame.OnDocumentSendingToSigningRequestedEventHandler :=
    OnDocumentSendingToSigningRequestedEventHandler;

  DocumentCardFrame.OnDocumentSigningRequestedEventHandler :=
    OnDocumentSigningRequestedEventHandler;
    
  DocumentCardFrame.OnDocumentInfoSavingRequestedEventHandler :=
    OnDocumentInfoSavingRequestedEventHandler;

  DocumentCardFrame.OnDocumentPerformingRequestedEventHandler :=
    OnDocumentPerformingRequestedEventHandler;

  DocumentCardFrame.OnDocumentRejectingFromSigningRequestedEventHandler :=
    OnDocumentRejectingFromSigningRequestedEventHandler;

  DocumentCardFrame.
    OnDocumentPerformingsChangesSavingRequestedEventHandler :=
      OnDocumentChargeSheetsChangesSavingRequestedEventHandler;

      {refactor}
  DocumentCardFrame.OnDocumentFileOpeningRequestedEventHandler :=
    OnDocumentFileOpeningRequestedEventHandler;

  DocumentCardFrame.
    OnRelatedDocumentSelectionFormRequestedEventHandler :=
      OnRelatedDocumentSelectionFormRequestedEventHandler;

  DocumentCardFrame.
    OnRelatedDocumentCardOpeningRequestedEventHandler :=
      OnRelatedDocumentCardOpeningRequestedEventHandler;

  DocumentCardFrame.OnDocumentPrintFormRequestedEventHandler :=
    OnDocumentPrintFormRequestedEventHandler;

  if DocumentCardFrame is TPerformableDocumentCardFrame then begin

    (DocumentCardFrame as TPerformableDocumentCardFrame).
      OnDocumentChargesPerformingRequestedEventHandler :=
        OnDocumentChargesPerformingRequestedEventHandler;
        
  end;

  DocumentCardFrame.
    OnDocumentApprovingChangingRequestedEventHandler :=
      OnDocumentApprovingChangingRequestedEventHandler;

  DocumentCardFrame.
    OnDocumentApprovingCompletingRequestedEventHandler :=
      OnDocumentApprovingCompletingRequestedEventHandler;

  DocumentCardFrame.
    OnDocumentApprovingCycleRemovingRequestedEventHandler :=
      OnDocumentApprovingCycleRemovingRequestedEventHandler;

  DocumentCardFrame.
    OnDocumentApprovingsRemovingRequestedEventHandler :=
      OnDocumentApprovingsRemovingRequestedEventHandler;

  DocumentCardFrame.
    OnEmployeesAddingForApprovingRequestedEventHandler :=
      OnEmployeesAddingForApprovingRequestedEventHandler;

  DocumentCardFrame.
    OnNewDocumentApprovingCycleCreatingRequestedEventHandler :=
      OnNewDocumentApprovingCycleCreatingRequestedEventHandler;

  DocumentCardFrame.OnDocumentApprovingCycleSelectedEventHandler :=
    OnDocumentApprovingCycleSelectedEventHandler;

end;

procedure TDocumentFlowWorkingForm.
  AssignEventHandlersToEmployeeDocumentReferenceForm(
    EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm
  );
begin

  EmployeeDocumentReferenceForm.
    OnNewDocumentCreatingRequestedEventHandler :=
      OnNewDocumentCreatingRequestedEventHandler;

  EmployeeDocumentReferenceForm.
    OnNewDocumentCreatingConfirmedEventHandler :=
      OnNewDocumentCreatingConfirmedEventHandler;

  EmployeeDocumentReferenceForm.
    OnNewDocumentCreatingFinishedEventHandler :=
      OnNewDocumentCreatingFinishedEventHandler;
      
  EmployeeDocumentReferenceForm.
    OnSelectedDocumentRecordChangingEventHandler :=
      OnSelectedDocumentRecordChangingEventHandler;
      
  EmployeeDocumentReferenceForm.
    OnSelectedDocumentRecordChangedEventHandler :=
      OnSelectedDocumentRecordChangedEventHandler;

  EmployeeDocumentReferenceForm.
    OnDocumentRecordsLoadingSuccessEventHandler :=
      OnDocumentRecordsLoadingSuccessEventHandler;

  EmployeeDocumentReferenceForm.
    OnDocumentRecordsLoadingFailedEventHandler :=
      OnDocumentRecordsLoadingFailedEventHandler;

  EmployeeDocumentReferenceForm.
    OnDocumentRecordsLoadingCanceledEventHandler :=
      OnDocumentRecordsLoadingCanceledEventHandler;

  EmployeeDocumentReferenceForm.
    OnDocumentDeletingRequestedEventHandler :=
      OnDocumentDeletingRequestedEventHandler;

  EmployeeDocumentReferenceForm.OnDocumentRecordDeletedEventHandler :=
    OnDocumentRecordDeletedEventHandler;

  EmployeeDocumentReferenceForm.OnDocumentRecordsRefreshRequestedEventHandler :=
    OnDocumentRecordsRefreshRequestedEventHandler;

  EmployeeDocumentReferenceForm.OnDocumentRecordsRefreshedEventHandler :=
    OnDocumentRecordsRefreshedEventHandler;

  EmployeeDocumentReferenceForm.OnDocucmentRecordFocusedEventHandler :=
    OnDocucmentRecordFocusedEventHandler;

  EmployeeDocumentReferenceForm.OnDocumentRecordChangingRequestedEventHandler :=
    OnDocumentRecordChangingRequestedEventHandler;
    
end;

constructor TDocumentFlowWorkingForm.Create(AOwner: TComponent);
begin

  inherited;

  InitializeLayout;
  CreateRequiredComponents;

end;

function TDocumentFlowWorkingForm.CreateDocumentCardFormViewModelFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardViewModel;
var DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
begin

  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;

  try

    DocumentCardFormViewModelMapperFactory :=
      TDocumentCardFormViewModelMapperFactories.
      Current.
      CreateDocumentCardFormViewModelMapperFactory(UIDocumentKind);

    DocumentCardFormViewModelMapper :=
      DocumentCardFormViewModelMapperFactory.
        CreateDocumentCardFormViewModelMapper;

    Result :=
      DocumentCardFormViewModelMapper.MapDocumentCardFormViewModelFrom(
        DocumentFullInfoDTO,
        DocumentUsageEmployeeAccessRightsInfoDTO
      );

  finally

    FreeAndNil(DocumentCardFormViewModelMapper);
    FreeAndNil(DocumentCardFormViewModelMapperFactory);
    
  end;

end;

function TDocumentFlowWorkingForm.CreateDocumentCardFrameFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO): TDocumentCardFrame;
var DocumentCardFormViewModel: TDocumentCardViewModel;
begin

  DocumentCardFormViewModel :=
    CreateDocumentCardFormViewModelFor(
      UIDocumentKind,
      DocumentFullInfoDTO,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  Result :=
    CreateDocumentCardFrameFor(
      UIDocumentKind,
      DocumentCardFormViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );
    
end;

function TDocumentFlowWorkingForm.CreateDocumentCardFrameFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentCardFormViewModel: TDocumentCardViewModel): TDocumentCardFrame;
var DocumentCardFrameFactory: TDocumentCardFrameFactory;
begin

  DocumentCardFrameFactory :=
    TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
      UIDocumentKind
    );

  try
  
    Result :=
      DocumentCardFrameFactory.CreateDocumentCardFrameForView(
        DocumentCardFormViewModel
      );

  finally

    FreeAndNil(DocumentCardFrameFactory);
    
  end;
end;

function TDocumentFlowWorkingForm.CreateDocumentCardFrameFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentCardFormViewModel: TDocumentCardViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
var DocumentCardFrameFactory: TDocumentCardFrameFactory;
begin

  DocumentCardFrameFactory :=
    TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
      UIDocumentKind
    );

  try
  
    Result :=
      DocumentCardFrameFactory.CreateDocumentCardFrameFrom(
        DocumentCardFormViewModel,
        DocumentUsageEmployeeAccessRightsInfoDTO
      );
    
  finally

    FreeAndNil(DocumentCardFrameFactory);
    
  end;

end;

procedure TDocumentFlowWorkingForm.ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;
begin

  if FBaseEmployeeDocumentsReferenceForm.RecordCount = 0 then
    ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection

  else ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord; {refactor}

end;

procedure TDocumentFlowWorkingForm.
  ShowEmptyNoActivedDocumentCardForCurrentDocumentKindIfDocumentsAreAbsent;
begin

  if FBaseEmployeeDocumentsReferenceForm.RecordCount = 0 then
    ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

end;

procedure TDocumentFlowWorkingForm.
  ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

var CurrentDocumentKindSection: TUIDocumentKindClass;
    DocumentCardFrame: TDocumentCardFrame;
    DocumentCardFrameFactory: TDocumentCardFrameFactory;
begin

  if not IsCurrentDocumentKindSectionValid then
    Exit;

  CurrentDocumentKindSection := GetCurrentUIDocumentKindSection;

  DocumentCardFrameFactory :=
    TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
      CurrentDocumentKindSection
    );

  DocumentCardFrame := nil;
  
  try

    try

      DocumentCardFrame :=
        DocumentCardFrameFactory.CreateEmptyNoActivedDocumentCardFrame;

      AssignDocumentCardFrame(DocumentCardFrame);

    except

      on e: Exception do begin

        FreeAndNil(DocumentCardFrame);
        raise;
        
      end;
      
    end;

  finally

    FreeAndNil(DocumentCardFrameFactory);
    
  end;

end;

procedure TDocumentFlowWorkingForm.CreateNewDocumentFrom(
  DocumentCardFrame: TDocumentCardFrame
);
var
    DocumentStorageService: IDocumentStorageService;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    NewDocumentInfoDTO: TNewDocumentInfoDTO;
    AddNewDocumentFullInfoCommandResult: IAddNewDocumentFullInfoCommandResult;
    DocumentCardViewModel: TDocumentCardViewModel;

    CurrentUIDocumentKind: TUIDocumentKindClass;
    CurrentServiceDocumentKind: TDocumentKindClass;
begin

  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;
  
  try

    if not VarIsNull(DocumentCardFrame.ViewModel.DocumentKindId) then begin

      CurrentServiceDocumentKind :=
        ResolveNativeDocumentKindById(DocumentCardFrame.ViewModel.DocumentKindId);

      CurrentUIDocumentKind :=
        ResolveUIDocumentKindSection(DocumentCardFrame.ViewModel.DocumentKindId);

    end

    else begin

      CurrentServiceDocumentKind := GetCurrentGlobalDocumentSectionKindForApplicationServicing;
      CurrentUIDocumentKind := GetCurrentUIDocumentKindSection;

    end;

    DocumentStorageService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentStorageService(CurrentServiceDocumentKind);

    DocumentCardFormViewModelMapperFactory :=
      TDocumentCardFormViewModelMapperFactories.
      Current.
      CreateDocumentCardFormViewModelMapperFactory(CurrentUIDocumentKind);

    DocumentCardFormViewModelMapper :=
      DocumentCardFormViewModelMapperFactory.
      CreateDocumentCardFormViewModelMapper;

    NewDocumentInfoDTO :=
      DocumentCardFormViewModelMapper.
      MapDocumentCardFormViewModelToNewDocumentInfoDTO(
        DocumentCardFrame.ViewModel
      );

    AddNewDocumentFullInfoCommandResult :=
      DocumentStorageService.AddNewDocumentFullInfo(
        TAddNewDocumentFullInfoCommand.Create(
          TWorkingEmployee.Current.Id,
          NewDocumentInfoDTO
        )
      );

    DocumentCardViewModel := DocumentCardFrame.ViewModel;

    DocumentCardViewModel.DocumentId :=
      AddNewDocumentFullInfoCommandResult.NewDocumentId;

    DocumentCardViewModel.CurrentDocumentWorkCycleStageNumber :=
      AddNewDocumentFullInfoCommandResult.CurrentNewDocumentWorkCycleStageNumber;

    DocumentCardViewModel.CurrentDocumentWorkCycleStageName :=
      AddNewDocumentFullInfoCommandResult.CurrentNewDocumentWorkCycleStageName;

    DocumentCardViewModel.DocumentCompleteNumber :=
      AddNewDocumentFullInfoCommandResult.AssignedNewDocumentNumber;

    DocumentCardViewModel.DocumentKindId :=
      FUINativeDocumentKindResolver.ResolveIdForUIDocumentKind(
        CurrentUIDocumentKind
      );

    DocumentCardViewModel.DocumentRemoveToolEnabled :=
      AddNewDocumentFullInfoCommandResult
        .NewDocumentUsageEmployeeAccessRightsInfoDTO
          .DocumentCanBeRemoved;
          
  finally

    FreeAndNil(DocumentCardFormViewModelMapper);
    FreeAndNil(DocumentCardFormViewModelMapperFactory);

  end;

end;

procedure TDocumentFlowWorkingForm.CreateRequiredComponents;
begin

  FRequestedFocuseableDocumentId := Null;
  
end;

procedure TDocumentFlowWorkingForm.CustomizeDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame);
begin

  DocumentCardFrame.WorkingEmployeeId := TWorkingEmployee.Current.Id;

  if not VarIsNull(GetCurrentDocumentKindId) then
    DocumentCardFrame.ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing

  else
    DocumentCardFrame.ServiceDocumentKind := GetCurrentGlobalDocumentSectionKindForApplicationServicing;

end;

procedure TDocumentFlowWorkingForm.CustomizeBaseEmployeeDocumentsReferenceForm(
  EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm);
begin

  EmployeeDocumentReferenceForm.Font := Font;
  EmployeeDocumentReferenceForm.UIDocumentKindResolver :=
    FUINativeDocumentKindResolver;

  { refactor: introduce the event bus, controllers }

  if EmployeeDocumentReferenceForm is TEmployeeIncomingDocumentsReferenceForm
  then begin

    TEmployeeIncomingDocumentsReferenceForm(
      EmployeeDocumentReferenceForm
    ).OnRespondingDocumentCreatingFinishedEventHandler :=
        OnRespondingDocumentCreatingFinishedEventHandler;

    TEmployeeIncomingDocumentsReferenceForm(
      EmployeeDocumentReferenceForm
    ).NativeDocumentKindDtos := FNativeDocumentKindDtos;

  end;

end;

procedure TDocumentFlowWorkingForm.OnNewDocumentCreatingConfirmedEventHandler(
  Sender: TObject;
  DocumentCardFrame: TDocumentCardFrame
);
begin

  CreateNewDocumentFrom(DocumentCardFrame);
    
end;

procedure TDocumentFlowWorkingForm.OnNewDocumentCreatingFinishedEventHandler(
  Sender: TObject;
  DocumentCardFrame: TDocumentCardFrame
);
begin
              
  AddNewDocumentRecordToBaseEmployeeDocumentsReferenceFormFrom(
    DocumentCardFrame.ViewModel
  );

  UpdateCurrentEmployeeDocumentKindWorkStatistics;

  CurrentDocumentKindSectionId
end;

procedure TDocumentFlowWorkingForm.OnNewDocumentCreatingRequestedEventHandler(
  Sender: TObject;
  var DocumentCardFrame: TDocumentCardFrame
);
var DocumentCardFrameFactory: TDocumentCardFrameFactory;
    DocumentCardFormViewModel: TDocumentCardViewModel;

    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;

    DocumentCreatingDefaultInfoReadService: IDocumentCreatingDefaultInfoReadService;
    DocumentCreatingDefaultInfoDTO: TDocumentCreatingDefaultInfoDTO;

    EmployeeDocumentKindAccessRightsAppService: IEmployeeDocumentKindAccessRightsAppService;
    EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto;
begin

  DocumentCardFormViewModel := nil;
  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;

  DocumentCreatingDefaultInfoDTO := nil;
  EmployeeDocumentKindAccessRightsInfoDto := nil;

  DocumentCardFrame := nil;
  DocumentCardFrameFactory := nil;

  try

    EmployeeDocumentKindAccessRightsAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetEmployeeDocumentKindAccessRightsAppService;

    EmployeeDocumentKindAccessRightsInfoDto :=
      EmployeeDocumentKindAccessRightsAppService.
        EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
          GetCurrentGlobalDocumentSectionKindForApplicationServicing,
          TWorkingEmployee.Current.Id
        );

    DocumentCreatingDefaultInfoReadService :=
      TApplicationServiceRegistries.
      Current.
      GetPresentationServiceRegistry.
      GetDocumentCreatingDefaultInfoReadService(
        GetCurrentGlobalDocumentSectionKindForApplicationServicing
      );

    DocumentCreatingDefaultInfoDTO :=
      DocumentCreatingDefaultInfoReadService.
        GetDocumentCreatingDefaultInfoForEmployee(
          TWorkingEmployee.Current.Id
        );
    
    try

      DocumentCardFormViewModelMapperFactory :=
        TDocumentCardFormViewModelMapperFactories.
        Current.
        CreateDocumentCardFormViewModelMapperFactory(
          GetCurrentUIDocumentKindSection
        );

      DocumentCardFormViewModelMapper :=
        DocumentCardFormViewModelMapperFactory.
        CreateDocumentCardFormViewModelMapper;

      DocumentCardFormViewModel :=
        DocumentCardFormViewModelMapper.
          CreateDocumentCardFormViewModelForNewDocumentCreating(
            FDocumentDataSetHoldersFactory,
            DocumentCreatingDefaultInfoDTO
          );

      DocumentCardFrameFactory :=
        TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
          GetCurrentUIDocumentKindSection
        );

      DocumentCardFrame :=
        DocumentCardFrameFactory.CreateCardFrameForNewDocumentCreating(
          DocumentCardFormViewModel,
          EmployeeDocumentKindAccessRightsInfoDto
        );

      DocumentCardFrame.Font := Font;

      CustomizeDocumentCardFrame(DocumentCardFrame);
      
    except

      on e: Exception do begin

        FreeAndNil(DocumentCardFrame);
        raise;
        
      end;

    end;

  finally

    FreeAndNil(EmployeeDocumentKindAccessRightsInfoDto);
    FreeAndNil(DocumentCreatingDefaultInfoDTO);
    FreeAndNil(DocumentCardFrameFactory);
    FreeAndNil(DocumentCardFormViewModelMapperFactory);
    FreeAndNil(DocumentCardFormViewModelMapper);
    
  end;

  DocumentCardFrame.Font := Font;
  
  SetControlSizeByOtherControlSize(
    DocumentCardFrame,
    Self,
    6 / 7,
    6 / 7
  );

  DocumentCardFrame.
    EnableEvenlySpacePartitionBetweenDocumentInformationAreas := True;

  DocumentCardFrame.PartitionSpaceEvenlyBetweenDocumentInfoAreas;

  AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

end;

procedure TDocumentFlowWorkingForm.
  OnRelatedDocumentCardOpeningRequestedEventHandler(
    Sender: TObject;
    const RelatedDocumentId, RelatedDocumentKindId: Variant;
    const SourceDocumentId, SourceDocumentKindId: Variant
  );
var RelatedDocumentStorageService: IRelatedDocumentStorageService;
    GettingRelatedDocumentFullInfoCommand: TGettingRelatedDocumentFullInfoCommand;
    FreeGettingRelatedDocumentFullInfoCommand: IGettingRelatedDocumentFullInfoCommand;
    GettingDocumentFullInfoCommandResult: IGettingDocumentFullInfoCommandResult;
    DocumentCardFrame: TDocumentCardFrame;
begin

  if VarIsNull(SourceDocumentId) then begin

    ShowCardForDocumentAsSeparatedFormForViewOnly(
      RelatedDocumentId, RelatedDocumentKindId
    );

    Exit;

  end;

  RelatedDocumentStorageService :=
    TApplicationServiceRegistries
    .Current
    .GetDocumentBusinessProcessServiceRegistry
    .GetRelatedDocumentStorageService(
      GetDocumentKindFromIdForApplicationServicing(SourceDocumentKindId)
    );

  GettingRelatedDocumentFullInfoCommand :=
    TGettingRelatedDocumentFullInfoCommand.Create(
      TWorkingEmployee.Current.Id,
      SourceDocumentId,
      RelatedDocumentId,
      RelatedDocumentKindId
    );

  FreeGettingRelatedDocumentFullInfoCommand := GettingRelatedDocumentFullInfoCommand;

  DocumentCardFrame := nil;

  try

    Screen.Cursor := crHourGlass;
    
    GettingDocumentFullInfoCommandResult :=
      RelatedDocumentStorageService.GetRelatedDocumentFullInfo(
        GettingRelatedDocumentFullInfoCommand
      );

    DocumentCardFrame :=
      CreateDocumentCardFrameFor(
        FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
          RelatedDocumentKindId
        ),
        GettingDocumentFullInfoCommandResult.DocumentFullInfoDTO,
        GettingDocumentFullInfoCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO
      );

    CustomizeDocumentCardFrame(DocumentCardFrame);

    AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

    DocumentCardForm := TDocumentCardForm.Create(DocumentCardFrame, Self);
    DocumentCardForm.DeleteOnClose := True;
    DocumentCardForm.Position := poMainFormCenter;
    DocumentCardForm.Caption := 'Карточка связного документа';
    DocumentCardForm.Font := Font;

    SetControlSizeByOtherControlSize(
      DocumentCardForm,
      Self,
      6 / 7,
      6 / 7
    );

    Screen.Cursor := crDefault;

    DocumentCardForm.ShowModal;
    
  except

    on e: Exception do begin

      Screen.Cursor := crDefault;
      
      FreeAndNil(DocumentCardFrame);

      raise;
      
    end;

  end;
  
end;

procedure TDocumentFlowWorkingForm.OnRespondingDocumentCreatingFinishedEventHandler(
  Sender: TObject;
  RespondingDocumentCardFrame: TDocumentCardFrame
);
begin

  FRequestedFocuseableDocumentId := RespondingDocumentCardFrame.ViewModel.DocumentId;
  
  CurrentDocumentKindSectionId := RespondingDocumentCardFrame.ViewModel.DocumentKindId;
  
end;

procedure TDocumentFlowWorkingForm.OnDetachableDocumentCardFormDeleteEventHandler(
  Sender: TObject);
begin

  FDetachableDocumentCardForm := nil;
  
end;

procedure TDocumentFlowWorkingForm.OnDocucmentRecordFocusedEventHandler(
  Sender: TObject;
  PreviousFocusedDocumentRecordViewModel,
  FocusedDocumentRecordViewModel: TDocumentRecordViewModel
);
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
  
  if Assigned(FocusedDocumentRecordViewModel) then begin

    ShowCardForDocumentAndUpdateRelatedDocumentRecord(
      FocusedDocumentRecordViewModel.DocumentId,
      FocusedDocumentRecordViewModel.KindId
    );

  end;

end;

procedure TDocumentFlowWorkingForm.OnSelectedDocumentRecordChangedEventHandler(
  Sender: TObject
);
begin

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

end;

procedure TDocumentFlowWorkingForm.OnSelectedDocumentRecordChangingEventHandler(
  Sender: TObject);
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

end;

procedure TDocumentFlowWorkingForm.PerformCurrentDocument;
var DocumentPerformingService: IDocumentPerformingService;
begin

  DocumentPerformingService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
      GetDocumentPerformingService(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

  DocumentPerformingService.PerformDocument(
    FSelectedDocumentCardFrame.ViewModel.
    DocumentMainInformationFormViewModel.DocumentId,
    TWorkingEmployee.Current.Id
  );

end;

procedure TDocumentFlowWorkingForm.PerformDocumentChargeSheets(
  DocumentChargeIds: TVariantList);
var
    DocumentChargeId: Variant;
    DocumentChargeSheetAppControlService: IDocumentChargeSheetControlAppService;
begin

  DocumentChargeSheetAppControlService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentChargeSheetControlAppService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  for DocumentChargeId in DocumentChargeIds do begin

    { refactor: внутри службы определять,
      требуется ли для документа конкретного вида
      перекрывающее или обычное исполнение }
    DocumentChargeSheetAppControlService.
      MakeOverlappingPerformingOfChargeSheet(
        TWorkingEmployee.Current.Id,
        DocumentChargeId,
        '',
        Now
      );
    
  end;

end;

procedure TDocumentFlowWorkingForm.QueueOldDocumentCardDestroyMessage;
begin

  if Assigned(FSelectedDocumentCardFrame) then begin

    PostMessage(
      Self.Handle,
      WM_DESTROY_OLD_DOCUMENT_CARD,
      0,
      Integer(FSelectedDocumentCardFrame)
    );

  end;

end;

procedure TDocumentFlowWorkingForm.
  QueueOldEmployeeDocumentsReferenceFormDestroyingMessage(
    OldEmployeeDocumentsReferenceForm: TBaseEmployeeDocumentsReferenceForm
  );
begin

  PostMessage(
    Self.Handle,
    WM_DESTROY_OLD_EMPLOYEE_DOCUMENTS_REFERENCE_FORM,
    0,
    Integer(OldEmployeeDocumentsReferenceForm)
  );

end;

procedure TDocumentFlowWorkingForm.QueueOldEmployeeDocumentsReferenceFormDestroyingMessageHandler(
  var Message: TMessage
);
var
    OldEmployeeDocumentsReferenceForm: TBaseEmployeeDocumentsReferenceForm;
begin

  OldEmployeeDocumentsReferenceForm := TBaseEmployeeDocumentsReferenceForm(Message.LParam);

  OldEmployeeDocumentsReferenceForm.FreeWhenItWillBePossible;
  
end;

procedure TDocumentFlowWorkingForm.QueueUpdateDocumentCardAfterApprovingCompletingMessageHandler;
begin

  PostMessage(
    Self.Handle,
    WM_UPDATE_DOCUMENT_CARD_AFTER_APPROVING_COMPLETING_MESSAGE,
    0,
    0
  );
  
end;

procedure TDocumentFlowWorkingForm.
  ShowCardForDocumentAndUpdateRelatedDocumentRecord(
    const DocumentId: Variant;
    const DocumentKindId: Variant
  );
var DocumentCardFrame: TDocumentCardFrame;
begin

  try

    try

      Screen.Cursor := crHourGlass;

      DocumentCardFrame :=
        GetCardFrameForDocument(
          DocumentId,
          DocumentKindId
        );

      CustomizeDocumentCardFrame(DocumentCardFrame);

      ChangeDocumentRecordInBaseEmployeeDocumentsReferenceFormFrom(
        DocumentCardFrame.ViewModel
      );

      AssignDocumentCardFrame(DocumentCardFrame);

    except

      on e: Exception do begin

        Screen.Cursor := crDefault;
        
        ShowErrorMessage(
          Self.Handle, e.Message, 'Ошибка'
        );
        
      end;

    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentFlowWorkingForm.ShowCardForDocumentAsSeparatedFormForViewOnly(
  const DocumentId: Variant;
  const DocumentKindId: Variant
);
var DocumentCardForm: TDocumentCardForm;
    DocumentCardFrame: TDocumentCardFrame;
begin

  DocumentCardFrame := nil;
  
  try

    Screen.Cursor := crHourGlass;
    
    DocumentCardFrame :=
      GetCardFrameForDocumentForViewOnly(DocumentId, DocumentKindId);

    CustomizeDocumentCardFrame(DocumentCardFrame);

    AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

    DocumentCardForm := TDocumentCardForm.Create(DocumentCardFrame, Self);
    DocumentCardForm.DeleteOnClose := True;
    DocumentCardForm.Position := poMainFormCenter;
    DocumentCardForm.Caption := 'Карточка связного документа';
    DocumentCardForm.Font := Font;

    SetControlSizeByOtherControlSize(
      DocumentCardForm,
      Self,
      6 / 7,
      6 / 7
    );

    Screen.Cursor := crDefault;
        
    DocumentCardForm.ShowModal;

  finally

    Screen.Cursor := crDefault;
    
    FreeAndNil(DocumentCardFrame);
    
  end;

end;

{ refactor: удалить резолверы ид док-ов, вместо сделать
  строготипизированными наьоры данных центральных таблиц доков }
procedure TDocumentFlowWorkingForm.ShowDocumentCardForCurrentDocumentRecord;
var
    DocumentCardFrame: TDocumentCardFrame;
    DocumentId: Variant;
    DocumentKindId: Variant;
begin

  try

    try

      Screen.Cursor := crHourGlass;

      DocumentKindId := GetCurrentDocumentKindId;
      DocumentId := GetCurrentDocumentId;

      DocumentCardFrame := GetCardFrameForDocument(DocumentId, DocumentKindId);

      CustomizeDocumentCardFrame(DocumentCardFrame);

      AssignDocumentCardFrame(DocumentCardFrame);

    except

      on e: Exception do begin

        Screen.Cursor := crDefault;
        
        ShowErrorMessage(
          Self.Handle,
          e.Message,
          'Ошибка'
        );
        
      end;

    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentFlowWorkingForm.ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
var
    CurrentDocumentId: Variant;
    CurrentDocumentKindId: Variant;
begin

  CurrentDocumentId := GetCurrentDocumentId;
  CurrentDocumentKindId := GetCurrentDocumentKindId;
                       
  ShowCardForDocumentAndUpdateRelatedDocumentRecord(
    CurrentDocumentId,
    CurrentDocumentKindId
  );

end;

procedure TDocumentFlowWorkingForm.RefreshCurrentDocumentCardFormViewModel;
var
    CurrentDocumentId: Variant;
    CurrentDocumentKindId: Variant;
begin

  CurrentDocumentId := GetCurrentDocumentId;
  CurrentDocumentKindId := GetCurrentDocumentKindId;

  RefreshDocumentCardFormViewModel(CurrentDocumentId, CurrentDocumentKindId);

end;

procedure TDocumentFlowWorkingForm.RefreshCurrentDocumentCardFormViewModelIfNecessary;
var
    CurrentDocumentId: Variant;
    CurrentDocumentKindId: Variant;
    DocumentCardFormViewModel: TDocumentCardViewModel;
    Placeholder: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  if not FSelectedDocumentCardFrame.IsDataChanged then Exit;

  RefreshCurrentDocumentCardFormViewModel;

end;

procedure TDocumentFlowWorkingForm.RefreshDocumentCardFormViewModel(
  const DocumentId, DocumentKindId: Variant);
var DocumentCardFormViewModel: TDocumentCardViewModel;
    Placeholder: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  try

      Screen.Cursor := crHourGlass;

      GetCardFormViewModelAndAvailableActionListForDocument(
        DocumentId,
        DocumentKindId,
        DocumentCardFormViewModel,
        Placeholder
      );

      FSelectedDocumentCardFrame.ViewModel := DocumentCardFormViewModel;

      ChangeDocumentRecordInBaseEmployeeDocumentsReferenceFormFrom(
        DocumentCardFormViewModel
      );

  finally

    Screen.Cursor := crDefault;

    FreeAndNil(Placeholder);

  end;
  
end;

procedure TDocumentFlowWorkingForm.RefreshDocumentTypesDataSetIfNecessary;

var
    GlobalDocumentKindsReadService: IGlobalDocumentKindsReadService;
    UIDocumentKindMapper: IUIDocumentKindMapper;
begin

  if Assigned(DocumentTypesDataSource.DataSet) then Exit;
  
  GlobalDocumentKindsReadService :=
    TApplicationServiceRegistries
    .Current
    .GetPresentationServiceRegistry
    .GetGlobalDocumentKindsReadService;

  GlobalDocumentKindDtos :=
    GlobalDocumentKindsReadService.GetGlobalDocumentKindDtos(
      TWorkingEmployee.Current.Id
    );

  NativeDocumentKindDtos :=
    GlobalDocumentKindDtos.FetchNativeDocumentKindDtos;

  UIDocumentKindMapper := TStandardUIDocumentKindMapper.Create;

  FUIDocumentKindResolver :=
    TStandardUIDocumentKindResolver.Create(
      UIDocumentKindMapper,
      GlobalDocumentKindDtos
    );

  FUINativeDocumentKindResolver :=
    TStandardUINativeDocumentKindResolver.Create(
      UIDocumentKindMapper,
      NativeDocumentKindDtos
    );

  FDocumentTypesPanelController.UIDocumentKindResolver := UIDocumentKindResolver;
  FDocumentTypesPanelController.UINativeDocumentKindResolver := UINativeDocumentKindResolver;
  
  FDocumentTypesPanelController.FillDocumentKindsControlFrom(
    Self,
    GlobalDocumentKindDtos
  );

end;

procedure TDocumentFlowWorkingForm.RejectApprovingOfCurrentDocument;
var DocumentApprovingRejectingService: IDocumentApprovingRejectingService;
begin

  DocumentApprovingRejectingService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentApprovingRejectingService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentApprovingRejectingService.RejectApprovingDocument(

    FSelectedDocumentCardFrame.
    ViewModel.
    DocumentMainInformationFormViewModel.
    DocumentId,
    
    TWorkingEmployee.Current.Id
  );

end;

procedure TDocumentFlowWorkingForm.RejectSigningOfCurrentDocument;
var DocumentSigningRejectingService: IDocumentSigningRejectingService;
begin

  DocumentSigningRejectingService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentSigningRejectingService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentSigningRejectingService.RejectSigningDocument(
    FSelectedDocumentCardFrame.ViewModel.DocumentMainInformationFormViewModel.DocumentId,
    TWorkingEmployee.Current.Id
  );

end;

procedure TDocumentFlowWorkingForm.RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
begin

  if

      RequestUserConfirmDocumentCardChangesIfNecessary =
      DocumentCardChangesConfirmed

  then SaveChangesOfCurrentDocumentCardIfNecessary

  else begin

    if Assigned(FSelectedDocumentCardFrame) then
      FSelectedDocumentCardFrame.OnChangesApplied;
    
  end;

end;

function TDocumentFlowWorkingForm.RequestUserConfirmDocumentCardChangesIfNecessary: TDocumentCardChangesConfirmingResult;
begin

  if not Assigned(FSelectedDocumentCardFrame) then begin

    Result := DocumentCardChangesNotConfirmed;
    Exit;

  end;

  if FSelectedDocumentCardFrame.IsEmpty or
     not FSelectedDocumentCardFrame.IsDataChanged
  then begin

    Result := DocumentCardChangesNotConfirmed;
    Exit;

  end;

  if

    ShowQuestionMessage(
      Self.Handle,
      'В текущей карточке документа обнаружены ' +
      'внесённые Вами изменения. Сохранить их ?',
      'Вопрос'
    ) = IDYES

  then Result := DocumentCardChangesConfirmed
  else Result := DocumentCardChangesNotConfirmed;
  
end;

function TDocumentFlowWorkingForm.ResolveNativeDocumentKindById(
  const DocumentKindId: Variant): TDocumentKindClass;
begin

  Result :=
    NativeDocumentKindDtos
      .FindByIdOrRaise(DocumentKindId).ServiceType;
      
end;

function TDocumentFlowWorkingForm.ResolveUIDocumentKindSection(
  const DocumentKindId: Variant
): TUIDocumentKindClass;
begin

  Result := FUIDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId);

end;

function TDocumentFlowWorkingForm.
  SaveApprovingsChangesOfCurrentDocumentCardIfNecessary: Boolean;
var DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentStorageService: IDocumentStorageService;
    DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
begin

  if not FSelectedDocumentCardFrame.DocumentApprovingsFrame.IsDataChanged
  then begin

    Result := False;
    Exit;
    
  end;

  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;

  DocumentApprovingsFormViewModel :=
    FSelectedDocumentCardFrame.DocumentApprovingsFrame.ViewModel;

  try

      DocumentStorageService :=
        TApplicationServiceRegistries.
        Current.
        GetDocumentBusinessProcessServiceRegistry.
        GetDocumentStorageService(
          GetCurrentNativeDocumentKindForApplicationServicing
        );

      DocumentCardFormViewModelMapperFactory :=
        TDocumentCardFormViewModelMapperFactories.
        Current.
        CreateDocumentCardFormViewModelMapperFactory(
          GetCurrentUIDocumentKind
        );

      DocumentCardFormViewModelMapper :=
        DocumentCardFormViewModelMapperFactory.
          CreateDocumentCardFormViewModelMapper;

      DocumentApprovingsInfoDTO :=
        DocumentCardFormViewModelMapper.
          DocumentApprovingsFormViewModelMapper.
            MapDocumentApprovingsFormViewModelTo(
              DocumentApprovingsFormViewModel
            );

      DocumentStorageService.ChangeDocumentApprovingsInfo(
        TChangeDocumentApprovingsInfoCommand.Create(
          TWorkingEmployee.Current.Id,
          FSelectedDocumentCardFrame.ViewModel.DocumentId,
          DocumentApprovingsInfoDTO
        )
      );

      FSelectedDocumentCardFrame.OnChangesApplied;
      
      Result := True;
    
  finally

    FreeAndNil(DocumentCardFormViewModelMapper);
    FreeAndNil(DocumentCardFormViewModelMapperFactory);
    
  end;

end;

procedure TDocumentFlowWorkingForm.SaveChangesAndRefreshCurrentDocumentCardIfNecessary;
begin

  if SaveChangesOfCurrentDocumentCardIfNecessary then
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

end;

procedure TDocumentFlowWorkingForm.SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
begin

  if SaveChangesOfCurrentDocumentCardIfNecessary then
    RefreshCurrentDocumentCardFormViewModel;
  
end;

{
  refactor:
  создать объекты сохранителей данных о док-ах
  для определенных видов карточек }
function TDocumentFlowWorkingForm.SaveChangesOfCurrentDocumentCardIfNecessary: Boolean;
var
    DocumentStorageService: IDocumentStorageService;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    ChangedDocumentInfoDTO: TChangedDocumentInfoDTO;
    SaveableDocumentKind: TUIDocumentKindClass;
begin

  SaveableDocumentKind := GetCurrentUIDocumentKind;

  if SaveableDocumentKind.InheritsFrom(TUIIncomingDocumentKind)
  then begin

    Result := SaveChargeSheetsChangesForCurrentDocumentAndUpdateUIIfNecessary;

    Exit;
    
  end;
  
  if not Assigned(FSelectedDocumentCardFrame) then begin

    Result := False;
    Exit;

  end;

  if not FSelectedDocumentCardFrame.IsDataChanged then begin

    Result := False;
    Exit;

  end;

  { Refactor: Выделить отдельный объект, опр. как сохранять
    данные документа в карточке для каждого
    вида документов
  }
  if FSelectedDocumentCardFrame.DocumentApprovingsFrame.IsDataChanged
     and not FSelectedDocumentCardFrame.DocumentChargesFrame.IsDataChanged
     and not FSelectedDocumentCardFrame.DocumentRelationsFrame.IsDataChanged
     and not FSelectedDocumentCardFrame.DocumentFilesFrame.IsDataChanged
     and not FSelectedDocumentCardFrame.DocumentMainInformationFrame.IsDataChanged
  then begin

    Result := SaveApprovingsChangesOfCurrentDocumentCardIfNecessary;

    Exit;
    
  end;

  DocumentStorageService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.GetDocumentStorageService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentCardFormViewModelMapperFactory := nil;
  DocumentCardFormViewModelMapper := nil;

  try

      Screen.Cursor := crHourGlass;

      DocumentCardFormViewModelMapperFactory :=
        TDocumentCardFormViewModelMapperFactories.
        Current.
        CreateDocumentCardFormViewModelMapperFactory(
          SaveableDocumentKind
        );

      DocumentCardFormViewModelMapper :=
        DocumentCardFormViewModelMapperFactory.
          CreateDocumentCardFormViewModelMapper;

      ChangedDocumentInfoDTO :=
        DocumentCardFormViewModelMapper.
          MapDocumentCardFormViewModelToChangedDocumentInfoDTO(
            FSelectedDocumentCardFrame.ViewModel
          );

      DocumentStorageService.ChangeDocumentInfo(
        TChangeDocumentInfoCommand.Create(
          TWorkingEmployee.Current.Id,
          ChangedDocumentInfoDTO
        )
      );

      FSelectedDocumentCardFrame.OnChangesApplied;

      ChangeDocumentRecordInBaseEmployeeDocumentsReferenceFormFrom(
        FSelectedDocumentCardFrame.ViewModel
      );

      Result := True;

  finally

    Screen.Cursor := crDefault;
    
    FreeAndNil(DocumentCardFormViewModelMapperFactory);
    FreeAndNil(DocumentCardFormViewModelMapper);

  end;

end;

{
  refactor:
  создать объекты сохранителей данных о док-ах
  для определенных видов карточек }
function TDocumentFlowWorkingForm.
  SaveChargeSheetsChangesForCurrentDocumentAndUpdateUIIfNecessary: Boolean;

  procedure UpdateCurrentEmployeeDocumentKindAndChargesStatistics;
  begin

      UpdateCurrentEmployeeDocumentKindWorkStatistics;

      UpdateEmployeeChargesWorkStatisticsForDocument(
        FSelectedDocumentCardFrame.ViewModel.DocumentId
      );

  end;

begin

  try

    if SaveChargeSheetsChangesForCurrentDocumentIfNecessary then begin

      RefreshDocumentCardFormViewModel(
        FSelectedDocumentCardFrame.ViewModel.DocumentId,
        FSelectedDocumentCardFrame.ViewModel.DocumentKindId
      );

      FSelectedDocumentCardFrame.OnChangesApplied;
      
      Result := True;
      
    end;

    UpdateCurrentEmployeeDocumentKindAndChargesStatistics;

  except

    on OuterException: TBusinessProcessServiceException do begin

      if OuterException.BusinessOperationSuccessed then begin

        try

          RefreshCurrentDocumentCardFormViewModel;
          UpdateCurrentEmployeeDocumentKindAndChargesStatistics;

          Result := True;
          
        except

          on InnerException: Exception do begin

            raise Exception.CreateFmt(
              'Возникли следующие ошибки: ' + sLineBreak +
              '1) %s' + sLineBreak + sLineBreak +
              '2) %s',
              [
                OuterException.Message,
                InnerException.Message
              ]
            );

          end;

        end;

      end;

      raise;

    end;

  end;
  
end;

function
 TDocumentFlowWorkingForm.
  SaveChargeSheetsChangesForCurrentDocumentIfNecessary: Boolean;

var DocumentChargeSheetControlAppService:
      IDocumentChargeSheetControlAppService;

    DocumentChargeSheetsChangesInfoDTOMapper:
      TDocumentChargeSheetsChangesInfoDTOMapper;

    DocumentChargeSheetsChangesInfoDTOMapperFactory:
      TDocumentChargeSheetsChangesInfoDTOMapperFactory;

    DocumentChargeSheetsChangesInfoDTO:
      TDocumentChargeSheetsChangesInfoDTO;
      
begin

  if
      not Assigned(FSelectedDocumentCardFrame) or
      not FSelectedDocumentCardFrame.DocumentChargesFrame.IsDataChanged

  then begin

    Result := False;
    Exit;

  end;
  
  DocumentChargeSheetControlAppService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentChargeSheetControlAppService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentChargeSheetsChangesInfoDTOMapper := nil;
  DocumentChargeSheetsChangesInfoDTOMapperFactory := nil;
  
  try

    DocumentChargeSheetsChangesInfoDTOMapperFactory :=
      TDocumentChargeSheetsChangesInfoDTOMapperFactories.
      Current.
      CreateDocumentChargeSheetsChangesInfoDTOMapperFactory(
        GetCurrentUIDocumentKind
      );

    DocumentChargeSheetsChangesInfoDTOMapper :=
      DocumentChargeSheetsChangesInfoDTOMapperFactory.
        CreateDocumentChargeSheetsChangesInfoDTOMapper;

    DocumentChargeSheetsChangesInfoDTO :=
      DocumentChargeSheetsChangesInfoDTOMapper.
        MapDocumentChargeSheetsChangesInfoDTOFrom(
          FSelectedDocumentCardFrame.ViewModel.DocumentChargesFormViewModel
        );

  finally

    FreeAndNil(DocumentChargeSheetsChangesInfoDTOMapperFactory);
    FreeAndNil(DocumentChargeSheetsChangesInfoDTOMapper);

  end;

  try

    Screen.Cursor := crHourGlass;
    
    try

      DocumentChargeSheetControlAppService.SaveDocumentChargeSheetsChanges(
        TSavingDocumentChargeSheetChangesCommand.Create(
          TWorkingEmployee.Current.Id,
          DocumentChargeSheetsChangesInfoDTO
        )
      );

      FSelectedDocumentCardFrame.DocumentChargesFrame.OnChangesApplied;

      Result := True;

    except

      on e: Exception do begin

        FSelectedDocumentCardFrame.DocumentChargesFrame.OnChangesApplyingFailed;
        
        raise;
        
      end;

    end;
    
  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentFlowWorkingForm.SendCurrentDocumentToApproving;
var SendingDocumentToApprovingService: ISendingDocumentToApprovingService;
begin

  SendingDocumentToApprovingService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetSendingDocumentToApprovingService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  SendingDocumentToApprovingService.SendDocumentToApproving(
    FSelectedDocumentCardFrame.ViewModel.DocumentId,
    TWorkingEmployee.Current.Id
  );
  
end;

procedure TDocumentFlowWorkingForm.SendCurrentDocumentToSigning;
var SendingDocumentToSigningService: ISendingDocumentToSigningService;
begin

  SendingDocumentToSigningService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetSendingDocumentToSigningService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  SendingDocumentToSigningService.SendDocumentToSigning(

    FSelectedDocumentCardFrame.ViewModel.
    DocumentMainInformationFormViewModel.DocumentId,

    TWorkingEmployee.Current.Id{,

    FSelectedDocumentCardFrame.ViewModel.
    DocumentMainInformationFormViewModel.DocumentSignerViewModel.Id}
    
  );
    
end;

procedure TDocumentFlowWorkingForm.SetBaseEmployeeDocumentsReferenceForm(
  const Value: TBaseEmployeeDocumentsReferenceForm);
begin

  if FBaseEmployeeDocumentsReferenceForm = Value then
    Exit;

  if Assigned(FBaseEmployeeDocumentsReferenceForm) then
    FBaseEmployeeDocumentsReferenceForm.FreeWhenItWillBePossible;

  FBaseEmployeeDocumentsReferenceForm := Value;

end;

procedure TDocumentFlowWorkingForm.SetCurrentDocumentKindSection(
  UIDocumentKindSection: TUIDocumentKindClass);
var CurrentDocumentKindNode: TcxDBTreeListNode;
begin

  SetCurrentDocumentKindSectionId(
    FUIDocumentKindResolver.ResolveIdForUIDocumentKind(UIDocumentKindSection)
  );

end;

procedure TDocumentFlowWorkingForm.SetCurrentDocumentKindSectionId(
  const Value: Variant
);
var
    DocumentKindTreeNode: TcxDBTreeListNode;
begin

  RefreshDocumentTypesDataSetIfNecessary;
  
  DocumentKindTreeNode := DocumentKindTreeList.FindNodeByKeyValue(Value);

  if Assigned(DocumentKindTreeNode) then
    DocumentKindTreeNode.Focused := True;
    
end;

procedure TDocumentFlowWorkingForm.SetDocumentDataSetHoldersFactory(
  const Value: TAbstractDocumentDataSetHoldersFactory);
begin

  FDocumentDataSetHoldersFactory := Value;

  { refactor: remove it after Factory refactor }
  TDocumentCardFormViewModelMapperFactories.Current.DocumentDataSetHoldersFactory :=
    FDocumentDataSetHoldersFactory;

end;

procedure TDocumentFlowWorkingForm.SetDocumentTypesDataSet(
  const Value: TDataSet);
begin

  DocumentKindTreeList.DataController.DataSource.DataSet := Value;
  
end;

procedure TDocumentFlowWorkingForm.SetGlobalDocumentKindDtos(
  const Value: TGlobalDocumentKindDtos);
begin

  FreeAndNil(FGlobalDocumentKindDtos);

  FGlobalDocumentKindDtos := Value;
  
end;

procedure TDocumentFlowWorkingForm.SetNativeDocumentKindDtos(
  const Value: TNativeDocumentKindDtos);
begin

  FreeAndNil(FNativeDocumentKindDtos);
  
  FNativeDocumentKindDtos := Value;

end;

procedure TDocumentFlowWorkingForm.SetUIDocumentKindResolver(
  Value: IUIDocumentKindResolver);
begin

  FUIDocumentKindResolver := Value;

  if Assigned(FDocumentTypesPanelController) then begin

    FDocumentTypesPanelController.UIDocumentKindResolver :=
      FUIDocumentKindResolver;

  end;

end;

procedure TDocumentFlowWorkingForm.SetUINativeDocumentKindResolver(
  Value: IUINativeDocumentKindResolver);
begin

  FUINativeDocumentKindResolver := Value;

  if Assigned(FDocumentTypesPanelController) then begin

    FDocumentTypesPanelController.UINativeDocumentKindResolver :=
      UINativeDocumentKindResolver;

  end;

  if Assigned(FBaseEmployeeDocumentsReferenceForm) then begin

    FBaseEmployeeDocumentsReferenceForm.UIDocumentKindResolver :=
      UINativeDocumentKindResolver;
      
  end;


end;

procedure TDocumentFlowWorkingForm.
  ShowEmployeeDocumentReferenceFormForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  );
var DocumentSetReadService: IDocumentSetReadService;
    DocumentKindWorkCycleInfoAppService: IDocumentKindWorkCycleInfoAppService;

    DocumentSetHolder: TDocumentSetHolder;
    DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos;
    
    DocumentsReferenceViewModel: TEmployeeDocumentsReferenceViewModel;
begin

  if Assigned(FBaseEmployeeDocumentsReferenceForm) then begin

    QueueOldEmployeeDocumentsReferenceFormDestroyingMessage(
      FBaseEmployeeDocumentsReferenceForm
    );

    FBaseEmployeeDocumentsReferenceForm := nil;
    
  end;

  DocumentSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetDocumentSetReadService(
            GetCurrentGlobalDocumentSectionKindForApplicationServicing
          );

  DocumentKindWorkCycleInfoAppService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetDocumentKindWorkCycleInfoAppService;

  DocumentSetHolder := nil;
  DocumentKindWorkCycleInfoDtos := nil;
  DocumentsReferenceViewModel := nil;
  
  try
      
    Screen.Cursor := crHourGlass;

    try

      DocumentSetHolder :=
        DocumentSetReadService.GetEmployeeDocumentSet(
          TWorkingEmployee.Current.Id
        );

      DocumentKindWorkCycleInfoDtos :=
        DocumentKindWorkCycleInfoAppService.GetAllDocumentKindWorkCycleInfos;

      DocumentsReferenceViewModel :=
        FEmployeeDocumentsReferenceViewModelFactory
          .CreateEmployeeDocumentsReferenceViewModelFor(
            UIDocumentKind, DocumentSetHolder, DocumentKindWorkCycleInfoDtos
          );
        
      FBaseEmployeeDocumentsReferenceForm :=
        FEmployeeDocumentsReferenceFormFactory.
          GetDocumentReferenceFormFor(
            UIDocumentKind, DocumentsReferenceViewModel
          );
    
      CustomizeBaseEmployeeDocumentsReferenceForm(
        FBaseEmployeeDocumentsReferenceForm
      );

      AssignEventHandlersToEmployeeDocumentReferenceForm(
        FBaseEmployeeDocumentsReferenceForm
      );

      InflateEmployeeDocumentReferenceFormToLayout(
        FBaseEmployeeDocumentsReferenceForm
      );

      if VarIsNull(FRequestedFocuseableDocumentId) then
        FBaseEmployeeDocumentsReferenceForm.Show

      else begin

        FBaseEmployeeDocumentsReferenceForm.Show(FRequestedFocuseableDocumentId);

        FRequestedFocuseableDocumentId := Null;

      end;
      
    except

      on E: Exception do begin

        if Assigned(FBaseEmployeeDocumentsReferenceForm) then
          FreeAndNil(FBaseEmployeeDocumentsReferenceForm)

        else if Assigned(DocumentsReferenceViewModel) then
          FreeAndNil(DocumentsReferenceViewModel)

        else begin

          FreeAndNil(DocumentKindWorkCycleInfoDtos);
          FreeAndNil(DocumentSetHolder);
          
        end;

        raise;

      end;
      
    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentFlowWorkingForm.OnDocumentSigningRequestedEventHandler(
  Sender: TObject);
begin

  try

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    SignCurrentDocument;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    UpdateEmployeeChargesWorkStatisticsForDocument(FSelectedDocumentCardFrame.ViewModel.DocumentId);
    UpdateCurrentEmployeeDocumentKindWorkStatistics;

  except

    on OuterException: TBusinessProcessServiceException do begin

      if OuterException.BusinessOperationSuccessed then begin

        try

          ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
          UpdateEmployeeDocumentWorkStatistics;

        except

          on InnerException: Exception do begin

            raise Exception.CreateFmt(
              'Возникли следующие ошибки:' + sLineBreak +
              '1) %s' + sLineBreak + sLineBreak +
              '2) %s',
              [
                OuterException.Message,
                InnerException.Message
              ]
            );

          end;

        end;

      end;

      raise;
      
    end;

  end;

end;

procedure TDocumentFlowWorkingForm.
  OnDocumentWorkStatisticsFetchedEventHandler(
    Sender: Tobject;
    EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
  );
begin

  try

    if not Assigned(EmployeeDocumentWorkStatisticsList) then Exit;
    
    FDocumentTypesPanelController.SetEmployeeDocumentWorkStatistics(
      Self,
      EmployeeDocumentWorkStatisticsList
    );

  finally

    FreeAndNil(EmployeeDocumentWorkStatisticsList);
    
  end;

end;

procedure TDocumentFlowWorkingForm.
  OnDocumentWorkStatisticsFetchingErrorEventHandler(
    Sender: TObject;
    const Error: Exception
  );
begin

  ShowErrorMessage(
    Self.Handle, Error.Message, 'Ошибка'
  );

end;

{ refactor }
procedure TDocumentFlowWorkingForm.OnDocumentFileOpeningRequestedEventHandler(
  Sender: TObject;
  const DocumentFileId: Variant;
  var DocumentFilePath: String
);
var DocumentFileServiceClient: IDocumentFileServiceClient;
begin
  
  DocumentFileServiceClient :=
    TApplicationServiceRegistries.
    Current.
    GetExternalServiceRegistry.
    GetDocumentFileServiceClient(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  if not VarIsNull(DocumentFileId) then
    DocumentFilePath := DocumentFileServiceClient.GetFile(DocumentFileId);
                     
end;

procedure TDocumentFlowWorkingForm.OldDocumentCardDestroyMessageHandler(
  var Message: TMessage
);
var OldDocumentCard: TDocumentCardFrame;
begin

  OldDocumentCard := TDocumentCardFrame(Message.LParam);

  FreeAndNil(OldDocumentCard);

end;

procedure TDocumentFlowWorkingForm.OnApprovingDocumentSendingRequestedEventHanlder(
  Sender: TObject);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    SendCurrentDocumentToApproving;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
    UpdateCurrentEmployeeDocumentKindWorkStatistics;

  finally

    Screen.Cursor := crDefault;

  end;
  
end;

{ refactor: скрыть отображетль инф-ции о новом
  цикле согласования }
procedure TDocumentFlowWorkingForm.
  OnNewDocumentApprovingCycleCreatingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    DocumentApprovingCycleDTO: TDOcumentApprovingCycleDTO;
    DocumentCardFormViewModelFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    CurrentDocumentKind: TUIDocumentKindClass;
begin

  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelFactory := nil;
  DocumentApprovingCycleDTO := nil;
  DocumentApprovingCycleViewModel := nil;

  try

    Screen.Cursor := crHourGlass;

    if VarIsNull(DocumentId) then
      CurrentDocumentKind := GetCurrentUIDocumentKindSection

    else CurrentDocumentKind := GetCurrentUIDocumentKind;
    
    DocumentCardFormViewModelFactory :=
      TDocumentCardFormViewModelMapperFactories.
      Current.
      CreateDocumentCardFormViewModelMapperFactory(
        CurrentDocumentKind
      );

    DocumentCardFormViewModelMapper :=
      DocumentCardFormViewModelFactory.
        CreateDocumentCardFormViewModelMapper;

    if VarIsNull(DocumentId) then begin

      DocumentApprovingCycleViewModel :=
        DocumentCardFormViewModelMapper.
          DocumentApprovingsFormViewModelMapper.
            CreateNewDocumentApprovingCycleViewModel;

    end

    else begin

      DocumentApprovingControlAppService :=
        TApplicationServiceRegistries.
        Current.
        GetDocumentBusinessProcessServiceRegistry.
        GetDocumentApprovingControlAppService(
          GetCurrentNativeDocumentKindForApplicationServicing
        );

      DocumentApprovingCycleDTO :=
        DocumentApprovingControlAppService.
          GetInfoForNewDocumentApprovingCycle(
            DocumentId,
            TWorkingEmployee.Current.Id
          );

      DocumentApprovingCycleViewModel :=
        DocumentCardFormViewModelMapper.
          DocumentApprovingsFormViewModelMapper.
            MapDocumentApprovingCycleViewModelFrom(
              DocumentApprovingCycleDTO
            );
    end;

    NewDocumentApprovingCycleViewModel := DocumentApprovingCycleViewModel;

    NewDocumentApprovingCycleViewModel.CanBeChanged := True;
    NewDocumentApprovingCycleViewModel.CanBeRemoved := True;
    NewDocumentApprovingCycleViewModel.CanBeCompleted := False;

  finally

    Screen.Cursor := crDefault;

    FreeAndNil(DocumentCardFormViewModelMapper);
    FreeAndNil(DocumentCardFormViewModelFactory);
    FreeAndNil(DocumentApprovingCycleDTO);

  end;

end;

procedure TDocumentFlowWorkingForm.
  OnDocumentApprovingChangingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    ApprovingViewModel: TDocumentApprovingViewModel
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
begin

  if not VarIsNull(ApprovingViewModel.CanBeChanged) then Exit;

  if not CurrentApprovingCycleViewModel.IsNew
  then begin

    ApprovingViewModel.CanBeChanged := False;
    ApprovingViewModel.CanBeRemoved := False;

    Exit;
    
  end;

  if VarIsNull(DocumentId) then begin

    ApprovingViewModel.CanBeChanged := False;
    ApprovingViewModel.CanBeRemoved := True;

    Exit;
    
  end;

  try

    Screen.Cursor := crHourGlass;

    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

    try

      DocumentApprovingControlAppService.
        EnsureThatEmployeeMayChangeDocumentApproverInfo(
          TWorkingEmployee.Current.Id,
          DocumentId,
          ApprovingViewModel.ApproverId
        );

      ApprovingViewModel.CanBeChanged := True;

    except

      on e: TDocumentApprovingControlAppServiceException do begin

        ApprovingViewModel.CanBeChanged := False;

        //raise;

      end;

    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentFlowWorkingForm.
  OnDocumentApprovingCompletingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    CycleViewModel: TDocumentApprovingCycleViewModel
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
begin

  if not CycleViewModel.CanBeCompleted then Exit;

  if VarIsNull(DocumentId) then begin

    CycleViewModel.CanBeCompleted := False;

    Exit;
    
  end;

  try

    Screen.Cursor := crHourGlass;
    
    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

    try

      DocumentApprovingControlAppService.CompleteDocumentApproving(
        DocumentId,
        TWorkingEmployee.Current.Id
      );

      CycleViewModel.CanBeCompleted := True;
      
      QueueUpdateDocumentCardAfterApprovingCompletingMessageHandler;

    except

      on e: TDocumentApprovingControlAppServiceException do begin

        CycleViewModel.CanBeCompleted := False;

        raise;

      end;

    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

{
  refactor:
  пересмотреть в связи
  с пересмотром реализации
  механизма согласования документов
}
procedure TDocumentFlowWorkingForm.
  OnDocumentApprovingCycleRemovingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    CycleViewModel: TDocumentApprovingCycleViewModel
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
begin

  if not VarIsNull(CycleViewModel.CanBeRemoved) then Exit;

  { предметная логика,
    перенести в слой предметной области
  }
  if not CycleViewModel.IsNew then begin

    CycleViewModel.CanBeRemoved := False;
    
    raise Exception.Create(
      'Завершенные циклы являются ' +
      'историей прошлых согласований и ' +
      'поэтому не подлежат удалению'
    );

  end;

  if VarIsNull(DocumentId) then begin

    CycleViewModel.CanBeRemoved := True;

    Exit;
    
  end;

  try

    Screen.Cursor := crHourGlass;

    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

    try

      DocumentApprovingControlAppService.
        EnsureThatEmployeeMayChangeDocumentApproverList(
          TWorkingEmployee.Current.Id,
          DocumentId
        );

      CycleViewModel.CanBeRemoved := True;
      
    except

      on e: TDocumentApprovingControlAppServiceException do begin

        CycleViewModel.CanBeRemoved := False;

        raise;

      end;

    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentFlowWorkingForm.
  OnDocumentApprovingCycleSelectedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    SelectedCycleViewModel: TDocumentApprovingCycleViewModel
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    ApprovingCycleInfoCanBeChanged, ApprovingCycleInfoCanBeRemoved: Boolean;
begin

  if not VarIsNull(SelectedCycleViewModel.CanBeChanged)
     and not VarIsNull(SelectedCycleViewModel.CanBeRemoved)

  then Exit;

  { предметная логика, вынести в домен, обращаться через
    прикладную службу }

  if not SelectedCycleViewModel.IsNew then begin

    SelectedCycleViewModel.CanBeChanged := False;
    SelectedCycleViewModel.CanBeRemoved := False;
    
    Exit;
    
  end;

  if VarIsNull(DocumentId) then begin

    SelectedCycleViewModel.CanBeChanged := False;
    SelectedCycleViewModel.CanBeRemoved := True;

    Exit;
    
  end;

  DocumentApprovingControlAppService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentApprovingControlAppService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  ApprovingCycleInfoCanBeChanged :=
    DocumentApprovingControlAppService.MayEmployeeChangeDocumentApproverList(
      TWorkingEmployee.Current.Id,
      DocumentId
    );

  ApprovingCycleInfoCanBeRemoved := ApprovingCycleInfoCanBeChanged;

  SelectedCycleViewModel.CanBeChanged := ApprovingCycleInfoCanBeChanged;
  SelectedCycleViewModel.CanBeRemoved := ApprovingCycleInfoCanBeRemoved;
  
end;

procedure TDocumentFlowWorkingForm.
  OnDocumentApprovingsRemovingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    DocumentApprovingsViewModel: TDocumentApprovingsViewModel
  );
var DocumentApprovingViewModel: TDocumentApprovingViewModel;
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
begin

  try

    Screen.Cursor := crHourGlass;

    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

    for DocumentApprovingViewModel in DocumentApprovingsViewModel do begin

      if not VarIsNull(
            DocumentApprovingViewModel.CanBeRemoved
         )

      then Continue;

      if not CurrentApprovingCycleViewModel.IsNew then begin

        DocumentApprovingViewModel.CanBeRemoved := False;
        Continue;
        
      end;

      if VarIsNull(DocumentApprovingViewModel.ApprovingId)
         or VarIsNull(DocumentId)
      then begin

        DocumentApprovingViewModel.CanBeRemoved := True;

        Continue;

      end;

      try

        DocumentApprovingControlAppService.
          EnsureThatEmployeeMayRemoveDocumentApprover(
            TWorkingEmployee.Current.Id,
            DocumentId,
            DocumentApprovingViewModel.ApproverId
          );

        DocumentApprovingViewModel.CanBeRemoved := True;
      
      except

        on e: TDocumentApprovingControlAppServiceException do begin

          DocumentApprovingViewModel.CanBeRemoved := False;
        
          raise;
        
        end;

      end;

    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentFlowWorkingForm.
  OnEmployeesAddingForApprovingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    EmployeeIds: TVariantList
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    EmployeeId: Variant;
begin

  if VarIsNull(DocumentId) then Exit;
  
  try

    Screen.Cursor := crHourGlass;
    
    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

    for EmployeeId in EmployeeIds do begin

      DocumentApprovingControlAppService.
        EnsureThatEmployeeMayAssignDocumentApprover(
          TWorkingEmployee.Current.Id,
          DocumentId,
          EmployeeId
        );
        
    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentFlowWorkingForm.OnDocumentApprovingRejectingRequestedEventHandler(
  Sender: TObject);
begin

  try

    Screen.Cursor := crHourGlass;

    //SaveChangesOfCurrentDocumentCardIfNecessary;
    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    RejectApprovingOfCurrentDocument;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
    UpdateCurrentEmployeeDocumentKindWorkStatistics;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentFlowWorkingForm.OnDocumentApprovingRequestedEventHandler(
  Sender: TObject);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    ApproveCurrentDocument;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
    UpdateCurrentEmployeeDocumentKindWorkStatistics;

  finally

    Screen.Cursor := crDefault;

  end;

  
end;

procedure TDocumentFlowWorkingForm.
  OnDocumentChargesPerformingRequestedEventHandler(
    Sender: TObject;
    RequestedChargeIds: TVariantList
  );
var DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
    DocumentKindWorkCycleInfoAppService: IDocumentKindWorkCycleInfoAppService;
begin

  try
      
    Screen.Cursor := crHourGlass;

    SaveChargeSheetsChangesForCurrentDocumentIfNecessary;
    PerformDocumentChargeSheets(RequestedChargeIds);

    UpdateEmployeeChargesWorkStatisticsForDocument(
      FSelectedDocumentCardFrame.ViewModel.DocumentId
    );

    UpdateCurrentEmployeeDocumentKindWorkStatistics;

    ShowDocumentCardForCurrentDocumentRecord;

    if
        not
        FSelectedDocumentCardFrame.
        DocumentChargesFrame.
        IsAllChargesPerformedByWorkingEmployee

    then Exit;

    DocumentKindWorkCycleInfoAppService :=
      TApplicationServiceRegistries
        .Current
          .GetPresentationServiceRegistry
            .GetDocumentKindWorkCycleInfoAppService;

    DocumentKindWorkCycleInfoDto :=
      DocumentKindWorkCycleInfoAppService.GetDocumentKindWorkCycleInfo(
        GetCurrentNativeDocumentKindForApplicationServicing
      );

    try

      { refactor: hide the details of the table records presenting }
      with
        FBaseEmployeeDocumentsReferenceForm
          .ViewModel
            .EmployeeDocumentTableViewModel
              .DocumentSetHolder as TIncomingDocumentSetHolder
      do begin

        FBaseEmployeeDocumentsReferenceForm.BeginUpdate;

        try

          AllChargeSheetsPerformedFieldValue := True;

          CurrentWorkCycleStageNameFieldValue :=
            DocumentKindWorkCycleInfoDto.DocumentPerformedStageInfo.StageName;

        finally

          FBaseEmployeeDocumentsReferenceForm.EndUpdate;
          
        end;

      end;

    finally

      FreeAndNil(DocumentKindWorkCycleInfoDto);
        
    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentFlowWorkingForm.OnDocumentDeletingRequestedEventHandler(
  Sender: TObject;
  const DocumentId: Variant
);
var
    DocumentStorageService: IDocumentStorageService;
    RemovableDocumentIds: TVariantList;
begin

  DocumentStorageService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentStorageService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentStorageService.RemoveDocumentsInfo(
    TRemoveDocumentsInfoCommand.Create(
      TWorkingEmployee.Current.Id,
      TVariantList.CreateFrom(
        [
          FSelectedDocumentCardFrame.
          ViewModel.DocumentId
        ]
      )
    )
  );

end;

procedure TDocumentFlowWorkingForm.OnDocumentInfoSavingRequestedEventHandler(
  Sender: TObject
);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardIfNecessary;

  finally

    Screen.Cursor := crDefault;

  end;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentPerformingRequestedEventHandler(
  Sender: TObject
);
begin

  try

    Screen.Cursor := crHourGlass;

    RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
    PerformCurrentDocument;

    { зависимость от порядка вызовов устранить }
    UpdateEmployeeChargesWorkStatisticsForDocument(
      FSelectedDocumentCardFrame.ViewModel.
      DocumentMainInformationFormViewModel.DocumentId
    );

    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    UpdateCurrentEmployeeDocumentKindWorkStatistics;

  finally

    Screen.Cursor := crDefault;
    
  end;
  
end;

procedure TDocumentFlowWorkingForm.
  OnDocumentChargeSheetsChangesSavingRequestedEventHandler(
    Sender: TObject
  );
begin

  SaveChargeSheetsChangesForCurrentDocumentAndUpdateUIIfNecessary;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentPrintFormRequestedEventHandler(
  Sender: TObject;
  DocumentCardViewModel: TDocumentCardViewModel
);
var DocumentPrintFormPresenter: IDocumentPrintFormPresenter;
    DocumentApprovingListCreatingAppService: IDocumentApprovingListCreatingAppService;
    DocumentApprovingListDTO: TDocumentApprovingListDTO;
    DocumentApprovingListViewModelMapper: TDocumentApprovingListViewModelMapper;
    DocumentApprovingListViewModel: TDocumentApprovingListViewModel;
begin

  DocumentApprovingListDTO := nil;
  DocumentApprovingListViewModelMapper := nil;
  DocumentApprovingListViewModel := nil;

  try

    DocumentPrintFormPresenter :=
      TDocumentReportPresenterRegistry.Current.GetDocumentPrintFormPresenter(
         FUIDocumentKindResolver.ResolveUIDocumentKindFromId(
            DocumentCardViewModel.DocumentKindId
         )
      );

    DocumentApprovingListCreatingAppService :=
      TApplicationServiceRegistries.Current.GetReportingServiceRegistry.
        GetDocumentApprovingListCreatingAppService(
          GetDocumentKindFromIdForApplicationServicing(
            DocumentCardViewModel.DocumentKindId
          )
        );

    DocumentApprovingListDTO :=
      DocumentApprovingListCreatingAppService.
        CreateDocumentApprovingListForDocument(
          DocumentCardViewModel.DocumentId
        );

    if not Assigned(DocumentApprovingListDTO) then begin

      DocumentPrintFormPresenter.PresentDocumentPrintFormBy(
        DocumentCardViewModel
      );

    end

    else begin

      DocumentApprovingListViewModelMapper :=
        TDocumentApprovingListViewModelMapper.Create(
          TKindedDocumentDataSetHoldersFactory.Create(
            GetCurrentUIDocumentKind,
            FDocumentDataSetHoldersFactory
          )
        );

      DocumentApprovingListViewModel :=
        DocumentApprovingListViewModelMapper.
          MapDocumentApprovingListViewModelFrom(
            DocumentApprovingListDTO
          );

      DocumentPrintFormPresenter.PresentDocumentPrintFormBy(
        DocumentCardViewModel,
        DocumentApprovingListViewModel
      );

    end;

  finally

    FreeAndNil(DocumentApprovingListDTO);
    FreeAndNil(DocumentApprovingListViewModel);
    FreeAndNil(DocumentApprovingListViewModelMapper);

  end;

end;

procedure TDocumentFlowWorkingForm.
  OnDocumentRecordChangingRequestedEventHandler(
    Sender: TObject;
    DocumentRecordViewModel: TDocumentRecordViewModel
  );
begin

  try

    if not Assigned(FSelectedDocumentCardFrame) then
      Exit;

    if DocumentRecordViewModel.DocumentId <>
       FSelectedDocumentCardFrame.ViewModel.DocumentId
    then begin

      raise Exception.Create(
        'Обнаружено несоответствие записи документа ' +
        'текущей карточке'
      );
      
    end;

    if not Assigned(FDetachableDocumentCardForm) then begin

      FDetachableDocumentCardForm :=
        TControlParentSwitchingForm.Create(
          nil, FSelectedDocumentCardFrame
        );

      FDetachableDocumentCardForm.DeleteOnClose := True;

      FDetachableDocumentCardForm.Position := poScreenCenter;

      FDetachableDocumentCardForm.BorderIcons :=
        FDetachableDocumentCardForm.BorderIcons - [biMinimize];

      FDetachableDocumentCardForm.OnDeleteEventHandler :=
        OnDetachableDocumentCardFormDeleteEventHandler;

      SetControlSizeByScreenSize(
        FDetachableDocumentCardForm,
        6 / 7,
        6 / 7
      );

      FDetachableDocumentCardForm.ShowModal;

    end

    else begin

      FDetachableDocumentCardForm.InternalControl :=
        FSelectedDocumentCardFrame;

      FDetachableDocumentCardForm.SetFocus;

    end;

  finally

    FreeAndNil(DocumentRecordViewModel);

  end;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentRecordDeletedEventHandler(
  Sender: TObject);
begin

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;
  UpdateCurrentEmployeeDocumentKindWorkStatistics;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentRecordsLoadingCanceledEventHandler(
  Sender: TObject);
begin

  ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentRecordsLoadingFailedEventHandler(
  Sender: TObject;
  const Error: Exception
);
begin

  ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

  ShowErrorMessage(Self.Handle, Error.Message, 'Ошибка');
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentRecordsLoadingSuccessEventHandler(
  Sender: TObject);
begin

  ShowEmptyNoActivedDocumentCardForCurrentDocumentKindIfDocumentsAreAbsent;

end;

procedure TDocumentFlowWorkingForm.OnDocumentRecordsRefreshedEventHandler(
  Sender: TObject);
begin

  UpdateCurrentEmployeeDocumentKindWorkStatistics;

end;

procedure TDocumentFlowWorkingForm.OnDocumentRecordsRefreshRequestedEventHandler(
  Sender: TObject);
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentRejectingFromSigningRequestedEventHandler(
  Sender: TObject
);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    RejectSigningOfCurrentDocument;

    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;

    UpdateCurrentEmployeeDocumentKindWorkStatistics;
    
  finally

    Screen.Cursor := crDefault;

  end;
  
end;

procedure TDocumentFlowWorkingForm.OnDocumentSendingToSigningRequestedEventHandler(
  Sender: TObject
);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    SendCurrentDocumentToSigning;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
    UpdateCurrentEmployeeDocumentKindWorkStatistics;
    
  finally

    Screen.Cursor := crDefault;

  end;

end;

end.
