unit DocumentChargeSheetsFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  ChangedDocumentInfoDTO,
  DocumentChargeSheetsFormViewModel,
  DocumentChargeSetHolder,
  DocumentChargeSheetSetHolder,
  DocumentChargeKindsControlAppService,
  DocumentChargesFormViewModelMapper,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentChargeSheetsChangesInfoDTO,
  DocumentChargeSheetSetHolderFactory,
  SysUtils,
  Classes,
  DB;

type

  TDocumentChargeSheetsFormViewModelMapper = class

    protected

      FDocumentChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
      FDocumentChargeSheetSetHolderFactory: IDocumentChargeSheetSetHolderFactory;
      
    protected

      function CreateDocumentChargeSheetsFormViewModelInstance:
        TDocumentChargeSheetsFormViewModel; virtual;

    protected

      procedure FillDocumentChargeSheetSetHolderFrom(
        DocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;
		    DocumentDTO: TDocumentDTO;
        DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
      );

    protected

      function MapDocumentChargeSheetsFormViewModelToAddedChargeSheetsInfoDTO(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
        AddedChargesInfoDTO: TDocumentChargesInfoDTO
      ): TDocumentChargeSheetsInfoDTO;

      function MapDocumentChargeSheetsFormViewModelToChangedChargeSheetsInfoDTO(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
        ChangedChargesInfoDTO: TDocumentChargesInfoDTO
      ): TDocumentChargeSheetsInfoDTO;

      function MapDocumentChargeSheetsFormViewModelToRemovedChargeSheetsInfoDTO(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
        RemovedChargesInfoDTO: TDocumentChargesInfoDTO
      ): TDocumentChargeSheetsInfoDTO;

      function MapDocumentChargeSheetsFormViewModelToChargeSheetsInfoDTO(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
        ChargesInfoDTO: TDocumentChargesInfoDTO
      ): TDocumentChargeSheetsInfoDTO;

    public

      constructor Create(
        DocumentChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
        DocumentChargeSheetSetHolderFactory: IDocumentChargeSheetSetHolderFactory
      );
      
      function MapDocumentChargeSheetsFormViewModelFrom(
        DocumentDTO: TDocumentDTO;
        DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
        DocumentChargeSheetsAccessRightsInfoDTO: TDocumentChargeSheetsAccessRightsInfoDTO
      ): TDocumentChargeSheetsFormViewModel; virtual;

      function MapDocumentChargeSheetsFormViewModelToChargeSheetsChangesInfoDTO(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      ): TDocumentChargeSheetsChangesInfoDTO; virtual;

      function CreateEmptyDocumentChargeSheetsFormViewModel(
        const DocumentKindId: Variant 
      ): TDocumentChargeSheetsFormViewModel; virtual;

  end;
  
implementation

uses

  AuxDebugFunctionsUnit,
  Variants, AbstractDataSetHolder;
  
{ TDocumentChargeSheetsFormViewModelMapper }

constructor TDocumentChargeSheetsFormViewModelMapper.Create(
  DocumentChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
  DocumentChargeSheetSetHolderFactory: IDocumentChargeSheetSetHolderFactory
);
begin

  inherited Create;

  FDocumentChargesFormViewModelMapper := DocumentChargesFormViewModelMapper;
  FDocumentChargeSheetSetHolderFactory := DocumentChargeSheetSetHolderFactory;

end;

function TDocumentChargeSheetsFormViewModelMapper.
  MapDocumentChargeSheetsFormViewModelFrom(
    DocumentDTO: TDocumentDTO;
    DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    DocumentChargeSheetsAccessRightsInfoDTO: TDocumentChargeSheetsAccessRightsInfoDTO
  ): TDocumentChargeSheetsFormViewModel;
  
var
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
    FreeDocumentChargesInfoDTO: IInterface;
