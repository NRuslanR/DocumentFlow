unit DocumentCardFormViewModelMapper;

interface

uses

  DocumentCreatingDefaultInfoDTO,
  DocumentCardFormViewModel,
  DocumentMainInformationFormViewModelUnit,
  DocumentRelationsFormViewModelUnit,
  DocumentFilesFormViewModelUnit,
  DocumentChargesFormViewModelUnit,
  DocumentMainInformationFormViewModelMapper,
  DocumentChargesFormViewModelMapper,
  DocumentChargeSheetsFormViewModelMapper,
  DocumentRelationsFormViewModelMapper,
  DocumentFilesFormViewModelMapper,
  DocumentChargeSetHolder,
  DocumentRelationSetHolder,
  DocumentFileSetHolder,
  DocumentApprovingCycleSetHolder,
  IncomingDocumentMainInformationFormViewModelMapper,
  DocumentApprovingsFormViewModelMapper,
  DocumentFilesViewFormViewModelMapper,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentFilesViewFrameUnit,
  DocumentFullInfoDTO,
  ChangedDocumentInfoDTO,
  NewDocumentInfoDTO,
  LoodsmanDocumentUploadingInfo,
  LoodsmanDocumentUploadingInfoFormViewModelMapper,
  LoodsmanDocumentUploadingInfoFormViewModel,
  SysUtils,
  Classes;

type

  TDocumentCardFormViewModelMapper = class

    private

    protected

      FMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
      FChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
      FChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
      FRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
      FFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
      FApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
      FFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper;
      FLoodsmanDocumentUploadingInfoFormViewModelMapper: TLoodsmanDocumentUploadingInfoFormViewModelMapper;
      
    protected

      function CreateDocumentCardFormViewModelInstance:
        TDocumentCardFormViewModel; virtual;

      function CreateChangedDocumentInfoDTOInstance:
        TChangedDocumentInfoDTO; virtual;

      function CreateNewDocumentInfoDTOInstance:
        TNewDocumentInfoDTO; virtual;

    protected

      function GetChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper; virtual;
      function GetDocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper; virtual;
      function GetFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper; virtual;
      function GetMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper; virtual;
      function GetRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper; virtual;
      function GetChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
      function GetFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper;

      procedure SetChargesFormViewModelMapper(
        const Value: TDocumentChargesFormViewModelMapper); virtual;

      procedure SetDocumentApprovingsFormViewModelMapper(
        const Value: TDocumentApprovingsFormViewModelMapper); virtual;

      procedure SetFilesFormViewModelMapper(
        const Value: TDocumentFilesFormViewModelMapper); virtual;

      procedure SetMainInformationFormViewModelMapper(
        const Value: TDocumentMainInformationFormViewModelMapper); virtual;
        
      procedure SetRelationsFormViewModelMapper(
        const Value: TDocumentRelationsFormViewModelMapper); virtual;

      procedure SetChargeSheetsFormViewModelMapper(
        const Value: TDocumentChargeSheetsFormViewModelMapper
      );

      procedure SetFilesViewFormViewModelMapper(
        const Value: TDocumentFilesViewFormViewModelMapper
      );

    public

      constructor Create; overload;

      constructor Create(
        MainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
        ChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
        ChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
        RelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
        FilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
        ApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
        FilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper
      ); overload;
      
      destructor Destroy; override;

      function MapDocumentCardFormViewModelFrom(
      
        DocumentFullInfoDTO: TDocumentFullInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO

      ): TDocumentCardFormViewModel; overload; virtual;

      function MapDocumentCardFormViewModelFrom(
      
        DocumentFullInfoDTO: TDocumentFullInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
        LoodsmanDocumentUploadingInfo: TLoodsmanDocumentUploadingInfo

      ): TDocumentCardFormViewModel; overload; virtual;

      function MapLoodsmanDocumentUploadingInfoFormViewModel(
        LoodsmanDocumentUploadingInfo: TLoodsmanDocumentUploadingInfo
      ): TLoodsmanDocumentUploadingInfoFormViewModel;
      
      function MapNewDocumentCardFormViewModelFrom(
      
        DocumentFullInfoDTO: TDocumentFullInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO

      ): TDocumentCardFormViewModel; virtual;
      
      function MapDocumentCardFormViewModelToChangedDocumentInfoDTO(
        DocumentCardViewModel: TDocumentCardFormViewModel
      ): TChangedDocumentInfoDTO; virtual;

      function MapDocumentCardFormViewModelToNewDocumentInfoDTO(
        DocumentCardViewModel: TDocumentCardFormViewModel
      ): TNewDocumentInfoDTO; virtual;

    public

      property MainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper
      read GetMainInformationFormViewModelMapper write SetMainInformationFormViewModelMapper;

      property ChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper
      read GetChargesFormViewModelMapper write SetChargesFormViewModelMapper;

      property ChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper
      read GetChargeSheetsFormViewModelMapper write SetChargeSheetsFormViewModelMapper;
      
      property RelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper
      read GetRelationsFormViewModelMapper write SetRelationsFormViewModelMapper;
    
      property FilesFormViewModelMapper: TDocumentFilesFormViewModelMapper
      read GetFilesFormViewModelMapper write SetFilesFormViewModelMapper;

      property FilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper
      read GetFilesViewFormViewModelMapper write SetFilesViewFormViewModelMapper;

      property DocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper
      read GetDocumentApprovingsFormViewModelMapper write SetDocumentApprovingsFormViewModelMapper;
      
  end;

