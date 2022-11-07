{ refactor:
  сделать карточку независимой
  от событий, исходящих от страниц, составляющих её.
  Реализовать связующий механизм
  доставки событий EventBus
}
unit unDocumentCardFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons, ComCtrls, DocumentMainInformationFrameUnit,
  unDocumentChargesFrame,
  DocumentRelationsFrameUnit,
  DocumentFilesFrameUnit,
  unDocumentCardInformationFrame,
  ExtCtrls,
  ColoredPageControlUnit,
  DocumentCardFormViewModel,
  DocumentFilesViewFrameUnit,
  DocumentFileInfoList,
  DocumentApprovingCyclesReferenceFormUnit,
  DocumentApproversInfoFormUnit,
  DocumentApprovingsFrameUnit,
  EmployeesReferenceFormUnit,
  DocumentApprovingCycleViewModel,
  UIDocumentKinds,
  DocumentApprovingViewModel,
  VariantListUnit,
  DocumentKinds,
  DocumentOperationToolBarFrameUnit,
  AnchorableDockFormUnit, dxSkinsCore,
  dxSkinsDefaultPainters,
  unDocumentFlowCardInformationFrame,
  DocumentApprovingSheetPresenter,
  DocumentReportPresenterRegistry,
  UserInterfaceSwitch,
  ApplicationServiceRegistry,
  unDocumentFlowInformationFrame, cxControls, cxSplitter;

type

  TOnApprovingDocumentSendingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentApprovingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentApprovingRejectingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;
    
  TOnDocumentSendingToSigningRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentInfoSavingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentChargesPerformingRequestedEventHandler =
    procedure (
      Sender: TObject;
      RequestedChargeIds: TVariantList
    ) of object;
    
  TOnDocumentRejectingFromSigningRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentPerformingsChangesSavingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentSigningRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentSigningMarkingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const SigningDate: TDateTime
    ) of object;

  TOnDocumentPrintFormRequestedEventHandler =
    procedure (
      Sender: TObject;
      DocumentCardViewModel: TDocumentCardFormViewModel
    ) of object;

  TOnDocumentFileOpeningRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentFileId: Variant;
      var DocumentFilePath: String
    ) of object;

  TOnDocumentApprovingChangingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      ApprovingViewModel: TDocumentApprovingViewModel
    ) of object;
    
  TOnDocumentApprovingsRemovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    ) of object;

  TOnDocumentApprovingCompletingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnNewDocumentApprovingCycleCreatingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnDocumentApprovingCycleRemovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnEmployeeReferenceForApprovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      var EmployeeReference: TEmployeesReferenceForm
    ) of object;

  TOnEmployeesAddingForApprovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      EmployeeIds: TVariantList
    ) of object;

  TOnDocumentApprovingCycleSelectedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant;
      SelectedCycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnRelatedDocumentCardOpeningRequestedEventHandler =
    procedure (
      Sender: TObject;
      const RelatedDocumentId: Variant;
      const RelatedDocumentKindId: Variant;
      const SourceDocumentId: Variant;
      const SourceDocumentKindId: Variant
    ) of object;

