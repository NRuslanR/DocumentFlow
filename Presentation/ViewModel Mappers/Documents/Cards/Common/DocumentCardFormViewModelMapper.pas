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
  DocumentRelationsFormViewModelMapper,
  DocumentFilesFormViewModelMapper,
  DocumentChargeSetHolder,
  DocumentRelationSetHolder,
  DocumentFileSetHolder,
  DocumentApprovingCycleSetHolder,
  IncomingDocumentMainInformationFormViewModelMapper,
  DocumentApprovingsFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  DocumentFilesViewFormViewModelMapper,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentFilesViewFrameUnit,
  SysUtils,
  DocumentFullInfoDTO,
  ChangedDocumentInfoDTO,
  NewDocumentInfoDTO,
  Classes;

type

  { refactor: В дальнейшем для входящих доков
    рассмотреть возможность создания модели представления
    не для перечня поручений, а дли перечня листов поручений.
    На данный момент, данные как о первом, так и о другом
    перечне будут храниться в едином наборе данных
    в виде сильной схожести отображения, но
    в дальнейшем могут быть расхождения по составу полей,
    хотя и маловероятно (я думаю), поэтому модель
    представления карточки документа должно вместо
    DocumentChargesFormViewModelMapper содержать объект
    типа DocumentChargeSheetsFormViewModelMapper }

  {
    refactor:
    DataSet Holder'ы передать в конструктор
    через единтсвенный объект, внутри
    которого они бы находились, для
    упрощения интерфейса и сокращения количества
    указываемых модулей }
  TDocumentCardFormViewModelMapper = class

    private
      
    protected

      FMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
      FChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
      FRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
      FFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
      FApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
      FFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper;

    protected

      FDocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;

    protected

      function CreateMainInformationFormViewModelMapper:
        TDocumentMainInformationFormViewModelMapper; virtual;

      function CreateChargesFormViewModelMapper:
        TDocumentChargesFormViewModelMapper; virtual;

      function CreateRelationsFormViewModelMapper:
        TDocumentRelationsFormViewModelMapper; virtual;

      function CreateFilesFormViewModelMapper:
        TDocumentFilesFormViewModelMapper; virtual;

      function CreateDocumentApprovingsFormViewModelMapper:
        TDocumentApprovingsFormViewModelMapper; virtual;

      function CreateDocumentFilesViewFormViewModelMapper:
        TDocumentFilesViewFormViewModelMapper; virtual;

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

    public

      constructor Create(
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      );
      
      destructor Destroy; override;

      function MapDocumentCardFormViewModelFrom(
      
        DocumentFullInfoDTO: TDocumentFullInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO

      ): TDocumentCardFormViewModel; virtual;

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

      function CreateEmptyDocumentCardFormViewModel(
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
        DocumentCreatingDefaultInfoDTO: TDocumentCreatingDefaultInfoDTO
      ): TDocumentCardFormViewModel; virtual;

      function CreateDocumentCardFormViewModelForNewDocumentCreating(
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
        DocumentCreatingDefaultInfoDTO: TDocumentCreatingDefaultInfoDTO
      ): TDocumentCardFormViewModel; virtual;

    public

      property MainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper
      read GetMainInformationFormViewModelMapper write SetMainInformationFormViewModelMapper;

      property ChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper
      read GetChargesFormViewModelMapper write SetChargesFormViewModelMapper;
      
      property RelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper
      read GetRelationsFormViewModelMapper write SetRelationsFormViewModelMapper;
    
      property FilesFormViewModelMapper: TDocumentFilesFormViewModelMapper
      read GetFilesFormViewModelMapper write SetFilesFormViewModelMapper;
      
      property DocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper
      read GetDocumentApprovingsFormViewModelMapper write SetDocumentApprovingsFormViewModelMapper;
      
  end;

implementation

uses

  { refactor: to pass the inner mappers to constructor of this mapper }
  ApplicationServiceRegistries;

{ TDocumentCardFormViewModelMapper }

constructor TDocumentCardFormViewModelMapper.Create(
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
);
begin

  inherited Create;

  FMainInformationFormViewModelMapper := CreateMainInformationFormViewModelMapper;
  FChargesFormViewModelMapper := CreateChargesFormViewModelMapper;
  FRelationsFormViewModelMapper := CreateRelationsFormViewModelMapper;
  FFilesFormViewModelMapper := CreateFilesFormViewModelMapper;
  FApprovingsFormViewModelMapper := CreateDocumentApprovingsFormViewModelMapper;
  FFilesViewFormViewModelMapper := CreateDocumentFilesViewFormViewModelMapper;

  FDocumentDataSetHoldersFactory := DocumentDataSetHoldersFactory;
  
end;

function TDocumentCardFormViewModelMapper.CreateChangedDocumentInfoDTOInstance: TChangedDocumentInfoDTO;
begin

  Result := TChangedDocumentInfoDTO.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
begin

  { refactor: to pass the inner mappers to constructor of the TDocumentCardFormViewModelMapper }
  
  Result :=
    TDocumentChargesFormViewModelMapper.Create(
      TApplicationServiceRegistries
        .Current
          .GetDocumentBusinessProcessServiceRegistry
            .GetDocumentChargeKindsControlAppService
    );
  