begin
                                                    
  DocumentChargesInfoDTO := DocumentChargeSheetsInfoDTO.ExtractChargesInfoDTO;

  FreeDocumentChargesInfoDTO := DocumentChargesInfoDTO;

  Result := CreateDocumentChargeSheetsFormViewModelInstance;

  try

    { обдумать необходиомтсь внутренней модели поручений
    , может быть не присваивать её набор данных в набор данных
    листов поручений  }

    Result.ChargesFormViewModel :=
      FDocumentChargesFormViewModelMapper
        .CreateEmptyDocumentChargesFormViewModel(
          DocumentDTO.KindId
        );                                              

    Result.DocumentChargeSheetSetHolder :=
      FDocumentChargeSheetSetHolderFactory.CreateDocumentChargeSheetSetHolder;

    if Assigned(DocumentChargeSheetsAccessRightsInfoDTO) then begin

      Result.DocumentChargeSheetSetHolder.HeadChargeSheetsIssuingAllowed :=
        DocumentChargeSheetsAccessRightsInfoDTO.AnyHeadChargeSheetsCanBeIssued;

    end;

    if
      Assigned(DocumentChargeSheetsInfoDTO) and
      (DocumentChargeSheetsInfoDTO.Count > 0)
    then begin

      FillDocumentChargeSheetSetHolderFrom(
        Result.DocumentChargeSheetSetHolder,
        DocumentDTO,
        DocumentChargeSheetsInfoDTO
      )

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheetsFormViewModelMapper.
  MapDocumentChargeSheetsFormViewModelToChargeSheetsChangesInfoDTO(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
  ): TDocumentChargeSheetsChangesInfoDTO;
var
    ChargesChangesInfoDTO: TDocumentChargesChangesInfoDTO;
begin

  ChargesChangesInfoDTO :=
    FDocumentChargesFormViewModelMapper
      .MapDocumentChargesFormViewModelToChargeChangesInfoDTO(
        DocumentChargeSheetsFormViewModel.ChargesFormViewModel
      );

  try

    try

      Result := TDocumentChargeSheetsChangesInfoDTO.Create;

      Result.AddedDocumentChargeSheetsInfoDTO :=
        MapDocumentChargeSheetsFormViewModelToAddedChargeSheetsInfoDTO(
          DocumentChargeSheetsFormViewModel,
          ChargesChangesInfoDTO.AddedDocumentChargesInfoDTO
        );

      Result.ChangedDocumentChargeSheetsInfoDTO :=
        MapDocumentChargeSheetsFormViewModelToChangedChargeSheetsInfoDTO(
          DocumentChargeSheetsFormViewModel,
          ChargesChangesInfoDTO.ChangedDocumentChargesInfoDTO
        );

      Result.RemovedDocumentChargeSheetsInfoDTO :=
        MapDocumentChargeSheetsFormViewModelToRemovedChargeSheetsInfoDTO(
          DocumentChargeSheetsFormViewModel,
          ChargesChangesInfoDTO.RemovedDocumentChargesInfoDTO
        );

      DocumentChargeSheetsFormViewModel
        .DocumentChargeSetHolder
          .RevealNonRemovedRecords

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(ChargesChangesInfoDTO);
    
  end;

end;

