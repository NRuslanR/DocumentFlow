unit DocumentChargesFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  ChangedDocumentInfoDTO,
  DocumentChargesFormViewModelUnit,
  DocumentChargeSheetsInfoDTO,
  DocumentChargeSetHolder,
  DocumentChargeKindsControlAppService,
  DocumentChargeSetHolderFactory,
  SysUtils,
  Classes,
  DB;

type

  TDocumentChargesFormViewModelMapper = class

    protected

      FDocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService;
      FDocumentChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
      
    protected

      function CreateDocumentChargesFormViewModelInstance:
        TDocumentChargesFormViewModel; virtual;

    protected

      procedure FillDocumentChargeSetHolderFrom(
        DocumentChargeSetHolder: TDocumentChargeSetHolder;
        DocumentChargesInfoDTO: TDocumentChargesInfoDTO
      );

    protected

      function MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

      function MapDocumentChargesFormViewModelToChangedChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

      function MapDocumentChargesFormViewModelToRemovedChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

    public

      constructor Create(
        DocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService;
        DocumentChargeSetHolderFactory: IDocumentChargeSetHolderFactory
      );
      
      function MapDocumentChargesFormViewModelFrom(
	  	  DocumentDTO: TDocumentDTO;
        DocumentChargesInfoDTO: TDocumentChargesInfoDTO
      ): TDocumentChargesFormViewModel; virtual;

      procedure FillDocumentChargeSetHolderByChargeInfoDto(
	  	  DocumentChargeSetHolder: TDocumentChargeSetHolder;
        DocumentChargeInfoDTO: TDocumentChargeInfoDTO
      ); virtual;

      function MapDocumentChargesFormViewModelToChargeChangesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesChangesInfoDTO; virtual;

      function MapDocumentChargesFormViewModelToChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

      function MapDocumentChargesFormViewModelToNewChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO; virtual;

      function CreateEmptyDocumentChargesFormViewModel(
        const DocumentKindId: Variant { refactor: delete, view unDocumentCardListFrame.OnNewDocumentCreatingRequestedEventHandler }
      ): TDocumentChargesFormViewModel; virtual;

  end;
  
implementation

uses

  Variants, AbstractDataSetHolder;
  
{ TDocumentChargesFormViewModelMapper }

constructor TDocumentChargesFormViewModelMapper.Create(
  DocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService;
  DocumentChargeSetHolderFactory: IDocumentChargeSetHolderFactory
);
begin

  inherited Create;

  FDocumentChargeKindsControlAppService := DocumentChargeKindsControlAppService;
  FDocumentChargeSetHolderFactory := DocumentChargeSetHolderFactory;
  
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelFrom(
  	DocumentDTO: TDocumentDTO;
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO
  ): TDocumentChargesFormViewModel;
  

begin

  Result := CreateEmptyDocumentChargesFormViewModel(DocumentDTO.KindId);

  if
    not Assigned(DocumentChargesInfoDTO)
    or (DocumentChargesInfoDTO.Count = 0)
  then Exit;

  FillDocumentChargeSetHolderFrom(
    Result.DocumentChargeSetHolder,
    DocumentChargesInfoDTO
  );

end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToChargeChangesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesChangesInfoDTO;
begin

  try

    Result := TDocumentChargesChangesInfoDTO.Create;
    
    Result.AddedDocumentChargesInfoDTO :=
      MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
        DocumentChargesFormViewModel
      );

    Result.ChangedDocumentChargesInfoDTO :=
      MapDocumentChargesFormViewModelToChangedChargesInfoDTO(
        DocumentChargesFormViewModel
      );

    Result.RemovedDocumentChargesInfoDTO :=
      MapDocumentChargesFormViewModelToRemovedChargesInfoDTO(
        DocumentChargesFormViewModel
      );

    DocumentChargesFormViewModel.
      DocumentChargeSetHolder.
        RevealNonRemovedRecords;

  except

    FreeAndNil(Result);

    raise;

  end;

end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToNewChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  Result :=
    MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
      DocumentChargesFormViewModel
    );

end;

