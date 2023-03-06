unit unDocumentCardListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, dxSkinsCore,
  dxSkinsDefaultPainters, ActnList, Menus, StdCtrls, cxInplaceContainer,
  cxTLData, cxDBTL, ExtCtrls, cxMaskEdit,
  BaseDocumentsReferenceFormUnit,
  unDocumentCardFrame,
  DocumentMainInformationFormViewModelUnit,
  DocumentsReferenceFormFactory,
  EmployeeDocumentWorkStatisticsService,
  EmployeeDocumentWorkStatistics,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  VariantListUnit, UIDocumentKindResolver, UIDocumentKindMapper,
  DocumentsReferenceViewModelFactory,
  DocumentKinds, UIDocumentKinds,
  EmployeesReferenceFormUnit,
  DocumentApprovingViewModel,
  DocumentApprovingCycleViewModel,
  DocumentDataSetHoldersFactory,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentFullInfoDTO,
  DocumentApprovingsFormViewModel,
  DocumentRecordViewModel,
  ControlParentSwitchingFormUnit,
  UINativeDocumentKindResolver,
  DocumentSetHolder,
  DocumentKindResolver,
  GlobalDocumentKindDto,
  NativeDocumentKindDto,
  DocumentsReferenceFormPresenter,
  OperationalDocumentKindInfo,
  DocumentCardFormViewModel,
  DocumentsReferenceViewModel,
  unDocumentFlowInformationFrame,
  Disposable,
  DocumentStorageService,
  Hashes,
  UserInterfaceSwitch,
  DBClient,
  EmployeeDocumentSetReadService;

const

  WM_DESTROY_OLD_DOCUMENT_CARD = WM_USER + 1;
  WM_UPDATE_DOCUMENT_CARD_AFTER_APPROVING_COMPLETING_MESSAGE = WM_USER + 2;
  WM_DESTROY_OLD_EMPLOYEE_DOCUMENTS_REFERENCE_FORM = WM_USER + 3;
  WM_DOCUMENT_CARD_SHOW = WM_USER + 4;
  
