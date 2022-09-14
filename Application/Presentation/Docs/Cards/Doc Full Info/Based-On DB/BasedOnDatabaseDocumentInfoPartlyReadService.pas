unit BasedOnDatabaseDocumentInfoPartlyReadService;

interface

uses

  DocumentInfoReadService,
  DocumentFullInfoDTO,
  AbstractDataSetHolder,
  AbstractApplicationService,
  DocumentChargeSheetsInfoDTO,
  DocumentDTOFromDataSetMapper,
  DocumentFilesInfoDTOFromDataSetMapper,
  DocumentRelationsInfoDTOFromDataSetMapper,
  DocumentChargesInfoDTOFromDataSetMapper,
  DocumentChargeSheetsInfoDTOFromDataSetMapper,
  DocumentFilesInfoHolder,
  DocumentApprovingsInfoDTOFromDataSetMapper,
  DocumentinfoHolder,
  DocumentApprovingCycleResultsInfoDTOFromDataSetMapper,
  DocumentApprovingsInfoHolder,
  DocumentChargesInfoHolder,
  QueryExecutor,
  DocumentPerformingInfoHolderBuilder,
  DocumentFilesInfoHolderBuilder,
  DocumentRelationsInfoHolder,
  DataSetQueryExecutor,
  FullDocumentApprovingsInfoHolderBuilder,
  DocumentRelationsInfoHolderBuilder,
  DocumentChargeSheetsInfoHolder,
  Disposable,
  DocumentInfoHolderBuilder,
  SysUtils;

type

  TDocumentInfoDTOFromDataSetMappers = record

    DocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper;
    DocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper;
    DocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
    DocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
    DocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
    DocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
    DocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;

  end;

  TDocumentInfoHolderBuilders = record

    DocumentInfoHolderBuilder: IDocumentInfoHolderBuilder;
    FullDocumentApprovingsInfoHolderBuilder: IFullDocumentApprovingsInfoHolderBuilder;
    DocumentRelationsInfoHolderBuilder: IDocumentRelationsInfoHolderBuilder;
    DocumentFilesInfoHolderBuilder: IDocumentFilesInfoHolderBuilder;
    DocumentPerformingInfoHolderBuilder: IDocumentPerformingInfoHolderBuilder;
    
  end;

  TBasedOnDatabaseDocumentInfoPartlyReadService =
    class (TAbstractApplicationService, IDocumentInfoReadService)

      protected

        function CreateDocumentDTO(DocumentId: Variant): TDocumentDTO; virtual;
        function CreateDocumentRelationsInfoDTO(DocumentDTO: TDocumentDTO): TDocumentRelationsInfoDTO; virtual;
        function CreateDocumentFilesInfoDTO(DocumentDTO: TDocumentDTO): TDocumentFilesInfoDTO; virtual;

        procedure CreateDocumentFullApprovingsInfoDTOFrom(
          DocumentDTO: TDocumentDTO;
          var DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
          var DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO
        ); virtual;

        procedure CreateChargesAndChargeSheetsInfoDTOFrom(
          DocumentDTO: TDocumentDTO;
          var DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
          var DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
        ); virtual;

      protected

        function  GetDocumentInfoHolder(DocumentId: Variant): TDocumentInfoHolder;
        
        function CreateFullDocumentApprovingsInfoHolder(DocumentId: Variant): TDocumentApprovingsInfoHolder;

        procedure CreateDocumentChargesAndChargeSheetsInfoHolder(
          DocumentId: Variant;
          var DocumentChargesInfoHolder: TDocumentChargesInfoHolder;
          var DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
        );

        function GetDocumentRelationsInfoHolder(DocumentId: Variant): TDocumentRelationsINfoHolder;

        function GetDocumentFilesInfoHolder(DocumentId: Variant): TDocumentFilesInfoHolder;

      protected

        FDocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper;
        FFreeDocumentDTOFromDataSetMapper: IDisposable;

        FDocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper;
        FFreeDocumentFilesInfoDTOFromDataSetMapper: IDisposable;
        
        FDocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
        FFreeDocumentRelationsInfoDTOFromDataSetMapper: IDisposable;
        
        FDocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
        FFreeDocumentChargesInfoDTOFromDataSetMapper: IDisposable;
        
        FDocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
        FFreeDocumentChargeSheetsInfoDTOFromDataSetMapper: IDisposable;

        FDocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
        FFreeDocumentApprovingsInfoDTOFromDataSetMapper: IDisposable;
        
        FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
        FFreeDocumentApprovingCycleResultsInfoDTOFromDataSetMapper: IDisposable;

        FDocumentInfoHolderBuilder: IDocumentInfoHolderBuilder;
        FFullDocumentApprovingsInfoHolderBuilder: IFullDocumentApprovingsInfoHolderBuilder;
        FDocumentRelationsInfoHolderBuilder: IDocumentRelationsInfoHolderBuilder;
        FDocumentFilesInfoHolderBuilder: IDocumentFilesInfoHolderBuilder;
        FDocumentPerformingInfoHolderBuilder: IDocumentPerformingInfoHolderBuilder;

      public

        constructor Create(
          DocumentInfoDTOFromDataSetMappers: TDocumentInfoDTOFromDataSetMappers;
          DocumentInfoHolderBuilders: TDocumentInfoHolderBuilders
        );

        function GetDocumentFullInfo(const DocumentId: Variant): TDocumentFullInfoDTO;

    end;