type

  TDocumentCardFrameSavingResult = (srChangesApplied, srNotValidData, srChangesAbsent);

  TDocumentCardFrame = class(TDocumentCardInformationFrame)
    DocumentCardPageControl: TPageControl;
    DocumentMainInfoAndReceiversPage: TTabSheet;
    DocumentRelationsAndFilesPage: TTabSheet;
    FooterButtonPanel: TPanel;
    DocumentMainInfoArea: TPanel;
    SplitterBetweenMainInfoAndReceiversAreas: TSplitter;
    DocumentChargesInfoArea: TPanel;
    DocumentRelationsInfoArea: TPanel;
    DocumentFilesInfoArea: TPanel;
    DocumentRelationsLabel: TLabel;
    DocumentRelationsFormArea: TPanel;
    DocumentFilesLabel: TLabel;
    DocumentFilesFormArea: TPanel;
    DocumentMainInfoLabel: TLabel;
    DocumentMainInfoFormArea: TPanel;
    DocumentChargesLabel: TLabel;
    DocumentChargesFormArea: TPanel;
    DocumentPreviewPage: TTabSheet;
    DocumentApprovingPage: TTabSheet;
    DocumentApprovingsPagePanel: TPanel;
    DocumentChargesPage: TTabSheet;
    DocumentMainInfoPage: TTabSheet;
    RelatedDocumentsAndFilesPanel: TPanel;
    RelatedDocumentsAndFilesVerticalSplitter: TSplitter;
    DocumentFilesViewArea: TPanel;
    DocumentPreviewLabel: TLabel;
    DocumentFilesViewFormPanel: TPanel;
    SplitterBetweenRelationsAndFilesAreas: TSplitter;
    procedure DocumentCardPageControlDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure SaveDocumentCardButtonClick(Sender: TObject);
    procedure SendToSigningButtonClick(Sender: TObject);
    procedure SignDocumentButtonClick(Sender: TObject);
    procedure RejectDocumentButtonClick(Sender: TObject);
    procedure ApproveDocumentButtonClick(Sender: TObject);
    procedure NoApproveDocumentButtonClick(Sender: TObject);
    procedure PerformDocumentButtonClick(Sender: TObject);
    procedure HandleDocumentMarkingAsSignedEvent(Sender: TObject);
    procedure SendToApprovingButtonClick(Sender: TObject);
    procedure DocumentCardPageControlChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure SplitterBetweenRelationsAndFilesAreasMoved(Sender: TObject);
    procedure SplitterBetweenMainInfoAndReceiversAreasMoved(Sender: TObject);
    procedure DocumentPrintFormButtonClick(Sender: TObject);
    procedure DocumentRelationsAndFilesPageShow(Sender: TObject);
    procedure DocumentApprovingSheetCreatingToolActivatedHandler(Sender: TObject);
    procedure RelatedDocumentsAndFilesVerticalSplitterMoved(Sender: TObject);
    procedure SplitterBetweenRelationsAndFilesAreasCanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);

  private

    //FEnableEvenlySpacePartitionBetweenMainInfoAndChargesAreas: Boolean;
    //FEnableEvenlySpacePartitionBetweenRelationsAndFilesAreas: Boolean;
    
    function GetOnRelatedDocumentSelectionFormRequestedEventHandler: TOnDocumentSelectionFormRequestedEventHandler;
    procedure SetOnRelatedDocumentSelectionFormRequestedEventHandler(
      const Value: TOnDocumentSelectionFormRequestedEventHandler);

    function GetDocumentMainInformationPageNumber: Integer;
    function GetNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    procedure SetNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio(
      const Value: Double);
    procedure SetLastSelectedNewUIDocumentCardSheetIndex(const Value: Integer);
    function GetOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    procedure SetOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio(
      const Value: Double);
    //function GetEnableEvenlySpacePartitionBetweenDocumentInformationAreas: Boolean;

    //procedure SetEnableEvenlySpacePartitionBetweenDocumentInformationAreas(const Value: Boolean);

  protected

    function GetDocumentId: Variant; override;

    procedure SetDocumentId(const Value: Variant); override;
    procedure SetServiceDocumentKind(const Value: TDocumentKindClass); override;
    procedure SetUIDocumentKind(const Value: TUIDocumentKindClass); override;

  protected

    procedure ApplyUIStyles; override;
    procedure SetFont(const Value: TFont); override;

  protected

    FViewOnly: Boolean;

    FDocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
    
    FOnDocumentPrintFormRequestedEventHandler:
      TOnDocumentPrintFormRequestedEventHandler;

    FOnApprovingDocumentSendingRequestedEventHandler:
      TOnApprovingDocumentSendingRequestedEventHandler;

    FOnDocumentApprovingRequestedEventHandler:
      TOnDocumentApprovingRequestedEventHandler;

    FOnDocumentApprovingRejectingRequestedEventHandler:
      TOnDocumentApprovingRejectingRequestedEventHandler;
      
    FOnDocumentSendingToSigningRequestedEventHandler:
      TOnDocumentSendingToSigningRequestedEventHandler;

    FOnDocumentInfoSavingRequestedEventHandler:
      TOnDocumentInfoSavingRequestedEventHandler;

    FOnDocumentRejectingFromSigningRequestedEventHandler:
      TOnDocumentRejectingFromSigningRequestedEventHandler;

    FOnDocumentPerformingsChangesSavingRequestedEventHandler:
      TOnDocumentPerformingsChangesSavingRequestedEventHandler;

    FOnDocumentSigningRequestedEventHandler:
      TOnDocumentSigningRequestedEventHandler;

    FOnDocumentSigningMarkingRequestedEventHandler:
      TOnDocumentSigningMarkingRequestedEventHandler;
      
    FOnDocumentFileOpeningRequestedEventHandler:
      TOnDocumentFileOpeningRequestedEventHandler;

    FOnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler;

    FOnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler;

    FOnDocumentApprovingCompletingRequestedEventHandler:
      TOnDocumentApprovingCompletingRequestedEventHandler;

    FOnDocumentApprovingCycleRemovingRequestedEventHandler:
      TOnDocumentApprovingCycleRemovingRequestedEventHandler;

    FOnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler;

    FOnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler;

    FOnNewDocumentApprovingCycleCreatingRequestedEventHandler:
      TOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

    FOnDocumentApprovingCycleSelectedEventHandler:
      TOnDocumentApprovingCycleSelectedEventHandler;

    FOnRelatedDocumentCardOpeningRequestedEventHandler:
      TOnRelatedDocumentCardOpeningRequestedEventHandler;

    FOnDocumentChargesPerformingRequestedEventHandler:
      TOnDocumentChargesPerformingRequestedEventHandler;

  protected { Approving Event Handlers }
  
    function GetOnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler;

    function GetOnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler;

    function GetOnDocumentApprovingCompletingRequestedEventHandler:
      TOnDocumentApprovingCompletingRequestedEventHandler;

    function GetOnDocumentApprovingCycleRemovingRequestedEventHandler:
      TOnDocumentApprovingCycleRemovingRequestedEventHandler;

    function GetOnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler;

    function GetOnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler;

    function GetOnNewDocumentApprovingCycleCreatingRequestedEventHandler:
      TOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

    function GetOnDocumentApprovingCycleSelectedEventHandler:
      TOnDocumentApprovingCycleSelectedEventHandler;

    procedure SetOnDocumentApprovingChangingRequestedEventHandler(
      const Value: TOnDocumentApprovingChangingRequestedEventHandler);

    procedure SetOnDocumentApprovingCompletingRequestedEventHandler(
      const Value: TOnDocumentApprovingCompletingRequestedEventHandler);

    procedure SetOnDocumentApprovingCycleRemovingRequestedEventHandler(
      const Value: TOnDocumentApprovingCycleRemovingRequestedEventHandler);

    procedure SetOnDocumentApprovingsRemovingRequestedEventHandler(
      const Value: TOnDocumentApprovingsRemovingRequestedEventHandler);

    procedure SetOnEmployeeReferenceForApprovingRequestedEventHandler(
      const Value: TOnEmployeeReferenceForApprovingRequestedEventHandler);

    procedure SetOnEmployeesAddingForApprovingRequestedEventHandler(
      const Value: TOnEmployeesAddingForApprovingRequestedEventHandler);

    procedure SetOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
      const Value: TOnNewDocumentApprovingCycleCreatingRequestedEventHandler);

    procedure SetOnDocumentFileOpeningRequestedEventHandler(
      const Value: TOnDocumentFileOpeningRequestedEventHandler);

    procedure SetOnDocumentApprovingCycleSelectedEventHandler(
      const Value: TOnDocumentApprovingCycleSelectedEventHandler
    );

  protected

    FViewModel: TDocumentCardFormViewModel;

    FDocumentApprovingsFrame: TDocumentApprovingsFrame;
    FDocumentMainInformationFrame: TDocumentMainInformationFrame;
    FDocumentChargesFrame: TDocumentChargesFrame;
    FDocumentRelationsFrame: TDocumentRelationsFrame;
    FDocumentFilesFrame: TDocumentFilesFrame;
    FDocumentFilesViewFrame: TDocumentFilesViewFrame;

  protected

    FMainInformationAndReceiversFormSizeRatio: Double;
    FRelatedDocumentsAndFilesFormSizeRatio: Double;
    FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    FSaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize: Boolean;
    FSaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize: Boolean;

    FLastSelectedOldUIDocumentCardSheetIndex: Integer;
    FLastSelectedNewUIDocumentCardSheetIndex: Integer;

    procedure SetMainInformationAndReceiversFormSizeRatio(const Ratio: Double);
    procedure SetRelatedDocumentsAndFilesFormSizeRatio(const Ratio: Double);

    procedure UpdateDocumentPageFormsSizesRatios;
    procedure UpdateMainInformationAndReceiversFormSizeRatio;
    procedure UpdateRelatedDocumentsAndFilesFormSizeRatio;
    procedure UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
    procedure UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

    procedure UpdateMainInformationAndReceiversFormSizesByRatio(const Ratio: Double);
    procedure UpdateRelatedDocumentsAndFilesFormSizesByRatio(const Ratio: Double);
    procedure UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(const Ratio: Double);
    procedure UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(const Ratio: Double);

    procedure UpdateDocumentPageFormSizesByCurrentRatios;

    function GetSaveDocumentSheetAreasSizeRatiosOnResize: Boolean;
    procedure SetSaveDocumentSheetAreasSizeRatiosOnResize(const Value: Boolean);

  protected

    function GetActiveDocumentInformationPage: TTabSheet; virtual;

  protected { Window Messages }

    procedure OnShowWindowMessageHandler(var Message: TMessage); message WM_SHOWWINDOW;

    procedure OnShow; override;
    
  protected

    procedure OnDocumentApprovingsChangedEventHandler(
      Sender: TObject
    );
    
    procedure OnDocumentMainInformationChangedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentReceiversChangedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentFilesChangedEventHandler(
      Sender: TObject
    );

    procedure OnDocumentFileShowingEventHandler(
      Sender: TObject;
      ShowableDocumentFileInfo: TDocumentFileInfo;
      var TargetDocumentFilePath: String
    );

    procedure OnDocumentRelationsChangedEventHandler(
      Sender: TObject
    );

    procedure OnRelatedDocumentCardOpeningRequestedEventHandle(
      Sender: TObject;
      const DocumentId, DocumentTypeId: Variant
    );

  protected

    procedure OnDocumentApprovingChangingRequestedEventHandle(
      Sender: TObject;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      ApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure OnDocumentApprovingsRemovingRequestedEventHandle(
      Sender: TObject;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure OnDocumentApprovingsRemovedEventHandle(
      Sender: TObject;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    ); virtual;

      procedure OnNewCycleApprovingsRemoved(
        NewCycleRemovedApprovingsViewModel: TDocumentApprovingsViewModel;
        RemainingNewCycleApprovingsViewModel: TDocumentApprovingsViewModel
      ); virtual;

    procedure OnEmployeesAddingForApprovingRequestedEventHandle(
      Sender: TObject;
      EmployeeIds: TVariantList
    ); virtual;

    procedure OnEmployeesAddedForApprovingEventHandle(
      Sender: TObject;
      EmployeeIds: TVariantList
    ); virtual;

    procedure OnDocumentApprovingCycleRemovingRequestedEventHandle(
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ); virtual;

    procedure OnDocumentApprovingCycleRemovedEventHandle(
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ); virtual;

    procedure OnDocumentApprovingCompletingRequestedEventHandle(
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ); virtual;

    procedure OnNewDocumentApprovingCycleCreatingRequestedEventHandle(
      Sender: TObject;
      var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    ); virtual;

    procedure OnDocumentApprovingCycleSelectedEventHandle(
      Sender: TObject;
      SelectedCycleViewModel: TDocumentApprovingCycleViewModel
    ); virtual;

    procedure OnNewCycleApprovingsCheck(
      ApprovingsOfNewCycle: TDocumentApprovingsViewModel
    ); virtual;

  protected

    procedure OnDocumentFileSelectedEventHandler(
      Sender: TObject;
      const FileId: Variant;
      const FileName: String
    );

    procedure OnDocumentFileAddedEventHandler(
      Sender: TObject;
      const FileName: String;
      const FilePath: String
    );

    procedure OnDocumentFileRemovedEventHandler(
      Sender: TObject;
      const FileName: String;
      const FilePath: String
    );

    procedure OnExistingDocumentFileOpeningRequestedEventHandler(
      Sender: TObject;
      const DocumentFileId: Variant;
      var DocumentFilePath: String
    );
    
  protected

    procedure SubscribeOnDocumentFilesFrameEvents;
    procedure SubscribeOnDocumentApprovingsFrameEvents;

  protected

    procedure ChangeUserInterfaceKind(Value: TUserInterfaceKind); override;
    procedure SwitchUserInterfaceTo(Value: TUserInterfaceKind); override;

    procedure SaveUIControlPropertiesForCurrentUserInterfaceKind;
    procedure RestoreUIControlPropertiesForCurrentUserInterfaceKind;
    
  protected

    procedure RaiseExceptionIfMoreThanOnAccessibleDocumentApprovingsFound(
      DocumentApprovings: TDocumentApprovingsViewModel
    );

    function GetNotApprovingReasonFromInputForm: String;

    procedure RaiseOnDocumentApprovingRejectingRequestedEventHandler;

  protected

    procedure Initialize; override;

    procedure SetEnabled(Value: Boolean); override;

    procedure AssignDocumentInformationFrame(
      var DocumentInformationFrameField: TDocumentCardInformationFrame;
      AssignableDocumentInformationFrame: TDocumentCardInformationFrame
    );

    procedure FreeAndSetDocumentInformationFrameReference(
      var DocumentInformationFrameField: TDocumentCardInformationFrame;
      AssignableDocumentInformationFrame: TDocumentCardInformationFrame
    );

    procedure InflateDocumentInformationFrameToPage(
      DocumentInformationFrame: TDocumentCardInformationFrame
    );
    
    function GetAreaForDocumentInformationFrame(
      DocumentInformationFrame: TDocumentCardInformationFrame
    ): TWinControl;

    function GetViewModel: TDocumentCardFormViewModel;
    procedure SetViewModel(ViewModel: TDocumentCardFormViewModel);

    procedure SetWorkingEmployeeId(const Id: Variant); override;

    function ValidateInput: Boolean; override;

    procedure SetOnDocumentPerformingsChangesSavingRequestedEventHandler(
      OnDocumentPerformingsChangesSavingRequestedEventHandler:
        TOnDocumentPerformingsChangesSavingRequestedEventHandler
    );

    procedure RaiseOnDocumentPerformingsChangesSavingRequestedEventHandler;

    procedure ChangeLayoutScrollnessOfDocumentMainInfoAndReceiversInfoAreasIfNecessary;
    procedure ChangeLayoutScrollnessOfDocumentRelationsInfoAndFilesInfoAreasIfNecessary;

    function GetViewOnly: Boolean; override;
    procedure SetViewOnly(const Value: Boolean); override;

    procedure SetActiveDocumentInfoPageNumber(const Value: Integer);
    function GetActiveDocumentInfoPageNumber: Integer;

    procedure UpdateDocumentFilesViewFrameIfNecessary;

  protected

    procedure SetDocumentOperationToolBarFrame(
      Value: TDocumentOperationToolBarFrame
    );

    procedure InflateDocumentOperationToolBarFrame(
      DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame
    );

    procedure SubscribeOnDocumentOperationToolBarFrameEvents(
      DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame
    ); virtual;


    function GetApprovingDocumentSendingTool: TButton;
    function GetSigningDocumentSendingTool: TButton;
    function GetDocumentSigningMarkingTool: TButton;
    function GetDocumentSigningTool: TButton;
    function GetDocumentSigningRejectingTool: TButton;
    
  public

    destructor Destroy; override;

    procedure AdjustFooterButtonLayout; virtual;
    procedure HideFooterButtonPanel;
    procedure SetFooterButtonPanelVisible(const Visible: Boolean);

    function SaveData: TDocumentCardFrameSavingResult;

    procedure OnChangesApplied; override;
    function IsDataChanged: Boolean; override;

    procedure RaisePendingEvents; override;

    function IsEmpty: Boolean;

    procedure AssignDocumentApprovingsFrame(
      DocumentApprovingsFrame: TDocumentApprovingsFrame
    );
    
    procedure AssignDocumentMainInformationFrame(
      DocumentMainInformationFrame: TDocumentMainInformationFrame
    ); virtual;

    procedure AssignDocumentChargesFrame(
      DocumentChargesFrame: TDocumentChargesFrame
    ); virtual;

    procedure AssignDocumentRelationsFrame(
      DocumentRelationsFrame: TDocumentRelationsFrame
    ); virtual;

    procedure AssignDocumentFilesFrame(
      DocumentFilesFrame: TDocumentFilesFrame
    ); virtual;

    procedure AssignDocumentFilesViewFrame(
      DocumentFilesViewFrame: TDocumentFilesViewFrame
    ); virtual;

    function GetMainInformationAndReceiversFormSizeRatio: Double;
    function GetRelatedDocumentsAndFilesFormSizeRatio: Double;

    procedure CopyUISettings(DocumentInformationFrame: TDocumentFlowInformationFrame); override;

    procedure SaveWithNestedFramesUIProperties;
    procedure SaveUIControlProperties; override;

    procedure RestoreWithNestedFramesUIProperties;
    procedure RestoreNestedFramesUIProperties;
    procedure SaveNestedFramesUIProperties;

    property ViewModel: TDocumentCardFormViewModel
    read GetViewModel write SetViewModel;
    
  published
  
    property OnDocumentFileOpeningRequestedEventHandler:
      TOnDocumentFileOpeningRequestedEventHandler
    read FOnDocumentFileOpeningRequestedEventHandler
    write SetOnDocumentFileOpeningRequestedEventHandler;
    
    property OnDocumentPrintFormRequestedEventHandler:
      TOnDocumentPrintFormRequestedEventHandler
    read FOnDocumentPrintFormRequestedEventHandler
    write FOnDocumentPrintFormRequestedEventHandler;

    property OnApprovingDocumentSendingRequestedEventHanlder:
      TOnApprovingDocumentSendingRequestedEventHandler
    read FOnApprovingDocumentSendingRequestedEventHandler
    write FOnApprovingDocumentSendingRequestedEventHandler;

    property OnDocumentApprovingRequestedEventHandler:
      TOnDocumentApprovingRequestedEventHandler
    read FOnDocumentApprovingRequestedEventHandler
    write FOnDocumentApprovingRequestedEventHandler;

    property OnDocumentApprovingRejectingRequestedEventHandler:
      TOnDocumentApprovingRejectingRequestedEventHandler
    read FOnDocumentApprovingRejectingRequestedEventHandler
    write FOnDocumentApprovingRejectingRequestedEventHandler;

    property OnDocumentSendingToSigningRequestedEventHandler:
      TOnDocumentSendingToSigningRequestedEventHandler
    read FOnDocumentSendingToSigningRequestedEventHandler
    write FOnDocumentSendingToSigningRequestedEventHandler;

    property OnDocumentInfoSavingRequestedEventHandler:
      TOnDocumentInfoSavingRequestedEventHandler
    read FOnDocumentInfoSavingRequestedEventHandler
    write FOnDocumentInfoSavingRequestedEventHandler;

    property OnDocumentChargesPerformingRequestedEventHandler: TOnDocumentChargesPerformingRequestedEventHandler
    read FOnDocumentChargesPerformingRequestedEventHandler
    write FOnDocumentChargesPerformingRequestedEventHandler;

    property OnDocumentRejectingFromSigningRequestedEventHandler:
      TOnDocumentRejectingFromSigningRequestedEventHandler
    read FOnDocumentRejectingFromSigningRequestedEventHandler
    write FOnDocumentRejectingFromSigningRequestedEventHandler;

    property OnDocumentPerformingsChangesSavingRequestedEventHandler:
      TOnDocumentPerformingsChangesSavingRequestedEventHandler
    read FOnDocumentPerformingsChangesSavingRequestedEventHandler
    write SetOnDocumentPerformingsChangesSavingRequestedEventHandler;

    property OnDocumentSigningRequestedEventHandler:
                TOnDocumentSigningRequestedEventHandler
    read FOnDocumentSigningRequestedEventHandler
    write FOnDocumentSigningRequestedEventHandler;

    property OnDocumentSigningMarkingRequestedEventHandler: TOnDocumentSigningMarkingRequestedEventHandler
    read FOnDocumentSigningMarkingRequestedEventHandler
    write FOnDocumentSigningMarkingRequestedEventHandler;
    
    property OnRelatedDocumentSelectionFormRequestedEventHandler:
      TOnDocumentSelectionFormRequestedEventHandler

    read GetOnRelatedDocumentSelectionFormRequestedEventHandler
    write SetOnRelatedDocumentSelectionFormRequestedEventHandler;

    property OnRelatedDocumentCardOpeningRequestedEventHandler:
      TOnRelatedDocumentCardOpeningRequestedEventHandler

    read FOnRelatedDocumentCardOpeningRequestedEventHandler
    write FOnRelatedDocumentCardOpeningRequestedEventHandler;

  published

    property OnDocumentApprovingCycleSelectedEventHandler:
      TOnDocumentApprovingCycleSelectedEventHandler
    read GetOnDocumentApprovingCycleSelectedEventHandler
    write SetOnDocumentApprovingCycleSelectedEventHandler;
    
    property OnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler
    read GetOnDocumentApprovingChangingRequestedEventHandler
    write SetOnDocumentApprovingChangingRequestedEventHandler;

    property OnDocumentApprovingCompletingRequestedEventHandler:
      TOnDocumentApprovingCompletingRequestedEventHandler
    read GetOnDocumentApprovingCompletingRequestedEventHandler
    write SetOnDocumentApprovingCompletingRequestedEventHandler;

    property OnDocumentApprovingCycleRemovingRequestedEventHandler:
      TOnDocumentApprovingCycleRemovingRequestedEventHandler
    read GetOnDocumentApprovingCycleRemovingRequestedEventHandler
    write SetOnDocumentApprovingCycleRemovingRequestedEventHandler;

    property OnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler
    read GetOnDocumentApprovingsRemovingRequestedEventHandler
    write SetOnDocumentApprovingsRemovingRequestedEventHandler;

    property OnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler
    read GetOnEmployeeReferenceForApprovingRequestedEventHandler
    write SetOnEmployeeReferenceForApprovingRequestedEventHandler;

    property OnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler
    read GetOnEmployeesAddingForApprovingRequestedEventHandler
    write SetOnEmployeesAddingForApprovingRequestedEventHandler;

    property OnNewDocumentApprovingCycleCreatingRequestedEventHandler:
      TOnNewDocumentApprovingCycleCreatingRequestedEventHandler
    read GetOnNewDocumentApprovingCycleCreatingRequestedEventHandler
    write SetOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

  published

    property DocumentApprovingsFrame: TDocumentApprovingsFrame
    read FDocumentApprovingsFrame write FDocumentApprovingsFrame;
    
    property DocumentMainInformationFrame: TDocumentMainInformationFrame
    read FDocumentMainInformationFrame;

    property DocumentChargesFrame: TDocumentChargesFrame
    read FDocumentChargesFrame;

    property DocumentRelationsFrame: TDocumentRelationsFrame
    read FDocumentRelationsFrame;

    property DocumentFilesFrame: TDocumentFilesFrame
    read FDocumentFilesFrame;

    property DocumentFilesViewFrame: TDocumentFilesViewFrame
    read FDocumentFilesViewFrame;

  published

    property ViewOnly: Boolean read GetViewOnly write SetViewOnly;

    property SaveDocumentSheetAreasSizeRatiosOnResize: Boolean
    read GetSaveDocumentSheetAreasSizeRatiosOnResize write SetSaveDocumentSheetAreasSizeRatiosOnResize;

    property SaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize: Boolean
    read FSaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize
    write FSaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize;

    property SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize: Boolean
    read FSaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize
    write FSaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize;

    property MainInformationAndReceiversFormSizeRatio: Double
    read GetMainInformationAndReceiversFormSizeRatio
    write SetMainInformationAndReceiversFormSizeRatio;

    property RelatedDocumentsAndFilesFormSizeRatio: Double
    read GetRelatedDocumentsAndFilesFormSizeRatio
    write SetRelatedDocumentsAndFilesFormSizeRatio;

    { Deprecated, extract to UserInterfaceCustomizer Object and pass self to it }
    property NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double
    read GetNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
    write SetNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

    property OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double
    read GetOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
    write SetOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

    property LastSelectedOldUIDocumentCardSheetIndex: Integer
    read FLastSelectedOldUIDocumentCardSheetIndex
    write FLastSelectedOldUIDocumentCardSheetIndex;

    property LastSelectedNewUIDocumentCardSheetIndex: Integer
    read FLastSelectedNewUIDocumentCardSheetIndex
    write SetLastSelectedNewUIDocumentCardSheetIndex;

    property ActiveDocumentInfoPageNumber: Integer
    read GetActiveDocumentInfoPageNumber
    write SetActiveDocumentInfoPageNumber;

    property DocumentMainInformationPageNumber: Integer
    read GetDocumentMainInformationPageNumber;

  published

    property DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame
    read FDocumentOperationToolBarFrame
    write SetDocumentOperationToolBarFrame;
    
  end;

implementation

  
{$R *.dfm}

uses

  CommonControlStyles,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  unDocumentChargeSheetsFrame,
  unNotDocumentApprovingReasonInputForm,
  Math,
  VariantFunctions,
  IObjectPropertiesStorageUnit,
  ExtendedDocumentMainInformationFrameUnit,
  ApplicationServiceRegistries,
  DocumentApprovingSheetDataCreatingAppService,
  DocumentApprovingSheetViewModelMapperFactories,
  DocumentApprovingSheetDataDto,
  InterfaceFunctions,
  DocumentApprovingSheetViewModel,
  DocumentFlowInformationFramePropertiesStorage,
  DocumentApprovingSheetViewModelMapper,
  ApplicationPropertiesStorageRegistry, ReportingServiceRegistry,
  ObjectPropertiesStorageRegistry, IObjectPropertiesStorageRegistryUnit;
  
{ TDocumentCardFrame }

function FooterButtonPositionComparator(
    Item1, Item2: Pointer
  ): Integer;
  var OneButton, OtherButton: TControl;
begin

    OneButton := TControl(Item1);
    OtherButton := TControl(Item2);

    Result := OneButton.Left - OtherButton.Left;

end;

procedure TDocumentCardFrame.AdjustFooterButtonLayout;
var FooterButtonList: TList;

  function CreateOrderedFooterButtonListByPosition: TList;
  var I: Integer;
      FooterButtonControl: TControl;
  begin

    Result := TList.Create;

    for I := 0 to FooterButtonPanel.ControlCount - 1 do begin

      FooterButtonControl := FooterButtonPanel.Controls[I];

      if FooterButtonControl.Visible then
        Result.Add(FooterButtonControl);

    end;

    Result.Sort(FooterButtonPositionComparator);

  end;

  procedure ArrangeCorrectlyFooterButtons(FooterButtonList: TList);

  const

      OFFSET_BETWEEN_FOOTER_BUTTONS = 10;

  var I, NextFooterButtonControlPos: Integer;
      PrevFooterButtonControl, FooterButtonControl: TControl;
  begin

    if FooterButtonList.Count = 0 then
      Exit;

    PrevFooterButtonControl := nil;

    for I := 0 to FooterButtonList.Count - 1 do begin

      if not Assigned(PrevFooterButtonControl) then begin

        PrevFooterButtonControl := TControl(FooterButtonList[I]);

        PrevFooterButtonControl.Left := OFFSET_BETWEEN_FOOTER_BUTTONS;
        
      end

      else begin

        FooterButtonControl := TControl(FooterButtonList[I]);

        FooterButtonControl.Left :=
          PrevFooterButtonControl.Left +
          PrevFooterButtonControl.Width + OFFSET_BETWEEN_FOOTER_BUTTONS;

        PrevFooterButtonControl := FooterButtonControl;
        
      end;
      
    end;

  end;

begin

  FooterButtonList := nil;

  try

    FooterButtonList := CreateOrderedFooterButtonListByPosition;

    ArrangeCorrectlyFooterButtons(FooterButtonList);

  finally

    FreeAndNil(FooterButtonList);

  end;
  
end;

procedure TDocumentCardFrame.ApplyUIStyles;
begin

  inherited ApplyUIStyles;

  DocumentMainInfoLabel.Font.Style := [fsBold];
  DocumentChargesLabel.Font.Style := [fsBold];
  DocumentRelationsLabel.Font.Style := [fsBold];
  DocumentFilesLabel.Font.Style := [fsBold];
  DocumentPreviewLabel.Font.Style := [fsBold];
  
  DocumentInfoPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;
    
end;

procedure TDocumentCardFrame.ApproveDocumentButtonClick(Sender: TObject);
begin

  if Assigned(FOnDocumentApprovingRequestedEventHandler) then
    FOnDocumentApprovingRequestedEventHandler(Self);
    
end;

procedure TDocumentCardFrame.AssignDocumentApprovingsFrame(
  DocumentApprovingsFrame: TDocumentApprovingsFrame);
begin

  AssignDocumentInformationFrame(
    TDocumentCardInformationFrame(FDocumentApprovingsFrame),
    DocumentApprovingsFrame
  );

  SubscribeOnDocumentApprovingsFrameEvents;
  
end;

procedure TDocumentCardFrame.AssignDocumentFilesFrame(
  DocumentFilesFrame: TDocumentFilesFrame);
begin

  AssignDocumentInformationFrame(
    TDocumentCardInformationFrame(FDocumentFilesFrame),
    DocumentFilesFrame
  );

  DocumentFilesFrame.DocumentFilesTableForm.Width :=
    DocumentFilesFrame.Width;

  DocumentFilesFrame.DocumentFilesTableForm.Height :=
    DocumentFilesFrame.Height;
    
  SubscribeOnDocumentFilesFrameEvents;

  UpdateDocumentFilesViewFrameIfNecessary;

end;

procedure TDocumentCardFrame.AssignDocumentFilesViewFrame(
  DocumentFilesViewFrame: TDocumentFilesViewFrame);
begin

  AssignDocumentInformationFrame(
    TDocumentCardInformationFrame(FDocumentFilesViewFrame),
    DocumentFilesViewFrame
  );

//  DocumentFilesViewFrame.DocumentFileListVisible := False;

  FDocumentFilesViewFrame.OnDocumentFileShowingEventHandler :=
    OnDocumentFileShowingEventHandler;

  UpdateDocumentFilesViewFrameIfNecessary;

end;

procedure TDocumentCardFrame.AssignDocumentInformationFrame(
  var DocumentInformationFrameField: TDocumentCardInformationFrame;
  AssignableDocumentInformationFrame: TDocumentCardInformationFrame);
begin

  FreeAndSetDocumentInformationFrameReference(
    DocumentInformationFrameField,
    AssignableDocumentInformationFrame
  );

  InflateDocumentInformationFrameToPage(
    DocumentInformationFrameField
  );

  DocumentInformationFrameField.Font := Font;
  DocumentInformationFrameField.WorkingEmployeeId := WorkingEmployeeId;
  DocumentInformationFrameField.DocumentId := DocumentId;
  DocumentInformationFrameField.ServiceDocumentKind := ServiceDocumentKind;
  DocumentInformationFrameField.UIDocumentKind := UIDocumentKind;
  
  if ViewOnly then
    AssignableDocumentInformationFrame.ViewOnly := True;

end;

procedure TDocumentCardFrame.AssignDocumentMainInformationFrame(
  DocumentMainInformationFrame: TDocumentMainInformationFrame);
begin

  AssignDocumentInformationFrame(
    TDocumentCardInformationFrame(FDocumentMainInformationFrame),
    DocumentMainInformationFrame
  );

  FDocumentMainInformationFrame.OnChangedEventHandler :=
    OnDocumentMainInformationChangedEventHandler;

end;

procedure TDocumentCardFrame.AssignDocumentChargesFrame(
  DocumentChargesFrame: TDocumentChargesFrame);
begin

  AssignDocumentInformationFrame(
    TDocumentCardInformationFrame(FDocumentChargesFrame),
    DocumentChargesFrame
  );

  FDocumentChargesFrame.
    OnDocumentPerformingsChangesSavingRequestedEventHandler :=
      FOnDocumentPerformingsChangesSavingRequestedEventHandler;

  FDocumentChargesFrame.OnChangedEventHandler :=
    OnDocumentReceiversChangedEventHandler;

  FDocumentChargesFrame.SelectChargeRecordByReceiverId(WorkingEmployeeId);
  
end;

procedure TDocumentCardFrame.AssignDocumentRelationsFrame(
  DocumentRelationsFrame: TDocumentRelationsFrame);
begin

  AssignDocumentInformationFrame(
    TDocumentCardInformationFrame(FDocumentRelationsFrame),
    DocumentRelationsFrame
  );

  DocumentRelationsFrame.DocumentRelationsTableForm.Width :=
    DocumentRelationsFrame.Width;

  DocumentRelationsFrame.DocumentRelationsTableForm.Height :=
    DocumentRelationsFrame.Height;

    
  FDocumentRelationsFrame.OnChangedEventHandler :=
    OnDocumentRelationsChangedEventHandler;

  FDocumentRelationsFrame.
    OnRelatedDocumentCardOpeningRequestedEventHandler :=
      OnRelatedDocumentCardOpeningRequestedEventHandle;

end;

procedure TDocumentCardFrame.ChangeLayoutScrollnessOfDocumentMainInfoAndReceiversInfoAreasIfNecessary;
begin

  FDocumentMainInformationFrame.ChangeLayoutScrollnessIfNecassary;
  FDocumentChargesFrame.ChangeLayoutScrollnessIfNecassary;
  
end;

procedure TDocumentCardFrame.ChangeLayoutScrollnessOfDocumentRelationsInfoAndFilesInfoAreasIfNecessary;
begin

  FDocumentRelationsFrame.ChangeLayoutScrollnessIfNecassary;
  FDocumentFilesFrame.ChangeLayoutScrollnessIfNecassary;
  
end;

procedure TDocumentCardFrame.ChangeUserInterfaceKind(Value: TUserInterfaceKind);
begin

  if UserInterfaceKind <> uiUnknown then
    SaveUIControlPropertiesForCurrentUserInterfaceKind;
    
  inherited ChangeUserInterfaceKind(Value);

  RestoreUIControlPropertiesForCurrentUserInterfaceKind;

end;

procedure TDocumentCardFrame.CopyUISettings(
  DocumentInformationFrame: TDocumentFlowInformationFrame
);
var
    OtherDocumentCardFrame: TDocumentCardFrame;
begin

  OtherDocumentCardFrame := DocumentInformationFrame as TDocumentCardFrame;

  inherited ChangeUserInterfaceKind(OtherDocumentCardFrame.UserInterfaceKind);

  if Assigned(FDocumentMainInformationFrame) then begin

    FDocumentMainInformationFrame.CopyUISettings(
      OtherDocumentCardFrame.DocumentMainInformationFrame
    );

  end;

  if Assigned(FDocumentApprovingsFrame) then begin

    FDocumentApprovingsFrame.CopyUISettings(
      OtherDocumentCardFrame.DocumentApprovingsFrame
    );

  end;

  if Assigned(FDocumentChargesFrame) then begin

    FDocumentChargesFrame.CopyUISettings(
      OtherDocumentCardFrame.DocumentChargesFrame
    );

  end;

  if Assigned(FDocumentRelationsFrame) then begin
  
    FDocumentRelationsFrame.CopyUISettings(
      OtherDocumentCardFrame.DocumentRelationsFrame
    );

  end;

  if Assigned(FDocumentFilesFrame) then begin

    FDocumentFilesFrame.CopyUISettings(
      OtherDocumentCardFrame.DocumentFilesFrame
    );

  end;

  MainInformationAndReceiversFormSizeRatio :=
    OtherDocumentCardFrame.MainInformationAndReceiversFormSizeRatio;

  RelatedDocumentsAndFilesFormSizeRatio :=
    OtherDocumentCardFrame.RelatedDocumentsAndFilesFormSizeRatio;

  NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
    OtherDocumentCardFrame.NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

  OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
    OtherDocumentCardFrame.OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
    
  ActiveDocumentInfoPageNumber :=
    OtherDocumentCardFrame.ActiveDocumentInfoPageNumber;

end;

destructor TDocumentCardFrame.Destroy;
begin

  inherited Destroy;

  FreeAndNil(FViewModel);

end;

procedure TDocumentCardFrame.DocumentApprovingSheetCreatingToolActivatedHandler(
  Sender: TObject
);
var
    DocumentApprovingSheetDataCreatingService: IDocumentApprovingSheetDataCreatingAppService;
    DocumentApprovingSheetDataDto: TDocumentApprovingSheetDataDto;
    DocumentApprovingSheetViewModelMapper: TDocumentApprovingSheetViewModelMapper;
    DocumentApprovingSheetViewModel: TDocumentApprovingSheetViewModel;
    DocumentApprovingSheetPresenter: IDocumentApprovingSheetPresenter;
begin

  DocumentApprovingSheetDataDto := nil;
  DocumentApprovingSheetViewModelMapper := nil;
  DocumentApprovingSheetViewModel := nil;

  DocumentApprovingSheetDataCreatingService :=
    TApplicationServiceRegistries
      .Current
        .GetReportingServiceRegistry
          .GetDocumentApprovingSheetDataCreatingAppService(ServiceDocumentKind);

  try

    DocumentApprovingSheetDataDto :=
      DocumentApprovingSheetDataCreatingService.CreateDocumentApprovingSheetData(
        ViewModel.DocumentId
      );

    DocumentApprovingSheetViewModelMapper :=
      TDocumentApprovingSheetViewModelMapperFactories
        .GetDocumentApprovingSheetViewModelMapperFactory(UIDocumentKind)
          .CreateDocumentApprovingSheetViewModelMapper;

    DocumentApprovingSheetViewModel :=
      DocumentApprovingSheetViewModelMapper.MapDocumentApprovingSheetViewModelFrom(
        DocumentApprovingSheetDataDto
      );

    DocumentApprovingSheetPresenter :=
      TDocumentReportPresenterRegistry
        .Current
          .GetDocumentApprovingSheetPresenter(UIDocumentKind);

    DocumentApprovingSheetPresenter.PresentDocumentApprovingSheet(
      DocumentApprovingSheetViewModel
    );

  finally

    FreeAndNil(DocumentApprovingSheetDataDto);
    FreeAndNil(DocumentApprovingSheetViewModelMapper);
    FreeAndNil(DocumentApprovingSheetViewModel);

  end;

end;

procedure TDocumentCardFrame.DocumentCardPageControlChange(Sender: TObject);
var
    SplitterThickness: Integer;
begin

  inherited;

  case UserInterfaceKind of

    uiOld: LastSelectedOldUIDocumentCardSheetIndex := DocumentCardPageControl.ActivePageIndex;

    uiNew: LastSelectedNewUIDocumentCardSheetIndex := DocumentCardPageControl.ActivePageIndex;

  end;

  UpdateDocumentFilesViewFrameIfNecessary;

  DocumentCardPageControl.ActivePage.Show;
  
end;

procedure TDocumentCardFrame.DocumentCardPageControlDrawTab(
  Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var Canvas: TCanvas;
    TabCaptionX, TabCaptionY: Integer;
    TabCaption: String;
begin

  Canvas := DocumentCardPageControl.Canvas;

  if Active then
    Canvas.Brush.Color := TDocumentFlowCommonControlStyles.GetActivePageControlTabColor

  else Canvas.Brush.Color := TDocumentFlowCommonControlStyles.GetPageControlTabColor;

  Canvas.FillRect(Rect);

  TabCaption := DocumentCardPageControl.Pages[TabIndex].Caption;

  TabCaptionX := (Rect.Right - Rect.Left - Canvas.TextWidth(TabCaption)) div 2;
  TabCaptionY := (Rect.Bottom - Rect.Top - Canvas.TextHeight(TabCaption)) div 2;

  Canvas.TextRect(
    Rect, Rect.Left + TabCaptionX, Rect.Top + TabCaptionY, TabCaption
  );

end;

procedure TDocumentCardFrame.DocumentPrintFormButtonClick(Sender: TObject);
begin

  if Assigned(FOnDocumentPrintFormRequestedEventHandler) then begin
  
    FOnDocumentPrintFormRequestedEventHandler(
      Self, ViewModel
    );

  end;

end;

procedure TDocumentCardFrame.DocumentRelationsAndFilesPageShow(Sender: TObject);
begin

  //PartitionSpaceEvenlyBetweenDocumentRelationsInfoAndFilesInfoAreas;
  
end;

procedure TDocumentCardFrame.FrameResize(Sender: TObject);
begin

  inherited;

  UpdateDocumentPageFormSizesByCurrentRatios;
  //PartitionSpaceEvenlyBetweenDocumentInfoAreas;

end;

procedure TDocumentCardFrame.FreeAndSetDocumentInformationFrameReference(
  var DocumentInformationFrameField: TDocumentCardInformationFrame;
  AssignableDocumentInformationFrame: TDocumentCardInformationFrame);
begin

  FreeAndNil(DocumentInformationFrameField);

  DocumentInformationFrameField := AssignableDocumentInformationFrame;

end;

function TDocumentCardFrame.GetOnDocumentApprovingChangingRequestedEventHandler: TOnDocumentApprovingChangingRequestedEventHandler;
begin

  Result := FOnDocumentApprovingChangingRequestedEventHandler;
  
end;

function TDocumentCardFrame.GetOnDocumentApprovingCompletingRequestedEventHandler: TOnDocumentApprovingCompletingRequestedEventHandler;
begin

  Result := FOnDocumentApprovingCompletingRequestedEventHandler;
  
end;

function TDocumentCardFrame.GetOnDocumentApprovingCycleRemovingRequestedEventHandler: TOnDocumentApprovingCycleRemovingRequestedEventHandler;
begin

  Result := FOnDocumentApprovingCycleRemovingRequestedEventHandler;
  
end;

function TDocumentCardFrame.GetOnDocumentApprovingCycleSelectedEventHandler: TOnDocumentApprovingCycleSelectedEventHandler;
begin

  Result := FOnDocumentApprovingCycleSelectedEventHandler;
  
end;

function TDocumentCardFrame.GetOnDocumentApprovingsRemovingRequestedEventHandler: TOnDocumentApprovingsRemovingRequestedEventHandler;
begin

  Result := FOnDocumentApprovingsRemovingRequestedEventHandler;
  
end;

function TDocumentCardFrame.GetOnEmployeeReferenceForApprovingRequestedEventHandler: TOnEmployeeReferenceForApprovingRequestedEventHandler;
begin

  Result := FOnEmployeeReferenceForApprovingRequestedEventHandler;
  
end;

function TDocumentCardFrame.GetOnEmployeesAddingForApprovingRequestedEventHandler: TOnEmployeesAddingForApprovingRequestedEventHandler;
begin

  Result := FOnEmployeesAddingForApprovingRequestedEventHandler;
  
end;

function TDocumentCardFrame.GetOnNewDocumentApprovingCycleCreatingRequestedEventHandler: TOnNewDocumentApprovingCycleCreatingRequestedEventHandler;
begin

  Result := FOnNewDocumentApprovingCycleCreatingRequestedEventHandler;
  
end;

function TDocumentCardFrame.
  GetOnRelatedDocumentSelectionFormRequestedEventHandler:
    TOnDocumentSelectionFormRequestedEventHandler;
begin

  if Assigned(FDocumentRelationsFrame) then
    Result :=
      FDocumentRelationsFrame.OnDocumentSelectionRequestedFormEventHandler

  else Result := nil;
  
end;

function TDocumentCardFrame.GetSaveDocumentSheetAreasSizeRatiosOnResize: Boolean;
begin

  Result :=
    SaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize
    and SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize;

end;

function TDocumentCardFrame.GetSigningDocumentSendingTool: TButton;
begin

  if not Assigned(FDocumentOperationToolBarFrame) then
    Result := nil

  else
    Result := FDocumentOperationToolBarFrame.GetSigningDocumentSendingTool;

end;

function TDocumentCardFrame.GetOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
begin
  Result := FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
end;

function TDocumentCardFrame.GetMainInformationAndReceiversFormSizeRatio: Double;
begin

  Result := FMainInformationAndReceiversFormSizeRatio;

end;

function TDocumentCardFrame.GetActiveDocumentInfoPageNumber: Integer;
begin

  DebugOutput(DocumentCardPageControl.ActivePage.Caption);
  
  Result := DocumentCardPageControl.ActivePageIndex;
  
end;

function TDocumentCardFrame.GetActiveDocumentInformationPage: TTabSheet;
var ActivePageNumber: Integer;
    ActivePage: TTabSheet;
begin

  ActivePageNumber := GetActiveDocumentInfoPageNumber;
  
  Result := DocumentCardPageControl.Pages[ActivePageNumber];

end;

function TDocumentCardFrame.GetApprovingDocumentSendingTool: TButton;
begin

  if not Assigned(FDocumentOperationToolBarFrame) then
    Result := nil

  else
    Result := FDocumentOperationToolBarFrame.GetApprovingDocumentSendingTool;

end;

function TDocumentCardFrame.GetAreaForDocumentInformationFrame(
  DocumentInformationFrame: TDocumentCardInformationFrame): TWinControl;
begin

  if DocumentInformationFrame is TDocumentMainInformationFrame then
    Result := DocumentMainInfoFormArea

  else if DocumentInformationFrame is TDocumentChargesFrame then
    Result := DocumentChargesFormArea

  else if DocumentInformationFrame is TDocumentRelationsFrame then
    Result := DocumentRelationsFormArea

  else if DocumentInformationFrame is TDocumentFilesFrame then
    Result := DocumentFilesFormArea

  else if DocumentInformationFrame is TDocumentApprovingsFrame then
    Result := DocumentApprovingsPagePanel

  else if DocumentInformationFrame is TDocumentFilesViewFrame then
    Result := DocumentFilesViewFormPanel
    
  else raise Exception.CreateFmt(
              'Document Information Frame''s type [%s] not found',
              [DocumentInformationFrame.ClassName]
             );

end;


function TDocumentCardFrame.GetDocumentMainInformationPageNumber: Integer;
begin

  case UserInterfaceKind of

    uiOld: Result := DocumentMainInfoAndReceiversPage.PageIndex;
    uiNew: Result := DocumentMainInfoPage.PageIndex;
    uiUnknown: Result := 0;

  end;

end;

function TDocumentCardFrame.GetDocumentSigningMarkingTool: TButton;
begin

  if not Assigned(FDocumentOperationToolBarFrame) then
    Result := nil

  else Result := FDocumentOperationToolBarFrame.GetDocumentSigningMarkingTool;

end;

function TDocumentCardFrame.GetDocumentSigningRejectingTool: TButton;
begin

  if not Assigned(FDocumentOperationToolBarFrame) then
    Result := nil

  else Result := FDocumentOperationToolBarFrame.GetDocumentSigningRejectingTool;
  
end;

function TDocumentCardFrame.GetDocumentSigningTool: TButton;
begin

  if not Assigned(FDocumentOperationToolBarFrame) then
    Result := nil

  else Result := FDocumentOperationToolBarFrame.GetDocumentSigningTool;

end;
        {
function TDocumentCardFrame.
  GetEnableEvenlySpacePartitionBetweenDocumentInformationAreas: Boolean;
begin

  Result := EnableEvenlySpacePartitionBetweenRelationsAndFilesAreas and
            EnableEvenlySpacePartitionBetweenMainInfoAndChargesAreas;

end;     }

function TDocumentCardFrame.GetRelatedDocumentsAndFilesFormSizeRatio: Double;
begin

  Result := FRelatedDocumentsAndFilesFormSizeRatio;

end;

procedure TDocumentCardFrame.SaveDocumentCardButtonClick(Sender: TObject);
begin

  SaveData;

end;

procedure TDocumentCardFrame.SaveNestedFramesUIProperties;
begin

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.SaveUIControlProperties;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.SaveUIControlProperties;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.SaveUIControlProperties;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.SaveUIControlProperties;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.SaveUIControlProperties;
    
end;

function TDocumentCardFrame.SaveData: TDocumentCardFrameSavingResult;
begin

  if not IsDataChanged then begin

    ShowInfoMessage(
      Self.Handle,
      'Изменений, внесенных в карточку ' +
      'документа, обнаружено не было',
      'Сообщение'
    );

    Result := srChangesAbsent;
    
    Exit;

  end;

  if Assigned(FOnDocumentInfoSavingRequestedEventHandler) then begin

    if ValidateInput then begin

      try

        FOnDocumentInfoSavingRequestedEventHandler(Self);

        OnChangesApplied;

        Result := srChangesApplied;
        
      except

        on e: Exception do begin

          raise;

        end;

      end;

    end

    else begin
    
      ShowWarningMessage(
        Self.Handle,
        'Не все требуемые поля заполнены корректно',
        'Внимание'
      );

      Result := srNotValidData;

    end;

  end;
  
end;

procedure TDocumentCardFrame.SaveUIControlProperties;
begin

  inherited SaveUIControlProperties;

end;

procedure TDocumentCardFrame.SaveUIControlPropertiesForCurrentUserInterfaceKind;
var
    PropertiesStorage: IDocumentFlowInformationFramePropertiesStorage;
begin

  if not SaveUIControlPropertiesEnabled then Exit;

  PropertiesStorage :=
    IDocumentFlowInformationFramePropertiesStorage(
      AsInterfaceOrException(
        TApplicationPropertiesStorageRegistry
          .Current
            .GetPropertiesStorageForObjectClass(ClassType),
        IDocumentFlowInformationFramePropertiesStorage,
        'DocumentFlowInformationFramePropertiesStorage interface not found'
      )
    );

  if not Assigned(PropertiesStorage) then Exit;

  PropertiesStorage.SaveFramePropertiesForUserInterfaceKind(
    Self, UserInterfaceKind
  );

end;

procedure TDocumentCardFrame.SaveWithNestedFramesUIProperties;
begin

  SaveUIControlProperties;
  SaveNestedFramesUIProperties;
  
end;

procedure TDocumentCardFrame.RestoreUIControlPropertiesForCurrentUserInterfaceKind;
var
    PropertiesStorage: IDocumentFlowInformationFramePropertiesStorage;
begin

  if not RestoreUIControlPropertiesEnabled then Exit;

  PropertiesStorage :=
    IDocumentFlowInformationFramePropertiesStorage(
      AsInterfaceOrException(
        TApplicationPropertiesStorageRegistry
          .Current
            .GetPropertiesStorageForObjectClass(ClassType),
        IDocumentFlowInformationFramePropertiesStorage,
        'DocumentFlowInformationFramePropertiesStorage interface not found'
      )
    );

  if not Assigned(PropertiesStorage) then Exit;

  PropertiesStorage.RestoreFramePropertiesForUserInterfaceKind(
    Self, UserInterfaceKind
  );
  
end;

procedure TDocumentCardFrame.RestoreWithNestedFramesUIProperties;
begin

  RestoreUIControlProperties;
  RestoreNestedFramesUIProperties;
  
end;

procedure TDocumentCardFrame.SetActiveDocumentInfoPageNumber(
  const Value: Integer);
var
    PreviousActivePageIndex: Integer;
begin

  PreviousActivePageIndex := DocumentCardPageControl.ActivePageIndex;

  DocumentCardPageControl.ActivePageIndex := VarIfThen(Value >= 0, Value, 0);

  if PreviousActivePageIndex <> Value then
    DocumentCardPageControl.OnChange(DocumentCardPageControl);

end;

procedure TDocumentCardFrame.SetEnabled(Value: Boolean);
begin

  DocumentCardPageControl.Enabled := True;

  FDocumentMainInformationFrame.Enabled := Value;
  FDocumentFilesFrame.Enabled := Value;
  FDocumentRelationsFrame.Enabled := Value;
  FDocumentChargesFrame.Enabled := Value;

end;
                          {
procedure TDocumentCardFrame.
  SetEnableEvenlySpacePartitionBetweenDocumentInformationAreas(
    const Value: Boolean
  );
begin

  EnableEvenlySpacePartitionBetweenRelationsAndFilesAreas := Value;
  EnableEvenlySpacePartitionBetweenMainInfoAndChargesAreas := Value;

end;                              }

procedure TDocumentCardFrame.SetFont(const Value: TFont);
begin

  inherited;

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.Font := Value;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.Font := Value;
    
  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.Font := Value;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.Font := Value;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.Font := Value;

  if Assigned(FDocumentFilesViewFrame) then
    FDocumentFilesViewFrame.Font := Value;

end;

procedure TDocumentCardFrame.SetFooterButtonPanelVisible(
  const Visible: Boolean
);
var DocumentOperationTool: TButton;
    I: Integer;
begin

  if not Assigned(FDocumentOperationToolBarFrame) then Exit;

  for I := 0 to FDocumentOperationToolBarFrame.ToolCount - 1 do begin

    DocumentOperationTool := FDocumentOperationToolBarFrame.Tools[I];

    if DocumentOperationTool.Caption = 'Печатная форма' then
      Continue;

    DocumentOperationTool.Visible := Visible;
    
  end;

end;

procedure TDocumentCardFrame.SetLastSelectedNewUIDocumentCardSheetIndex(
  const Value: Integer);
begin

  FLastSelectedNewUIDocumentCardSheetIndex := Value;

end;

procedure TDocumentCardFrame.SetRelatedDocumentsAndFilesFormSizeRatio(
  const Ratio: Double);
begin

  FRelatedDocumentsAndFilesFormSizeRatio := VarIfThen(Ratio > 0, Ratio, 1);

  UpdateRelatedDocumentsAndFilesFormSizesByRatio(FRelatedDocumentsAndFilesFormSizeRatio);

end;

procedure TDocumentCardFrame.SetOnDocumentApprovingChangingRequestedEventHandler(
  const Value: TOnDocumentApprovingChangingRequestedEventHandler);
begin

  FOnDocumentApprovingChangingRequestedEventHandler := Value;
  
end;

procedure TDocumentCardFrame.SetOnDocumentApprovingCompletingRequestedEventHandler(
  const Value: TOnDocumentApprovingCompletingRequestedEventHandler);
begin

  FOnDocumentApprovingCompletingRequestedEventHandler := Value;
  
end;

procedure TDocumentCardFrame.SetOnDocumentApprovingCycleRemovingRequestedEventHandler(
  const Value: TOnDocumentApprovingCycleRemovingRequestedEventHandler);
begin

  FOnDocumentApprovingCycleRemovingRequestedEventHandler := Value;
  
end;

procedure TDocumentCardFrame.SetOnDocumentApprovingCycleSelectedEventHandler(
  const Value: TOnDocumentApprovingCycleSelectedEventHandler);
begin

  FOnDocumentApprovingCycleSelectedEventHandler := Value;
      
end;

procedure TDocumentCardFrame.SetOnDocumentApprovingsRemovingRequestedEventHandler(
  const Value: TOnDocumentApprovingsRemovingRequestedEventHandler);
begin

  FOnDocumentApprovingsRemovingRequestedEventHandler := Value;
  
end;

procedure TDocumentCardFrame.SetOnDocumentFileOpeningRequestedEventHandler(
  const Value: TOnDocumentFileOpeningRequestedEventHandler);
var ActiveDocumentInfoPage: TTabSheet;
begin

  FOnDocumentFileOpeningRequestedEventHandler := Value;

  ActiveDocumentInfoPage := GetActiveDocumentInformationPage;

  if ActiveDocumentInfoPage = DocumentPreviewPage then begin

    if Assigned(FDocumentFilesViewFrame) then begin

      FDocumentFilesViewFrame.
        SynchronizeUIWithCurrentDocumentFileInfoIfNecessary;

    end;

  end;

end;

procedure TDocumentCardFrame.SetOnDocumentPerformingsChangesSavingRequestedEventHandler(
  OnDocumentPerformingsChangesSavingRequestedEventHandler: TOnDocumentPerformingsChangesSavingRequestedEventHandler);
begin

  FDocumentChargesFrame.
    OnDocumentPerformingsChangesSavingRequestedEventHandler :=
      OnDocumentPerformingsChangesSavingRequestedEventHandler;
    
end;

procedure TDocumentCardFrame.SetOnEmployeeReferenceForApprovingRequestedEventHandler(
  const Value: TOnEmployeeReferenceForApprovingRequestedEventHandler);
begin

  FOnEmployeeReferenceForApprovingRequestedEventHandler := Value;
  
end;

procedure TDocumentCardFrame.SetOnEmployeesAddingForApprovingRequestedEventHandler(
  const Value: TOnEmployeesAddingForApprovingRequestedEventHandler);
begin

  FOnEmployeesAddingForApprovingRequestedEventHandler := Value;
    
end;

procedure TDocumentCardFrame.SetOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
  const Value: TOnNewDocumentApprovingCycleCreatingRequestedEventHandler);
begin


  FOnNewDocumentApprovingCycleCreatingRequestedEventHandler := Value;

end;

procedure TDocumentCardFrame.SetOnRelatedDocumentSelectionFormRequestedEventHandler(
  const Value: TOnDocumentSelectionFormRequestedEventHandler);
begin

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.OnDocumentSelectionRequestedFormEventHandler :=
      Value;
  
end;

procedure TDocumentCardFrame.SetDocumentOperationToolBarFrame(
  Value: TDocumentOperationToolBarFrame);
begin

  FreeAndNil(FDocumentOperationToolBarFrame);

  FDocumentOperationToolBarFrame := Value;

  SubscribeOnDocumentOperationToolBarFrameEvents(Value);
  InflateDocumentOperationToolBarFrame(FDocumentOperationToolBarFrame);
  
end;

function TDocumentCardFrame.GetDocumentId: Variant;
begin

  if Assigned(FViewModel) then
    Result := FViewModel.DocumentId

  else Result := Null;
  
end;

procedure TDocumentCardFrame.SetDocumentId(const Value: Variant);
begin

end;

procedure TDocumentCardFrame.SetSaveDocumentSheetAreasSizeRatiosOnResize(
  const Value: Boolean);
begin

  SaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize := Value;
  SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize := Value;

end;

procedure TDocumentCardFrame.SetServiceDocumentKind(
  const Value: TDocumentKindClass);
begin

  inherited SetServiceDocumentKind(Value);

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.ServiceDocumentKind := ServiceDocumentKind;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.ServiceDocumentKind := ServiceDocumentKind;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.ServiceDocumentKind := ServiceDocumentKind;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.ServiceDocumentKind := ServiceDocumentKind;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.ServiceDocumentKind := ServiceDocumentKind;
    
end;

procedure TDocumentCardFrame.SetUIDocumentKind(
  const Value: TUIDocumentKindClass);
begin

  inherited SetUIDocumentKind(Value);

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.UIDocumentKind := Value;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.UIDocumentKind := Value;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.UIDocumentKind := Value;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.UIDocumentKind := Value;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.UIDocumentKind := Value;

end;

procedure TDocumentCardFrame.SetOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio(
  const Value: Double);
begin
  FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
    VarIfThen(Value > 0, Value, 0.5);

  UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(
    FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
  );

end;

procedure TDocumentCardFrame.SetMainInformationAndReceiversFormSizeRatio(
  const Ratio: Double
);
begin

  FMainInformationAndReceiversFormSizeRatio := Ratio;

  UpdateMainInformationAndReceiversFormSizesByRatio(FMainInformationAndReceiversFormSizeRatio);
  
end;

procedure TDocumentCardFrame.
  SetNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio(const Value: Double);
begin

  FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
    VarIfThen(Value > 0, Value, 0.5);

  UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(
    FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
  );

end;

function TDocumentCardFrame.GetViewModel: TDocumentCardFormViewModel;
begin

  Result := FViewModel;

  { refactor: perhaps it may be removed due to FInitialViewModel }

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.ViewModel;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.ViewModel;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.ViewModel;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.ViewModel;

end;

function TDocumentCardFrame.GetViewOnly: Boolean;
begin

  Result := FViewOnly;
  
end;

procedure TDocumentCardFrame.HandleDocumentMarkingAsSignedEvent(
  Sender: TObject);
begin

  if Assigned(FOnDocumentSigningMarkingRequestedEventHandler) then begin

    FOnDocumentSigningMarkingRequestedEventHandler(
      Self,
      TExtendedDocumentMainInformationFrame(DocumentMainInformationFrame).DocumentDateTimePicker.DateTime
    );
    
  end;

end;

procedure TDocumentCardFrame.HideFooterButtonPanel;
begin

  FooterButtonPanel.Visible := False;
  
end;

procedure TDocumentCardFrame.SetViewModel(ViewModel: TDocumentCardFormViewModel);
begin

  if not Assigned(ViewModel) then Exit;
  
  FreeAndNil(FViewModel);

  FViewModel := ViewModel;

  if
    Assigned(FDocumentApprovingsFrame) 
  then begin

    FDocumentApprovingsFrame.DocumentId := FViewModel.DocumentId;
    
    FDocumentApprovingsFrame.ViewModel :=
      ViewModel.DocumentApprovingsFormViewModel;

  end;

  if
    Assigned(FDocumentMainInformationFrame)
  then begin

    FDocumentMainInformationFrame.DocumentId := FViewModel.DocumentId;
    
    FDocumentMainInformationFrame.ViewModel :=
      ViewModel.DocumentMainInformationFormViewModel;

  end;

  if
    Assigned(FDocumentFilesFrame)
  then begin

    FDocumentFilesFrame.DocumentId := FViewModel.DocumentId;
    
    FDocumentFilesFrame.ViewModel :=
      ViewModel.DocumentFilesFormViewModel;

  end;

  if
    Assigned(FDocumentRelationsFrame)
  then begin

    FDocumentRelationsFrame.DocumentId := FViewModel.DocumentId;
    
    FDocumentRelationsFrame.ViewModel :=
      ViewModel.DocumentRelationsFormViewModel;

  end;          

  if
    Assigned(FDocumentChargesFrame)
  then begin

    FDocumentChargesFrame.DocumentId := FViewModel.DocumentId;
    
    FDocumentChargesFrame.ViewModel :=
      ViewModel.DocumentChargesFormViewModel;

    FDocumentChargesFrame.SelectChargeRecordByReceiverId(
      WorkingEmployeeId
    );
    
  end;

  if Assigned(FDocumentFilesViewFrame) then begin

    FDocumentFilesViewFrame.DocumentId := FViewModel.DocumentId;

    FDocumentFilesViewFrame.SetDocumentFileInfoList(
      ViewModel.DocumentFilesViewFormViewModel.DocumentFileInfoList
    );

    UpdateDocumentFilesViewFrameIfNecessary;

  end;
    
end;

procedure TDocumentCardFrame.SetViewOnly(const Value: Boolean);
begin
                      
  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.ViewOnly := Value;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.ViewOnly := Value;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.ViewOnly := Value;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.ViewOnly := Value;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.ViewOnly := Value;

  SetFooterButtonPanelVisible(not Value);

  FViewOnly := True;

end;

procedure TDocumentCardFrame.SetWorkingEmployeeId(const Id: Variant);
begin

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.WorkingEmployeeId := Id;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.WorkingEmployeeId := Id;
    
  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.WorkingEmployeeId := Id;

  if Assigned(FDocumentChargesFrame) then begin

    FDocumentChargesFrame.WorkingEmployeeId := Id;

    FDocumentChargesFrame.SelectChargeRecordByReceiverId(Id);

  end;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.WorkingEmployeeId := id;

end;

function TDocumentCardFrame
  .GetNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
begin

  Result := FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

end;

function TDocumentCardFrame.GetNotApprovingReasonFromInputForm: String;
begin

  with TNotDocumentApprovingReasonInputForm.Create(nil) do begin

    try

      if ShowModal = mrOk then
        Result := InputText

      else Result := '';
      
    finally

      Free;
      
    end;

  end;

end;

procedure TDocumentCardFrame.
  RaiseExceptionIfMoreThanOnAccessibleDocumentApprovingsFound(
    DocumentApprovings: TDocumentApprovingsViewModel
  );
begin

  if DocumentApprovings.Count > 1 then begin

    raise Exception.Create(
      'Обнаружено более одного доступного ' +
      'согласования. На данный момент ' +
      'возможность множественного ' +
      'согласования в рамках одного цикла ' +
      'не поддерживается. Обратитесь к ' +
      'администратору.'
    );

  end;

end;

procedure TDocumentCardFrame.RaiseOnDocumentApprovingRejectingRequestedEventHandler;
begin

  if Assigned(FOnDocumentApprovingRejectingRequestedEventHandler) then
    FOnDocumentApprovingRejectingRequestedEventHandler(Self);

end;

procedure TDocumentCardFrame.SignDocumentButtonClick(Sender: TObject);
begin

  if Assigned(FOnDocumentSigningRequestedEventHandler) then
    FOnDocumentSigningRequestedEventHandler(Self);

end;

procedure TDocumentCardFrame.RejectDocumentButtonClick(
  Sender: TObject);
begin

  if Assigned(FOnDocumentRejectingFromSigningRequestedEventHandler) then
    FOnDocumentRejectingFromSigningRequestedEventHandler(Self);

end;

procedure TDocumentCardFrame.RelatedDocumentsAndFilesVerticalSplitterMoved(
  Sender: TObject);
begin

  UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
  UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
  ChangeLayoutScrollnessOfDocumentRelationsInfoAndFilesInfoAreasIfNecessary;

end;

procedure TDocumentCardFrame.SplitterBetweenMainInfoAndReceiversAreasMoved(
  Sender: TObject);
begin

  UpdateMainInformationAndReceiversFormSizeRatio;
  ChangeLayoutScrollnessOfDocumentMainInfoAndReceiversInfoAreasIfNecessary;
  
end;

procedure TDocumentCardFrame.SplitterBetweenRelationsAndFilesAreasCanResize(
  Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin

  inherited;

{  Accept := NewSize = TDocumentFlowCommonControlStyles.GetSplitterThickness      }

end;

procedure TDocumentCardFrame.SplitterBetweenRelationsAndFilesAreasMoved(
  Sender: TObject);
begin

  UpdateRelatedDocumentsAndFilesFormSizeRatio;
  ChangeLayoutScrollnessOfDocumentRelationsInfoAndFilesInfoAreasIfNecessary;
  
end;

procedure TDocumentCardFrame.SubscribeOnDocumentApprovingsFrameEvents;
begin

  FDocumentApprovingsFrame.OnChangedEventHandler :=
    OnDocumentApprovingsChangedEventHandler;

  FDocumentApprovingsFrame.
    OnDocumentApprovingChangingRequestedEventHandler :=
      OnDocumentApprovingChangingRequestedEventHandle;

  FDocumentApprovingsFrame.
    OnDocumentApprovingsRemovingRequestedEventHandler :=
      OnDocumentApprovingsRemovingRequestedEventHandle;

  FDocumentApprovingsFrame.
    OnEmployeesAddingForApprovingRequestedEventHandler :=
      OnEmployeesAddingForApprovingRequestedEventHandle;

  FDocumentApprovingsFrame.
    OnDocumentApprovingCycleRemovingRequestedEventHandler :=
      OnDocumentApprovingCycleRemovingRequestedEventHandle;

  FDocumentApprovingsFrame.OnDocumentApprovingCycleRemovedEventHandler :=
    OnDocumentApprovingCycleRemovedEventHandle;

  FDocumentApprovingsFrame.
    OnDocumentApprovingCompletingRequestedEventHandler :=
      OnDocumentApprovingCompletingRequestedEventHandle;

  FDocumentApprovingsFrame.
    OnNewDocumentApprovingCycleCreatingRequestedEventHandler :=
      OnNewDocumentApprovingCycleCreatingRequestedEventHandle;

  FDocumentApprovingsFrame.
    OnDocumentApprovingCycleSelectedEventHandler :=
      OnDocumentApprovingCycleSelectedEventHandle;

  FDocumentApprovingsFrame.OnEmployeesAddedForApprovingEventHandler :=
    OnEmployeesAddedForApprovingEventHandle;

  FDocumentApprovingsFrame.OnDocumentApprovingsRemovedEventHandler :=
    OnDocumentApprovingsRemovedEventHandle;
    
end;

procedure TDocumentCardFrame.SubscribeOnDocumentFilesFrameEvents;
begin

  FDocumentFilesFrame.OnDocumentFileAddedEventHandler :=
    OnDocumentFileAddedEventHandler;

  FDocumentFilesFrame.OnDocumentFileRemovedEventHandler :=
    OnDocumentFileRemovedEventHandler;

  FDocumentFilesFrame.OnDocumentFileSelectedEventHandler :=
    OnDocumentFileSelectedEventHandler;

  FDocumentFilesFrame.OnExistingDocumentFileOpeningRequestedEventHandler :=
    OnExistingDocumentFileOpeningRequestedEventHandler;
    
end;

procedure TDocumentCardFrame.SubscribeOnDocumentOperationToolBarFrameEvents(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame
);
var DocumentOperationTool: TButton;
begin

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentSavingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := SaveDocumentCardButtonClick;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentPrintFormCreatingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := DocumentPrintFormButtonClick;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentApprovingSheetCreatingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := DocumentApprovingSheetCreatingToolActivatedHandler;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetSigningDocumentSendingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := SendToSigningButtonClick;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentSigningTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := SignDocumentButtonClick;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentSigningRejectingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := RejectDocumentButtonClick;
    
  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetApprovingDocumentSendingTool;

  if Assigned(DocumentOperationTool) then begin

    DocumentOperationTool.OnClick := SendToApprovingButtonClick;

    DocumentOperationTool.Enabled := False;
    
  end;

  DocumentOperationTool := DocumentOperationToolBarFrame.GetDocumentSigningMarkingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := HandleDocumentMarkingAsSignedEvent;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentPerformingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := PerformDocumentButtonClick;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentApprovingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := ApproveDocumentButtonClick;

  DocumentOperationTool :=
    DocumentOperationToolBarFrame.GetDocumentNotApprovingTool;

  if Assigned(DocumentOperationTool) then
    DocumentOperationTool.OnClick := NoApproveDocumentButtonClick;
    
end;

procedure TDocumentCardFrame.SwitchUserInterfaceTo(Value: TUserInterfaceKind);
var
    IsNewUISwitched: Boolean;
begin

  inherited SwitchUserInterfaceTo(Value);

  IsNewUISwitched := Value = uiNew;

  DocumentMainInfoPage.TabVisible := IsNewUISwitched;
  DocumentChargesPage.TabVisible := IsNewUISwitched;

  DocumentMainInfoAndReceiversPage.TabVisible := not IsNewUISwitched;
//  DocumentPreviewPage.TabVisible := not IsNewUISwitched;

//  RelatedDocumentsAndFilesVerticalSplitter.Visible := IsNewUISwitched;
//  DocumentFilesViewArea.Visible := IsNewUISwitched;

{  if Assigned(DocumentFilesViewFrame) then
    DocumentFilesViewFrame.DocumentFileListVisible := not IsNewUISwitched;     }

  if Assigned(DocumentFilesViewFrame) then begin

    DocumentFilesFrame.OnDocumentFileSelectedEventHandler :=
      OnDocumentFileSelectedEventHandler;

  end;

  { refactor: UIKind-based customization logic extract to separete UICustomizers }

  case Value of

    uiOld:
    begin

      DocumentChargesFormArea.Parent := DocumentChargesInfoArea;
      DocumentMainInfoFormArea.Parent := DocumentMainInfoArea;
      
{      DocumentFilesViewFormPanel.Parent := DocumentPreviewPage;
      DocumentFilesViewFormPanel.Align := alClient;     }
      
      DocumentMainInfoAndReceiversPage.PageIndex := 0;

      DocumentChargesPage.PageIndex := DocumentCardPageControl.PageCount - 1;
      DocumentMainInfoPage.PageIndex := DocumentCardPageControl.PageCount - 1;

{      DocumentRelationsInfoArea.Align := alNone;
      SplitterBetweenRelationsAndFilesAreas.Align := alNone;
      DocumentFilesInfoArea.Align := alNone;

      RelatedDocumentsAndFilesPanel.Align := alNone;
      RelatedDocumentsAndFilesVerticalSplitter.Align := alNone;
      DocumentFilesViewArea.Align := alNone;

      RelatedDocumentsAndFilesPanel.Align := alClient;

      DocumentRelationsInfoArea.Align := alLeft;
      SplitterBetweenRelationsAndFilesAreas.Align := alLeft;
      DocumentFilesInfoArea.Align := alClient;     }

      ActiveDocumentInfoPageNumber := LastSelectedOldUIDocumentCardSheetIndex;

{      if Assigned(DocumentFilesViewFrame) then
        DocumentFilesFrame.OnDocumentFileSelectedEventHandler := nil;     }

    end;

    uiNew:
    begin

      DocumentChargesFormArea.Parent := DocumentChargesPage;
      DocumentMainInfoFormArea.Parent := DocumentMainInfoPage;

{      DocumentFilesViewFormPanel.Parent := DocumentFilesViewArea;
      DocumentFilesViewFormPanel.Align := alClient;
      DocumentFilesViewFormPanel.BevelKind := bkNone;

      RelatedDocumentsAndFilesPanel.Align := alNone;
      RelatedDocumentsAndFilesVerticalSplitter.Align := alNone;
      DocumentFilesViewArea.Align := alNone;

      RelatedDocumentsAndFilesPanel.Align := alLeft;
      RelatedDocumentsAndFilesVerticalSplitter.Align := alLeft;
      DocumentFilesViewArea.Align := alClient;    }

      DocumentChargesPage.PageIndex := 0;
      DocumentMainInfoPage.PageIndex := 1;

      DocumentMainInfoAndReceiversPage.PageIndex :=
        DocumentCardPageControl.PageCount - 1;

{      DocumentRelationsInfoArea.Align := alNone;
      SplitterBetweenRelationsAndFilesAreas.Align := alNone;
      DocumentFilesInfoArea.Align := alNone;

      RelatedDocumentsAndFilesVerticalSplitter.Width :=
        TDocumentFlowCommonControlStyles.GetSplitterThickness;

      DocumentFilesViewFormPanel.BevelKind := bkFlat;

      SplitterBetweenRelationsAndFilesAreas.Top := 10;
      SplitterBetweenRelationsAndFilesAreas.Height :=
        TDocumentFlowCommonControlStyles.GetSplitterThickness;

      DocumentRelationsInfoArea.Align := alTop;
      SplitterBetweenRelationsAndFilesAreas.Align := alTop;
      DocumentFilesInfoArea.Align := alClient;     }

      ActiveDocumentInfoPageNumber := LastSelectedNewUIDocumentCardSheetIndex;

{      if Assigned(DocumentFilesViewFrame) then begin

        DocumentFilesFrame.OnDocumentFileSelectedEventHandler :=
          OnDocumentFileSelectedEventHandler;

      end;   }

    end;

  end;

end;

procedure TDocumentCardFrame.SendToApprovingButtonClick(Sender: TObject);
begin

  if Assigned(FOnApprovingDocumentSendingRequestedEventHandler) then
    FOnApprovingDocumentSendingRequestedEventHandler(Self);
    
end;

procedure TDocumentCardFrame.SendToSigningButtonClick(
  Sender: TObject);
begin

  if Assigned(FOnDocumentSendingToSigningRequestedEventHandler) then begin

    FOnDocumentSendingToSigningRequestedEventHandler(Self);

  end;

end;

procedure TDocumentCardFrame.UpdateDocumentFilesViewFrameIfNecessary;
var
    CurrentDocumentFileInfo: TDocumentFileInfo;
begin

  if not Assigned(FDocumentFilesViewFrame) then Exit;
  
  if
    ((UserInterfaceKind = uiOld)
    and
    (DocumentCardPageControl.ActivePage = DocumentPreviewPage))

    or(
      (UserInterfaceKind = uiNew)
      and
      (DocumentCardPageControl.ActivePage = DocumentRelationsAndFilesPage)
    )
  then begin

    CurrentDocumentFileInfo := FDocumentFilesFrame.GetCurrentDocumentFileInfo;

    try

      if Assigned(CurrentDocumentFileInfo) then begin

        FDocumentFilesViewFrame.CurrentDocumentFileName :=
          CurrentDocumentFileInfo.FileName;

      end;

    finally

      FreeAndNil(CurrentDocumentFileInfo);

    end;

  end;

end;

procedure TDocumentCardFrame.UpdateDocumentPageFormSizesByCurrentRatios;
begin

  UpdateMainInformationAndReceiversFormSizesByRatio(FMainInformationAndReceiversFormSizeRatio);
  UpdateRelatedDocumentsAndFilesFormSizesByRatio(FRelatedDocumentsAndFilesFormSizeRatio);
  UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(
    FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
  );
  UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(
    FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
  );

end;

procedure TDocumentCardFrame.UpdateDocumentPageFormsSizesRatios;
begin

  UpdateMainInformationAndReceiversFormSizeRatio;
  UpdateRelatedDocumentsAndFilesFormSizeRatio;
  UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
  UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
  
end;

procedure TDocumentCardFrame.UpdateMainInformationAndReceiversFormSizeRatio;
begin

  if SaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize then begin

    if DocumentChargesInfoArea.Height > 0 then begin

      FMainInformationAndReceiversFormSizeRatio :=
        DocumentMainInfoArea.Height /  DocumentChargesInfoArea.Height;

    end

    else begin

      FMainInformationAndReceiversFormSizeRatio := 1;

    end;
    
  end;

end;

procedure TDocumentCardFrame.UpdateMainInformationAndReceiversFormSizesByRatio(
  const Ratio: Double);
begin

  if UserInterfaceKind = uiNew then Exit;
  
  if SaveDocumentMainInfoAndChargesAreasSizeRatiosOnResize then begin

    DocumentMainInfoArea.Height :=
      Integer(Round(DocumentMainInfoAndReceiversPage.Height * Ratio / (1 + Ratio)));

  end;

end;

procedure TDocumentCardFrame.UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
begin

  if
    not SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize
    or (UserInterfaceKind <> uiNew)
  then Exit;

  if DocumentFilesViewArea.Width > 0 then begin

    FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
      RelatedDocumentsAndFilesPanel.Width / DocumentFilesViewArea.Width;

  end

  else FNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio := 1;

end;

procedure TDocumentCardFrame.
  UpdateNewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(const Ratio: Double);
var
  r: Double;
begin

  if UserInterfaceKind <> uiNew then Exit;

  r := IfThen(Ratio = 0, 1, Ratio);

  RelatedDocumentsAndFilesPanel.Width :=
    Integer(Round(DocumentRelationsAndFilesPage.Width * r / (1 + r)));

end;

procedure TDocumentCardFrame.UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;
begin
  if
    not SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize
    or (UserInterfaceKind <> uiOld)
  then Exit;

  if DocumentFilesViewArea.Width > 0 then begin

    FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
      RelatedDocumentsAndFilesPanel.Width / DocumentFilesViewArea.Width;

  end

  else FOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio := 1;
end;

procedure TDocumentCardFrame.UpdateOldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizesByRatio(
  const Ratio: Double);
var
  r: Double;
begin

  if UserInterfaceKind <> uiOld then Exit;

  r := IfThen(Ratio = 0, 1, Ratio);

  RelatedDocumentsAndFilesPanel.Width :=
    Integer(Round(DocumentRelationsAndFilesPage.Width * r / (1 + r)));

end;

procedure TDocumentCardFrame.UpdateRelatedDocumentsAndFilesFormSizeRatio;
begin

  if not SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize then Exit;

  if DocumentFilesInfoArea.Height > 0 then begin

      FRelatedDocumentsAndFilesFormSizeRatio :=
        DocumentRelationsInfoArea.Height / DocumentFilesInfoArea.Height;

  end

  else begin

    FRelatedDocumentsAndFilesFormSizeRatio := 1;

  end;

{  case UserInterfaceKind of

    uiOld:
    begin

      if DocumentFilesInfoArea.Width > 0 then begin

          FRelatedDocumentsAndFilesFormSizeRatio :=
            DocumentRelationsInfoArea.Width / DocumentFilesInfoArea.Width;

      end

      else begin

        FRelatedDocumentsAndFilesFormSizeRatio := 1;

      end;

    end;

    uiNew:
    begin

      if DocumentFilesInfoArea.Height > 0 then begin

          FRelatedDocumentsAndFilesFormSizeRatio :=
            DocumentRelationsInfoArea.Height / DocumentFilesInfoArea.Height;

      end

      else begin

        FRelatedDocumentsAndFilesFormSizeRatio := 1;

      end;

    end;

  end;  }

end;

procedure TDocumentCardFrame.UpdateRelatedDocumentsAndFilesFormSizesByRatio(
  const Ratio: Double);
begin

  if SaveRelatedDocumentsInfoAndFilesAreasSizeRatiosOnResize then begin

    DocumentRelationsInfoArea.Height :=
      Integer(Round(DocumentRelationsAndFilesPage.Height * Ratio / (1 + Ratio)));

{    case UserInterfaceKind of

      uiOld:
      begin

        DocumentRelationsInfoArea.Width :=
          Integer(Round(DocumentRelationsAndFilesPage.Width * Ratio / (1 + Ratio)));

      end;

      uiNew:
      begin

        DocumentRelationsInfoArea.Height :=
          Integer(Round(DocumentRelationsAndFilesPage.Height * Ratio / (1 + Ratio)));
          
      end;

    end; }

  end;

end;

function TDocumentCardFrame.ValidateInput: Boolean;
begin

  Result :=
    Assigned(FDocumentMainInformationFrame) and
    FDocumentMainInformationFrame.ValidateInput and

    Assigned(FDocumentChargesFrame) and
    FDocumentChargesFrame.ValidateInput and

    Assigned(FDocumentApprovingsFrame) and
    FDocumentApprovingsFrame.ValidateInput and

    Assigned(FDocumentRelationsFrame) and
    FDocumentRelationsFrame.ValidateInput and

    Assigned(FDocumentFilesFrame) and
    FDocumentFilesFrame.ValidateInput;

end;

procedure TDocumentCardFrame.InflateDocumentInformationFrameToPage(
  DocumentInformationFrame: TDocumentCardInformationFrame);
begin

  DocumentInformationFrame.Parent :=
    GetAreaForDocumentInformationFrame(DocumentInformationFrame);

  DocumentInformationFrame.Width := DocumentInformationFrame.Parent.Width;
  DocumentInformationFrame.Height := DocumentInformationFrame.Parent.Height;
  
  DocumentInformationFrame.Align := alClient;
  
end;

procedure TDocumentCardFrame.InflateDocumentOperationToolBarFrame(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame);
begin

  DocumentOperationToolBarFrame.Parent := FooterButtonPanel;
  DocumentOperationToolBarFrame.Align := alClient;

  DocumentOperationToolBarFrame.Show;
  
end;

procedure TDocumentCardFrame.Initialize;
begin

  SaveDocumentSheetAreasSizeRatiosOnResize := True;
  
  UpdateDocumentPageFormsSizesRatios;

  EnableScrolling := False;

  RelatedDocumentsAndFilesVerticalSplitter.Width :=
    TDocumentFlowCommonControlStyles.GetSplitterThickness;
  
  inherited Initialize;
  
end;

function TDocumentCardFrame.IsDataChanged: Boolean;
begin

  Result :=
    (Assigned(FDocumentMainInformationFrame) and
     FDocumentMainInformationFrame.IsDataChanged)
    or
    (Assigned(FDocumentChargesFrame) and
     FDocumentChargesFrame.IsDataChanged)
    or
    (Assigned(FDocumentRelationsFrame) and
     FDocumentRelationsFrame.IsDataChanged)
    or
    (Assigned(FDocumentFilesFrame) and
     FDocumentFilesFrame.IsDataChanged)
    or
    (Assigned(FDocumentApprovingsFrame) and
     FDocumentApprovingsFrame.IsDataChanged);

end;

function TDocumentCardFrame.IsEmpty: Boolean;
begin

  Result := not Assigned(FViewModel);
  
end;

procedure TDocumentCardFrame.NoApproveDocumentButtonClick(Sender: TObject);
var
    AccessibleDocumentApprovings: TDocumentApprovingsViewModel;
    AccessibleDocumentApproving: TDocumentApprovingViewModel;
    NotDocumentApprovingReason: String;
begin

  AccessibleDocumentApprovings :=
    DocumentApprovingsFrame.GetAccessibleDocumentApprovingsOfNewCycle;
    
  if not Assigned(AccessibleDocumentApprovings) then  begin

    RaiseOnDocumentApprovingRejectingRequestedEventHandler;
    Exit;
    
  end;

  try

    RaiseExceptionIfMoreThanOnAccessibleDocumentApprovingsFound(
      AccessibleDocumentApprovings
    );

    AccessibleDocumentApproving := AccessibleDocumentApprovings[0];
    
    if Trim(AccessibleDocumentApproving.Note) = '' then begin

      NotDocumentApprovingReason := GetNotApprovingReasonFromInputForm;

      if NotDocumentApprovingReason <> '' then begin

        AccessibleDocumentApproving.Note := NotDocumentApprovingReason;

        DocumentApprovingsFrame.UpdateNewCycleDocumentApproving(
          AccessibleDocumentApproving
        );
        
        RaiseOnDocumentApprovingRejectingRequestedEventHandler;
        
      end;

    end

    else
      RaiseOnDocumentApprovingRejectingRequestedEventHandler;
    
  finally

    FreeAndNil(AccessibleDocumentApprovings);
    
  end;

end;

procedure TDocumentCardFrame.
  OnDocumentApprovingChangingRequestedEventHandle(
    Sender: TObject;
    CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    ApprovingViewModel: TDocumentApprovingViewModel
  );
begin

  if Assigned(FOnDocumentApprovingChangingRequestedEventHandler) then begin

    FOnDocumentApprovingChangingRequestedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      CurrentApprovingCycleViewModel,
      ApprovingViewModel
    );

  end;

end;

procedure TDocumentCardFrame.OnDocumentApprovingCompletingRequestedEventHandle(
  Sender: TObject; CycleViewModel: TDocumentApprovingCycleViewModel);
begin

  if Assigned(FOnDocumentApprovingCompletingRequestedEventHandler) then begin

    FOnDocumentApprovingCompletingRequestedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      CycleViewModel
    );

  end;

end;

procedure TDocumentCardFrame.OnDocumentApprovingCycleRemovedEventHandle(
  Sender: TObject;
  CycleViewModel: TDocumentApprovingCycleViewModel
);
var
    ApprovingDocumentSendingTool: TButton;
    SigningDocumentSendingTool: TButton;
    SigningTool: TButton;
    SigningMarkingTool: TButton;
begin

  inherited;

  if CycleViewModel.IsNew then begin

    ApprovingDocumentSendingTool := GetApprovingDocumentSendingTool;
    
    if Assigned(ApprovingDocumentSendingTool) then
      ApprovingDocumentSendingTool.Enabled := False;

    SigningDocumentSendingTool := GetSigningDocumentSendingTool;
    SigningTool := GetDocumentSigningTool;
    SigningMarkingTool := GetDocumentSigningMarkingTool;
    
    SetEnabledControls(
      True,
      [
        SigningDocumentSendingTool,
        SigningTool,
        SigningMarkingTool
      ]
    );

  end;

end;

procedure TDocumentCardFrame.OnDocumentApprovingCycleRemovingRequestedEventHandle(
  Sender: TObject; CycleViewModel: TDocumentApprovingCycleViewModel);
begin

  if Assigned(FOnDocumentApprovingCycleRemovingRequestedEventHandler) then begin

    FOnDocumentApprovingCycleRemovingRequestedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      CycleViewModel
    );

  end;