type

  TDocumentCardShowMessageData = class (TInterfacedObject, IDisposable)

    public

      DocumentId: Variant;
      DocumentKindId: Variant;

      constructor Create(
        DocumentId: Variant;
        DocumentKindId: Variant
      );

  end;

  TDocumentCardChangesConfirmingResult = (

    DocumentCardChangesConfirmed,
    DocumentCardChangesNotConfirmed

  );

  TOnRelatedDocumentSelectionFormRequestedEventHandler =
    procedure (
      Sender: TObject;
      var RelatedDocumentSelectionForm: TForm
    ) of object;

  TOnEmployeeDocumentSetChangedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnEmployeeDocumentChargeSheetSetChangedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnRespondingDocumentCreatedEventHandler =
    procedure (
      Sender: TObject;
      RespondingDocumentCardViewModel: TDocumentCardFormViewModel
    ) of object;

  TOnDocumentCardListUpdatedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TDocumentCardListFrame = class(TDocumentFlowInformationFrame)
    PanelForDocumentRecordsAndCard: TPanel;
    DocumentListPanel: TPanel;
    SeparatorBetweenDocumentRecordsAndDocumentCard: TSplitter;
    DocumentCardPanel: TPanel;
    DocumentListLabel: TLabel;
    DocumentRecordsGridPanel: TPanel;
    DocumentCardFormPanel: TPanel;

    procedure DocumentListPanelResize(Sender: TObject);

  protected

    FDocumentCardShowMessages: TIntegerHash;

    FRequestedFocuseableDocumentId: Variant;
    FUIDocumentKindResolver: IUIDocumentKindResolver;
    FUINativeDocumentKindResolver: IUINativeDocumentKindResolver;

    FBaseDocumentsReferenceForm: TBaseDocumentsReferenceForm;

    FDetachableDocumentCardForm: TControlParentSwitchingForm;
    
    FSelectedDocumentCardFrame: TDocumentCardFrame;

    FDocumentsReferenceFormFactory:
      TDocumentsReferenceFormFactory;

    FDocumentsReferenceViewModelFactory:
      TDocumentsReferenceViewModelFactory;

    FOnRelatedDocumentSelectionFormRequestedEventHandler:
      TOnRelatedDocumentSelectionFormRequestedEventHandler;

    FCurrentDocumentKindInfo: IOperationalDocumentKindInfo;

    FDocumentsReferenceFormPresenter: IDocumentsReferenceFormPresenter;

    procedure SetCurrentDocumentKindInfo(
      const Value: IOperationalDocumentKindInfo
    );

  protected

    procedure SetWorkingEmployeeId(const Value: Variant); override;

  protected

    procedure SwitchUserInterfaceTo(Value: TUserInterfaceKind); override;

  protected

    FOnDocumentCardListUpdatedEventHandler: TOnDocumentCardListUpdatedEventHandler;
    FOnRespondingDocumentCreatedEventHandler: TOnRespondingDocumentCreatedEventHandler;
    FOnEmployeeDocumentSetChangedEventHandler: TOnEmployeeDocumentSetChangedEventHandler;
    FOnEmployeeDocumentChargeSheetSetChangedEventHandler: TOnEmployeeDocumentChargeSheetSetChangedEventHandler;

    procedure RaiseOnEmployeeDocumentSetChangedEventHandler;
    procedure RaiseOnEmployeeDocumentChargeSheetSetChangedEventHandler;
    procedure RaiseOnRespondingDocumentCreatedEventHandler(
      RespondingDocumentCardViewModel: TDocumentCardFormViewModel
    );

  public

    procedure OnShow; override;

  private

    FNativeDocumentKindDtos: TNativeDocumentKindDtos;
    FGlobalDocumentKindDtos: TGlobalDocumentKindDtos;

  private
    
    function GetEnableDocumentCardListGroupingTool: Boolean;
    procedure SetEnableDocumentCardListGroupingTool(const Value: Boolean);

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
      Sender: TObject;
      CurrentViewModel: TDocumentsReferenceViewModel;
      var UpdatedViewModel: TDocumentsReferenceViewModel
    );

    procedure OnDocumentCardRefreshRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant
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

    procedure OnDocumentRecordFocusedEventHandler(
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

    procedure OnDocumentSigningMarkingRequestedEventHandler(
      Sender: TObject;
      const SigningDate: TDateTime
    );

    procedure OnRelatedDocumentCardOpeningRequestedEventHandler(
      Sender: TObject;
      const RelatedDocumentId, RelatedDocumentKindId: Variant;
      const SourceDocumentId, SourceDocumentKindId: Variant
    );

    procedure OnDocumentPrintFormRequestedEventHandler(
      Sender: TObject;
      DocumentCardViewModel: TDocumentCardFormViewModel
    );

    procedure OnDocumentApprovingChangingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      ApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure OnDocumentApprovingCycleSelectedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      SelectedCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCompletingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCycleRemovingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingsRemovingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure OnEmployeesAddingForApprovingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      EmployeeIds: TVariantList
    );

    procedure OnNewDocumentApprovingCycleCreatingRequestedEventHandler(
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnRespondingDocumentCreatingFinishedEventHandler(
      Sender: TObject;
      RespondingDocumentCardFrame: TDocumentCardFrame
    );

    procedure SetBaseDocumentsReferenceForm(
      const Value: TBaseDocumentsReferenceForm);

  private

    procedure CustomizeAndAssignDocumentCardFrame(var DocumentCardFrame: TDocumentCardFrame);

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

    procedure ShowDocumentCardForCurrentDocumentRecord;
    procedure ShowDocumentCardFrame(const DocumentId: Variant; const DocumentKindId: Variant);
    procedure ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    procedure ShowCardForDocumentAndUpdateRelatedDocumentRecord(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

    procedure ShowCardForDocument(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

    procedure ShowCardForDocumentAsSeparatedFormForViewOnly(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

  public

    procedure CustomizeDocumentCardFrame(
      DocumentCardFrame: TDocumentCardFrame
    ); virtual;

    procedure QueueOldDocumentCardDestroyMessage;
    procedure QueueUpdateDocumentCardAfterApprovingCompletingMessageHandler;

    procedure QueueOldEmployeeDocumentsReferenceFormDestroyingMessage(
      OldEmployeeDocumentsReferenceForm: TBaseDocumentsReferenceForm
    );

    procedure QueueDocumentCardShowMessage(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    );

    procedure HandleDocumentCardShowMessage(
      var Message: TMessage
    ); message WM_DOCUMENT_CARD_SHOW;

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

    function CreateDocumentsReferenceViewModelForEmployee(
      const UIDocumentKind: TUIDocumentKindClass;
      const EmployeeId: Variant;
      Options: IEmployeeDocumentSetReadOptions
    ): TDocumentsReferenceViewModel;
    
    function GetDocumentSetHolder(
      const ServiceDocumentKind: TDocumentKindClass;
      const EmployeeId: Variant;
      const Options: IEmployeeDocumentSetReadOptions = nil
    ): TDocumentSetHolder; virtual;


    procedure CustomizeBaseDocumentsReferenceForm(
      EmployeeDocumentReferenceForm: TBaseDocumentsReferenceForm
    ); virtual;

    procedure InflateEmployeeDocumentReferenceFormToLayout(
      EmployeeDocumentReferenceForm: TBaseDocumentsReferenceForm
    );
    
    procedure AssignEventHandlersToEmployeeDocumentReferenceForm(
      EmployeeDocumentReferenceForm: TBaseDocumentsReferenceForm
    );

    procedure
      AddNewDocumentsReferenceFormRecordBy(
        DocumentCardViewModel: TDocumentCardFormViewModel
      );

    procedure
      ChangeDocumentsReferenceFormRecordBy(
        {DocumentCardViewModel: TDocumentCardFormViewModel}
        DocumentId, DocumentKindId: Variant
      );

    procedure AssignDocumentCardFrame(
      DocumentCardFrame: TDocumentCardFrame
    );

    procedure ShowEmptyNoActivedDocumentCardForCurrentDocumentKindIfDocumentsAreAbsent;
    procedure ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

    procedure ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;

    function RequestUserConfirmDocumentCardChangesIfNecessary: TDocumentCardChangesConfirmingResult;

    function GetDocumentStorageService(
      const ServiceDocumentKind: TDocumentKindClass
    ): IDocumentStorageService; virtual;

    procedure GetCardFormViewModelAndAvailableActionListForDocument(
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      var DocumentCardViewModel: TDocumentCardFormViewModel;
      var AvailableActionList: TDocumentUsageEmployeeAccessRightsInfoDTO
    );

    function CreateDocumentCardFormViewModelFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentFullInfoDTO: TDocumentFullInfoDTO;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    ): TDocumentCardFormViewModel;

    function CreateDocumentCardFrameFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentCardFormViewModel: TDocumentCardFormViewModel;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    ): TDocumentCardFrame; overload;

    function CreateDocumentCardFrameFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentFullInfoDTO: TDocumentFullInfoDTO;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    ): TDocumentCardFrame; overload;

    function CreateDocumentCardFrameFor(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentCardFormViewModel: TDocumentCardFormViewModel
    ): TDocumentCardFrame; overload;
    
    function GetCardFrameForDocument(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    ): TDocumentCardFrame;

    function GetCardFrameForDocumentForViewOnly(
      const DocumentId: Variant;
      const DocumentKindId: Variant
    ): TDocumentCardFrame;

    function GetDocumentSetByIds(
      const DocumentKindId: Variant;
      DocumentIds: array of Variant
    ): TDocumentSetHolder; virtual;

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
    procedure MarkAsSignedCurrentDocument(const SigningDate: TDateTime);

    procedure PerformDocumentChargeSheets(
      DocumentChargeIds: TVariantList
    );

    function GetCurrentUIDocumentKind: TUIDocumentKindClass;
    function ResolveUIDocumentKindSection(const DocumentKindId: Variant): TUIDocumentKindClass;
    function ResolveUINativeDocumentKindById(const DocumentKindId: Variant): TUIDocumentKindClass;
    function GetCurrentDocumentKindId: Variant;
    function GetCurrentDocumentId: Variant;

    function GetCurrentNativeDocumentKindForApplicationServicing: TDocumentKindClass;
    function ResolveNativeDocumentKindById(const DocumentKindId: Variant): TDocumentKindClass;
    function GetCurrentGlobalDocumentKindForApplicationServicing: TDocumentKindClass;
    function GetEmployeeDocumentSetReadOptionsFromDocumentReferenceFormViewModel(ViewModel: TDocumentsReferenceViewModel): TEmployeeDocumentSetReadOptions;

    function GetDocumentKindFromIdForApplicationServicing(
      const DocumentKindId: Variant
    ): TDocumentKindClass;

    procedure SetUINativeDocumentKindResolver(Value: IUINativeDocumentKindResolver);
    procedure SetUIDocumentKindResolver(Value: IUIDocumentKindResolver);

  public

    destructor Destroy; override;

    constructor Create(AOwner: TComponent); overload; override;

    constructor Create(
      AOwner: TComponent;
      const RestoreUIControlPropertiesOnCreate: Boolean;
      const SaveUIControlPropertiesOnDestroy: Boolean
    ); overload;

    procedure RemoveDocumentAreas;
    procedure SetDocumentAreasVisible(const Visible: Boolean);
    
  public

    procedure RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

    property EnableDocumentCardListGroupingTool: Boolean
    read GetEnableDocumentCardListGroupingTool write SetEnableDocumentCardListGroupingTool;

  public

    procedure SaveUIControlProperties; override;
    procedure RestoreDefaultUIControlProperties; override;

  private

    procedure RaiseOnDocumentCardListUpdatedEventHandler;

  protected

    procedure SetFont(const Value: TFont); override;

    procedure ApplyUIStyles; override;

  public

    property EmployeeDocumentsReferenceForm: TBaseDocumentsReferenceForm
    read FBaseDocumentsReferenceForm write SetBaseDocumentsReferenceForm;

    property DocumentCardFrame: TDocumentCardFrame
    read FSelectedDocumentCardFrame write AssignDocumentCardFrame;

    property UIDocumentKindResolver: IUIDocumentKindResolver
    read FUIDocumentKindResolver write SetUIDocumentKindResolver;

    property UINativeDocumentKindResolver: IUINativeDocumentKindResolver
    read FUINativeDocumentKindResolver write SetUINativeDocumentKindResolver;

    property DocumentsReferenceFormPresenter: IDocumentsReferenceFormPresenter
    read FDocumentsReferenceFormPresenter
    write FDocumentsReferenceFormPresenter;

    property DocumentsReferenceFormFactory:
      TDocumentsReferenceFormFactory
    read FDocumentsReferenceFormFactory
    write FDocumentsReferenceFormFactory;

    property DocumentsReferenceViewModelFactory:
      TDocumentsReferenceViewModelFactory                     
    read FDocumentsReferenceViewModelFactory
    write FDocumentsReferenceViewModelFactory;

    property CurrentDocumentKindInfo: IOperationalDocumentKindInfo
    read FCurrentDocumentKindInfo write SetCurrentDocumentKindInfo;
    
  public

    property OnRelatedDocumentSelectionFormRequestedEventHandler:
      TOnRelatedDocumentSelectionFormRequestedEventHandler

    read FOnRelatedDocumentSelectionFormRequestedEventHandler
    write FOnRelatedDocumentSelectionFormRequestedEventHandler;

    property OnEmployeeDocumentSetChangedEventHandler: TOnEmployeeDocumentSetChangedEventHandler
    read FOnEmployeeDocumentSetChangedEventHandler
    write FOnEmployeeDocumentSetChangedEventHandler;

    property OnEmployeeDocumentChargeSheetSetChangedEventHandler: TOnEmployeeDocumentChargeSheetSetChangedEventHandler
    read FOnEmployeeDocumentChargeSheetSetChangedEventHandler
    write FOnEmployeeDocumentChargeSheetSetChangedEventHandler;

    property OnRespondingDocumentCreatedEventHandler: TOnRespondingDocumentCreatedEventHandler
    read FOnRespondingDocumentCreatedEventHandler
    write FOnRespondingDocumentCreatedEventHandler;

    property OnDocumentCardListUpdatedEventHandler: TOnDocumentCardListUpdatedEventHandler
    read FOnDocumentCardListUpdatedEventHandler
    write FOnDocumentCardListUpdatedEventHandler;
    
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
  unDocumentChargesFrame,
  DocumentFilesFrameUnit,
  DocumentRelationsFrameUnit,
  DocumentRelationsReferenceFormUnit,
  DocumentFilesReferenceFormUnit,
  WorkingEmployeeUnit,
  ApplicationPropertiesStorageRegistry,
  DocumentsReferenceFormProcessorFactory,
  DocumentsReferenceFormProcessor,
  ExtendedDocumentMainInformationFrameUnit,
  EmployeeDocumentChargesWorkStatisticsService,
  EmployeeDocumentChargesWorkStatistics,
  AccountingServiceRegistry,
  DocumentViewingAccountingService,
  DocumentReportPresenterRegistry,
  DocumentPrintFormPresenter,
  DocumentChargeSheetControlAppService,
  DocumentSigningRejectingService,
  DocumentSigningAppService,
  ApplicationServiceRegistries,
  ExternalServiceRegistry,
  IDocumentFileServiceClientUnit,
  DocumentBusinessProcessServiceRegistry,
  DocumentCardFrameFactories,
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
  DocumentApprovingsFrameUnit,
  DocumentApprovingListDTO,
  DocumentApprovingListSetHolder,
  DocumentApprovingListSetHolderMapper,
  EmployeeDocumentKindAccessRightsAppService,
  DocumentDataSetHolderFactories,
  EmployeeDocumentKindAccessRightsInfoDto,
  DocumentStorageServiceCommandsAndRespones,
  RelatedDocumentStorageService,
  DocumentKindSetHolder,
  DocumentKindWorkCycleInfoDto,
  DocumentKindWorkCycleInfoAppService,
  IncomingDocumentSetHolder,
  StandardUIDocumentKindResolver,
  StandardUINativeDocumentKindResolver,
  StandardUIDocumentKindMapper,
  EmployeeDocumentRecordViewModel,
  PresentationServiceRegistry,
  BaseIncomingDocumentsReferenceFormUnit,
  DocumentSigningMarkingAppService;

{$R *.dfm}

destructor TDocumentCardListFrame.Destroy;
begin

  FreeAndNil(FDocumentCardShowMessages);
  FreeAndNil(FDocumentsReferenceFormFactory);

  if Assigned(FBaseDocumentsReferenceForm) then begin

    FBaseDocumentsReferenceForm.Parent.RemoveControl(
      FBaseDocumentsReferenceForm
    );

    if Assigned(FBaseDocumentsReferenceForm.Owner) then begin

      FBaseDocumentsReferenceForm.Owner.RemoveComponent(
        FBaseDocumentsReferenceForm
      );

    end;
    
    FBaseDocumentsReferenceForm.SafeDestroy;

  end;

  inherited Destroy;

end;


procedure TDocumentCardListFrame.DocumentListPanelResize(Sender: TObject);
begin

  CenterWindowRelativeByHorz(DocumentListLabel, DocumentListPanel);

end;

{ refactor: сократить объём кода, перенести в контроллеры }
procedure TDocumentCardListFrame.GetCardFormViewModelAndAvailableActionListForDocument(
  const DocumentId, DocumentKindId: Variant;
  var DocumentCardViewModel: TDocumentCardFormViewModel;
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
  DocumentCardFormViewModelMapperFactory := nil;
  GettingDocumentFullInfoCommandResult := nil;

  try

    try

      DocumentStorageService :=
        GetDocumentStorageService(
          GetDocumentKindFromIdForApplicationServicing(DocumentKindId)
        );

      GettingDocumentFullInfoCommandResult :=
        DocumentStorageService.GetDocumentFullInfo(
          TGettingDocumentFullInfoCommand.Create(
            DocumentId,
            WorkingEmployeeId
          )
        );

      DocumentCardViewModel :=
        CreateDocumentCardFormViewModelFor(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId),
          GettingDocumentFullInfoCommandResult.DocumentFullInfoDTO,
          GettingDocumentFullInfoCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO.AsSelf
        );

      AvailableActionList :=
        GettingDocumentFullInfoCommandResult.
          DocumentUsageEmployeeAccessRightsInfoDTO.AsSelf.Clone;

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

function TDocumentCardListFrame.GetCardFrameForDocument(
  const DocumentId: Variant;
  const DocumentKindId: Variant
): TDocumentCardFrame;
var
    DocumentCardFormViewModel: TDocumentCardFormViewModel;
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

      FreeAndNil(Result);

      Raise;

    end;
    
  finally

    FreeAndNil(AvailableDocumentActionList);

  end;

end;

function TDocumentCardListFrame.GetCardFrameForDocumentForViewOnly(
  const DocumentId: Variant;
  const DocumentKindId: Variant
): TDocumentCardFrame;
var DocumentCardFrameFactory: TDocumentCardFrameFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModel: TDocumentCardFormViewModel;
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
      GetDocumentStorageService(
        GetDocumentKindFromIdForApplicationServicing(DocumentKindId)
      );

    try
    
      GettingDocumentFullInfoCommandResult :=
        DocumentStorageService.GetDocumentFullInfo(
          TGettingDocumentFullInfoCommand.Create(
            DocumentId,
            WorkingEmployeeId)
          );

      DocumentCardFormViewModel :=
        CreateDocumentCardFormViewModelFor(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId),
          GettingDocumentFullInfoCommandResult.DocumentFullInfoDTO,
          GettingDocumentFullInfoCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO.AsSelf
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

function TDocumentCardListFrame.
  GetCurrentNativeDocumentKindForApplicationServicing: TDocumentKindClass;
begin

  Result := ResolveNativeDocumentKindById(GetCurrentDocumentKindId);

end;

function TDocumentCardListFrame.
  GetCurrentGlobalDocumentKindForApplicationServicing: TDocumentKindClass;
begin
     
  Result :=
    GlobalDocumentKindDtos
      .FindByIdOrRaise(GetCurrentDocumentKindId)
        .ServiceType;

end;

function TDocumentCardListFrame.GetDocumentKindFromIdForApplicationServicing(
  const DocumentKindId: Variant
): TDocumentKindClass;
begin

  Result :=
    NativeDocumentKindDtos.FindByIdOrRaise(DocumentKindId).ServiceType;

end;

function TDocumentCardListFrame.GetDocumentSetHolder(
  const ServiceDocumentKind: TDocumentKindClass;
  const EmployeeId: Variant;
  const Options: IEmployeeDocumentSetReadOptions
): TDocumentSetHolder;
var
    EmployeeDocumentSetReadService: IEmployeeDocumentSetReadService;
begin

  EmployeeDocumentSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetEmployeeDocumentSetReadService(ServiceDocumentKind);

  Result :=
    EmployeeDocumentSetReadService.GetEmployeeDocumentSet(EmployeeId, Options);

end;

function TDocumentCardListFrame.GetDocumentStorageService(
  const ServiceDocumentKind: TDocumentKindClass
): IDocumentStorageService;
begin

  Result :=
    TApplicationServiceRegistries
      .Current
        .GetDocumentBusinessProcessServiceRegistry
          .GetDocumentStorageService(ServiceDocumentKind);
          
end;

function TDocumentCardListFrame.GetEnableDocumentCardListGroupingTool: Boolean;
begin

  if Assigned(FBaseDocumentsReferenceForm) then
    Result := FBaseDocumentsReferenceForm.EnableRecordGroupingByColumnsOption

  else Result := False;
  
end;

function TDocumentCardListFrame.GetCurrentDocumentKindId: Variant;
begin

  if not Assigned(FBaseDocumentsReferenceForm) then
    Result := Null

  else begin

    if FBaseDocumentsReferenceForm.DocumentSetHolder.IsEmpty then
      Result := Null

    else begin

      Result := FBaseDocumentsReferenceForm.DocumentSetHolder.KindIdFieldValue;
        
    end;

  end;

end;

function TDocumentCardListFrame.GetCurrentDocumentId: Variant;
begin

  if not Assigned(FBaseDocumentsReferenceForm) then
    Result := Null

  else begin

    if FBaseDocumentsReferenceForm.DocumentSetHolder.IsEmpty then
      Result := Null

    else begin
    
      Result :=
        FBaseDocumentsReferenceForm.DocumentSetHolder.DocumentIdFieldValue;

    end;

  end;

end;

function TDocumentCardListFrame.GetCurrentUIDocumentKind: TUIDocumentKindClass;
begin

  Result :=
    FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
      GetCurrentDocumentKindId
    );
    