implementation

{ TBasedOnDatabaseDocumentInfoPartlyReadService }

constructor TBasedOnDatabaseDocumentInfoPartlyReadService.Create(
  DocumentInfoDTOFromDataSetMappers: TDocumentInfoDTOFromDataSetMappers;
  DocumentInfoHolderBuilders: TDocumentInfoHolderBuilders
);
begin

  inherited Create;

  with DocumentInfoDTOFromDataSetMappers, DocumentInfoHolderBuilders do begin

    FDocumentDTOFromDataSetMapper := DocumentDTOFromDataSetMapper;
    FFreeDocumentDTOFromDataSetMapper := FDocumentDTOFromDataSetMapper;

    FDocumentFilesInfoDTOFromDataSetMapper := DocumentFilesInfoDTOFromDataSetMapper;
    FFreeDocumentFilesInfoDTOFromDataSetMapper := FDocumentFilesInfoDTOFromDataSetMapper;

    FDocumentRelationsInfoDTOFromDataSetMapper := DocumentRelationsInfoDTOFromDataSetMapper;
    FFreeDocumentRelationsInfoDTOFromDataSetMapper := FDocumentRelationsInfoDTOFromDataSetMapper;

    FDocumentChargesInfoDTOFromDataSetMapper := DocumentChargesInfoDTOFromDataSetMapper;
    FFreeDocumentChargesInfoDTOFromDataSetMapper := FDocumentChargesInfoDTOFromDataSetMapper;
    
    FDocumentChargeSheetsInfoDTOFromDataSetMapper := DocumentChargeSheetsInfoDTOFromDataSetMapper;
    FFreeDocumentChargeSheetsInfoDTOFromDataSetMapper := FDocumentChargeSheetsInfoDTOFromDataSetMapper;

    FDocumentApprovingsInfoDTOFromDataSetMapper := DocumentApprovingsInfoDTOFromDataSetMapper;
    FFreeDocumentApprovingsInfoDTOFromDataSetMapper := FDocumentApprovingsInfoDTOFromDataSetMapper;

    FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper := DocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
    FFreeDocumentApprovingCycleResultsInfoDTOFromDataSetMapper := FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;

    FDocumentInfoHolderBuilder := DocumentInfoHolderBuilder;
    FFullDocumentApprovingsInfoHolderBuilder := FullDocumentApprovingsInfoHolderBuilder;
    FDocumentPerformingInfoHolderBuilder := DocumentPerformingInfoHolderBuilder;
    FDocumentRelationsInfoHolderBuilder := DocumentRelationsInfoHolderBuilder;
    FDocumentFilesInfoHolderBuilder := DocumentFilesInfoHolderBuilder;
    
  end;

end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.
  GetDocumentFullInfo(const DocumentId: Variant): TDocumentFullInfoDTO;
var
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
    DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;

    DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
    DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
begin

  Result := TDocumentFullInfoDTO.Create;

  try

    Result.DocumentDTO := CreateDocumentDTO(DocumentId);

    CreateDocumentFullApprovingsInfoDTOFrom(
      Result.DocumentDTO,
      DocumentApprovingsInfoDTO,
      DocumentApprovingCycleResultsInfoDTO
    );

    CreateChargesAndChargeSheetsInfoDTOFrom(
      Result.DocumentDTO,
      DocumentChargesInfoDTO,
      DocumentChargeSheetsInfoDTO
    );

    Result.DocumentApprovingCycleResultsInfoDTO := DocumentApprovingCycleResultsInfoDTO;
    Result.DocumentDTO.ApprovingsInfoDTO := DocumentApprovingsInfoDTO;
    Result.DocumentChargeSheetsInfoDTO := DocumentChargeSheetsInfoDTO;
    Result.DocumentDTO.ChargesInfoDTO := DocumentChargesInfoDTO;
    Result.DocumentRelationsInfoDTO := CreateDocumentRelationsInfoDTO(Result.DocumentDTO);
    Result.DocumentFilesInfoDTO := CreateDocumentFilesInfoDTO(Result.DocumentDTO);
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TBasedOnDatabaseDocumentInfoPartlyReadService.CreateDocumentFullApprovingsInfoDTOFrom(
  DocumentDTO: TDocumentDTO;
  var DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
  var DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO
);

var
    FullDocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder;
