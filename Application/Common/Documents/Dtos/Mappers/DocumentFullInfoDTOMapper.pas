unit DocumentFullInfoDTOMapper;

interface

uses

  Document,
  DocumentFullInfoDTO,
  DocumentRelationsUnit,
  DocumentChargeSheetsInfoDTO,
  DocumentApprovingCycleResult,
  DocumentChargeSheet,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentChargeSheetsInfoDTODomainMapper,
  DocumentApprovingsInfoDTOMapper,
  DocumentApprovings,
  DocumentRepositoryRegistry,
  DocumentKind,
  DocumentDTOMapper,
  DocumentKindRepository,
  DocumentFileUnit,
  Disposable,
  Employee,
  SysUtils,
  Classes;

type

  IDocumentFullInfoDTOMapper = interface

    function MapDocumentFullInfoDTOFrom(

      Document: TDocument;
      AccessingEmployee: TEmployee;

      DocumentRelations: TDocumentRelations = nil;
      DocumentFiles: TDocumentFiles = nil;
      DocumentApprovingCycleResults: TDocumentApprovingCycleResults = nil;
      DocumentChargeSheets: TDocumentChargeSheets = nil

    ): TDocumentFullInfoDTO;

  end;

  { используется в службе создания ответного документа, см. RespondingDocumentCreatingAppService }
  TDocumentFullInfoDTOMapper = class abstract (TInterfacedObject, IDocumentFullInfoDTOMapper)

    protected

      FDocumentRepositoryRegistry: IDocumentRepositoryRegistry;
      
      FDocumentDTOMapper: TDocumentDTOMapper;
      FFreeDocumentDTOMapper: IDisposable;

      FDocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
      FFreeDocumentApprovingsInfoDTOMapper: IDisposable;
      
      FDocumentChargeSheetsInfoDTOMapper: IDocumentChargeSheetsInfoDTODomainMapper;

      FDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
      FFreeDocumentFlowEmployeeInfoDTOMapper: IDisposable;
      
    protected

      function CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO; virtual;

      function MapDocumentDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentDTO; virtual;

    protected
    
      function MapDocumentRelationsInfoDTOFrom(
        DocumentRelations: TDocumentRelations
      ): TDocumentRelationsInfoDTO; virtual;

    protected

      function MapDocumentFilesInfoDTOFrom(
        DocumentFiles: TDocumentFiles
      ): TDocumentFilesInfoDTO; virtual;

      function MapDocumentFileInfoDTOFrom(
        DocumentFile: TDocumentFile
      ): TDocumentFileInfoDTO; virtual;
      
    protected

      function MapDocumentApprovingCycleResultsInfoDTOFrom(
        DocumentApprovingCycleResults: TDocumentApprovingCycleResults;
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentApprovingCycleResultsInfoDTO; virtual;

      function MapDocumentApprovingCycleResultInfoDTO(
        DocumentApprovingCycleResult: TDocumentApprovingCycleResult;
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentApprovingCycleResultInfoDTO; virtual;

      function MapDocumentApprovingsInfoDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentApprovingsInfoDTO; virtual;

    protected

      function MapDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheets: TDocumentChargeSheets;
        Employee: TEmployee
      ): TDocumentChargeSheetsInfoDTO; virtual;
      
    public

      constructor Create(
        DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
        DocumentDTOMapper: TDocumentDTOMapper;
        DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
        DocumentChargeSheetsInfoDTOMapper: IDocumentChargeSheetsInfoDTODomainMapper;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
      ); virtual;
      
      function MapDocumentFullInfoDTOFrom(

        Document: TDocument;
        AccessingEmployee: TEmployee;

        DocumentRelations: TDocumentRelations = nil;
        DocumentFiles: TDocumentFiles = nil;
        DocumentApprovingCycleResults: TDocumentApprovingCycleResults = nil;
        DocumentChargeSheets: TDocumentChargeSheets = nil

      ): TDocumentFullInfoDTO;

  end;


implementation

uses

  IDomainObjectBaseUnit;
  
{ TDocumentFullInfoDTOMapper }

constructor TDocumentFullInfoDTOMapper.Create(
  DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
  DocumentDTOMapper: TDocumentDTOMapper;
  DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
  DocumentChargeSheetsInfoDTOMapper: IDocumentChargeSheetsInfoDTODomainMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FDocumentRepositoryRegistry := DocumentRepositoryRegistry;
  
  FDocumentDTOMapper := DocumentDTOMapper;
  FFreeDocumentDTOMapper := FDocumentDTOMapper;
  
  FDocumentApprovingsInfoDTOMapper := DocumentApprovingsInfoDTOMapper;
  FFreeDocumentApprovingsInfoDTOMapper := FDocumentApprovingsInfoDTOMapper;
  
  FDocumentChargeSheetsInfoDTOMapper := DocumentChargeSheetsInfoDTOMapper;

  FDocumentFlowEmployeeInfoDTOMapper := DocumentFlowEmployeeInfoDTOMapper;
  FFreeDocumentFlowEmployeeInfoDTOMapper := FDocumentFlowEmployeeInfoDTOMapper;
  
end;

function TDocumentFullInfoDTOMapper.CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO;
begin

  Result := TDocumentFullInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOMapper.MapDocumentFullInfoDTOFrom(

  Document: TDocument;
  AccessingEmployee: TEmployee;
  
  DocumentRelations: TDocumentRelations;
  DocumentFiles: TDocumentFiles;
  DocumentApprovingCycleResults: TDocumentApprovingCycleResults;
  DocumentChargeSheets: TDocumentChargeSheets

): TDocumentFullInfoDTO;
begin

  Result := CreateDocumentFullInfoDTOInstance;
  
  try

    Result.DocumentDTO := MapDocumentDTOFrom(Document, AccessingEmployee);
    Result.DocumentRelationsInfoDTO := MapDocumentRelationsInfoDTOFrom(DocumentRelations);
    Result.DocumentFilesInfoDTO := MapDocumentFilesInfoDTOFrom(DocumentFiles);

    Result.DocumentApprovingCycleResultsInfoDTO :=
      MapDocumentApprovingCycleResultsInfoDTOFrom(
        DocumentApprovingCycleResults, Document, AccessingEmployee
      );

    Result.DocumentChargeSheetsInfoDTO :=
      MapDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheets, AccessingEmployee
      );
      
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentFullInfoDTOMapper.MapDocumentDTOFrom(
  Document: TDocument;
  AccessingEmployee: TEmployee
): TDocumentDTO;
begin

  Result := FDocumentDTOMapper.MapDocumentDTOFrom(Document, AccessingEmployee);
   
end;

function TDocumentFullInfoDTOMapper.MapDocumentRelationsInfoDTOFrom(
  DocumentRelations: TDocumentRelations
): TDocumentRelationsInfoDTO;
var
    DocumentRelationInfoDTO: TDocumentRelationInfoDTO;

    RelatedDocumentInfo: Variant;
    RelatedDocumentId: Variant;
    RelatedDocumentKindId: Variant;

    RelatedDocument: TDocument;
    FreeRelatedDocument: IDomainObjectBase;
    
    RelatedDocumentKind: TDocumentKind;
    FreeRelatedDocumentKind: IDomainObjectBase;
begin

  Result := TDocumentRelationsInfoDTO.Create;

  if not Assigned(DocumentRelations) then Exit;

  DocumentRelationInfoDTO := nil;
  
  try

    for RelatedDocumentInfo in DocumentRelations.RelatedDocumentInfoList
    do begin

      RelatedDocumentId := RelatedDocumentInfo[0];
      RelatedDocumentKindId := RelatedDocumentInfo[1];

      RelatedDocumentKind :=
        FDocumentRepositoryRegistry.
          GetDocumentKindRepository
            .FindDocumentKindByIdentity(RelatedDocumentKindId);

      FreeRelatedDocumentKind := RelatedDocumentKind;

      RelatedDocument :=
        FDocumentRepositoryRegistry
          .GetDocumentRepository(RelatedDocumentKind.DocumentClass)
            .FindDocumentById(RelatedDocumentId);

      FreeRelatedDocument := RelatedDocument;

      DocumentRelationInfoDTO := TDocumentRelationInfoDTO.Create;

      DocumentRelationInfoDTO.TargetDocumentId := DocumentRelations.TargetDocumentId;
      DocumentRelationInfoDTO.RelatedDocumentId := RelatedDocumentId;
      DocumentRelationInfoDTO.RelatedDocumentKindId := RelatedDocumentKindId;
      DocumentRelationInfoDTO.RelatedDocumentKindName := RelatedDocumentKind.Name;
      DocumentRelationInfoDTO.RelatedDocumentNumber := RelatedDocument.Number;
      DocumentRelationInfoDTO.RelatedDocumentName := RelatedDocument.Name;
      DocumentRelationInfoDTO.RelatedDocumentDate := RelatedDocument.DocumentDate;

      Result.Add(DocumentRelationInfoDTO);

      DocumentRelationInfoDTO := nil;
      
    end;

  except

    on E: Exception do begin

      FreeAndNil(DocumentRelationInfoDTO);
      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentFullInfoDTOMapper.MapDocumentFilesInfoDTOFrom(
  DocumentFiles: TDocumentFiles
): TDocumentFilesInfoDTO;
var
    DocumentFile: TDocumentFile;
begin

  Result := TDocumentFilesInfoDTO.Create;

  if not Assigned(DocumentFiles) then Exit;
  
  try

    for DocumentFile in DocumentFiles do
      Result.Add(MapDocumentFileInfoDTOFrom(DocumentFile));

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentFullInfoDTOMapper.MapDocumentFileInfoDTOFrom(
  DocumentFile: TDocumentFile
): TDocumentFileInfoDTO;
begin

  Result := TDocumentFileInfoDTO.Create;

  try

    Result.Id := DocumentFile.Identity;
    Result.DocumentId := DocumentFile.DocumentId;
    Result.FileName := DocumentFile.FileName;
    Result.FilePath := DocumentFile.FilePath;
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentFullInfoDTOMapper.MapDocumentApprovingCycleResultsInfoDTOFrom(
  DocumentApprovingCycleResults: TDocumentApprovingCycleResults;
  Document: TDocument;
  AccessingEmployee: TEmployee
): TDocumentApprovingCycleResultsInfoDTO;

var
    DocumentApprovingCycleResult: TDocumentApprovingCycleResult;
begin

  Result := TDocumentApprovingCycleResultsInfoDTO.Create;

  if not Assigned(DocumentApprovingCycleResults) then Exit;

  try

    for DocumentApprovingCycleResult in DocumentApprovingCycleResults do
    begin

      Result.Add(
        MapDocumentApprovingCycleResultInfoDTO(
          DocumentApprovingCycleResult,
          Document,
          AccessingEmployee
        )
      );
      
    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentFullInfoDTOMapper.MapDocumentApprovingCycleResultInfoDTO(
  DocumentApprovingCycleResult: TDocumentApprovingCycleResult;
  Document: TDocument;
  AccessingEmployee: TEmployee
): TDocumentApprovingCycleResultInfoDTO;
begin

  Result := TDocumentApprovingCycleResultInfoDTO.Create;

  try

    Result.Id := DocumentApprovingCycleResult.CycleNumber;
    Result.CycleNumber := DocumentApprovingCycleResult.CycleNumber;

    Result.DocumentApprovingsInfoDTO :=
      MapDocumentApprovingsInfoDTOFrom(
        Document, AccessingEmployee
      );

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise

    end;

  end;

end;

function TDocumentFullInfoDTOMapper.MapDocumentApprovingsInfoDTOFrom(
  Document: TDocument;
  AccessingEmployee: TEmployee

): TDocumentApprovingsInfoDTO;
begin

  Result :=
    FDocumentApprovingsInfoDTOMapper.MapDocumentApprovingsInfoDTOFrom(
      Document, AccessingEmployee
    );

end;

function TDocumentFullInfoDTOMapper.MapDocumentChargeSheetsInfoDTOFrom(
  DocumentChargeSheets: TDocumentChargeSheets;
  Employee: TEmployee
): TDocumentChargeSheetsInfoDTO;
begin

  Result :=
    FDocumentChargeSheetsInfoDTOMapper.MapDocumentChargeSheetsInfoFrom(
      DocumentChargeSheets
    );
    
end;

end.