end;

procedure TDocumentCardFrame.OnDocumentApprovingCycleSelectedEventHandle(
  Sender: TObject;
  SelectedCycleViewModel: TDocumentApprovingCycleViewModel
);
var ApprovingsOfNewCycle: TDocumentApprovingsViewModel;
    DocumentSigningTool: TButton;
    NewCycleDocumentApprovingsExists: Boolean;
begin

  ApprovingsOfNewCycle := FDocumentApprovingsFrame.GetApprovingsOfNewCycle;

  try

    OnNewCycleApprovingsCheck(ApprovingsOfNewCycle);

  finally

    FreeAndNil(ApprovingsOfNewCycle);
    
  end;

  if Assigned(FOnDocumentApprovingCycleSelectedEventHandler) then begin
  
    FOnDocumentApprovingCycleSelectedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      SelectedCycleViewModel
    );

  end;

end;

procedure TDocumentCardFrame.OnDocumentApprovingsChangedEventHandler(
  Sender: TObject
);
begin

end;

procedure TDocumentCardFrame.OnDocumentApprovingsRemovedEventHandle(
  Sender: TObject;
  DocumentApprovingsViewModel: TDocumentApprovingsViewModel
);
var RemainingDocumentApprovingsViewModel: TDocumentApprovingsViewModel;
    AllDocumentApprovingsRemoved: Boolean;