end;

function TDocumentCardListFrame.GetGlobalDocumentKindDtos: TGlobalDocumentKindDtos;
begin

  Result := FGlobalDocumentKindDtos;
  
end;

function TDocumentCardListFrame.GetNativeDocumentKindDtos: TNativeDocumentKindDtos;
begin

  Result := FNativeDocumentKindDtos;

end;

procedure TDocumentCardListFrame.HandleDocumentCardShowMessage(
  var Message: TMessage);
var
    DocumentRecordViewModel: TDocumentRecordViewModel;
begin

  with TDocumentCardShowMessageData(Message.LParam) do begin

    if not FDocumentCardShowMessages.Exists(VarToStr(DocumentId)) then Exit;

    FDocumentCardShowMessages.Delete(VarToStr(DocumentId));

    try

      Screen.Cursor := crHourGlass;
      
      ShowCardForDocument(DocumentId, DocumentKindId);

      if FBaseDocumentsReferenceForm.IsEmpty then Exit;

      DocumentRecordViewModel :=
        FBaseDocumentsReferenceForm.GetDocumentRecordViewModel(
          FSelectedDocumentCardFrame.DocumentId
        );

      DocumentRecordViewModel.CanBeRemoved :=
        FSelectedDocumentCardFrame.ViewModel.DocumentRemoveToolEnabled;

      FBaseDocumentsReferenceForm.ChangeDocumentRecordByViewModel(
        DocumentRecordViewModel
      );

    finally

      Screen.Cursor := crDefault;

      FreeAndNil(DocumentRecordViewModel);

    end;

  end;

end;

function TDocumentCardListFrame.GetEmployeeDocumentSetReadOptionsFromDocumentReferenceFormViewModel(
  ViewModel: TDocumentsReferenceViewModel): TEmployeeDocumentSetReadOptions;
var
  I: Integer;
begin

  Result := nil;
  if not Assigned(ViewModel) then Exit;

  Result := TEmployeeDocumentSetReadOptions.Create;

  for I := 0 to ViewModel.SelectedDocumentWorkCycleStageNames.Count - 1 do
    Result.SelectedDocumentWorkCycleStageNames.Add(
      ViewModel.SelectedDocumentWorkCycleStageNames[I]);

end;

procedure TDocumentCardListFrame.InflateEmployeeDocumentReferenceFormToLayout(
  EmployeeDocumentReferenceForm: TBaseDocumentsReferenceForm);
begin

  EmployeeDocumentReferenceForm.Parent := DocumentRecordsGridPanel;
  EmployeeDocumentReferenceForm.Align := alClient;
  EmployeeDocumentReferenceForm.BorderStyle := bsNone;

end;

procedure TDocumentCardListFrame.InitializeLayout;
begin

end;

procedure TDocumentCardListFrame.MarkAsSignedCurrentDocument;
var
    DocumentSigningMarkingAppService: IDocumentSigningMarkingAppService;
begin

  DocumentSigningMarkingAppService :=
    TApplicationServiceRegistries
      .Current
        .GetDocumentBusinessProcessServiceRegistry
          .GetDocumentSigningMarkingAppService(
            GetCurrentNativeDocumentKindForApplicationServicing
          );

  DocumentSigningMarkingAppService.MarkDocumentAsSigned(
    FSelectedDocumentCardFrame.ViewModel.DocumentId,
    WorkingEmployeeId,
    SigningDate
  );
  
end;

procedure TDocumentCardListFrame.SignCurrentDocument;
var DocumentSigningAppService: IDocumentSigningAppService;
begin

  DocumentSigningAppService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentSigningAppService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  Screen.Cursor := crHourGlass;

  try

    DocumentSigningAppService.SignDocument(
        FSelectedDocumentCardFrame.ViewModel.DocumentId,
        WorkingEmployeeId
    );

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentCardListFrame.SwitchUserInterfaceTo(
  Value: TUserInterfaceKind);
begin

  inherited SwitchUserInterfaceTo(Value);

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.UserInterfaceKind := Value;
    
  if Assigned(FSelectedDocumentCardFrame) then
    FSelectedDocumentCardFrame.UserInterfaceKind := Value;

end;

procedure TDocumentCardListFrame.
  UpdateDocumentCardAfterApprovingCompletingMessageHandler(
    var Message: TMessage
  );
begin

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
  
end;

procedure TDocumentCardListFrame.
  AddNewDocumentsReferenceFormRecordBy(
    DocumentCardViewModel: TDocumentCardFormViewModel
  );
var
    DocumentSetHolder: TDocumentSetHolder;
    DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor;
    DocumentRecordViewModel: TDocumentRecordViewModel;
begin

  DocumentRecordViewModel := nil;
  
  DocumentSetHolder :=
    GetDocumentSetByIds(
      FBaseDocumentsReferenceForm.DocumentSetHolder.DocumentsKindId,
      [DocumentCardViewModel.DocumentId]
    );

  try

    DocumentsReferenceFormProcessor :=
      FBaseDocumentsReferenceForm.DocumentsReferenceFormProcessor;

    DocumentRecordViewModel :=
      DocumentsReferenceFormProcessor
        .CreateCurrentDocumentRecordViewModelFrom(DocumentSetHolder);

    DocumentRecordViewModel.CanBeRemoved := DocumentCardViewModel.DocumentRemoveToolEnabled;
    
    FBaseDocumentsReferenceForm.AddNewDocumentRecord(DocumentRecordViewModel);

  finally

    FreeAndNil(DocumentRecordViewModel);
    FreeAndNil(DocumentSetHolder);
    
  end;

end;

procedure TDocumentCardListFrame.
  ChangeDocumentsReferenceFormRecordBy(
    {DocumentCardViewModel: TDocumentCardFormViewModel}
    DocumentId, DocumentKindId: Variant
  );
var
    DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor;
    DocumentSetHolder: TDocumentSetHolder;
    DocumentRecordViewModel: TDocumentRecordViewModel;
begin

  DocumentRecordViewModel := nil;

  DocumentSetHolder :=
    GetDocumentSetByIds(
      FBaseDocumentsReferenceForm.DocumentSetHolder.DocumentsKindId,
      //[DocumentCardViewModel.DocumentId]
      DocumentId
    );

  try                          

    DocumentsReferenceFormProcessor :=
      FBaseDocumentsReferenceForm.DocumentsReferenceFormProcessor;

    DocumentRecordViewModel :=
      DocumentsReferenceFormProcessor
        .CreateCurrentDocumentRecordViewModelFrom(DocumentSetHolder);

    //DocumentRecordViewModel.CanBeRemoved := DocumentCardViewModel.DocumentRemoveToolEnabled;
    
    FBaseDocumentsReferenceForm.ChangeDocumentRecordByViewModel(
      DocumentRecordViewModel
    );

  finally

    FreeAndNil(DocumentRecordViewModel);
    
  end;

end;

function TDocumentCardListFrame.GetDocumentSetByIds(
  const DocumentKindId: Variant;
  DocumentIds: array of Variant
): TDocumentSetHolder;
var
    EmployeeDocumentSetReadService: IEmployeeDocumentSetReadService;
begin

  EmployeeDocumentSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetEmployeeDocumentSetReadService(
            GetDocumentKindFromIdForApplicationServicing(DocumentKindId)
          );

  Result :=
    EmployeeDocumentSetReadService.GetEmployeeDocumentSubSetByIds(
      WorkingEmployeeId,
      DocumentIds
    );

end;

procedure TDocumentCardListFrame.ApplyUIStyles;
begin

  inherited ApplyUIStyles;

  DocumentListPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;

  DocumentListLabel.Font.Style := [fsBold];

  DocumentCardFormPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;
    
end;

procedure TDocumentCardListFrame.ApproveCurrentDocument;
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

    WorkingEmployeeId
  );

end;

