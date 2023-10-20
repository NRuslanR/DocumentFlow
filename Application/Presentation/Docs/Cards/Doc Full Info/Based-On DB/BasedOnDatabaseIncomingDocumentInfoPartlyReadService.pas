unit BasedOnDatabaseIncomingDocumentInfoPartlyReadService;

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
  SysUtils,
  BasedOnDatabaseDocumentInfoPartlyReadService,
  IncomingDocumentFullInfoDTO;

type

  TBasedOnDatabaseIncomingDocumentInfoPartlyReadService =
    class (TBasedOnDatabaseDocumentInfoPartlyReadService)

      protected

        function CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO; override;
        function CreateDocumentRelationsInfoDTO(DocumentDTO: TDocumentDTO): TDocumentRelationsInfoDTO; override;
        function CreateDocumentFilesInfoDTO(DocumentDTO: TDocumentDTO): TDocumentFilesInfoDTO; override;

        procedure CreateDocumentFullApprovingsInfoDTOFrom(
          DocumentDTO: TDocumentDTO;
          var DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
          var DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO
        ); override;

        procedure CreateChargesAndChargeSheetsInfoDTOFrom(
          DocumentDTO: TDocumentDTO;
          var DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
          var DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
        ); override;

    end;

implementation

{ TBasedOnDatabaseIncomingDocumentInfoPartlyReadService }

procedure TBasedOnDatabaseIncomingDocumentInfoPartlyReadService.CreateChargesAndChargeSheetsInfoDTOFrom(
  DocumentDTO: TDocumentDTO;
  var DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
  var DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
);
begin

  inherited CreateChargesAndChargeSheetsInfoDTOFrom(
    (DocumentDTO as TIncomingDocumentDTO).OriginalDocumentDTO,
    DocumentChargesInfoDTO,
    DocumentChargeSheetsInfoDTO
  );

end;

function TBasedOnDatabaseIncomingDocumentInfoPartlyReadService.CreateDocumentFilesInfoDTO(
  DocumentDTO: TDocumentDTO): TDocumentFilesInfoDTO;
begin

  Result :=
    inherited CreateDocumentFilesInfoDTO(
      (DocumentDTO as TIncomingDocumentDTO).OriginalDocumentDTO
    );
    
end;

procedure TBasedOnDatabaseIncomingDocumentInfoPartlyReadService.CreateDocumentFullApprovingsInfoDTOFrom(
  DocumentDTO: TDocumentDTO;
  var DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
  var DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO);
begin

  inherited CreateDocumentFullApprovingsInfoDTOFrom(
    (DocumentDTO as TIncomingDocumentDTO).OriginalDocumentDTO,
    DocumentApprovingsInfoDTO,
    DocumentApprovingCycleResultsInfoDTO
  );

end;

function TBasedOnDatabaseIncomingDocumentInfoPartlyReadService.CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO;
begin

  Result := TIncomingDocumentFullInfoDTO.Create;
  
end;

function TBasedOnDatabaseIncomingDocumentInfoPartlyReadService.CreateDocumentRelationsInfoDTO(
  DocumentDTO: TDocumentDTO): TDocumentRelationsInfoDTO;
begin

  Result :=
    inherited CreateDocumentRelationsInfoDTO(
      (DocumentDTO as TIncomingDocumentDTO).OriginalDocumentDTO
    );

end;

end.
