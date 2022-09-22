unit DocumentCardFrameFactory;

interface

uses

  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentCardFormViewModel,
  EmployeeDocumentCardFormViewModel,
  unDocumentCardFrame,
  unDocumentChargesFrame,
  PDFViewFormUnit,
  DocumentRelationsFrameUnit,
  DocumentMainInformationFrameUnit,
  DocumentFilesFrameUnit,
  DocumentFilesViewFrameUnit,

  DocumentApprovingsFormViewModel,
  DocumentMainInformationFormViewModelUnit,
  DocumentChargesFormViewModelUnit,
  DocumentRelationsFormViewModelUnit,
  DocumentFilesViewFormViewModel,
  DocumentFilesFormViewModelUnit,

  DocumentRelationsReferenceFormUnit,
  DocumentFilesReferenceFormUnit,

  DocumentApprovingsFrameUnit,
  DocumentApproversInfoFormUnit,
  DocumentApprovingCyclesReferenceFormUnit,
  DocumentOperationToolBarFrameUnit,

  EmployeeDocumentKindAccessRightsInfoDto,

  DocumentChargeKindsControlAppService,
  
  SysUtils,
  Classes;

type

  IDocumentCardFrameFactoryOptions = interface

    function DocumentFormPrintToolRequired: Boolean; overload;
    function DocumentFormPrintToolRequired(const Value: Boolean): IDocumentCardFrameFactoryOptions; overload;

    function ApprovingSheetPrintToolRequired: Boolean; overload;
    function ApprovingSheetPrintToolRequired(const Value: Boolean): IDocumentCardFrameFactoryOptions; overload;
    
  end;

  TDocumentCardFrameFactoryOptions = class (TInterfacedObject, IDocumentCardFrameFactoryOptions)

    protected

      FDocumentFormPrintToolRequired: Boolean;
      FApprovingSheetPrintToolRequired: Boolean;

    public

      function DocumentFormPrintToolRequired: Boolean; overload;
      function DocumentFormPrintToolRequired(const Value: Boolean): IDocumentCardFrameFactoryOptions; overload;

      function ApprovingSheetPrintToolRequired: Boolean; overload;
      function ApprovingSheetPrintToolRequired(const Value: Boolean): IDocumentCardFrameFactoryOptions; overload;
    
  end;

  TDocumentCardFrameFactory = class

    protected

      FOptions: IDocumentCardFrameFactoryOptions;

      function CreateDefaultOptions: IDocumentCardFrameFactoryOptions; virtual;
      
    protected

      function CreateDocumentCardFrameInstanceBy(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentCardFrame; virtual;

    protected

      function CreateDefaultDocumentCardFrameInstance(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentCardFrame; virtual;

      function CreateDocumentCardFrameInstanceForNewDocumentCreating(
        EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
      ): TDocumentCardFrame; overload; virtual;

      function CreateDocumentCardFrameInstanceForNewDocumentCreating(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentCardFrame; overload; virtual;

      function CreateDocumentCardFrameInstanceForView: TDocumentCardFrame; virtual;

    protected

      function CreateDocumentMainInformationFrameInstance: TDocumentMainInformationFrame; virtual;
      function CreateDocumentRelationsFrameInstance: TDocumentRelationsFrame; virtual;
      function CreateDocumentFilesFrameInstance: TDocumentFilesFrame; virtual;
      function CreateDocumentFilesViewFrameInstance: TDocumentFilesViewFrame; virtual;
      function CreateDocumentApprovingsFrameInstance: TDocumentApprovingsFrame; virtual;
      function CreateDocumentChargesFrameInstance: TDocumentChargesFrame; virtual;
      function CreateDocumentChargeSheetsFrameInstance: TDocumentChargesFrame; virtual;

    protected

      function CreateDocumentMainInformationFrame(
        DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel = nil;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentMainInformationFrame; virtual;

      function CreateDocumentApprovingsFrame(
        DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentApprovingsFrame; virtual;

      function CreateDocumentChargesFrame(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel = nil;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentChargesFrame; virtual;

      function CreateDocumentChargeSheetsFrame(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel = nil;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentChargesFrame; virtual;
      
      function CreateDocumentRelationsFrame(
        DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel = nil;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentRelationsFrame; virtual;

      function CreateDocumentFilesFrame(
        DocumentFilesFormViewModel: TDocumentFilesFormViewModel = nil;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentFilesFrame; virtual;

      function CreateDocumentFilesViewFrame(
        DocumentFilesViewFormViewModel: TDocumentFilesViewFormViewModel = nil;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentFilesViewFrame; virtual;

    protected

      procedure CreateSheetsAndInflateToDocumentCardFrame(
        DocumentCardFrame: TDocumentCardFrame;
        const ViewModel: TDocumentCardFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      );

      function CreateAndCustomizeDocumentOperationToolBarFrameBy(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentOperationToolBarFrame;

      function CreateDocumentOperationToolBarFrameInstanceBy(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentOperationToolBarFrame; virtual;

      procedure CustomizeDocumentOperationToolBarFrameBy(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      function CreateAndCustomizeDocumentOperationToolBarFrameForNewDocumentCreating:
        TDocumentOperationToolBarFrame;

      function CreateDocumentOperationToolBarFrameInstanceForNewDocumentCreating:
        TDocumentOperationToolBarFrame; virtual;

      procedure CustomizeDocumentOperationToolBarFrameForNewDocumentCreating(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame
      ); virtual;

    protected

      procedure CreateDocumentSavingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateDocumentApprovingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateDocumentNotApprovingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateDocumentSigningToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateDocumentSigningMarkingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;
      
      procedure CreateDocumentSigningRejectingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateDocumentPerformingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateApprovingDocumentSendingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;

      procedure CreateSigningDocumentSendingToolFor(
        DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ); virtual;
      
    public

      constructor Create(
        Options: IDocumentCardFrameFactoryOptions = nil
      ); virtual;
      
      function CreateDocumentCardFrameFrom(
        const ViewModel: TDocumentCardFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentCardFrame; virtual;

      function CreateCardFrameForNewDocumentCreating(
        const ViewModel: TDocumentCardFormViewModel;
        EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
      ): TDocumentCardFrame; overload; virtual;

      function CreateCardFrameForNewDocumentCreating(
        const ViewModel: TDocumentCardFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentCardFrame; overload; virtual;

      function CreateEmptyNoActivedDocumentCardFrame(
      ): TDocumentCardFrame; virtual;

      function CreateDocumentCardFrameForView(
        const ViewModel: TDocumentCardFormViewModel
      ): TDocumentCardFrame; virtual;

    public

      property Options: IDocumentCardFrameFactoryOptions
      read FOptions write FOptions;
      
  end;

implementation

uses

  Forms,
  unDocumentChargeSheetsFrame,
  AuxDebugFunctionsUnit,
  ExtendedDocumentMainInformationFrameUnit,
  DocumentFlowPDFViewFormUnit;

{ TDocumentCardFrameFactory }

function TDocumentCardFrameFactory.CreateDocumentCardFrameFrom(
  const ViewModel: TDocumentCardFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Result :=
    CreateDocumentCardFrameInstanceBy(
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  try

    CreateSheetsAndInflateToDocumentCardFrame(
      Result,
      ViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

    Result.DocumentOperationToolBarFrame :=
      CreateAndCustomizeDocumentOperationToolBarFrameBy(
        DocumentUsageEmployeeAccessRightsInfoDTO
      );
      
    Result.ViewModel := ViewModel;

    Result.RestoreUIControlProperties;
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

constructor TDocumentCardFrameFactory.Create(
  Options: IDocumentCardFrameFactoryOptions
);
begin

  inherited Create;

  if Assigned(Options) then
    Self.Options := Options

  else Self.Options := CreateDefaultOptions;
  
end;

function TDocumentCardFrameFactory.
  CreateAndCustomizeDocumentOperationToolBarFrameBy(
    DocumentUsageEmployeeAccessRightsInfoDTO:
      TDocumentUsageEmployeeAccessRightsInfoDTO
  ): TDocumentOperationToolBarFrame;
begin

  Result :=
    CreateDocumentOperationToolBarFrameInstanceBy(
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  CustomizeDocumentOperationToolBarFrameBy(
    Result, DocumentUsageEmployeeAccessRightsInfoDTO
  );
  
end;

function TDocumentCardFrameFactory.
  CreateDocumentOperationToolBarFrameInstanceBy(
    DocumentUsageEmployeeAccessRightsInfoDTO:
      TDocumentUsageEmployeeAccessRightsInfoDTO
  ): TDocumentOperationToolBarFrame;
begin

  Result := TDocumentOperationToolBarFrame.Create(nil);
  
end;

procedure TDocumentCardFrameFactory.CustomizeDocumentOperationToolBarFrameBy(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO:
    TDocumentUsageEmployeeAccessRightsInfoDTO
);
begin

  CreateDocumentSavingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateDocumentApprovingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateDocumentNotApprovingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateDocumentSigningToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateDocumentSigningMarkingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );
  
  CreateDocumentSigningRejectingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateDocumentPerformingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateApprovingDocumentSendingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  CreateSigningDocumentSendingToolFor(
    DocumentOperationToolBarFrame,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  if FOptions.DocumentFormPrintToolRequired then begin

    DocumentOperationToolBarFrame.CreateDocumentPrintFormCreatingTool(
      'Печатная форма'
    );

  end;

  if FOptions.ApprovingSheetPrintToolRequired then begin

    DocumentOperationToolBarFrame.CreateDocumentApprovingSheetCreatingTool(
      'Лист согласования'
    );

  end;

end;

function TDocumentCardFrameFactory.
  CreateAndCustomizeDocumentOperationToolBarFrameForNewDocumentCreating:
    TDocumentOperationToolBarFrame;
begin

  Result :=
    CreateDocumentOperationToolBarFrameInstanceForNewDocumentCreating;

  CustomizeDocumentOperationToolBarFrameForNewDocumentCreating(Result);
  
end;

procedure TDocumentCardFrameFactory.CreateApprovingDocumentSendingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if
    (DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeSentToApproving
    or
    DocumentUsageEmployeeAccessRightsInfoDTO.EmployeeHasRightsForSendingToApproving)
  then begin

    DocumentOperationToolBarFrame.
      CreateApprovingDocumentSendingTool('Отправить на согласование');

  end;
  
end;

function TDocumentCardFrameFactory.
CreateDocumentOperationToolBarFrameInstanceForNewDocumentCreating:
  TDocumentOperationToolBarFrame;
begin

  Result := TDocumentOperationToolBarFrame.Create(nil);
  
end;

procedure TDocumentCardFrameFactory.CreateDocumentPerformingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
var ChargeSheetsAccessRightsInfoDTO: TDocumentChargeSheetsAccessRightsInfoDTO;
begin

  ChargeSheetsAccessRightsInfoDTO :=
    DocumentUsageEmployeeAccessRightsInfoDTO.
      DocumentChargeSheetsAccessRightsInfoDTO;

  if not Assigned(ChargeSheetsAccessRightsInfoDTO) then Exit;

  if
    ChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBePerformed
  then begin

    DocumentOperationToolBarFrame.CreateDocumentPerformingTool('Исполнено');

  end;  
  
end;

procedure TDocumentCardFrameFactory.
  CustomizeDocumentOperationToolBarFrameForNewDocumentCreating(
    DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame
  );
begin

  DocumentOperationToolBarFrame.CreateDocumentSavingTool('Создать');
  
end;

function TDocumentCardFrameFactory.CreateCardFrameForNewDocumentCreating(
  const ViewModel: TDocumentCardFormViewModel;
  EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
): TDocumentCardFrame;
begin

  Result :=
    CreateDocumentCardFrameInstanceForNewDocumentCreating(
      EmployeeDocumentKindAccessRightsInfoDto
    );
  
  try

    CreateSheetsAndInflateToDocumentCardFrame(
      Result,
      ViewModel
    );

    Result.
      DocumentMainInformationFrame.
        AsSelfRegisteredDocumentMarkingToolEnabled :=

          EmployeeDocumentKindAccessRightsInfoDto.
            EmployeeCanMarkDocumentsAsSelfRegistered;

    Result.DocumentOperationToolBarFrame :=
      CreateAndCustomizeDocumentOperationToolBarFrameForNewDocumentCreating;
    
    Result.ViewModel := ViewModel;

    Result.ActiveDocumentInfoPageNumber := Result.DocumentMainInformationPageNumber;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentCardFrameFactory.CreateCardFrameForNewDocumentCreating(
  const ViewModel: TDocumentCardFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Result :=
    CreateDocumentCardFrameInstanceForNewDocumentCreating(DocumentUsageEmployeeAccessRightsInfoDTO);

  try

    CreateSheetsAndInflateToDocumentCardFrame(
      Result,
      ViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

    Result.DocumentOperationToolBarFrame :=
      CreateAndCustomizeDocumentOperationToolBarFrameForNewDocumentCreating;

    Result.ViewModel := ViewModel;

    Result.ActiveDocumentInfoPageNumber := Result.DocumentMainInformationPageNumber;
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;
  
end;

function TDocumentCardFrameFactory.CreateDefaultDocumentCardFrameInstance(
  DocumentUsageEmployeeAccessRightsInfoDTO:
    TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Result := TDocumentCardFrame.Create(nil, False, False);

end;

function TDocumentCardFrameFactory.CreateDefaultOptions: IDocumentCardFrameFactoryOptions;
begin

  Result :=
    TDocumentCardFrameFactoryOptions
      .Create
        .DocumentFormPrintToolRequired(True)
        .ApprovingSheetPrintToolRequired(False);

end;

function TDocumentCardFrameFactory.CreateDocumentApprovingsFrame(
  DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentApprovingsFrame;
var ApproversInfoFormViewOnly: Boolean;
    ApprovingCyclesTableFormViewOnly: Boolean;
begin

  Result := CreateDocumentApprovingsFrameInstance;

  Result.DocumentApprovingCyclesReferenceForm :=
    TDocumentApprovingCyclesReferenceForm.Create(Result);

  Result.DocumentApproversInfoForm :=
    TDocumentApproversInfoForm.Create(Result);

  if Assigned(DocumentUsageEmployeeAccessRightsInfoDTO) then begin

    if not DocumentUsageEmployeeAccessRightsInfoDTO.CanBeChangedDocumentApproverList
       and not DocumentUsageEmployeeAccessRightsInfoDTO.CanBeChangedDocumentApproversInfo
    then begin

      Result.DocumentApproversInfoForm.ViewOnly := True;

    end

    else begin

      Result.DocumentApproversInfoForm.ViewOnly := False;
      
      Result.DocumentApproversInfoForm.AddingApproversOptionsEnabled :=
        DocumentUsageEmployeeAccessRightsInfoDTO.CanBeChangedDocumentApproverList;

      Result.DocumentApproversInfoForm.RemovingApproversOptionsEnabled :=
        DocumentUsageEmployeeAccessRightsInfoDTO.CanBeChangedDocumentApproverList;
      
    end;

    if DocumentUsageEmployeeAccessRightsInfoDTO.
       CanBeChangedDocumentApproverList
    then begin

      Result.DocumentApprovingCyclesReferenceForm.ViewOnly := False;

    end

    else begin

      Result.DocumentApprovingCyclesReferenceForm.ViewOnly :=
        not DocumentUsageEmployeeAccessRightsInfoDTO.DocumentApprovingCanBeCompleted;
          
    end;

  end;

end;

function TDocumentCardFrameFactory.CreateDocumentApprovingsFrameInstance: TDocumentApprovingsFrame;
begin

  Result := TDocumentApprovingsFrame.Create(nil);
  
end;

procedure TDocumentCardFrameFactory.CreateDocumentApprovingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeApproved
  then begin

    DocumentOperationToolBarFrame.CreateDocumentApprovingTool('Согласовать');

  end;
  
end;

function TDocumentCardFrameFactory.CreateDocumentCardFrameForView(
  const ViewModel: TDocumentCardFormViewModel
): TDocumentCardFrame;
var DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  DocumentUsageEmployeeAccessRightsInfo :=
    TDocumentUsageEmployeeAccessRightsInfoDTO.Create;

  DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeViewed := True;


  try

    Result :=
      CreateDocumentCardFrameFrom(
        ViewModel, DocumentUsageEmployeeAccessRightsInfo
      );

  finally

    FreeAndNil(DocumentUsageEmployeeAccessRightsInfo);

  end;

end;

function TDocumentCardFrameFactory.CreateEmptyNoActivedDocumentCardFrame: TDocumentCardFrame;
begin

  Result := CreateDocumentCardFrameForView(nil);

  Result.HideFooterButtonPanel;

end;

procedure TDocumentCardFrameFactory.
  CreateSheetsAndInflateToDocumentCardFrame(
    DocumentCardFrame: TDocumentCardFrame;
    const ViewModel: TDocumentCardFormViewModel;
    DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
  );
var DocumentMainInformationForm: TDocumentMainInformationFrame;
    DocumentApprovingsForm: TDocumentApprovingsFrame;
    DocumentChargesForm: TDocumentChargesFrame;
    DocumentRelationsForm: TDocumentRelationsFrame;
    DocumentFilesForm: TDocumentFilesFrame;
    DocumentFilesViewForm: TDocumentFilesViewFrame;

    DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel;
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel;
    DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel;
    DocumentFilesFormViewModel: TDocumentFilesFormViewModel;
    DocumentFilesViewFormViewModel: TDocumentFilesViewFormViewModel;
    DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel;
begin

  if Assigned(ViewModel) then begin

    DocumentMainInformationFormViewModel := ViewModel.DocumentMainInformationFormViewModel;
    DocumentChargesFormViewModel := ViewModel.DocumentChargesFormViewModel;
    DocumentRelationsFormViewModel := ViewModel.DocumentRelationsFormViewModel;
    DocumentFilesFormViewModel := ViewModel.DocumentFilesFormViewModel;
    DocumentFilesViewFormViewModel := ViewModel.DocumentFilesViewFormViewModel;
    DocumentApprovingsFormViewModel := ViewModel.DocumentApprovingsFormViewModel;
  
  end

  else begin

    DocumentMainInformationFormViewModel := nil;
    DocumentChargesFormViewModel := nil;
    DocumentRelationsFormViewModel := nil;
    DocumentFilesFormViewModel := nil;
    DocumentFilesViewFormViewModel := nil;
    DocumentApprovingsFormViewModel := nil;

  end;

  DocumentMainInformationForm :=
    CreateDocumentMainInformationFrame(
      DocumentMainInformationFormViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  DocumentCardFrame.InsertComponent(DocumentMainInformationForm);

  DocumentCardFrame.AssignDocumentMainInformationFrame(
    DocumentMainInformationForm
  );

  DocumentApprovingsForm :=
    CreateDocumentApprovingsFrame(
      DocumentApprovingsFormViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  if Assigned(DocumentApprovingsForm) then begin

    DocumentCardFrame.InsertComponent(DocumentApprovingsForm);

    DocumentCardFrame.AssignDocumentApprovingsFrame(DocumentApprovingsForm);

  end;

  if
    not Assigned(DocumentUsageEmployeeAccessRightsInfoDTO)
    or
    not Assigned(
      DocumentUsageEmployeeAccessRightsInfoDTO
        .DocumentChargeSheetsAccessRightsInfoDTO
    )
    or
    not DocumentUsageEmployeeAccessRightsInfoDTO
          .DocumentChargeSheetsAccessRightsInfoDTO
            .AnyChargeSheetsCanBeViewed
  then begin
  
    DocumentChargesForm :=
      CreateDocumentChargesFrame(
        DocumentChargesFormViewModel,
        DocumentUsageEmployeeAccessRightsInfoDTO
      );

  end

  else begin

    DocumentChargesForm :=
      CreateDocumentChargeSheetsFrame(
        DocumentChargesFormViewModel,
        DocumentUsageEmployeeAccessRightsInfoDTO
      );
    
  end;

  DocumentCardFrame.InsertComponent(DocumentChargesForm);

  DocumentCardFrame.AssignDocumentChargesFrame(DocumentChargesForm);

  DocumentRelationsForm :=
    CreateDocumentRelationsFrame(
      DocumentRelationsFormViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  DocumentCardFrame.InsertComponent(DocumentRelationsForm);
                                      
  DocumentCardFrame.AssignDocumentRelationsFrame(DocumentRelationsForm);

  DocumentFilesForm :=
    CreateDocumentFilesFrame(
      DocumentFilesFormViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  DocumentCardFrame.InsertComponent(DocumentFilesForm);

  DocumentCardFrame.AssignDocumentFilesFrame(DocumentFilesForm);

  DocumentFilesViewForm :=
    CreateDocumentFilesViewFrame(
      DocumentFilesViewFormViewModel,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );

  DocumentCardFrame.InsertComponent(DocumentFilesViewForm);

  DocumentCardFrame.AssignDocumentFilesViewFrame(DocumentFilesViewForm);

end;

procedure TDocumentCardFrameFactory.CreateSigningDocumentSendingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeSentToSigning
    or
    DocumentUsageEmployeeAccessRightsInfoDTO.EmployeeHasRightsForSendingToSigning
  then begin

    DocumentOperationToolBarFrame.
      CreateSigningDocumentSendingTool('Отправить на подпись');

  end;
  
end;

function TDocumentCardFrameFactory.CreateDocumentCardFrameInstanceBy(
  DocumentUsageEmployeeAccessRightsInfoDTO:
    TDocumentUsageEmployeeAccessRightsInfoDTO
  ): TDocumentCardFrame;
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.AllDocumentAndChargeSheetsAccessRightsAbsent
  then begin

    Raise Exception.Create(
      'Не удалось создать карточку документа ' +
      'из-за отсутствия необходимых прав доступа'
    );

  end;

  if DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeViewedOnly
  then begin

    Result := CreateDocumentCardFrameInstanceForView;
    
  end

  else begin

    Result :=
      CreateDefaultDocumentCardFrameInstance(
        DocumentUsageEmployeeAccessRightsInfoDTO
      );

  end;

end;

function TDocumentCardFrameFactory.
  CreateDocumentCardFrameInstanceForNewDocumentCreating(
    EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
  ): TDocumentCardFrame;
begin

  Result := CreateDefaultDocumentCardFrameInstance;

  Result.RestoreUIControlPropertiesEnabled := False;
  Result.SaveUIControlPropertiesEnabled := False;

end;

function TDocumentCardFrameFactory.CreateDocumentCardFrameInstanceForNewDocumentCreating(
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Result := CreateDefaultDocumentCardFrameInstance(DocumentUsageEmployeeAccessRightsInfoDTO);

  Result.RestoreUIControlPropertiesEnabled := False;
  Result.SaveUIControlPropertiesEnabled := False;

end;

function TDocumentCardFrameFactory.CreateDocumentCardFrameInstanceForView: TDocumentCardFrame;
begin

  Result := CreateDefaultDocumentCardFrameInstance;

  Result.ViewOnly := True;
  
end;

function TDocumentCardFrameFactory.CreateDocumentMainInformationFrameInstance: TDocumentMainInformationFrame;
begin

  Result := TExtendedDocumentMainInformationFrame.Create(nil);

end;

procedure TDocumentCardFrameFactory.CreateDocumentNotApprovingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeRejectedFromApproving
  then begin

    DocumentOperationToolBarFrame.CreateDocumentNotApprovingTool('Не согласовать');

  end;
  
end;

function TDocumentCardFrameFactory.CreateDocumentFilesFrameInstance: TDocumentFilesFrame;
begin

  Result := TDocumentFilesFrame.Create(nil);
  
end;

function TDocumentCardFrameFactory.CreateDocumentFilesViewFrameInstance: TDocumentFilesViewFrame;
begin

  Result :=
    TDocumentFilesViewFrame.Create(
      nil,
      TDocumentFlowPDFViewForm.Create(nil),
      False
    );

end;

function TDocumentCardFrameFactory.CreateDocumentRelationsFrameInstance:
  TDocumentRelationsFrame;
begin

  Result := TDocumentRelationsFrame.Create(nil);

  Result.AssignDocumentRelationsTableForm(
    TDocumentRelationsReferenceForm.Create(nil)
  );
  
end;

procedure TDocumentCardFrameFactory.CreateDocumentSavingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.CanBeChangedDocumentApproverList
    or
    DocumentUsageEmployeeAccessRightsInfoDTO.CanBeChangedDocumentApproversInfo
    or
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeChanged
  then begin

    DocumentOperationToolBarFrame.CreateDocumentSavingTool('Сохранить');

  end;
  
end;

procedure TDocumentCardFrameFactory.CreateDocumentSigningMarkingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
);
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeMarkedAsSigned or
    DocumentUsageEmployeeAccessRightsInfoDTO.EmployeeHasRightsForSigningMarking
  then begin

    DocumentOperationToolBarFrame.CreateDocumentSigningMarkingTool('Подписан')

  end;
  
end;

procedure TDocumentCardFrameFactory.CreateDocumentSigningRejectingToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeRejectedFromSigning
  then begin

    DocumentOperationToolBarFrame.CreateDocumentSigningRejectingTool('Отклонить');

  end;
  
end;

procedure TDocumentCardFrameFactory.CreateDocumentSigningToolFor(
  DocumentOperationToolBarFrame: TDocumentOperationToolBarFrame;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  if 
    DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeSigned
    or
    DocumentUsageEmployeeAccessRightsInfoDTO.EmployeeHasRightsForSigning
  then begin

    DocumentOperationToolBarFrame.CreateDocumentSigningTool('Подписать');

  end;
  
end;

function TDocumentCardFrameFactory.CreateDocumentChargesFrameInstance: TDocumentChargesFrame;
begin

  Result := TDocumentChargesFrame.Create(nil);

end;

function TDocumentCardFrameFactory.CreateDocumentChargeSheetsFrameInstance: TDocumentChargesFrame;
begin

  Result := TDocumentChargeSheetsFrame.Create(nil);
  
end;

function TDocumentCardFrameFactory.CreateDocumentFilesFrame(
  DocumentFilesFormViewModel: TDocumentFilesFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentFilesFrame;
begin

  Result := CreateDocumentFilesFrameInstance;

  Result.AssignDocumentFilesTableForm(
    TDocumentFilesReferenceForm.Create(nil)
  );

  if Assigned(DocumentUsageEmployeeAccessRightsInfoDTO) then begin

    if DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeChanged then
      Result.ViewOnly := False

    else Result.ViewOnly := True;

  end;

end;

function TDocumentCardFrameFactory.CreateDocumentFilesViewFrame(
  DocumentFilesViewFormViewModel: TDocumentFilesViewFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentFilesViewFrame;
begin

  Result := CreateDocumentFilesViewFrameInstance;

  Result.DocumentFileListVisible := False;

end;

function TDocumentCardFrameFactory.CreateDocumentMainInformationFrame(
  DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentMainInformationFrame;
begin

  Result := CreateDocumentMainInformationFrameInstance;

  if Assigned(DocumentUsageEmployeeAccessRightsInfoDTO) then begin

    if DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeChanged then
      Result.ViewOnly := False

    else Result.ViewOnly := True;

    if Assigned(DocumentMainInformationFormViewModel) then begin

      DocumentMainInformationFormViewModel.NumberPrefixPattern :=
        DocumentUsageEmployeeAccessRightsInfoDTO.NumberPrefixPattern;

    end;

    Result.DocumentNumberReadOnly :=
      not DocumentUsageEmployeeAccessRightsInfoDTO.NumberCanBeChanged;
      
    Result.AsSelfRegisteredDocumentMarkingToolEnabled :=
      DocumentUsageEmployeeAccessRightsInfoDTO
        .DocumentCanBeMarkedAsSelfRegistered;

  end;

end;

function TDocumentCardFrameFactory.CreateDocumentChargesFrame(

  DocumentChargesFormViewModel: TDocumentChargesFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO

): TDocumentChargesFrame;
begin

  Result := CreateDocumentChargesFrameInstance;

  if Assigned(DocumentUsageEmployeeAccessRightsInfoDTO) then begin

    if DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeChanged then
      Result.ViewOnly := False

    else Result.ViewOnly := True;

  end;

end;

function TDocumentCardFrameFactory.CreateDocumentChargeSheetsFrame(
  DocumentChargesFormViewModel: TDocumentChargesFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentChargesFrame;
begin

  Result := CreateDocumentChargeSheetsFrameInstance;

  if not Assigned(DocumentUsageEmployeeAccessRightsInfoDTO) then Exit;

  with
    TDocumentChargeSheetsFrame(Result),
    DocumentUsageEmployeeAccessRightsInfoDTO
      .DocumentChargeSheetsAccessRightsInfoDTO
  do begin

    IssuingChargeSheetToolVisible := AnyChargeSheetsCanBeIssued;
    RemovingChargeToolVisible := AnyChargeSheetsCanBeIssued or AnyChargeSheetsCanBeRemoved;

    SaveChargeSheetChangesToolVisible :=
      AnyChargeSheetsCanBeIssued or
      AnyChargeSheetsCanBeChanged or
      AnyChargeSheetsCanBeRemoved;

    ViewOnly := not SaveChargeSheetChangesToolVisible;
    
  end;
  
end;

function TDocumentCardFrameFactory.CreateDocumentRelationsFrame(
  DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentRelationsFrame;
begin

  Result := CreateDocumentRelationsFrameInstance;

  if Assigned(DocumentUsageEmployeeAccessRightsInfoDTO) then begin

    if DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeChanged then
      Result.ViewOnly := False

    else Result.ViewOnly := True;

  end;
  
end;

{ TDocumentCardFrameFactoryOptions }

function TDocumentCardFrameFactoryOptions.ApprovingSheetPrintToolRequired: Boolean;
begin

  Result := FApprovingSheetPrintToolRequired;
  
end;

function TDocumentCardFrameFactoryOptions.ApprovingSheetPrintToolRequired(
  const Value: Boolean): IDocumentCardFrameFactoryOptions;
begin

  FApprovingSheetPrintToolRequired := Value;

  Result := Self;
  
end;

function TDocumentCardFrameFactoryOptions.DocumentFormPrintToolRequired: Boolean;
begin

  Result := FDocumentFormPrintToolRequired;

end;

function TDocumentCardFrameFactoryOptions.DocumentFormPrintToolRequired(
  const Value: Boolean): IDocumentCardFrameFactoryOptions;
begin

  FDocumentFormPrintToolRequired := Value;

  Result := Self;
  
end;

end.