procedure TDocumentCardListFrame.AssignDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame
);
begin

  QueueOldDocumentCardDestroyMessage;

  if not Assigned(DocumentCardFrame) then begin

    FSelectedDocumentCardFrame := nil;
    Exit;

  end;

  //FSelectedDocumentCardFrame := DocumentCardFrame;
  
  DocumentCardFrame.Parent := DocumentCardFormPanel;
  DocumentCardFrame.Align := alClient;
                                                                                    
  AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

  DocumentCardFrame.RaisePendingEvents;

  if Assigned(FSelectedDocumentCardFrame) then begin

    FSelectedDocumentCardFrame.SaveWithNestedFramesUIProperties;

    DocumentCardFrame.CopyUISettings(FSelectedDocumentCardFrame);

  end;

  DocumentCardFrame.RestoreWithNestedFramesUIProperties;

  FSelectedDocumentCardFrame := DocumentCardFrame;
  
  if Assigned(FDetachableDocumentCardForm) then begin

    FDetachableDocumentCardForm.InternalControl :=
      FSelectedDocumentCardFrame;

    FDetachableDocumentCardForm.SetFocus;
    
  end;

  DocumentCardFrame.OnShow;

end;

{ refactor document card frame, event handlers mechanism }
procedure TDocumentCardListFrame.AssignEventHandlersToDocumentCardFrame(
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

  DocumentCardFrame.
    OnDocumentChargesPerformingRequestedEventHandler :=
      OnDocumentChargesPerformingRequestedEventHandler;

  DocumentCardFrame.OnDocumentSigningMarkingRequestedEventHandler :=
    OnDocumentSigningMarkingRequestedEventHandler;
    
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

procedure TDocumentCardListFrame.
  AssignEventHandlersToEmployeeDocumentReferenceForm(
    EmployeeDocumentReferenceForm: TBaseDocumentsReferenceForm
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

  EmployeeDocumentReferenceForm.OnDocumentRecordFocusedEventHandler :=
    OnDocumentRecordFocusedEventHandler;

  EmployeeDocumentReferenceForm.OnDocumentRecordChangingRequestedEventHandler :=
    OnDocumentRecordChangingRequestedEventHandler;

  EmployeeDocumentReferenceForm.OnDocumentCardRefreshRequestedEventHandler :=
    OnDocumentCardRefreshRequestedEventHandler;

end;

constructor TDocumentCardListFrame.Create(AOwner: TComponent);
begin

  inherited;

  InitializeLayout;
  CreateRequiredComponents;

end;

constructor TDocumentCardListFrame.Create(AOwner: TComponent;
  const RestoreUIControlPropertiesOnCreate,
  SaveUIControlPropertiesOnDestroy: Boolean
);
begin

  inherited Create(
    AOwner,
    RestoreUIControlPropertiesOnCreate,
    SaveUIControlPropertiesOnDestroy
  );

  InitializeLayout;
  CreateRequiredComponents;
  
end;

function TDocumentCardListFrame.CreateDocumentCardFormViewModelFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFormViewModel;
var
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
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

function TDocumentCardListFrame.CreateDocumentCardFrameFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO): TDocumentCardFrame;
var DocumentCardFormViewModel: TDocumentCardFormViewModel;
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

function TDocumentCardListFrame.CreateDocumentCardFrameFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentCardFormViewModel: TDocumentCardFormViewModel): TDocumentCardFrame;
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

function TDocumentCardListFrame.CreateDocumentsReferenceViewModelForEmployee(
  const UIDocumentKind: TUIDocumentKindClass;
  const EmployeeId: Variant;
  Options: IEmployeeDocumentSetReadOptions
): TDocumentsReferenceViewModel;
var
    DocumentKindId: Variant;
    ServiceDocumentKind: TDocumentKindClass;
    DocumentKindWorkCycleInfoAppService: IDocumentKindWorkCycleInfoAppService;
    DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos;
    DocumentSetHolder: TDocumentSetHolder;
begin

  DocumentKindId :=
    FUINativeDocumentKindResolver
      .ResolveIdForUIDocumentKind(UIDocumentKind);
      
  ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId);
  
  DocumentKindWorkCycleInfoAppService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetDocumentKindWorkCycleInfoAppService(ServiceDocumentKind);

  DocumentKindWorkCycleInfoDtos := nil; DocumentSetHolder := nil;

  Screen.Cursor := crHourGlass;

  try

    try

      { из SelectedDocumentKindWorkCycleStageInfoDtos
      сформировать Options из списка номеров/наименований стадий }

      DocumentSetHolder :=
        GetDocumentSetHolder(
          FCurrentDocumentKindInfo.ServiceDocumentKind,
          EmployeeId,
          Options
        );

      DocumentSetHolder.DocumentsKindId := DocumentKindId;

      DocumentKindWorkCycleInfoDtos :=
        DocumentKindWorkCycleInfoAppService.GetAllDocumentKindWorkCycleInfos;

      Result :=
        FDocumentsReferenceViewModelFactory
          .CreateDocumentsReferenceViewModelFor(
            UIDocumentKind,
            DocumentSetHolder,
            DocumentKindWorkCycleInfoDtos,
            Options.SelectedDocumentWorkCycleStageNames
          );

    except

      FreeAndNil(DocumentSetHolder);
      FreeAndNil(DocumentKindWorkCycleInfoDtos);

      Raise;
      
    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

function TDocumentCardListFrame.CreateDocumentCardFrameFor(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentCardFormViewModel: TDocumentCardFormViewModel;
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

procedure TDocumentCardListFrame.ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;
begin

  if FBaseDocumentsReferenceForm.RecordCount = 0 then
    ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection

  else ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord; {refactor}

end;

procedure TDocumentCardListFrame.ShowDocumentCardFrame(const DocumentId,
  DocumentKindId: Variant);
var
    DocumentCardFrame: TDocumentCardFrame;
begin

  try

    try

      Screen.Cursor := crHourGlass;

      DocumentCardFrame := GetCardFrameForDocument(DocumentId, DocumentKindId);

      CustomizeAndAssignDocumentCardFrame(DocumentCardFrame);

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

procedure TDocumentCardListFrame.
  ShowEmptyNoActivedDocumentCardForCurrentDocumentKindIfDocumentsAreAbsent;
begin

  if FBaseDocumentsReferenceForm.RecordCount = 0 then
    ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

end;

procedure TDocumentCardListFrame.
  ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

var
    DocumentCardFrame: TDocumentCardFrame;
    DocumentCardFrameFactory: TDocumentCardFrameFactory;
begin

  DocumentCardFrameFactory :=
    TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
      FCurrentDocumentKindInfo.UIDocumentKind
    );

  DocumentCardFrame := nil;
  
  try

    DocumentCardFrame :=
      DocumentCardFrameFactory.CreateEmptyNoActivedDocumentCardFrame;

    CustomizeAndAssignDocumentCardFrame(DocumentCardFrame);

  finally

    FreeAndNil(DocumentCardFrameFactory);
    
  end;

end;