function TDocumentChargeSheetsFormViewModelMapper
  .MapDocumentChargeSheetsFormViewModelToAddedChargeSheetsInfoDTO(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
    AddedChargesInfoDTO: TDocumentChargesInfoDTO
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargeSheetsFormViewModel
    .DocumentChargeSheetSetHolder
      .RevealAddedRecords;

  Result :=
    MapDocumentChargeSheetsFormViewModelToChargeSheetsInfoDTO(
      DocumentChargeSheetsFormViewModel,
      AddedChargesInfoDTO
    );
    
end;

function TDocumentChargeSheetsFormViewModelMapper
  .MapDocumentChargeSheetsFormViewModelToChangedChargeSheetsInfoDTO(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
    ChangedChargesInfoDTO: TDocumentChargesInfoDTO
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargeSheetsFormViewModel
    .DocumentChargeSheetSetHolder
      .RevealChangedRecords;

  Result :=
    MapDocumentChargeSheetsFormViewModelToChargeSheetsInfoDTO(
      DocumentChargeSheetsFormViewModel,
      ChangedChargesInfoDTO
    );

end;

function TDocumentChargeSheetsFormViewModelMapper
  .MapDocumentChargeSheetsFormViewModelToRemovedChargeSheetsInfoDTO(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
    RemovedChargesInfoDTO: TDocumentChargesInfoDTO
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargeSheetsFormViewModel
    .DocumentChargeSheetSetHolder
      .RevealRemovedRecords;

  Result :=
    MapDocumentChargeSheetsFormViewModelToChargeSheetsInfoDTO(
      DocumentChargeSheetsFormViewModel,
      RemovedChargesInfoDTO
    );
    
end;

function TDocumentChargeSheetsFormViewModelMapper
  .MapDocumentChargeSheetsFormViewModelToChargeSheetsInfoDTO(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
    ChargesInfoDTO: TDocumentChargesInfoDTO
  ): TDocumentChargeSheetsInfoDTO;
var
    ChargeInfoDTO: TDocumentChargeInfoDTO;
    ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
    FreeChargeSheetInfoDTO: IInterface;
begin

  Result := TDocumentChargeSheetsInfoDTO.Create;

  try

    for ChargeInfoDTO in ChargesInfoDTO do begin

      ChargeSheetInfoDTO :=
        TDocumentChargeSheetInfoDTO(ChargeInfoDTO.ChargeSheetInfoDTOClass.Create);

      FreeChargeSheetInfoDTO := ChargeSheetInfoDTO;

      Result.Add(ChargeSheetInfoDTO);

      ChargeSheetInfoDTO.ChargeInfoDTO := ChargeInfoDTO;

      with
        ChargeSheetInfoDTO,
        DocumentChargeSheetsFormViewModel.DocumentChargeSheetSetHolder
      do begin

        Locate(ChargeIdFieldName, ChargeInfoDTO.Id);

        Id := IdFieldValue;
        TopLevelChargeSheetId := TopLevelChargeSheetIdFieldValue;
        DocumentId := DocumentIdFieldValue;
        ViewDateByPerformer := ViewDateByPerformerFieldValue;

        IssuerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

        IssuerInfoDTO.Id := IssuerIdFieldValue;
        IssuingDateTime := IssuingDateTimeFieldValue;

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TDocumentChargeSheetsFormViewModelMapper.
  CreateEmptyDocumentChargeSheetsFormViewModel(
    const DocumentKindId: Variant
  ): TDocumentChargeSheetsFormViewModel;
begin

  Result := CreateDocumentChargeSheetsFormViewModelInstance;

  try

    Result.ChargesFormViewModel :=
      FDocumentChargesFormViewModelMapper
        .CreateEmptyDocumentChargesFormViewModel(DocumentKindId);

    Result.DocumentChargeSheetSetHolder :=
      FDocumentChargeSheetSetHolderFactory.CreateDocumentChargeSheetSetHolder;

  except

    FreeAndNil(Result);

  end;

end;

procedure TDocumentChargeSheetsFormViewModelMapper.
  FillDocumentChargeSheetSetHolderFrom(
    DocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;
	  DocumentDTO: TDocumentDTO;
    DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
  );
var
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  with DocumentChargeSheetSetHolder do begin

    for DocumentChargeSheetInfoDTO in DocumentChargeSheetsInfoDTO do begin

      FDocumentChargesFormViewModelMapper
        .FillDocumentChargeSetHolderByChargeInfoDto(
          ChargeSetHolder,
          DocumentChargeSheetInfoDTO.ChargeInfoDTO
        );

      Edit;

      IdFieldValue := DocumentChargeSheetInfoDTO.Id;

      TopLevelChargeSheetIdFieldValue := DocumentChargeSheetInfoDTO.TopLevelChargeSheetId;

      DocumentIdFieldValue := DocumentChargeSheetInfoDTO.DocumentId;

      ViewDateByPerformerFieldValue := DocumentChargeSheetInfoDTO.ViewDateByPerformer;

      with DocumentChargeSheetInfoDTO.AccessRights do begin

        ViewingAllowedFieldValue := ViewingAllowed;
        ChargeSectionAccessibleFieldValue := ChargeSectionAccessible;
        ResponseSectionAccessibleFieldValue := ResponseSectionAccessible;
        RemovingAllowedFieldValue := RemovingAllowed;
        PerformingAllowedFieldValue := PerformingAllowed;
        IsEmployeePerformerFieldValue := IsEmployeePerformer;
        SubordinateChargeSheetsIssuingAllowedFieldValue := SubordinateChargeSheetsIssuingAllowed;

      end;

      IssuerNameFieldValue := DocumentChargeSheetInfoDTO.IssuerInfoDTO.FullName;
      IssuerIdFieldValue := DocumentChargeSheetInfoDTO.IssuerInfoDTO.Id;
      IssuingDateTimeFieldValue := DocumentChargeSheetInfoDTO.IssuingDateTime;

      MarkCurrentRecordAsNonChanged;

      Post;
      
    end;

    First;

  end;

end;

function TDocumentChargeSheetsFormViewModelMapper.
  CreateDocumentChargeSheetsFormViewModelInstance: TDocumentChargeSheetsFormViewModel;
begin

  Result := TDocumentChargeSheetsFormViewModel.Create;

end;

end.