begin

  inherited;

  if not FDocumentApprovingsFrame.IsNewApprovingCycleSelected then
    Exit;

  RemainingDocumentApprovingsViewModel :=
    FDocumentApprovingsFrame.GetApprovingsOfFocusedCycle;

  try

    OnNewCycleApprovingsRemoved(
      DocumentApprovingsViewModel,
      RemainingDocumentApprovingsViewModel
    );

  finally

    FreeAndNil(RemainingDocumentApprovingsViewModel);

  end;
  
end;

procedure TDocumentCardFrame.OnDocumentApprovingsRemovingRequestedEventHandle(
  Sender: TObject;
  CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
  DocumentApprovingsViewModel: TDocumentApprovingsViewModel
);
begin

  if Assigned(FOnDocumentApprovingsRemovingRequestedEventHandler) then
    FOnDocumentApprovingsRemovingRequestedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      CurrentApprovingCycleViewModel,
      DocumentApprovingsViewModel
    );

end;

procedure TDocumentCardFrame.OnDocumentFileAddedEventHandler(
  Sender: TObject;
  const FileName, FilePath: String
);
var AddedDocumentFileInfo: TDocumentFileInfo;
begin

  if not Assigned(FDocumentFilesViewFrame) then Exit;

  AddedDocumentFileInfo := TDocumentFileInfo.Create(Null, FileName, FilePath);

  FDocumentFilesViewFrame.AddDocumentFileInfo(AddedDocumentFileInfo);

  FDocumentFilesViewFrame.SynchronizeUIWithCurrentDocumentFileInfoIfNecessary;