end;

function TDocumentCardFormViewModelMapper.CreateDocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
begin

  Result := TDocumentApprovingsFormViewModelMapper.Create;
  
end;

function TDocumentCardFormViewModelMapper.
  CreateDocumentCardFormViewModelForNewDocumentCreating(
    DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
    DocumentCreatingDefaultInfoDTO: TDocumentCreatingDefaultInfoDTO
  ): TDocumentCardFormViewModel;
begin

  Result :=
    CreateEmptyDocumentCardFormViewModel(
      DocumentDataSetHoldersFactory,
      DocumentCreatingDefaultInfoDTO
    );

  if not Assigned(DocumentCreatingDefaultInfoDTO) then Exit;
  
  if Assigned(DocumentCreatingDefaultInfoDTO.DocumentResponsibleInfoDTO) then
  begin

    Result.DocumentMainInformationFormViewModel.DocumentResponsibleViewModel :=

      FMainInformationFormViewModelMapper.
        DocumentResponsibleViewModelMapper.MapDocumentResponsibleViewModelFrom(
          DocumentCreatingDefaultInfoDTO.DocumentResponsibleInfoDTO
        );

  end;

  if Assigned(DocumentCreatingDefaultInfoDTO.DocumentSignerInfoDTO) then
  begin

    Result.DocumentMainInformationFormViewModel.DocumentSignerViewModel :=

      FMainInformationFormViewModelMapper.
        DocumentSignerViewModelMapper.MapDocumentSignerViewModelFrom(
          DocumentCreatingDefaultInfoDTO.DocumentSignerInfoDTO
        );

  end;

end;

function TDocumentCardFormViewModelMapper.CreateDocumentCardFormViewModelInstance: TDocumentCardFormViewModel;
begin

  Result := TDocumentCardFormViewModel.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateDocumentFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper;
begin

  Result := TDocumentFilesViewFormViewModelMapper.Create;
  
end;

function TDocumentCardFormViewModelMapper.
  CreateEmptyDocumentCardFormViewModel(
    DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
    DocumentCreatingDefaultInfoDTO: TDocumentCreatingDefaultInfoDTO { refactor: delete, view unDocumentCardListFrame.OnNewDocumentCreatingRequestedEventHandler }
  ): TDocumentCardFormViewModel;
var
  DocumentChargeSetHolder: TDocumentChargeSetHolder;
  DocumentRelationSetHolder: TDocumentRelationSetHolder;
  DocumentFileSetHolder: TDocumentFileSetHolder;
  DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
begin

  DocumentChargeSetHolder := nil;
  DocumentRelationSetHolder := nil;
  DocumentFileSetHolder := nil;
  DocumentApprovingCycleSetHolder := nil;

  Result := CreateDocumentCardFormViewModelInstance;
  
  try

    DocumentChargeSetHolder :=
      DocumentDataSetHoldersFactory.CreateDocumentChargeSetHolder;

    DocumentRelationSetHolder :=
      DocumentDataSetHoldersFactory.CreateDocumentRelationSetHolder;

    DocumentFileSetHolder :=
      DocumentDataSetHoldersFactory.CreateDocumentFileSetHolder;

    DocumentApprovingCycleSetHolder :=
      DocumentDataSetHoldersFactory.CreateDocumentApprovingCycleSetHolder;
      
    Result.DocumentMainInformationFormViewModel :=
      FMainInformationFormViewModelMapper.CreateEmptyDocumentMainInformationFormViewModel;

    Result.DocumentFilesFormViewModel :=
      FFilesFormViewModelMapper.CreateEmptyDocumentFilesFormViewModel(
        DocumentFileSetHolder
      );

    Result.DocumentFilesViewFormViewModel :=
      FFilesViewFormViewModelMapper.
        CreateEmptyDocumentFilesViewFormViewModel;

    DocumentFileSetHolder := nil;

    Result.DocumentChargesFormViewModel :=
      FChargesFormViewModelMapper.CreateEmptyDocumentChargesFormViewModel(
        DocumentChargeSetHolder,
        DocumentCreatingDefaultInfoDTO.DocumentKindId { refactor: delete, view above }

      );

    DocumentChargeSetHolder := nil;

    Result.DocumentRelationsFormViewModel :=
      FRelationsFormViewModelMapper.CreateEmptyDocumentRelationsFormViewModel(
        DocumentRelationSetHolder
      );

    DocumentRelationSetHolder := nil;

    Result.DocumentApprovingsFormViewModel :=
      FApprovingsFormViewModelMapper.CreateEmptyDocumentApprovingsFormViewModel(
        DocumentApprovingCycleSetHolder
      );

    DocumentApprovingCycleSetHolder := nil;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      FreeAndNil(DocumentChargeSetHolder);
      FreeAndNil(DocumentRelationSetHolder);
      FreeAndNil(DocumentFileSetHolder);
      FreeAndNil(DocumentApprovingCycleSetHolder);

      raise;
      
    end;

  end;
  
end;