procedure TDocumentCardListFrame.CreateNewDocumentFrom(
  DocumentCardFrame: TDocumentCardFrame
);
var
    DocumentStorageService: IDocumentStorageService;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    NewDocumentInfoDTO: TNewDocumentInfoDTO;
    AddNewDocumentFullInfoCommandResult: IAddNewDocumentFullInfoCommandResult;
    DocumentCardViewModel: TDocumentCardFormViewModel;

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
        ResolveUINativeDocumentKindById(DocumentCardFrame.ViewModel.DocumentKindId);

    end

    else begin

      CurrentServiceDocumentKind := FCurrentDocumentKindInfo.ServiceDocumentKind;
      CurrentUIDocumentKind := FCurrentDocumentKindInfo.UIDocumentKind;

    end;

    DocumentStorageService := GetDocumentStorageService(CurrentServiceDocumentKind);

    DocumentCardFormViewModelMapperFactory :=
      TDocumentCardFormViewModelMapperFactories.
      Current.
      CreateDocumentCardFormViewModelMapperFactory(CurrentUIDocumentKind);

    DocumentCardFormViewModelMapper :=
      DocumentCardFormViewModelMapperFactory
        .CreateDocumentCardFormViewModelMapper;

    NewDocumentInfoDTO :=
      DocumentCardFormViewModelMapper
        .MapDocumentCardFormViewModelToNewDocumentInfoDTO(
          DocumentCardFrame.ViewModel
        );

    AddNewDocumentFullInfoCommandResult :=
      DocumentStorageService.AddNewDocumentFullInfo(
        TAddNewDocumentFullInfoCommand.Create(
          WorkingEmployeeId,
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

    DocumentCardViewModel.Number :=
      AddNewDocumentFullInfoCommandResult.AssignedNewDocumentNumber;

    DocumentCardViewModel.DocumentKindId :=
      FUINativeDocumentKindResolver.ResolveIdForUIDocumentKind(
        CurrentUIDocumentKind
      );

    DocumentCardViewModel
      .DocumentMainInformationFormViewModel
        .DocumentAuthorIdentity :=
          AddNewDocumentFullInfoCommandResult.DocumentAuthorDto.Id;

    DocumentCardViewModel
      .DocumentMainInformationFormViewModel
        .DocumentAuthorShortFullName :=
          AddNewDocumentFullInfoCommandResult.DocumentAuthorDto.FullName;

    DocumentCardViewModel.DocumentRemoveToolEnabled :=
      AddNewDocumentFullInfoCommandResult
        .NewDocumentUsageEmployeeAccessRightsInfoDTO.AsSelf.DocumentCanBeRemoved;
          
  finally

    FreeAndNil(DocumentCardFormViewModelMapper);
    FreeAndNil(DocumentCardFormViewModelMapperFactory);

  end;

end;

procedure TDocumentCardListFrame.CreateRequiredComponents;
begin

  FRequestedFocuseableDocumentId := Null;
  FDocumentCardShowMessages := TIntegerHash.Create;
  
end;

procedure TDocumentCardListFrame.CustomizeDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame
);
begin

  AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

  DocumentCardFrame.WorkingEmployeeId := WorkingEmployeeId;
  DocumentCardFrame.Font := Font;
  
  if not VarIsNull(GetCurrentDocumentKindId) then begin

    DocumentCardFrame.ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;
    DocumentCardFrame.UIDocumentKind := GetCurrentUIDocumentKind;

  end

  else begin

    DocumentCardFrame.ServiceDocumentKind := FCurrentDocumentKindInfo.ServiceDocumentKind;
    DocumentCardFrame.UIDocumentKind := FCurrentDocumentKindInfo.UIDocumentKind;
    
  end;

  DocumentCardFrame.UserInterfaceKind := UserInterfaceKind;

end;

procedure TDocumentCardListFrame.CustomizeAndAssignDocumentCardFrame(
  var DocumentCardFrame: TDocumentCardFrame);
begin

  try

    CustomizeDocumentCardFrame(DocumentCardFrame);
    AssignDocumentCardFrame(DocumentCardFrame);

  except

    if FSelectedDocumentCardFrame <> DocumentCardFrame then
      FreeAndNil(DocumentCardFrame);

    Raise;

  end;

end;

procedure TDocumentCardListFrame.CustomizeBaseDocumentsReferenceForm(
  EmployeeDocumentReferenceForm: TBaseDocumentsReferenceForm);
begin

  EmployeeDocumentReferenceForm.Font := Font;
  EmployeeDocumentReferenceForm.WorkingEmployeeId := WorkingEmployeeId;
  EmployeeDocumentReferenceForm.UIDocumentKindResolver := FUINativeDocumentKindResolver;
  EmployeeDocumentReferenceForm.OperationalDocumentKindInfo := FCurrentDocumentKindInfo;
  
  AssignEventHandlersToEmployeeDocumentReferenceForm(EmployeeDocumentReferenceForm);

  {
    refactor: использовать отдельный объект для настройки справочника документов
    для каждого типа документов для исключения "жестких" проверок на тип документов ниже.
    Объект должен настраивать специфичные поля справочника, а также
    устанавливать обработчики событий
  }

  if EmployeeDocumentReferenceForm is TBaseIncomingDocumentsReferenceForm
  then begin

    TBaseIncomingDocumentsReferenceForm(
      EmployeeDocumentReferenceForm
    ).OnRespondingDocumentCreatingFinishedEventHandler :=
        OnRespondingDocumentCreatingFinishedEventHandler;

    TBaseIncomingDocumentsReferenceForm(
      EmployeeDocumentReferenceForm
    ).NativeDocumentKindDtos := FNativeDocumentKindDtos;

  end;

  EmployeeDocumentReferenceForm.UserInterfaceKind := UserInterfaceKind;
  
end;

procedure TDocumentCardListFrame.OnNewDocumentCreatingConfirmedEventHandler(
  Sender: TObject;
  DocumentCardFrame: TDocumentCardFrame
);
begin
                      
  CreateNewDocumentFrom(DocumentCardFrame);
    
end;

procedure TDocumentCardListFrame.OnNewDocumentCreatingFinishedEventHandler(
  Sender: TObject;
  DocumentCardFrame: TDocumentCardFrame
);
begin

  AddNewDocumentsReferenceFormRecordBy(DocumentCardFrame.ViewModel);

  RaiseOnEmployeeDocumentSetChangedEventHandler;

end;

procedure TDocumentCardListFrame.OnNewDocumentCreatingRequestedEventHandler(
  Sender: TObject;
  var DocumentCardFrame: TDocumentCardFrame
);
var
    DocumentStorageService: IDocumentStorageService;
    DocumentCardFrameFactory: TDocumentCardFrameFactory;
    DocumentCardFormViewModel: TDocumentCardFormViewModel;

    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    {
    DocumentCreatingDefaultInfoReadService: IDocumentCreatingDefaultInfoReadService;
    DocumentCreatingDefaultInfoDTO: TDocumentCreatingDefaultInfoDTO;

    EmployeeDocumentKindAccessRightsAppService: IEmployeeDocumentKindAccessRightsAppService;
    EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto; }

    DocumentCreatingResult: IDocumentCreatingCommandResult;
begin

  DocumentCardFormViewModel := nil;
  DocumentCardFormViewModelMapper := nil;
  DocumentCardFormViewModelMapperFactory := nil;
                                        {
  DocumentCreatingDefaultInfoDTO := nil;
  EmployeeDocumentKindAccessRightsInfoDto := nil;  }

  DocumentCardFrame := nil;
  DocumentCardFrameFactory := nil;

  try

    {
      -refactor:
        выделить вызовы служб ниже до try
        в отдельный метод CreateDocument(DocumentKindId, EmployeeId)
        службы DocumentStorageService, возвращающий обьект
        DocumentFullInfoDTO с обьектом прав дсоутпа EmployeeDocumentUsageAccessRightsInfoDTO,
        и, таким образом, унифицировать создание модели карточки документа,
        используя метод CreateDocumentCardFrameFrom фабрики карточек DocumentCardFactory.
        В таком случае удалить метод CreateCardFrameForNewDocumentCreating
    }

    {
    EmployeeDocumentKindAccessRightsAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetEmployeeDocumentKindAccessRightsAppService;

    EmployeeDocumentKindAccessRightsInfoDto :=
      EmployeeDocumentKindAccessRightsAppService.
        EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
          FCurrentDocumentKindInfo.ServiceDocumentKind,
          WorkingEmployeeId
        );

    DocumentCreatingDefaultInfoReadService :=
      TApplicationServiceRegistries.
      Current.
      GetPresentationServiceRegistry.
      GetDocumentCreatingDefaultInfoReadService(
        FCurrentDocumentKindInfo.ServiceDocumentKind
      );

    DocumentCreatingDefaultInfoDTO :=
      DocumentCreatingDefaultInfoReadService.
        GetDocumentCreatingDefaultInfoForEmployee(
          WorkingEmployeeId
        );

    DocumentCreatingDefaultInfoDTO.DocumentKindId :=
      NativeDocumentKindDtos.FindByServiceTypeOrRaise(FCurrentDocumentKindInfo.ServiceDocumentKind).Id;

    }
    
    { refactor- }

    DocumentStorageService :=
      TApplicationServiceRegistries
        .Current
          .GetDocumentBusinessProcessServiceRegistry
            .GetDocumentStorageService(
              FCurrentDocumentKindInfo.ServiceDocumentKind
            );

    DocumentCreatingResult :=
      DocumentStorageService.CreateDocument(
        TDocumentCreatingCommand.Create(WorkingEmployeeId)
      );

    try

      DocumentCardFormViewModelMapperFactory :=
        TDocumentCardFormViewModelMapperFactories.
        Current.
        CreateDocumentCardFormViewModelMapperFactory(
          FCurrentDocumentKindInfo.UIDocumentKind
        );

      DocumentCardFormViewModelMapper :=
        DocumentCardFormViewModelMapperFactory
          .CreateDocumentCardFormViewModelMapper;

      DocumentCardFormViewModel :=
        DocumentCardFormViewModelMapper
          .MapDocumentCardFormViewModelFrom(
            DocumentCreatingResult.DocumentFullInfoDTO,
            DocumentCreatingResult.DocumentAccessRightsInfoDTO
          );
        {DocumentCardFormViewModelMapper.
          CreateDocumentCardFormViewModelForNewDocumentCreating(
            TDocumentDataSetHolderFactories.Instance.GetDocumentDataSetHolderFactory(
              FCurrentDocumentKindInfo.UIDocumentKind
            ),
            DocumentCreatingDefaultInfoDTO
          ); }

      DocumentCardFrameFactory :=
        TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
          FCurrentDocumentKindInfo.UIDocumentKind
        );

      DocumentCardFrame :=
        DocumentCardFrameFactory
          .CreateCardFrameForNewDocumentCreating(
            DocumentCardFormViewModel,
            DocumentCreatingResult.DocumentAccessRightsInfoDTO
          );
        {
        .CreateCardFrameForNewDocumentCreating(
          DocumentCardFormViewModel,
          EmployeeDocumentKindAccessRightsInfoDto
        );                                  }

      DocumentCardFrame.Font := Font;

      CustomizeDocumentCardFrame(DocumentCardFrame);
      
    except

      FreeAndNil(DocumentCardFrame);

      Raise;

    end;

  finally
     {
    FreeAndNil(EmployeeDocumentKindAccessRightsInfoDto);
    FreeAndNil(DocumentCreatingDefaultInfoDTO);           }
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

  AssignEventHandlersToDocumentCardFrame(DocumentCardFrame);

end;

procedure TDocumentCardListFrame.
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
      WorkingEmployeeId,
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
        GettingDocumentFullInfoCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO.AsSelf
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

procedure TDocumentCardListFrame.OnRespondingDocumentCreatingFinishedEventHandler(
  Sender: TObject;
  RespondingDocumentCardFrame: TDocumentCardFrame
);
begin

  FRequestedFocuseableDocumentId := RespondingDocumentCardFrame.ViewModel.DocumentId;

  RaiseOnRespondingDocumentCreatedEventHandler(RespondingDocumentCardFrame.ViewModel);
  
end;

procedure TDocumentCardListFrame.OnDetachableDocumentCardFormDeleteEventHandler(
  Sender: TObject);
begin

  FDetachableDocumentCardForm := nil;
  
end;

procedure TDocumentCardListFrame.OnDocumentRecordFocusedEventHandler(
  Sender: TObject;
  PreviousFocusedDocumentRecordViewModel,
  FocusedDocumentRecordViewModel: TDocumentRecordViewModel
);
begin
                                
  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

  if                       
    Assigned(FocusedDocumentRecordViewModel)
    and (
      not Assigned(FSelectedDocumentCardFrame)
      or (
        FSelectedDocumentCardFrame.DocumentId <>
        FocusedDocumentRecordViewModel.DocumentId
      )
    )
    and not
    FDocumentCardShowMessages.Exists(
      VarToStr(FocusedDocumentRecordViewModel.DocumentId)
    )      
  then begin

    if
      Assigned(FSelectedDocumentCardFrame)
      and not VarIsNull(FSelectedDocumentCardFrame.DocumentId)
    then begin

      if
        FDocumentCardShowMessages
          .Exists(VarToStr(FSelectedDocumentCardFrame.DocumentId))

      then begin

        FDocumentCardShowMessages
          .Delete(VarToStr(FSelectedDocumentCardFrame.DocumentId));

      end;

    end;

    DebugOutput(FocusedDocumentRecordViewModel.Name);

    ShowCardForDocumentAndUpdateRelatedDocumentRecord(
      FocusedDocumentRecordViewModel.DocumentId,
      FocusedDocumentRecordViewModel.KindId
    );

  end;

end;

procedure TDocumentCardListFrame.OnSelectedDocumentRecordChangedEventHandler(
  Sender: TObject
);
begin

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

end;

procedure TDocumentCardListFrame.OnSelectedDocumentRecordChangingEventHandler(
  Sender: TObject);
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

end;

procedure TDocumentCardListFrame.OnShow;
begin

  inherited;

  if Assigned(FSelectedDocumentCardFrame) then
    FSelectedDocumentCardFrame.OnShow;


  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.Show;
    
end;