implementation

{ TDocumentCardFormViewModelMapper }

constructor TDocumentCardFormViewModelMapper.Create;
begin

  inherited;

end;

constructor TDocumentCardFormViewModelMapper.Create(
  MainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
  ChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
  ChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
  RelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
  FilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
  ApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
  FilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper
);
begin

  inherited Create;

  FMainInformationFormViewModelMapper := MainInformationFormViewModelMapper;
  FChargesFormViewModelMapper := ChargesFormViewModelMapper;
  FChargeSheetsFormViewModelMapper := ChargeSheetsFormViewModelMapper;
  FRelationsFormViewModelMapper := RelationsFormViewModelMapper;
  FFilesFormViewModelMapper := FilesFormViewModelMapper;
  FApprovingsFormViewModelMapper := ApprovingsFormViewModelMapper;
  FFilesViewFormViewModelMapper := FilesViewFormViewModelMapper;

  FLoodsmanDocumentUploadingInfoFormViewModelMapper := TLoodsmanDocumentUploadingInfoFormViewModelMapper.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateChangedDocumentInfoDTOInstance: TChangedDocumentInfoDTO;
begin

  Result := TChangedDocumentInfoDTO.Create;

end;

function TDocumentCardFormViewModelMapper.CreateDocumentCardFormViewModelInstance: TDocumentCardFormViewModel;
begin

  Result := TDocumentCardFormViewModel.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateNewDocumentInfoDTOInstance: TNewDocumentInfoDTO;
begin

  Result := TNewDocumentInfoDTO.Create;
  
end;

destructor TDocumentCardFormViewModelMapper.Destroy;
begin

  FreeAndNil(FFilesViewFormViewModelMapper);
  FreeAndNil(FMainInformationFormViewModelMapper);
  FreeAndNil(FChargesFormViewModelMapper);
  FreeAndNil(FRelationsFormViewModelMapper);
  FreeAndNil(FFilesFormViewModelMapper);
  FreeAndNil(FApprovingsFormViewModelMapper);
  FreeAndNil(FLoodsmanDocumentUploadingInfoFormViewModelMapper);
  
  inherited;

end;

function TDocumentCardFormViewModelMapper.GetChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
begin

  Result := FChargesFormViewModelMapper;
  
end;

function TDocumentCardFormViewModelMapper.GetChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
begin

  Result := FChargeSheetsFormViewModelMapper;

end;

function TDocumentCardFormViewModelMapper.GetDocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
begin

  Result := FApprovingsFormViewModelMapper;
  
end;

function TDocumentCardFormViewModelMapper.GetFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
begin

  Result := FFilesFormViewModelMapper;

end;

function TDocumentCardFormViewModelMapper.GetFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper;
begin

  Result := FFilesViewFormViewModelMapper;

end;

function TDocumentCardFormViewModelMapper.GetMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result := FMainInformationFormViewModelMapper;
  
end;

function TDocumentCardFormViewModelMapper.GetRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
begin

  Result := FRelationsFormViewModelMapper;
  
end;

