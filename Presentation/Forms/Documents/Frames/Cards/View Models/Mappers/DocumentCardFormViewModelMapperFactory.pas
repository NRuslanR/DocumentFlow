unit DocumentCardFormViewModelMapperFactory;

interface

uses

  DocumentDataSetHoldersFactory,
  DocumentCardFormViewModelMapper,
  DocumentApprovingsFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  DocumentChargesFormViewModelMapper,
  DocumentChargeSheetsFormViewModelMapper,
  DocumentRelationsFormViewModelMapper,
  DocumentFilesFormViewModelMapper,
  DocumentFilesViewFormViewModelMapper,
  SysUtils,
  Classes;
  
type

  
  TDocumentCardFormViewModelMapperFactory = class

    protected

      FDocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;

      function CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper; virtual;
      
    public

      constructor Create(
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      );

      function CreateDocumentCardFormViewModelMapper:
        TDocumentCardFormViewModelMapper; virtual;

    public

      function CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper; virtual;
      function CreateDocumentChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper; virtual;

      function CreateDocumentChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper; virtual;
      function CreateDocumentRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper; virtual;
      function CreateDocumentFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper; virtual;
      function CreateDocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper; virtual;
      function CreateDocumentFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper; virtual;
      
  end;

implementation

uses

  ApplicationServiceRegistries;

{ TDocumentCardFormViewModelMapperFactory }

constructor TDocumentCardFormViewModelMapperFactory.Create(
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
);
begin

  inherited Create;

  FDocumentDataSetHoldersFactory := DocumentDataSetHoldersFactory;

end;

function TDocumentCardFormViewModelMapperFactory.CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result := CreateDocumentCardFormViewModelMapperInstance;

  try

    Result.MainInformationFormViewModelMapper :=
      CreateDocumentMainInformationFormViewModelMapper;

    Result.ChargesFormViewModelMapper :=
      CreateDocumentChargesFormViewModelMapper;

    Result.ChargeSheetsFormViewModelMapper :=
      CreateDocumentChargeSheetsFormViewModelMapper;

    Result.RelationsFormViewModelMapper :=
      CreateDocumentRelationsFormViewModelMapper;

    Result.FilesFormViewModelMapper :=
      CreateDocumentFilesFormViewModelMapper;

    Result.DocumentApprovingsFormViewModelMapper :=
      CreateDocumentApprovingsFormViewModelMapper;

    Result.FilesViewFormViewModelMapper :=
      CreateDocumentFilesViewFormViewModelMapper;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper;
begin

  Result := TDocumentCardFormViewModelMapper.Create;
  
end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result := TDocumentMainInformationFormViewModelMapper.Create;

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
begin

  Result :=
    TDocumentChargesFormViewModelMapper.Create(

      TApplicationServiceRegistries
        .Current
          .GetDocumentBusinessProcessServiceRegistry
            .GetDocumentChargeKindsControlAppService,

      FDocumentDataSetHoldersFactory.CreateDocumentChargeSetHolderFactory
    );

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
begin

  Result :=
    TDocumentChargeSheetsFormViewModelMapper.Create(
      TDocumentChargesFormViewModelMapper.Create(

        TApplicationServiceRegistries
          .Current
            .GetDocumentBusinessProcessServiceRegistry
              .GetDocumentChargeKindsControlAppService,

        FDocumentDataSetHoldersFactory.CreateDocumentChargeSetHolderFactory
      ),
      FDocumentDataSetHoldersFactory.CreateDocumentChargeSheetSetHolderFactory
    );

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentRelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
begin

  Result :=
    TDocumentRelationsFormViewModelMapper.Create(
      FDocumentDataSetHoldersFactory.CreateDocumentRelationSetHolderFactory
    )

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentFilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
begin

  Result :=
    TDocumentFilesFormViewModelMapper.Create(
      FDocumentDataSetHoldersFactory.CreateDocumentFileSetHolderFactory
    );

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
begin

  Result :=
    TDocumentApprovingsFormViewModelMapper.Create(
      FDocumentDataSetHoldersFactory.CreateDocumentApprovingCycleSetHolderFactory
    );

end;

function TDocumentCardFormViewModelMapperFactory
  .CreateDocumentFilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper;
begin

  Result := TDocumentFilesViewFormViewModelMapper.Create;

end;

end.