begin

  FullDocumentApprovingsInfoHolder :=
    CreateFullDocumentApprovingsInfoHolder(DocumentDTO.Id);

  try

    DocumentApprovingsInfoDTO :=
      FDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentApprovingsInfoDTOFrom(
        FullDocumentApprovingsInfoHolder
      );

    DocumentApprovingCycleResultsInfoDTO :=
      FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper.MapDocumentApprovingCycleResultsInfoDTOFrom(
        FullDocumentApprovingsInfoHolder
      );

  finally

    FreeAndNil(FullDocumentApprovingsInfoHolder);

  end;

end;

procedure TBasedOnDatabaseDocumentInfoPartlyReadService.CreateChargesAndChargeSheetsInfoDTOFrom(
  DocumentDTO: TDocumentDTO;
  var DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
  var DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
);
var
    DocumentChargesInfoHolder: TDocumentChargesInfoHolder;
    DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
begin

  CreateDocumentChargesAndChargeSheetsInfoHolder(
    DocumentDTO.Id,
    DocumentChargesInfoHolder,
    DocumentChargeSheetsInfoHolder
  );

  try

    DocumentChargesInfoDTO :=
      FDocumentChargesInfoDTOFromDataSetMapper.MapDocumentChargesInfoDTOFrom(
        DocumentChargesInfoHolder
      );

    DocumentChargeSheetsInfoDTO :=
      FDocumentChargeSheetsInfoDTOFromDataSetMapper.MapDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsInfoHolder
      );

  finally

    FreeAndNil(DocumentChargesInfoHolder);
    FreeAndNil(DocumentChargeSheetsInfoHolder);
    
  end;

end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.CreateDocumentDTO(
  DocumentId: Variant): TDocumentDTO;
var
    DocumentInfoHolder: TDocumentInfoHolder;
begin

  DocumentInfoHolder := GetDocumentInfoHolder(DocumentId);

  try

    Result := FDocumentDTOFromDataSetMapper.MapDocumentDTOFrom(DocumentInfoHolder);

  finally

    FreeAndNil(DocumentInfoHolder);

  end;

end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.
  CreateDocumentFilesInfoDTO(DocumentDTO: TDocumentDTO): TDocumentFilesInfoDTO;
var
    DocumentFilesInfoHolder: TDocumentFilesInfoHolder;
begin

  DocumentFilesInfoHolder := GetDocumentFilesInfoHolder(DocumentDTO.Id);

  try

    Result :=
      FDocumentFilesInfoDTOFromDataSetMapper
        .MapDocumentFilesInfoDTOFrom(DocumentFilesInfoHolder);

  finally

    FreeAndNil(DocumentFilesInfoHolder);

  end;

end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.CreateDocumentRelationsInfoDTO(
  DocumentDTO: TDocumentDTO
): TDocumentRelationsInfoDTO;
var
    DocumentRelationsInfoHolder: TDocumentRelationsInfoHolder;
begin

  DocumentRelationsInfoHolder := GetDocumentRelationsInfoHolder(DocumentDTO.Id);

  try

    Result :=
      FDocumentRelationsInfoDTOFromDataSetMapper
        .MapDocumentRelationsInfoDTOFrom(DocumentRelationsInfoHolder);

  finally

    FreeAndNil(DocumentRelationsInfoHolder);

  end;

end;

procedure TBasedOnDatabaseDocumentInfoPartlyReadService
  .CreateDocumentChargesAndChargeSheetsInfoHolder(
    DocumentId: Variant;
    var DocumentChargesInfoHolder: TDocumentChargesInfoHolder;
    var DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
  );
begin

  FDocumentPerformingInfoHolderBuilder
    .BuildDocumentPerformingInfoHolder(
      DocumentId,
      DocumentChargesInfoHolder,
      DocumentChargeSheetsInfoHolder
    );

end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.CreateFullDocumentApprovingsInfoHolder(
  DocumentId: Variant): TDocumentApprovingsInfoHolder;
begin

  Result :=
    FFullDocumentApprovingsInfoHolderBuilder
      .BuildFullDocumentApprovingsInfoHolder(DocumentId);

end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.GetDocumentFilesInfoHolder(
  DocumentId: Variant): TDocumentFilesInfoHolder;
begin

  Result :=
    FDocumentFilesInfoHolderBuilder.BuildDocumentFilesInfoHolder(DocumentId);
    
end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.GetDocumentInfoHolder(
  DocumentId: Variant): TDocumentInfoHolder;
var
    QueryParams: TQueryParams;
begin

  Result := FDocumentInfoHolderBuilder.BuildDocumentInfoHolder(DocumentId);
  
end;

function TBasedOnDatabaseDocumentInfoPartlyReadService.GetDocumentRelationsInfoHolder(
  DocumentId: Variant): TDocumentRelationsINfoHolder;
begin

  Result :=
    FDocumentRelationsInfoHolderBuilder
      .BuildDocumentRelationsInfoHolder(DocumentId);

end;

end.
