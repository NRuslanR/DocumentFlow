unit BaseIncomingDocumentsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseDocumentsReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxTextEdit, cxSpinEdit, cxLocalization, ActnList,
  ImgList, PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls,
  StdCtrls, cxButtons, ToolWin, DocumentSetHolder, IncomingDocumentSetHolder,
  DocumentRecordViewModel, IncomingDocumentRecordViewModel,
  NativeDocumentKindDto, unDocumentCardFrame, DocumentsReferenceViewModel,
  AbstractDocumentSetHolderDecorator, cxCheckBox, cxImageComboBox;

type

  TOnRespondingDocumentCreatingFinishedEventHandler =
    procedure (
      Sender: TObject;
      RespondingDocumentCardFrame: TDocumentCardFrame
    ) of object;

  TBaseIncomingDocumentsReferenceForm = class(TBaseDocumentsReferenceForm)
    ReceiptDateColumn: TcxGridDBColumn;
    IncomingDocumentNumberColumn: TcxGridDBColumn;
    SendingDepartmentNameColumn: TcxGridDBColumn;
    actCreateRespondingDocument: TAction;
    RespondingDocumentCreatingToolButton: TToolButton;
    CreateRespondingDocumentMenuItem: TMenuItem;

    procedure actCreateRespondingDocumentExecute(Sender: TObject);
    
  protected

    FNativeDocumentKindDtos: TNativeDocumentKindDtos;

  protected

    procedure UpdateDataOperationControls; override;
    procedure UpdateDocumentToolButtonsVisibilityBy(DocumentSetHolder: TDocumentSetHolder); override;
    procedure SetActivatedDataOperationControls(const Activated: Boolean); override;
    
  protected

    FOnRespondingDocumentCreatingFinishedEventHandler: TOnRespondingDocumentCreatingFinishedEventHandler;

    procedure OnRespondingDocumentCreatingRequestedEventHandler(
      Sender: TObject
    );

    procedure RaiseOnRespondingDocumentCreatingFinishedEventHandler(
      RespondingDocumentCreatingCardFrame: TDocumentCardFrame
    );

  public

    procedure ShowRespondingDocumentCreatingCard(
      DocumentRecordViewModel: TDocumentRecordViewModel
    );

  public

    property NativeDocumentKindDtos: TNativeDocumentKindDtos
    read FNativeDocumentKindDtos write FNativeDocumentKindDtos;

  public

    property OnRespondingDocumentCreatingFinishedEventHandler:
        TOnRespondingDocumentCreatingFinishedEventHandler

    read FOnRespondingDocumentCreatingFinishedEventHandler
    write FOnRespondingDocumentCreatingFinishedEventHandler;

  end;

var
  BaseIncomingDocumentsReferenceForm: TBaseIncomingDocumentsReferenceForm;

implementation

uses

  UIDocumentKinds,
  RespondingDocumentCreatingAppService,
  DocumentCardFormViewModel,
  DocumentCardFormViewModelMapper,
  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapperFactories,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentCardFrameFactory,
  DocumentCardFrameFactories,
  DocumentKinds,
  DocumentCardFormUnit,
  ApplicationServiceRegistries,
  WorkingEmployeeUnit,
  unApplicationMainForm,
  AuxWindowsFunctionsUnit, DBDataTableFormUnit;

{$R *.dfm}

{ TBaseIncomingDocumentsReferenceForm }

procedure TBaseIncomingDocumentsReferenceForm.OnRespondingDocumentCreatingRequestedEventHandler(
  Sender: TObject);
var
    RespondingDocumentCreatingCardFrame: TDocumentCardFrame;
begin

  RespondingDocumentCreatingCardFrame := Sender as TDocumentCardFrame;

  if RaiseOnNewDocumentCreatingConfirmedEventHandler(RespondingDocumentCreatingCardFrame) then
    RaiseOnRespondingDocumentCreatingFinishedEventHandler(RespondingDocumentCreatingCardFrame);

end;

procedure TBaseIncomingDocumentsReferenceForm.RaiseOnRespondingDocumentCreatingFinishedEventHandler(
  RespondingDocumentCreatingCardFrame: TDocumentCardFrame);