end;

procedure TDocumentCardFrame.
  OnDocumentFileRemovedEventHandler(
    Sender: TObject;
    const FileName, FilePath: String
  );
begin

  if not Assigned(FDocumentFilesViewFrame) then
    Exit;

  FDocumentFilesViewFrame.RemoveDocumentFileInfo(FileName);

  FDocumentFilesViewFrame.SynchronizeUIWithCurrentDocumentFileInfoIfNecessary;
  
end;

procedure TDocumentCardFrame.OnDocumentFilesChangedEventHandler(
  Sender: TObject);
begin

end;

procedure TDocumentCardFrame.OnDocumentFileSelectedEventHandler(
  Sender: TObject;
  const FileId: Variant;
  const FileName: String
);
begin

  if
//    (UserInterfaceKind <> uiNew) or
    (ActiveDocumentInfoPageNumber <> DocumentRelationsAndFilesPage.PageIndex)
  then Exit;

  FDocumentFilesViewFrame.CurrentDocumentFileName := FileName;

end;

procedure TDocumentCardFrame.OnDocumentFileShowingEventHandler(
  Sender: TObject;
  ShowableDocumentFileInfo: TDocumentFileInfo;
  var TargetDocumentFilePath: String
);
begin

  if Assigned(FOnDocumentFileOpeningRequestedEventHandler) then begin

    TargetDocumentFilePath := ShowableDocumentFileInfo.FilePath;

    FOnDocumentFileOpeningRequestedEventHandler(
      Self,
      ShowableDocumentFileInfo.Id,
      TargetDocumentFilePath
    );

  end;