procedure TDocumentCardListFrame.PerformDocumentChargeSheets(
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

  Screen.Cursor := crHourGlass;
  
  try

    DocumentChargeSheetAppControlService.PerformChargeSheets(
      WorkingEmployeeId,
      DocumentChargeIds,
      GetCurrentDocumentId
    );

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentCardListFrame.QueueDocumentCardShowMessage(
  const DocumentId: Variant;
  const DocumentKindId: Variant
);
var
    DocumentCardShowMessageData: TDocumentCardShowMessageData;
begin

  DocumentCardShowMessageData :=
    TDocumentCardShowMessageData.Create(DocumentId, DocumentKindId);

  try

    PostMessage(
      Self.Handle,
      WM_DOCUMENT_CARD_SHOW,
      0,
      Integer(DocumentCardShowMessageData)
    );

    FDocumentCardShowMessages[VarToStr(DocumentId)] := 1;
    
  except

    FreeAndNil(DocumentCardShowMessageData);

    Raise;

  end;

end;

procedure TDocumentCardListFrame.QueueOldDocumentCardDestroyMessage;
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

procedure TDocumentCardListFrame.
  QueueOldEmployeeDocumentsReferenceFormDestroyingMessage(
    OldEmployeeDocumentsReferenceForm: TBaseDocumentsReferenceForm
  );
begin

  PostMessage(
    Self.Handle,
    WM_DESTROY_OLD_EMPLOYEE_DOCUMENTS_REFERENCE_FORM,
    0,
    Integer(OldEmployeeDocumentsReferenceForm)
  );

end;

procedure TDocumentCardListFrame.QueueOldEmployeeDocumentsReferenceFormDestroyingMessageHandler(
  var Message: TMessage
);
var
    OldEmployeeDocumentsReferenceForm: TBaseDocumentsReferenceForm;
    ViewModel: TDocumentsReferenceViewModel;
begin

  OldEmployeeDocumentsReferenceForm := TBaseDocumentsReferenceForm(Message.LParam);

  ViewModel := OldEmployeeDocumentsReferenceForm.ViewModel;
  
  OldEmployeeDocumentsReferenceForm.SafeDestroy;

  ViewModel.Free;
  
end;

procedure TDocumentCardListFrame.QueueUpdateDocumentCardAfterApprovingCompletingMessageHandler;
begin

  PostMessage(
    Self.Handle,
    WM_UPDATE_DOCUMENT_CARD_AFTER_APPROVING_COMPLETING_MESSAGE,
    0,
    0
  );
  
end;                                            

procedure TDocumentCardListFrame.ShowCardForDocument(const DocumentId,
  DocumentKindId: Variant);
var
    DocumentCardFrame: TDocumentCardFrame;
begin

  DocumentCardFrame :=
    GetCardFrameForDocument(
      DocumentId,
      DocumentKindId
    );

  CustomizeAndAssignDocumentCardFrame(DocumentCardFrame);

end;

procedure TDocumentCardListFrame.
  ShowCardForDocumentAndUpdateRelatedDocumentRecord(
    const DocumentId: Variant;
    const DocumentKindId: Variant
  );
var
    DocumentCardFrame: TDocumentCardFrame;
begin
                                      
  try

    try

      Screen.Cursor := crHourGlass;

      QueueDocumentCardShowMessage(DocumentId, DocumentKindId);

      ChangeDocumentsReferenceFormRecordBy({DocumentCardFrame.ViewModel}
        DocumentId, DocumentKindId
      );

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

procedure TDocumentCardListFrame.ShowCardForDocumentAsSeparatedFormForViewOnly(
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
procedure TDocumentCardListFrame.ShowDocumentCardForCurrentDocumentRecord;
var
    DocumentId: Variant;
    DocumentKindId: Variant;
begin

  DocumentKindId := GetCurrentDocumentKindId;
  DocumentId := GetCurrentDocumentId;

  ShowDocumentCardFrame(DocumentId, DocumentKindId);

end;

procedure TDocumentCardListFrame.ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
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

procedure TDocumentCardListFrame.RaiseOnDocumentCardListUpdatedEventHandler;
begin

  if Assigned(FOnDocumentCardListUpdatedEventHandler) then
    FOnDocumentCardListUpdatedEventHandler(Self);
    
end;

procedure TDocumentCardListFrame.RaiseOnEmployeeDocumentChargeSheetSetChangedEventHandler;
begin

  if Assigned(FOnEmployeeDocumentChargeSheetSetChangedEventHandler) then
    FOnEmployeeDocumentChargeSheetSetChangedEventHandler(Self);

end;

procedure TDocumentCardListFrame.RaiseOnEmployeeDocumentSetChangedEventHandler;
begin

  if Assigned(FOnEmployeeDocumentSetChangedEventHandler) then
    FOnEmployeeDocumentSetChangedEventHandler(Self);
    
end;

procedure TDocumentCardListFrame.RaiseOnRespondingDocumentCreatedEventHandler(
  RespondingDocumentCardViewModel: TDocumentCardFormViewModel
);
begin

  if Assigned(FOnRespondingDocumentCreatedEventHandler) then
    FOnRespondingDocumentCreatedEventHandler(Self, RespondingDocumentCardViewModel);
    
end;

procedure TDocumentCardListFrame.RefreshCurrentDocumentCardFormViewModel;
var
    CurrentDocumentId: Variant;
    CurrentDocumentKindId: Variant;
begin

  CurrentDocumentId := GetCurrentDocumentId;
  CurrentDocumentKindId := GetCurrentDocumentKindId;

  RefreshDocumentCardFormViewModel(CurrentDocumentId, CurrentDocumentKindId);

end;

procedure TDocumentCardListFrame.RefreshCurrentDocumentCardFormViewModelIfNecessary;
var
    CurrentDocumentId: Variant;
    CurrentDocumentKindId: Variant;
    DocumentCardFormViewModel: TDocumentCardFormViewModel;
    Placeholder: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  if not FSelectedDocumentCardFrame.IsDataChanged then Exit;

  RefreshCurrentDocumentCardFormViewModel;

end;

procedure TDocumentCardListFrame.RefreshDocumentCardFormViewModel(
  const DocumentId, DocumentKindId: Variant);
var DocumentCardFormViewModel: TDocumentCardFormViewModel;
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

  finally

    Screen.Cursor := crDefault;

    FreeAndNil(Placeholder);

  end;
  
end;

procedure TDocumentCardListFrame.RejectApprovingOfCurrentDocument;
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

    FSelectedDocumentCardFrame
      .ViewModel
        .DocumentMainInformationFormViewModel
          .DocumentId,
    
    WorkingEmployeeId
  );

end;

procedure TDocumentCardListFrame.RejectSigningOfCurrentDocument;
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
    WorkingEmployeeId
  );

end;

procedure TDocumentCardListFrame.RemoveDocumentAreas;
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
  
  if Assigned(EmployeeDocumentsReferenceForm) then
    EmployeeDocumentsReferenceForm := nil;

  if Assigned(DocumentCardFrame) then
    DocumentCardFrame := nil;

  SetDocumentAreasVisible(False);

end;

procedure TDocumentCardListFrame.RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
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

function TDocumentCardListFrame.RequestUserConfirmDocumentCardChangesIfNecessary: TDocumentCardChangesConfirmingResult;
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

function TDocumentCardListFrame.ResolveNativeDocumentKindById(
  const DocumentKindId: Variant): TDocumentKindClass;
begin

  Result :=
    NativeDocumentKindDtos
      .FindByIdOrRaise(DocumentKindId).ServiceType;
      
end;

function TDocumentCardListFrame.ResolveUIDocumentKindSection(
  const DocumentKindId: Variant
): TUIDocumentKindClass;
begin

  Result := FUIDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId);

end;

function TDocumentCardListFrame.ResolveUINativeDocumentKindById(
  const DocumentKindId: Variant): TUIDocumentKindClass;
begin

  Result := FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId);
  
end;

procedure TDocumentCardListFrame.RestoreDefaultUIControlProperties;
begin

  inherited RestoreDefaultUIControlProperties;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.RestoreDefaultUIControlProperties;

  if Assigned(FSelectedDocumentCardFrame) then
    FSelectedDocumentCardFrame.RestoreDefaultUIControlProperties;

end;

function TDocumentCardListFrame.
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
          WorkingEmployeeId,
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

procedure TDocumentCardListFrame.SaveChangesAndRefreshCurrentDocumentCardIfNecessary;
begin

  if SaveChangesOfCurrentDocumentCardIfNecessary then
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

end;

procedure TDocumentCardListFrame.SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
begin

  if SaveChangesOfCurrentDocumentCardIfNecessary then
    RefreshCurrentDocumentCardFormViewModel;
  
end;

{
  refactor:
  создать объекты сохранителей данных о док-ах
  для определенных видов карточек }
function TDocumentCardListFrame.SaveChangesOfCurrentDocumentCardIfNecessary: Boolean;
var
    DocumentStorageService: IDocumentStorageService;
    DocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    ChangedDocumentInfoDTO: TChangedDocumentInfoDTO;
    SaveableDocumentKind: TUIDocumentKindClass;
begin

  SaveableDocumentKind := FSelectedDocumentCardFrame.UIDocumentKind;

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
    GetDocumentStorageService(
      FSelectedDocumentCardFrame.ServiceDocumentKind//GetCurrentNativeDocumentKindForApplicationServicing
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
          WorkingEmployeeId,
          ChangedDocumentInfoDTO
        )
      );

      FSelectedDocumentCardFrame.OnChangesApplied;

      Result := True;

  finally

    Screen.Cursor := crDefault;
    
    FreeAndNil(DocumentCardFormViewModelMapperFactory);
    FreeAndNil(DocumentCardFormViewModelMapper);

  end;

end;

function TDocumentCardListFrame.
  SaveChargeSheetsChangesForCurrentDocumentAndUpdateUIIfNecessary: Boolean;
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

    ChangeDocumentsReferenceFormRecordBy({FSelectedDocumentCardFrame.ViewModel}
      FSelectedDocumentCardFrame.ViewModel.DocumentId,
      FSelectedDocumentCardFrame.ViewModel.DocumentKindId
    );

    RaiseOnEmployeeDocumentChargeSheetSetChangedEventHandler;

  except

    on OuterException: TBusinessProcessServiceException do begin

      if OuterException.BusinessOperationSuccessed then begin

        try

          RefreshDocumentCardFormViewModel(
            FSelectedDocumentCardFrame.ViewModel.DocumentId,
            FSelectedDocumentCardFrame.ViewModel.DocumentKindId
          );

          ChangeDocumentsReferenceFormRecordBy({FSelectedDocumentCardFrame.ViewModel}
            FSelectedDocumentCardFrame.ViewModel.DocumentId,
            FSelectedDocumentCardFrame.ViewModel.DocumentKindId
          );

          RaiseOnEmployeeDocumentChargeSheetSetChangedEventHandler;
          
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

      Raise;

    end;

  end;
  
end;

function
 TDocumentCardListFrame.
  SaveChargeSheetsChangesForCurrentDocumentIfNecessary: Boolean;

var
    DocumentChargeSheetControlAppService:
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
      FSelectedDocumentCardFrame.ServiceDocumentKind
    );

  DocumentChargeSheetsChangesInfoDTOMapper := nil;
  DocumentChargeSheetsChangesInfoDTOMapperFactory := nil;
  
  try

    DocumentChargeSheetsChangesInfoDTOMapperFactory :=
      TDocumentChargeSheetsChangesInfoDTOMapperFactories.
      Current.
      CreateDocumentChargeSheetsChangesInfoDTOMapperFactory(
        FSelectedDocumentCardFrame.UIDocumentKind
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
          WorkingEmployeeId,
          FSelectedDocumentCardFrame.DocumentId,
          DocumentChargeSheetsChangesInfoDTO
        )
      );

      FSelectedDocumentCardFrame.DocumentChargesFrame.OnChangesApplied;

      Result := True;

    except

      on E: Exception do begin

        if
          (E is TBusinessProcessServiceException)
          and TBusinessProcessServiceException(E).BusinessOperationSuccessed
        then begin

          FSelectedDocumentCardFrame.DocumentChargesFrame.OnChangesApplied;

          Result := True;
          
        end

        else FSelectedDocumentCardFrame.DocumentChargesFrame.OnChangesApplyingFailed;

        Raise;

      end;

    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentCardListFrame.SaveUIControlProperties;