begin

  if Assigned(FOnRespondingDocumentCreatingFinishedEventHandler) then
    FOnRespondingDocumentCreatingFinishedEventHandler(Self, RespondingDocumentCreatingCardFrame);
    
end;

procedure TBaseIncomingDocumentsReferenceForm.actCreateRespondingDocumentExecute(
  Sender: TObject);
var
    FocusedDocumentRecordViewModel: TDocumentRecordViewModel;
begin

  inherited;

  FocusedDocumentRecordViewModel := CreateFocusedDocumentRecordViewModel;

  if Assigned(FocusedDocumentRecordViewModel) then
    ShowRespondingDocumentCreatingCard(FocusedDocumentRecordViewModel);

end;

procedure TBaseIncomingDocumentsReferenceForm.SetActivatedDataOperationControls(
  const Activated: Boolean);
begin

  inherited SetActivatedDataOperationControls(Activated);

  actCreateRespondingDocument.Enabled := Activated;

end;

procedure TBaseIncomingDocumentsReferenceForm.ShowRespondingDocumentCreatingCard(
  DocumentRecordViewModel: TDocumentRecordViewModel
);

  function CreateRespondingDocumentCardViewModelFrom(
    DocumentKind: TUIDocumentKindClass;
    RespondingDocumentCreatingResultDto: TRespondingDocumentCreatingResultDto
  ): TDocumentCardFormViewModel;
  var
      RespondingDocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
      RespondingDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
  begin

    RespondingDocumentCardFormViewModelMapperFactory := nil;
    RespondingDocumentCardFormViewModelMapper := nil;

    try

      RespondingDocumentCardFormViewModelMapperFactory :=
        TDocumentCardFormViewModelMapperFactories
          .Current
            .CreateDocumentCardFormViewModelMapperFactory(DocumentKind);

      RespondingDocumentCardFormViewModelMapper :=
        RespondingDocumentCardFormViewModelMapperFactory.CreateDocumentCardFormViewModelMapper;

      Result :=
        RespondingDocumentCardFormViewModelMapper.MapNewDocumentCardFormViewModelFrom(
          RespondingDocumentCreatingResultDto.DocumentFullInfoDTO,
          RespondingDocumentCreatingResultDto.DocumentUsageEmployeeAccessRightsInfoDTO
        );

    finally

      FreeAndNil(RespondingDocumentCardFormViewModelMapperFactory);
      FreeAndNil(RespondingDocumentCardFormViewModelMapper);
      
    end;

  end;

  function CreateRespondingDocumentCardFrameFrom(
    DocumentKind: TUIDocumentKindClass;
    DocumentCardViewModel: TDocumentCardFormViewModel;
    DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
  ): TDocumentCardFrame;
  var
      RespondingDocumentCardFrameFactory: TDocumentCardFrameFactory;
  begin

    RespondingDocumentCardFrameFactory :=
      TDocumentCardFrameFactories.Current.CreateDocumentCardFrameFactory(
        DocumentKind
      );

    try
    
      Result :=
        RespondingDocumentCardFrameFactory.CreateCardFrameForNewDocumentCreating(
          DocumentCardViewModel,
          DocumentUsageEmployeeAccessRightsInfoDTO
        );

    finally

      FreeAndNil(RespondingDocumentCardFrameFactory);

    end

  end;

var
    CurrentServiceDocumentKind: TDocumentKindClass;
    OutcomingServiceDocumentKind: TDocumentKindClass;
    CurrentUIIncomingDocumentKind: TUIIncomingDocumentKindClass;

    RespondingDocumentCreatingAppService: IRespondingDocumentCreatingAppService;
    RespondingDocumentCreatingResultDto: TRespondingDocumentCreatingResultDto;

    RespondingDocumentCardFormViewModel: TDocumentCardFormViewModel;
    RespondingDocumentCardFrame: TDocumentCardFrame;
    RespondingDocumentCardForm: TDocumentCardForm;