end;

procedure TDocumentCardFrame.OnDocumentMainInformationChangedEventHandler(
  Sender: TObject);
begin

end;

procedure TDocumentCardFrame.OnDocumentReceiversChangedEventHandler(
  Sender: TObject);
begin

end;

procedure TDocumentCardFrame.OnDocumentRelationsChangedEventHandler(
  Sender: TObject);
begin

end;

procedure TDocumentCardFrame.OnEmployeesAddedForApprovingEventHandle(
  Sender: TObject;
  EmployeeIds: TVariantList
);
var ApprovingDocumentSendingTool: TButton;
    SigningDocumentSendingTool: TButton;
    SigningMarkingTool: TButton;
    SigningTool: TButton;
begin

  inherited;

  ApprovingDocumentSendingTool := GetApprovingDocumentSendingTool;

  if Assigned(ApprovingDocumentSendingTool) then
    ApprovingDocumentSendingTool.Enabled := True;

  SigningDocumentSendingTool := GetSigningDocumentSendingTool;
  SigningTool := GetDocumentSigningTool;
  SigningMarkingTool := GetDocumentSigningMarkingTool;

  SetEnabledControls(
    False,
    [
      SigningDocumentSendingTool,
      SigningTool,
      SigningMarkingTool
    ]
  );