begin

  inherited SaveUIControlProperties;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.SaveUIControlProperties;

  if Assigned(FSelectedDocumentCardFrame) then
    FSelectedDocumentCardFrame.SaveUIControlProperties;

end;

procedure TDocumentCardListFrame.SendCurrentDocumentToApproving;
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
    WorkingEmployeeId
  );
  
end;

procedure TDocumentCardListFrame.SendCurrentDocumentToSigning;
var SendingDocumentToSigningService: ISendingDocumentToSigningService;
begin

  SendingDocumentToSigningService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetSendingDocumentToSigningService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  try

    SendingDocumentToSigningService.SendDocumentToSigning(

      FSelectedDocumentCardFrame.ViewModel.
      DocumentMainInformationFormViewModel.DocumentId,

      WorkingEmployeeId

    );

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentCardListFrame.SetBaseDocumentsReferenceForm(
  const Value: TBaseDocumentsReferenceForm);
begin

  if FBaseDocumentsReferenceForm = Value then Exit;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.FreeWhenItWillBePossible;

  FBaseDocumentsReferenceForm := Value;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.Font := Font;

end;

procedure TDocumentCardListFrame.SetCurrentDocumentKindInfo(
  const Value: IOperationalDocumentKindInfo
);
begin

  FCurrentDocumentKindInfo := Value;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.OperationalDocumentKindInfo := Value;
  
  FDocumentsReferenceFormPresenter.ShowDocumentsReferenceForm(
    Self, FCurrentDocumentKindInfo
  );

end;

procedure TDocumentCardListFrame.SetDocumentAreasVisible(
  const Visible: Boolean);
begin

  SeparatorBetweenDocumentRecordsAndDocumentCard.Visible := Visible;
  DocumentListPanel.Visible := Visible;
  DocumentCardPanel.Visible := Visible;

end;

procedure TDocumentCardListFrame.SetEnableDocumentCardListGroupingTool(
  const Value: Boolean);
begin

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.EnableRecordGroupingByColumnsOption := Value;
    
end;

procedure TDocumentCardListFrame.SetFont(const Value: TFont);
begin

  inherited;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.Font := Font;

  if Assigned(FSelectedDocumentCardFrame) then
    FSelectedDocumentCardFrame.Font := Font;

end;

procedure TDocumentCardListFrame.SetGlobalDocumentKindDtos(
  const Value: TGlobalDocumentKindDtos);
begin

  FGlobalDocumentKindDtos := Value;
  
end;

procedure TDocumentCardListFrame.SetNativeDocumentKindDtos(
  const Value: TNativeDocumentKindDtos);
begin
  
  FNativeDocumentKindDtos := Value;

end;

procedure TDocumentCardListFrame.SetUIDocumentKindResolver(
  Value: IUIDocumentKindResolver);
begin

  FUIDocumentKindResolver := Value;

end;

procedure TDocumentCardListFrame.SetUINativeDocumentKindResolver(
  Value: IUINativeDocumentKindResolver);
begin

  FUINativeDocumentKindResolver := Value;

  if Assigned(FBaseDocumentsReferenceForm) then begin

    FBaseDocumentsReferenceForm.UIDocumentKindResolver :=
      UINativeDocumentKindResolver;
      
  end;

end;

procedure TDocumentCardListFrame.SetWorkingEmployeeId(const Value: Variant);
begin

  inherited;

  if Assigned(FBaseDocumentsReferenceForm) then
    FBaseDocumentsReferenceForm.WorkingEmployeeId := Value;

  if Assigned(FSelectedDocumentCardFrame) then
    FSelectedDocumentCardFrame.WorkingEmployeeId := Value;
    
end;

procedure TDocumentCardListFrame.
  ShowEmployeeDocumentReferenceFormForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  );
var
    DocumentsReferenceViewModel: TDocumentsReferenceViewModel;
    SelectedWorkCycleStageNames: TStringList;
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;
  
  if Assigned(FBaseDocumentsReferenceForm) then begin

    QueueOldEmployeeDocumentsReferenceFormDestroyingMessage(
      FBaseDocumentsReferenceForm
    );

    FBaseDocumentsReferenceForm := nil;
    
  end;

  FBaseDocumentsReferenceForm :=
    FDocumentsReferenceFormFactory.
      GetDocumentReferenceFormFor(UIDocumentKind);

  try

    Screen.Cursor := crHourGlass;

    try                                

      SelectedWorkCycleStageNames := TStringList.Create;

      SelectedWorkCycleStageNames.Assign(
        FBaseDocumentsReferenceForm.SelectedWorkCycleStageNames
      );

      DocumentsReferenceViewModel :=
        CreateDocumentsReferenceViewModelForEmployee(
          UIDocumentKind,
          WorkingEmployeeId,
          TEmployeeDocumentSetReadOptions.Create(SelectedWorkCycleStageNames)
        );

      FBaseDocumentsReferenceForm.ViewModel := DocumentsReferenceViewModel;

      DocumentsReferenceViewModel := nil;
      
      CustomizeBaseDocumentsReferenceForm(
        FBaseDocumentsReferenceForm
      );

      InflateEmployeeDocumentReferenceFormToLayout(
        FBaseDocumentsReferenceForm
      );
      
      if VarIsNull(FRequestedFocuseableDocumentId) then
        FBaseDocumentsReferenceForm.Show

      else begin

        FBaseDocumentsReferenceForm.Show(FRequestedFocuseableDocumentId);

        FRequestedFocuseableDocumentId := Null;

      end;

    except

      if Assigned(FBaseDocumentsReferenceForm) then
        FreeAndNil(FBaseDocumentsReferenceForm)

      else if Assigned(DocumentsReferenceViewModel) then
        FreeAndNil(DocumentsReferenceViewModel);

      Raise;

    end;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentCardListFrame.OnDocumentSigningMarkingRequestedEventHandler(
  Sender: TObject;
  const SigningDate: TDateTime
);
begin

  SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
  MarkAsSignedCurrentDocument(SigningDate);
  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

  RaiseOnEmployeeDocumentSetChangedEventHandler;
  
end;

procedure TDocumentCardListFrame.OnDocumentSigningRequestedEventHandler(
  Sender: TObject);
begin

  try

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    SignCurrentDocument;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    RaiseOnEmployeeDocumentSetChangedEventHandler;

  except

    on OuterException: TBusinessProcessServiceException do begin

      if OuterException.BusinessOperationSuccessed then begin

        try

          ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;
          RaiseOnEmployeeDocumentSetChangedEventHandler;

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

{ refactor }
procedure TDocumentCardListFrame.OnDocumentFileOpeningRequestedEventHandler(
  Sender: TObject;
  const DocumentFileId: Variant;
  var DocumentFilePath: String
);
var
    DocumentFileServiceClient: IDocumentFileServiceClient;
    DocumentCardFrame: TDocumentCardFrame;
begin

  DocumentCardFrame := Sender as TDocumentCardFrame;
  
  DocumentFileServiceClient :=
    TApplicationServiceRegistries.
    Current.
    GetExternalServiceRegistry.
    GetDocumentFileServiceClient(DocumentCardFrame.ServiceDocumentKind);

  if not VarIsNull(DocumentFileId) then
    DocumentFilePath := DocumentFileServiceClient.GetFile(DocumentFileId);
                     
end;

procedure TDocumentCardListFrame.OldDocumentCardDestroyMessageHandler(
  var Message: TMessage
);
var OldDocumentCard: TDocumentCardFrame;
begin

  OldDocumentCard := TDocumentCardFrame(Message.LParam);

  FreeAndNil(OldDocumentCard);

end;

procedure TDocumentCardListFrame.OnApprovingDocumentSendingRequestedEventHanlder(
  Sender: TObject);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    SendCurrentDocumentToApproving;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    RaiseOnEmployeeDocumentSetChangedEventHandler;

  finally

    Screen.Cursor := crDefault;

  end;
  
end;

{ refactor: скрыть отображетль инф-ции о новом
  цикле согласования }
procedure TDocumentCardListFrame.
  OnNewDocumentApprovingCycleCreatingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
var
  DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
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

    if VarIsNull(DocumentKindId) then
      CurrentDocumentKind := FCurrentDocumentKindInfo.UIDocumentKind

    else CurrentDocumentKind := ResolveUINativeDocumentKindById(DocumentKindId);
    
    DocumentCardFormViewModelFactory :=
      TDocumentCardFormViewModelMapperFactories.
      Current.
      CreateDocumentCardFormViewModelMapperFactory(CurrentDocumentKind);

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
          ResolveNativeDocumentKindById(DocumentKindId)
        );

      DocumentApprovingCycleDTO :=
        DocumentApprovingControlAppService.
          GetInfoForNewDocumentApprovingCycle(
            DocumentId,
            WorkingEmployeeId
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

procedure TDocumentCardListFrame.
  OnDocumentApprovingChangingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    ApprovingViewModel: TDocumentApprovingViewModel
  );
var
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    ServiceDocumentKind: TDocumentKindClass;
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

  if not VarIsNull(DocumentKindId) then
    ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId)

  else ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;

  try

    Screen.Cursor := crHourGlass;

    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(ServiceDocumentKind);

    try

      DocumentApprovingControlAppService.
        EnsureThatEmployeeMayChangeDocumentApproverInfo(
          WorkingEmployeeId,
          DocumentId,
          ApprovingViewModel.ApproverId
        );

      ApprovingViewModel.CanBeChanged := True;

    except

      on e: TDocumentApprovingControlAppServiceException do begin

        ApprovingViewModel.CanBeChanged := False;

      end;

    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentCardListFrame.
  OnDocumentApprovingCompletingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    CycleViewModel: TDocumentApprovingCycleViewModel
  );
var
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    ServiceDocumentKind: TDocumentKindClass;
begin

  if not CycleViewModel.CanBeCompleted then Exit;

  if VarIsNull(DocumentId) then begin

    CycleViewModel.CanBeCompleted := False;

    Exit;
    
  end;

  try

    Screen.Cursor := crHourGlass;

    if not VarIsNull(DocumentKindId) then
      ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId)

    else ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;

    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(ServiceDocumentKind);

    try

      DocumentApprovingControlAppService.CompleteDocumentApproving(
        DocumentId,
        WorkingEmployeeId
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
procedure TDocumentCardListFrame.
  OnDocumentApprovingCycleRemovingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    CycleViewModel: TDocumentApprovingCycleViewModel
  );