function TDocumentCardFormViewModelMapper.MapDocumentCardFormViewModelFrom(
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFormViewModel;
begin

  Result :=
    MapDocumentCardFormViewModelFrom(
      DocumentFullInfoDTO,
      DocumentUsageEmployeeAccessRightsInfoDTO,
      nil
    );

end;

function TDocumentCardFormViewModelMapper.MapDocumentCardFormViewModelFrom(

  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
  LoodsmanDocumentUploadingInfo: TLoodsmanDocumentUploadingInfo
  
): TDocumentCardFormViewModel;
begin

  Result := CreateDocumentCardFormViewModelInstance;
                          
  try

    Result.DocumentMainInformationFormViewModel :=

      FMainInformationFormViewModelMapper.
        MapDocumentMainInformationFormViewModelFrom(
          DocumentFullInfoDTO.DocumentDTO
        );
    
    Result.DocumentFilesFormViewModel :=

      FFilesFormViewModelMapper.MapDocumentFilesFormViewModelFrom(
        DocumentFullInfoDTO.DocumentFilesInfoDTO
      );

    Result.DocumentChargesFormViewModel :=

      FChargesFormViewModelMapper.MapDocumentChargesFormViewModelFrom(
        DocumentFullInfoDTO.DocumentDTO,
        DocumentFullInfoDTO.DocumentDTO.ChargesInfoDTO
      );

    Result.DocumentChargeSheetsFormViewModel :=
      FChargeSheetsFormViewModelMapper.MapDocumentChargeSheetsFormViewModelFrom(
        DocumentFullInfoDTO.DocumentDTO,
        DocumentFullInfoDTO.DocumentChargeSheetsInfoDTO,
        DocumentUsageEmployeeAccessRightsInfoDTO.DocumentChargeSheetsAccessRightsInfoDTO
      );

    Result.DocumentRelationsFormViewModel :=

      FRelationsFormViewModelMapper.MapDocumentRelationsFormViewModelFrom(
        DocumentFullInfoDTO.DocumentRelationsInfoDTO
      );

    Result.DocumentApprovingsFormViewModel :=
      FApprovingsFormViewModelMapper.MapDocumentApprovingsFormViewModelFrom(
        DocumentFullInfoDTO.DocumentDTO.ApprovingsInfoDTO,
        DocumentFullInfoDTO.DocumentApprovingCycleResultsInfoDTO,
        DocumentUsageEmployeeAccessRightsInfoDTO
      );

    Result.DocumentFilesViewFormViewModel :=
      FFilesViewFormViewModelMapper.MapDocumentFilesViewFormViewModelFrom(
        DocumentFullInfoDTO.DocumentFilesInfoDTO
      );

    Result.DocumentRemoveToolEnabled :=
      DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeRemoved;

    if not Assigned(LoodsmanDocumentUploadingInfo) then Exit;

    Result.LoodsmanDocumentUploadingInfoFormViewModel :=
      MapLoodsmanDocumentUploadingInfoFormViewModel(LoodsmanDocumentUploadingInfo);

  except

    FreeAndNil(Result);
      
    Raise;

  end;

end;

function TDocumentCardFormViewModelMapper.MapNewDocumentCardFormViewModelFrom(
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFormViewModel;
begin

  Result := MapDocumentCardFormViewModelFrom(DocumentFullInfoDTO, DocumentUsageEmployeeAccessRightsInfoDTO);

  with Result.DocumentChargesFormViewModel.DocumentChargeSetHolder do begin

    while not Eof do begin

      MarkCurrentRecordAsAdded;
      
      Next;

    end;

    First;

  end;

end;

function TDocumentCardFormViewModelMapper.
  MapDocumentCardFormViewModelToChangedDocumentInfoDTO(
    DocumentCardViewModel: TDocumentCardFormViewModel
  ): TChangedDocumentInfoDTO;
begin

  Result := CreateChangedDocumentInfoDTOInstance;

  try

    Result.ChangedDocumentDTO :=
      FMainInformationFormViewModelMapper.
        MapDocumentMainInformationFormViewModelToChangedDocumentDTO(
          DocumentCardViewModel.DocumentMainInformationFormViewModel
        );

    Result.ChangedDocumentDTO.ApprovingsInfoDTO :=

      FApprovingsFormViewModelMapper.
        MapDocumentApprovingsFormViewModelTo(
          DocumentCardViewModel.DocumentApprovingsFormViewModel
        );

    Result.
      ChangedDocumentDTO.
        ChargesChangesInfoDTO :=
        
          FChargesFormViewModelMapper.
            MapDocumentChargesFormViewModelToChargeChangesInfoDTO(
              DocumentCardViewModel.DocumentChargesFormViewModel
            );

    Result.ChangedDocumentRelationsInfoDTO :=
      FRelationsFormViewModelMapper.MapDocumentRelationsFormViewModelTo(
        DocumentCardViewModel.DocumentRelationsFormViewModel
      );

    Result.ChangedDocumentFilesInfoDTO :=
      FFilesFormViewModelMapper.MapDocumentFilesFormViewModelTo(
        DocumentCardViewModel.DocumentFilesFormViewModel
      );
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentCardFormViewModelMapper.
  MapDocumentCardFormViewModelToNewDocumentInfoDTO(
    DocumentCardViewModel: TDocumentCardFormViewModel
  ): TNewDocumentInfoDTO;
begin

  Result := CreateNewDocumentInfoDTOInstance;

  try

    Result.DocumentDTO :=

      FMainInformationFormViewModelMapper.
        MapDocumentMainInformationFormViewModelToNewDocumentDTO(
          DocumentCardViewModel.DocumentMainInformationFormViewModel
        );

    Result.DocumentDTO.ApprovingsInfoDTO :=

      FApprovingsFormViewModelMapper.
        MapDocumentApprovingsFormViewModelTo(
          DocumentCardViewModel.DocumentApprovingsFormViewModel
        );

    Result.
      DocumentDTO.
        ChargesInfoDTO :=

          FChargesFormViewModelMapper.
            MapDocumentChargesFormViewModelToNewChargesInfoDTO(
              DocumentCardViewModel.DocumentChargesFormViewModel
            );

    Result.DocumentRelationsInfoDTO :=
      FRelationsFormViewModelMapper.MapDocumentRelationsFormViewModelTo(
        DocumentCardViewModel.DocumentRelationsFormViewModel
      );

    Result.DocumentFilesInfoDTO :=
      FFilesFormViewModelMapper.MapDocumentFilesFormViewModelTo(
        DocumentCardViewModel.DocumentFilesFormViewModel
      );
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentCardFormViewModelMapper
  .MapLoodsmanDocumentUploadingInfoFormViewModel(
    LoodsmanDocumentUploadingInfo: TLoodsmanDocumentUploadingInfo
  ): TLoodsmanDocumentUploadingInfoFormViewModel;
begin

  Result :=
    FLoodsmanDocumentUploadingInfoFormViewModelMapper
      .MapLoodsmanDocumentUploadingInfoFormViewModel(LoodsmanDocumentUploadingInfo);
      
end;

procedure TDocumentCardFormViewModelMapper.SetChargesFormViewModelMapper(
  const Value: TDocumentChargesFormViewModelMapper);
begin

  FreeAndNil(FChargesFormViewModelMapper);

  FChargesFormViewModelMapper := Value;
  
end;

procedure TDocumentCardFormViewModelMapper.SetChargeSheetsFormViewModelMapper(
  const Value: TDocumentChargeSheetsFormViewModelMapper);
begin

  FreeAndNil(FChargeSheetsFormViewModelMapper);

  FChargeSheetsFormViewModelMapper := Value;
  
end;

procedure TDocumentCardFormViewModelMapper.SetDocumentApprovingsFormViewModelMapper(
  const Value: TDocumentApprovingsFormViewModelMapper);
begin

  FreeAndNil(FApprovingsFormViewModelMapper);

  FApprovingsFormViewModelMapper := Value;
  
end;

procedure TDocumentCardFormViewModelMapper.SetFilesFormViewModelMapper(
  const Value: TDocumentFilesFormViewModelMapper);
begin

  FreeAndNil(FFilesFormViewModelMapper);

  FFilesFormViewModelMapper := Value;
  
end;

procedure TDocumentCardFormViewModelMapper.SetFilesViewFormViewModelMapper(
  const Value: TDocumentFilesViewFormViewModelMapper);
begin

  FreeAndNil(FFilesViewFormViewModelMapper);

  FFilesViewFormViewModelMapper := Value;
  
end;

procedure TDocumentCardFormViewModelMapper.SetMainInformationFormViewModelMapper(
  const Value: TDocumentMainInformationFormViewModelMapper);
begin

  FreeAndNil(FMainInformationFormViewModelMapper);

  FMainInformationFormViewModelMapper := Value;
  
end;

procedure TDocumentCardFormViewModelMapper.SetRelationsFormViewModelMapper(
  const Value: TDocumentRelationsFormViewModelMapper);
begin

  FreeAndNil(FApprovingsFormViewModelMapper);

  FRelationsFormViewModelMapper := Value;
  
end;

end.