end;

procedure TDocumentCardFrame.OnEmployeesAddingForApprovingRequestedEventHandle(
  Sender: TObject; EmployeeIds: TVariantList);
begin

  if Assigned(FOnEmployeesAddingForApprovingRequestedEventHandler) then begin

    FOnEmployeesAddingForApprovingRequestedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      EmployeeIds
    );

  end;

end;

procedure TDocumentCardFrame.
  OnExistingDocumentFileOpeningRequestedEventHandler(
    Sender: TObject;
    const DocumentFileId: Variant;
    var DocumentFilePath: String
  );
begin

  if Assigned(FOnDocumentFileOpeningRequestedEventHandler) then
    FOnDocumentFileOpeningRequestedEventHandler(
      Self, DocumentFileId, DocumentFilePath
    );
    
end;

procedure TDocumentCardFrame.OnNewCycleApprovingsCheck(
  ApprovingsOfNewCycle: TDocumentApprovingsViewModel
);
var
    ApprovingDocumentSendingTool: TButton;
    SigningDocumentSendingTool: TButton;
    SigningTool: TButton;
    SigningMarkingTool: TButton;

    NewCycleApprovingsExists: Boolean;
begin

  NewCycleApprovingsExists :=
    Assigned(ApprovingsOfNewCycle)
    and (ApprovingsOfNewCycle.Count > 0);

  ApprovingDocumentSendingTool := GetApprovingDocumentSendingTool;
  
  if Assigned(ApprovingDocumentSendingTool) then
    ApprovingDocumentSendingTool.Enabled := NewCycleApprovingsExists;

  SigningDocumentSendingTool := GetSigningDocumentSendingTool;
  SigningTool := GetDocumentSigningTool;
  SigningMarkingTool := GetDocumentSigningMarkingTool;

  SetEnabledControls(
    not NewCycleApprovingsExists,
    [
      SigningDocumentSendingTool,
      SigningTool,
      SigningMarkingTool
    ]
  );
  