var
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    ServiceDocumentKind: TDocumentKindClass;
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

    if not VarIsNull(DocumentKindId) then
      ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId)

    else ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;
    
    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(ServiceDocumentKind);

    try

      DocumentApprovingControlAppService.
        EnsureThatEmployeeMayChangeDocumentApproverList(
          WorkingEmployeeId,
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

procedure TDocumentCardListFrame.
  OnDocumentApprovingCycleSelectedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    SelectedCycleViewModel: TDocumentApprovingCycleViewModel
  );
var DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    ApprovingCycleInfoCanBeChanged, ApprovingCycleInfoCanBeRemoved: Boolean;
    ServiceDocumentKind: TDocumentKindClass;
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

  if not VarIsNull(DocumentKindId) then
    ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId)

  else ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;
  
  DocumentApprovingControlAppService :=
    TApplicationServiceRegistries.
    Current.
    GetDocumentBusinessProcessServiceRegistry.
    GetDocumentApprovingControlAppService(ServiceDocumentKind);

  ApprovingCycleInfoCanBeChanged :=
    DocumentApprovingControlAppService.MayEmployeeChangeDocumentApproverList(
      WorkingEmployeeId,
      DocumentId
    );

  ApprovingCycleInfoCanBeRemoved := ApprovingCycleInfoCanBeChanged;

  SelectedCycleViewModel.CanBeChanged := ApprovingCycleInfoCanBeChanged;
  SelectedCycleViewModel.CanBeRemoved := ApprovingCycleInfoCanBeRemoved;
  
end;

procedure TDocumentCardListFrame.
  OnDocumentApprovingsRemovingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    DocumentApprovingsViewModel: TDocumentApprovingsViewModel
  );
var
    DocumentApprovingViewModel: TDocumentApprovingViewModel;
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    ServiceDocumentKind: TDocumentKindClass;
begin

  try

    Screen.Cursor := crHourGlass;

    if VarIsNull(DocumentId) then begin

      for DocumentApprovingViewModel in DocumentApprovingsViewModel do
        DocumentApprovingViewModel.CanBeRemoved := True;

      Exit;

    end;

    if not VarIsNull(DocumentKindId) then
      ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId)

    else ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;

    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(ServiceDocumentKind);

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
            WorkingEmployeeId,
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

procedure TDocumentCardListFrame.
  OnEmployeesAddingForApprovingRequestedEventHandler(
    Sender: TObject;
    const DocumentId: Variant;
    const DocumentKindId: Variant;
    EmployeeIds: TVariantList
  );
var
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    EmployeeId: Variant;
    ServiceDocumentKind: TDocumentKindClass;
begin

  if VarIsNull(DocumentId) then Exit;

  if not VarIsNull(DocumentKindId) then
    ServiceDocumentKind := ResolveNativeDocumentKindById(DocumentKindId)

  else ServiceDocumentKind := GetCurrentNativeDocumentKindForApplicationServicing;
  
  try

    Screen.Cursor := crHourGlass;
    
    DocumentApprovingControlAppService :=
      TApplicationServiceRegistries.
      Current.
      GetDocumentBusinessProcessServiceRegistry.
      GetDocumentApprovingControlAppService(ServiceDocumentKind);

    for EmployeeId in EmployeeIds do begin

      DocumentApprovingControlAppService.
        EnsureThatEmployeeMayAssignDocumentApprover(
          WorkingEmployeeId,
          DocumentId,
          EmployeeId
        );
        
    end;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentCardListFrame.OnDocumentApprovingRejectingRequestedEventHandler(
  Sender: TObject);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    RejectApprovingOfCurrentDocument;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    RaiseOnEmployeeDocumentSetChangedEventHandler;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentCardListFrame.OnDocumentApprovingRequestedEventHandler(
  Sender: TObject);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    ApproveCurrentDocument;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    RaiseOnEmployeeDocumentSetChangedEventHandler;

  finally

    Screen.Cursor := crDefault;

  end;

  
end;

procedure TDocumentCardListFrame.
  OnDocumentChargesPerformingRequestedEventHandler(
    Sender: TObject;
    RequestedChargeIds: TVariantList
  );
var DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
    DocumentKindWorkCycleInfoAppService: IDocumentKindWorkCycleInfoAppService;
begin

  SaveChargeSheetsChangesForCurrentDocumentIfNecessary;

  PerformDocumentChargeSheets(RequestedChargeIds);

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

  RaiseOnEmployeeDocumentSetChangedEventHandler;

end;

procedure TDocumentCardListFrame.OnDocumentDeletingRequestedEventHandler(
  Sender: TObject;
  const DocumentId: Variant
);
var
    DocumentStorageService: IDocumentStorageService;
    RemovableDocumentIds: TVariantList;
begin

  DocumentStorageService :=
    GetDocumentStorageService(
      GetCurrentNativeDocumentKindForApplicationServicing
    );

  DocumentStorageService.RemoveDocumentsInfo(
    TRemoveDocumentsInfoCommand.Create(
      WorkingEmployeeId,
      TVariantList.CreateFrom(
        [
          FSelectedDocumentCardFrame.
          ViewModel.DocumentId
        ]
      )
    )
  );

end;

procedure TDocumentCardListFrame.OnDocumentInfoSavingRequestedEventHandler(
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

procedure TDocumentCardListFrame.OnDocumentCardRefreshRequestedEventHandler(
  Sender: TObject;
  const DocumentId, DocumentKindId: Variant
);
begin

  ShowCardForDocumentAndUpdateRelatedDocumentRecord(DocumentId, DocumentKindId);
  
end;

procedure TDocumentCardListFrame.
  OnDocumentChargeSheetsChangesSavingRequestedEventHandler(
    Sender: TObject
  );
begin

  SaveChargeSheetsChangesForCurrentDocumentAndUpdateUIIfNecessary;

end;

procedure TDocumentCardListFrame.OnDocumentPrintFormRequestedEventHandler(
  Sender: TObject;
  DocumentCardViewModel: TDocumentCardFormViewModel
);
var DocumentPrintFormPresenter: IDocumentPrintFormPresenter;
    DocumentApprovingListCreatingAppService: IDocumentApprovingListCreatingAppService;
    DocumentApprovingListDTOs: TDocumentApprovingListDTOs;
    DocumentApprovingListSetHolderMapper: TDocumentApprovingListSetHolderMapper;
    DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;
begin

  DocumentApprovingListDTOs := nil;
  DocumentApprovingListSetHolderMapper := nil;
  DocumentApprovingListSetHolder := nil;

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

    DocumentApprovingListDTOs :=
      DocumentApprovingListCreatingAppService.
        CreateDocumentApprovingListsForDocument(
          DocumentCardViewModel.DocumentId
        );

    if not Assigned(DocumentApprovingListDTOs) then begin

      DocumentPrintFormPresenter.PresentDocumentPrintFormBy(
        DocumentCardViewModel
      );

    end

    else begin

      DocumentApprovingListSetHolderMapper :=
        TDocumentApprovingListSetHolderMapper.Create(
          TDocumentDataSetHolderFactories.Instance.GetDocumentDataSetHolderFactory(
            ResolveUIDocumentKindSection(DocumentCardViewModel.DocumentKindId)
          )
        );

      DocumentApprovingListSetHolder :=
        DocumentApprovingListSetHolderMapper.
          MapDocumentApprovingListSetHolderFrom(
            DocumentApprovingListDTOs
          );

      DocumentPrintFormPresenter.PresentDocumentPrintFormBy(
        DocumentCardViewModel,
        DocumentApprovingListSetHolder
      );

    end;

  finally

    FreeAndNil(DocumentApprovingListDTOs);
    FreeAndNil(DocumentApprovingListSetHolder);
    FreeAndNil(DocumentApprovingListSetHolderMapper);

  end;

end;

procedure TDocumentCardListFrame.
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

procedure TDocumentCardListFrame.OnDocumentRecordDeletedEventHandler(
  Sender: TObject);
begin

  ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;

  RaiseOnEmployeeDocumentSetChangedEventHandler;
  
end;

procedure TDocumentCardListFrame.OnDocumentRecordsLoadingCanceledEventHandler(
  Sender: TObject);
begin

  ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;
  
end;

procedure TDocumentCardListFrame.OnDocumentRecordsLoadingFailedEventHandler(
  Sender: TObject;
  const Error: Exception
);
begin

  ShowEmptyNoActivedDocumentCardForCurrentSelectedDocumentKindSection;

  ShowErrorMessage(Self.Handle, Error.Message, 'Ошибка');
  
end;

procedure TDocumentCardListFrame.OnDocumentRecordsLoadingSuccessEventHandler(
  Sender: TObject);
begin

  ShowEmptyNoActivedDocumentCardForCurrentDocumentKindIfDocumentsAreAbsent;

end;

procedure TDocumentCardListFrame.OnDocumentRecordsRefreshedEventHandler(
  Sender: TObject);
begin

  RaiseOnDocumentCardListUpdatedEventHandler;

end;

procedure TDocumentCardListFrame.OnDocumentRecordsRefreshRequestedEventHandler(
  Sender: TObject;
  CurrentViewModel: TDocumentsReferenceViewModel;
  var UpdatedViewModel: TDocumentsReferenceViewModel
);
var
    Options: IEmployeeDocumentSetReadOptions;
begin

  RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

  Options :=
    GetEmployeeDocumentSetReadOptionsFromDocumentReferenceFormViewModel(
      CurrentViewModel
    );

  UpdatedViewModel :=
    CreateDocumentsReferenceViewModelForEmployee(
      FCurrentDocumentKindInfo.UIDocumentKind,
      WorkingEmployeeId,
      Options
    );

end;

procedure TDocumentCardListFrame.OnDocumentRejectingFromSigningRequestedEventHandler(
  Sender: TObject
);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    RejectSigningOfCurrentDocument;

    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecordOrEmptyNoActivedDocumentCardIfItNotExists;

    RaiseOnEmployeeDocumentSetChangedEventHandler;
    
  finally

    Screen.Cursor := crDefault;

  end;
  
end;

procedure TDocumentCardListFrame.OnDocumentSendingToSigningRequestedEventHandler(
  Sender: TObject
);
begin

  try

    Screen.Cursor := crHourGlass;

    SaveChangesAndRefreshCurrentDocumentCardViewModelIfNecessary;
    SendCurrentDocumentToSigning;
    ShowDocumentCardForCurrentDocumentRecordAndUpdateThisRecord;

    RaiseOnEmployeeDocumentSetChangedEventHandler;
    
  finally

    Screen.Cursor := crDefault;

  end;

end;

{ TDocumentCardShowMessageData }

constructor TDocumentCardShowMessageData.Create(DocumentId,
  DocumentKindId: Variant);
begin

  inherited Create;

  Self.DocumentId := DocumentId;
  Self.DocumentKindId := DocumentKindId;
  
end;

end.