function TDocumentCardFormViewModelMapper.CreateFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
begin

  Result := TDocumentFilesFormViewModelMapper.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result := TDocumentMainInformationFormViewModelMapper.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateNewDocumentInfoDTOInstance: TNewDocumentInfoDTO;
begin

  Result := TNewDocumentInfoDTO.Create;
  
end;

function TDocumentCardFormViewModelMapper.CreateRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
begin

  Result := TDocumentRelationsFormViewModelMapper.Create;
  
end;

destructor TDocumentCardFormViewModelMapper.Destroy;
begin

  FreeAndNil(FFilesViewFormViewModelMapper);
  FreeAndNil(FMainInformationFormViewModelMapper);
  FreeAndNil(FChargesFormViewModelMapper);
  FreeAndNil(FRelationsFormViewModelMapper);
  FreeAndNil(FFilesFormViewModelMapper);
  FreeAndNil(FApprovingsFormViewModelMapper);
  
  inherited;

end;

function TDocumentCardFormViewModelMapper.GetChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
begin

  Result := FChargesFormViewModelMapper;
  
end;

function TDocumentCardFormViewModelMapper.GetDocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
begin

  Result := FApprovingsFormViewModelMapper;
  
end;

function TDocumentCardFormViewModelMapper.GetFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
begin

  Result := FFilesFormViewModelMapper;

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
var
  DocumentChargeSetHolder: TDocumentChargeSetHolder;
  DocumentRelationSetHolder: TDocumentRelationSetHolder;
  DocumentFileSetHolder: TDocumentFileSetHolder;
  DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
  
begin

  DocumentChargeSetHolder := nil;
  DocumentRelationSetHolder := nil;
  DocumentFileSetHolder := nil;
  DocumentApprovingCycleSetHolder := nil;

  Result := CreateDocumentCardFormViewModelInstance;

  try

    DocumentChargeSetHolder :=
      FDocumentDataSetHoldersFactory.CreateDocumentChargeSetHolder;

    DocumentRelationSetHolder :=
      FDocumentDataSetHoldersFactory.CreateDocumentRelationSetHolder;

    DocumentFileSetHolder :=
      FDocumentDataSetHoldersFactory.CreateDocumentFileSetHolder;

    DocumentApprovingCycleSetHolder :=
      FDocumentDataSetHoldersFactory.CreateDocumentApprovingCycleSetHolder;

    Result.DocumentMainInformationFormViewModel :=

      FMainInformationFormViewModelMapper.
        MapDocumentMainInformationFormViewModelFrom(
          DocumentFullInfoDTO.DocumentDTO
        );
    
    Result.DocumentFilesFormViewModel :=

      FFilesFormViewModelMapper.MapDocumentFilesFormViewModelFrom(
        DocumentFullInfoDTO.DocumentFilesInfoDTO,
        DocumentFileSetHolder
      );

    DocumentFileSetHolder := nil;

    Result.DocumentChargesFormViewModel :=

      FChargesFormViewModelMapper.MapDocumentChargesFormViewModelFrom(
        DocumentFullInfoDTO.DocumentDTO,
        DocumentFullInfoDTO.DocumentDTO.ChargesInfoDTO,
        DocumentFullInfoDTO.DocumentChargeSheetsInfoDTO,
        DocumentChargeSetHolder
      );

    DocumentChargeSetHolder := nil;

    Result.DocumentRelationsFormViewModel :=

      FRelationsFormViewModelMapper.MapDocumentRelationsFormViewModelFrom(
        DocumentFullInfoDTO.DocumentRelationsInfoDTO,
        DocumentRelationSetHolder
      );

    DocumentRelationSetHolder := nil;

    Result.DocumentApprovingsFormViewModel :=
      FApprovingsFormViewModelMapper.MapDocumentApprovingsFormViewModelFrom(
        DocumentFullInfoDTO.DocumentDTO.ApprovingsInfoDTO,
        DocumentFullInfoDTO.DocumentApprovingCycleResultsInfoDTO,
        DocumentUsageEmployeeAccessRightsInfoDTO,
        DocumentApprovingCycleSetHolder
      );

    DocumentApprovingCycleSetHolder := nil;

    Result.DocumentFilesViewFormViewModel :=
      FFilesViewFormViewModelMapper.MapDocumentFilesViewFormViewModelFrom(
        DocumentFullInfoDTO.DocumentFilesInfoDTO
      );

    Result.DocumentRemoveToolEnabled :=
      DocumentUsageEmployeeAccessRightsInfoDTO.DocumentCanBeRemoved;
      
  except

    FreeAndNil(Result);
    FreeAndNil(DocumentChargeSetHolder);
    FreeAndNil(DocumentRelationSetHolder);
    FreeAndNil(DocumentFileSetHolder);
    FreeAndNil(DocumentApprovingCycleSetHolder);
      
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

      MarkCurrentChargeRecordAsAdded;
      
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

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

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

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;


end;

procedure TDocumentCardFormViewModelMapper.SetChargesFormViewModelMapper(
  const Value: TDocumentChargesFormViewModelMapper);
begin

  FreeAndNil(FChargesFormViewModelMapper);

  FChargesFormViewModelMapper := Value;
  
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