begin

  {refactor: move all implementation to card controller class }
  
  CurrentServiceDocumentKind :=
    FNativeDocumentKindDtos.FindByIdOrRaise(
      GetDocumentKindIdFromCurrentRecord
    ).ServiceType;

  RespondingDocumentCreatingAppService :=
    TApplicationServiceRegistries
      .Current
        .GetDocumentBusinessProcessServiceRegistry
          .GetRespondingDocumentCreatingAppService(CurrentServiceDocumentKind);

  RespondingDocumentCreatingResultDto := nil;
  RespondingDocumentCardForm := nil;
  RespondingDocumentCardFormViewModel := nil;
  RespondingDocumentCardFrame := nil;

  try

    Screen.Cursor := crHourGlass;
    
    RespondingDocumentCreatingResultDto :=
      RespondingDocumentCreatingAppService.CreateRespondingDocumentFor(
        GetCurrentDocumentRecordId,
        TWorkingEmployee.Current.Id
      );

    CurrentUIIncomingDocumentKind :=
      TUIIncomingDocumentKindClass(ResolveUIDocumentKindFromCurrentRecord);

    RespondingDocumentCardFormViewModel :=
      CreateRespondingDocumentCardViewModelFrom(
        CurrentUIIncomingDocumentKind.OutcomingDocumentKind,
        RespondingDocumentCreatingResultDto
      );

    RespondingDocumentCardFrame :=
      CreateRespondingDocumentCardFrameFrom(
        CurrentUIIncomingDocumentKind.OutcomingDocumentKind,
        RespondingDocumentCardFormViewModel,
        RespondingDocumentCreatingResultDto.DocumentUsageEmployeeAccessRightsInfoDTO
      );

    RespondingDocumentCardFormViewModel := nil;

    RespondingDocumentCardForm := TDocumentCardForm.Create(RespondingDocumentCardFrame, Self);

    CustomizeNewDocumentCardForm(RespondingDocumentCardForm);

    RespondingDocumentCardFrame.WorkingEmployeeId := TWorkingEmployee.Current.Id;

    OutcomingServiceDocumentKind :=
      NativeDocumentKindDtos
        .FindByIdOrRaise(
          FUIDocumentKindResolver.ResolveIdForUIDocumentKind(
            CurrentUIIncomingDocumentKind.OutcomingDocumentKind
          )
        ).ServiceType;

    RespondingDocumentCardFrame.ServiceDocumentKind := OutcomingServiceDocumentKind;
    RespondingDocumentCardFrame.UIDocumentKind := CurrentUIIncomingDocumentKind.OutcomingDocumentKind;
    
      TApplicationMainForm(Application.MainForm)
        .ApplicationMainFrame
          .DocumentCardListFrame
            .AssignEventHandlersToDocumentCardFrame(RespondingDocumentCardFrame);

    RespondingDocumentCardFrame.Font := Font;

    RespondingDocumentCardFrame.OnDocumentInfoSavingRequestedEventHandler :=
      OnRespondingDocumentCreatingRequestedEventHandler;

    SetControlSizeByRatio(
      RespondingDocumentCardForm,
      Application.MainForm.Width,
      Application.MainForm.Height,
      6 / 7,
      6 / 7
    );

    RespondingDocumentCardForm.ShowModal;

    RespondingDocumentCardForm := nil;

  finally

    Screen.Cursor := crDefault;
    
    FreeAndNil(RespondingDocumentCardForm);
    FreeAndNil(RespondingDocumentCardFormViewModel);
    FreeAndNil(RespondingDocumentCardFrame);
    FreeAndNil(RespondingDocumentCreatingResultDto);

  end;

end;

procedure TBaseIncomingDocumentsReferenceForm.UpdateDataOperationControls;
begin

  inherited UpdateDataOperationControls;

  actCreateRespondingDocument.Enabled := HasDataSetRecords;

end;

procedure TBaseIncomingDocumentsReferenceForm.UpdateDocumentToolButtonsVisibilityBy(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited;

  with
    TIncomingDocumentSetHolder(
      TAbstractDocumentSetHolderDecorator(
        DocumentSetHolder
      ).GetNestedDocumentSetHolderByType(TIncomingDocumentSetHolder)
    )
  do begin

    actCreateRespondingDocument.Visible := RespondingDocumentCreatingAllowed;

  end;

end;

end.