end;

procedure TDocumentCardFrame.OnNewCycleApprovingsRemoved(
  NewCycleRemovedApprovingsViewModel: TDocumentApprovingsViewModel;
  RemainingNewCycleApprovingsViewModel: TDocumentApprovingsViewModel
);
var
    ApprovingDocumentSendingTool: TButton;
    SigningDocumentSendingTool: TButton;
    SigningTool: TButton;
    SigningMarkingTool: TButton;
    NewCycleApprovingsExists: Boolean;
begin

  ApprovingDocumentSendingTool := GetApprovingDocumentSendingTool;

  NewCycleApprovingsExists :=
    Assigned(RemainingNewCycleApprovingsViewModel)
    and (RemainingNewCycleApprovingsViewModel.Count > 0);

  if Assigned(ApprovingDocumentSendingTool) then
    ApprovingDocumentSendingTool.Enabled := NewCycleApprovingsExists;

  SigningDocumentSendingTool := GetSigningDocumentSendingTool;
  SigningTool := GetDocumentSigningTool;
  SigningMarkingTool := GetDocumentSigningMarkingTool;

  SetEnabledControls(
    not NewCycleApprovingsExists,
    [
      SigningDocumentSendingTool,
      SigningTool,
      SigningMarkingTool
    ]
  );
  
end;

procedure TDocumentCardFrame.
  OnNewDocumentApprovingCycleCreatingRequestedEventHandle(
    Sender: TObject;
    var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  if Assigned(FOnNewDocumentApprovingCycleCreatingRequestedEventHandler)
  then begin

    FOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
      Self,
      FViewModel.DocumentId,
      FViewModel.DocumentKindId,
      NewDocumentApprovingCycleViewModel
    );

  end;

end;

procedure TDocumentCardFrame.
  OnRelatedDocumentCardOpeningRequestedEventHandle(
    Sender: TObject;
    const DocumentId, DocumentTypeId: Variant
  );
begin

  if Assigned(FOnRelatedDocumentCardOpeningRequestedEventHandler) then
  begin

    FOnRelatedDocumentCardOpeningRequestedEventHandler(
      Self,
      DocumentId, DocumentTypeId,
      ViewModel.DocumentId, ViewModel.DocumentKindId
    );
    
  end;

end;

procedure TDocumentCardFrame.OnShow;
begin

  DocumentApprovingsFrame.DocumentApprovingCyclesInfoArea.Width :=
    DocumentApprovingsFrame.DocumentApprovingCyclesInfoArea.Width + 100;
  DocumentApprovingsFrame.DocumentApprovingCyclesInfoArea.Width :=
    DocumentApprovingsFrame.DocumentApprovingCyclesInfoArea.Width - 100;

//  DocumentApprovingsFrame.Realign;


//  DocumentApprovingsFrame.DocumentApproversFormPanel.Width;
//  DocumentApprovingsFrame.DocumentApproversInfoForm.Width;

  inherited OnShow;

  UpdateDocumentFilesViewFrameIfNecessary;
  
  if Assigned(Parent) then
    FooterButtonPanel.Parent := Parent;
  
end;

procedure TDocumentCardFrame.OnShowWindowMessageHandler(var Message: TMessage);
begin

  if Assigned(DocumentCardPageControl)
     and (DocumentCardPageControl.ActivePage = DocumentApprovingPage)

  then DocumentApprovingPage.Show;

  inherited;

end;

procedure TDocumentCardFrame.PerformDocumentButtonClick(Sender: TObject);
var
    DocumentChargeSheetsFrame: TDocumentChargeSheetsFrame;
    SelectedChargeIds: TVariantList;
begin

  DocumentChargeSheetsFrame :=
    FDocumentChargesFrame as TDocumentChargeSheetsFrame;

  if not
     DocumentChargeSheetsFrame.
      ValidateAllowableForPerformingChargesSelected
  then Exit;
    
  if not Assigned(FOnDocumentChargesPerformingRequestedEventHandler)
  then Exit;

  if

    ShowQuestionMessage(
        Self.Handle,
        'Вы уверены, что хотите исполнить ' +
        'поручение(я) по документу ?',
        'Сообщение'
    ) = IDYES

  then begin

    try

      SelectedChargeIds :=
        DocumentChargeSheetsFrame.FetchSelectedChargeIds;

      FOnDocumentChargesPerformingRequestedEventHandler(
        Self, SelectedChargeIds
      )

    finally

      FreeAndNil(SelectedChargeIds);


    end;

  end;

end;

procedure TDocumentCardFrame.RaiseOnDocumentPerformingsChangesSavingRequestedEventHandler;
begin

  if Assigned(FOnDocumentPerformingsChangesSavingRequestedEventHandler) then
    FOnDocumentPerformingsChangesSavingRequestedEventHandler(Self);
  
end;

procedure TDocumentCardFrame.RaisePendingEvents;
begin

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.RaisePendingEvents;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.RaisePendingEvents;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.RaisePendingEvents;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.RaisePendingEvents;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.RaisePendingEvents;
  
end;

procedure TDocumentCardFrame.RestoreNestedFramesUIProperties;
begin

   if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.RestoreUIControlProperties;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.RestoreUIControlProperties;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.RestoreUIControlProperties;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.RestoreUIControlProperties;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.RestoreUIControlProperties;
    
end;

procedure TDocumentCardFrame.OnChangesApplied;
begin

  if Assigned(FDocumentMainInformationFrame) then
    FDocumentMainInformationFrame.OnChangesApplied;

  if Assigned(FDocumentApprovingsFrame) then
    FDocumentApprovingsFrame.OnChangesApplied;

  if Assigned(FDocumentChargesFrame) then
    FDocumentChargesFrame.OnChangesApplied;

  if Assigned(FDocumentRelationsFrame) then
    FDocumentRelationsFrame.OnChangesApplied;

  if Assigned(FDocumentFilesFrame) then
    FDocumentFilesFrame.OnChangesApplied;
  
end;

end.