procedure TDocumentChargesFormViewModelMapper.FillDocumentChargeSetHolderByChargeInfoDto(
  DocumentChargeSetHolder: TDocumentChargeSetHolder;
  DocumentChargeInfoDTO: TDocumentChargeInfoDTO
);
begin

  with DocumentChargeSetHolder do begin

    AppendWithoutRecordIdGeneration;

    IdFieldValue := DocumentChargeInfoDTO.Id;

    IsForAcquaitanceFieldValue := DocumentChargeInfoDTO.IsForAcquaitance;

    KindIdFieldValue := DocumentChargeInfoDTO.KindId;

    KindNameFieldValue := DocumentChargeInfoDTO.KindName;

    KindServiceNameFieldValue := DocumentChargeInfoDTO.ServiceKindName;

    PerformerFullNameFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.FullName;

    PerformerSpecialityFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.Speciality;

    PerformerIdFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.Id;

    PerformerDepartmentNameFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name;

    PerformerCommentFieldValue := DocumentChargeInfoDTO.PerformerResponse;

    PerformingDateTimeFieldValue := DocumentChargeInfoDTO.PerformingDateTime;

    ChargeTextFieldValue := DocumentChargeInfoDTO.ChargeText;

    IsPerformerForeignFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.IsForeign;

    CanBeChangedFieldValue := DocumentChargeInfoDTO.AccessRights.ChargeSectionAccessible;
    CanBeRemovedFieldValue := DocumentChargeInfoDTO.AccessRights.RemovingAllowed;

    if Assigned(DocumentChargeInfoDTO.ActuallyPerformedEmployeeInfoDTO)
    then begin

      DocumentChargeSetHolder.ActualPerformerFullNameFieldValue :=
        DocumentChargeInfoDTO.ActuallyPerformedEmployeeInfoDTO.FullName;

    end;

    MarkCurrentRecordAsNonChanged;

    Post;

  end;

end;

procedure TDocumentChargesFormViewModelMapper.
  FillDocumentChargeSetHolderFrom(
    DocumentChargeSetHolder: TDocumentChargeSetHolder;
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO
  );
var
    DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  with DocumentChargeSetHolder do begin

    for DocumentChargeInfoDTO in DocumentChargesInfoDTO do begin

      FillDocumentChargeSetHolderByChargeInfoDto(
        DocumentChargeSetHolder, DocumentChargeInfoDTO
      );

    end;

    First;
    
  end;

end;

function TDocumentChargesFormViewModelMapper.
  CreateEmptyDocumentChargesFormViewModel(
    const DocumentKindId: Variant
  ): TDocumentChargesFormViewModel;
begin

  Result := CreateDocumentChargesFormViewModelInstance;

  Result.DocumentChargeSetHolder :=
    FDocumentChargeSetHolderFactory.CreateDocumentChargeSetHolder;

  Result.DocumentChargeKindDto :=
    FDocumentChargeKindsControlAppService
      .FindMainDocumentChargeKindForDocumentKind(DocumentKindId);
    
end;

function TDocumentChargesFormViewModelMapper.
  CreateDocumentChargesFormViewModelInstance: TDocumentChargesFormViewModel;
begin

  Result := TDocumentChargesFormViewModel.Create;

end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealAddedRecords;

  Result :=
    MapDocumentChargesFormViewModelToChargesInfoDTO(DocumentChargesFormViewModel);
  
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToChangedChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealChangedRecords;

  Result :=
    MapDocumentChargesFormViewModelToChargesInfoDTO(DocumentChargesFormViewModel);
    
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToRemovedChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealRemovedRecords;

  Result :=
    MapDocumentChargesFormViewModelToChargesInfoDTO(DocumentChargesFormViewModel);
    
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
var DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargesInfoDTO.Create;

  try

    with
      DocumentChargesFormViewModel,
      DocumentChargesFormViewModel.DocumentChargeSetHolder
    do begin

      DocumentChargeSetHolder.First;

      while not Eof do begin

        { conditional refactor: см. TDocumentChargesFormViewModel }
        DocumentChargeInfoDTO := DocumentChargeKindDto.ChargeInfoDTOClass.Create;
                                                                 
        Result.Add(DocumentChargeInfoDTO);

        DocumentChargeInfoDTO.Id := IdFieldValue;

        DocumentChargeInfoDTO.KindId := KindIdFieldValue;
        
        DocumentChargeInfoDTO.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

        DocumentChargeInfoDTO.PerformerInfoDTO.FullName := PerformerFullNameFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.Speciality := PerformerSpecialityFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.Id := PerformerIdFieldValue;

        DocumentChargeInfoDTO.IsForAcquaitance := IsForAcquaitanceFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

        DocumentChargeInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name :=
          PerformerDepartmentNameFieldValue;

        DocumentChargeInfoDTO.PerformerResponse :=
          DocumentChargeSetHolder.PerformerCommentFieldValue;
        
        DocumentChargeInfoDTO.PerformingDateTime := PerformingDateTimeFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.IsForeign := IsPerformerForeignFieldValue;

        DocumentChargeInfoDTO.ChargeText := ChargeTextFieldValue;

        Next;
      
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
