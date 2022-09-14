unit IncomingDocumentFullInfoDTOFromDataSetMapper;

interface

uses

  DB,
  DepartmentInfoDTO,
  DocumentFullInfoDTO,
  IncomingDocumentFullInfoDTO,
  EmployeeInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DocumentFullInfoDataSetHolder,
  IncomingDocumentFullInfoDataSetHolder,
  DocumentFullInfoDTOFromDataSetMapper,
  DocumentDTOFromDataSetMapper,
  DocumentApprovingsInfoDTOFromDataSetMapper,
  DocumentApprovingCycleResultsInfoDTOFromDataSetMapper,
  DocumentChargesInfoDTOFromDataSetMapper,
  DocumentChargeSheetsInfoDTOFromDataSetMapper,
  DocumentRelationsInfoDTOFromDataSetMapper,
  IncomingDocumentDTOFromDataSetMapper,
  IncomingDocumentInfoHolder,
  DocumentFilesInfoDTOFromDataSetMapper,
  DocumentInfoHolder,
  SysUtils,
  Classes;

type

  TIncomingDocumentFullInfoDTOFromDataSetMapper =
    class (TDocumentFullInfoDTOFromDataSetMapper)

      protected

        FDocumentFullInfoDTOFromDataSetMapper:
          TDocumentFullInfoDTOFromDataSetMapper;

      protected

        function CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO; override;

        function GetOriginalDocumentInfoHolder(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentInfoHolder;
        
      public

        destructor Destroy; override;
        constructor Create(

          IncomingDocumentDTOFromDataSetMapper: TIncomingDocumentDTOFromDataSetMapper;
          DocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
          DocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
          DocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
          DocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
          DocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
          DocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper;

          DocumentFullInfoDTOFromDataSetMapper:
            TDocumentFullInfoDTOFromDataSetMapper
        );

        function MapDocumentFullInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentFullInfoDTO; override;

      public

        function MapDocumentDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentDTO; override;

      public

        function MapDocumentApprovingsInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentApprovingsInfoDTO; override;

        function MapDocumentApprovingCycleResultsInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentApprovingCycleResultsInfoDTO; override;

      public
      
        function MapDocumentSigningsInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentSigningsInfoDTO; override;

        function MapDocumentFilesInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentFilesInfoDTO; override;

        function MapDocumentRelationsInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentRelationsInfoDTO; override;

      public

        function MapDocumentChargesInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentChargesInfoDTO; override;

        function MapDocumentChargeSheetsInfoDTOFrom(
          DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        ): TDocumentChargeSheetsInfoDTO; override;


    end;

implementation

{ TIncomingDocumentFullInfoDTOFromDataSetMapper }

constructor TIncomingDocumentFullInfoDTOFromDataSetMapper.Create(
  IncomingDocumentDTOFromDataSetMapper: TIncomingDocumentDTOFromDataSetMapper;
  DocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
  DocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
  DocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
  DocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
  DocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
  DocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper;
  DocumentFullInfoDTOFromDataSetMapper: TDocumentFullInfoDTOFromDataSetMapper
);
begin

  inherited Create(
    IncomingDocumentDTOFromDataSetMapper,
    DocumentApprovingsInfoDTOFromDataSetMapper,
    DocumentApprovingCycleResultsInfoDTOFromDataSetMapper,
    DocumentChargesInfoDTOFromDataSetMapper,
    DocumentChargeSheetsInfoDTOFromDataSetMapper,
    DocumentRelationsInfoDTOFromDataSetMapper,
    DocumentFilesInfoDTOFromDataSetMapper
  );

  FDocumentFullInfoDTOFromDataSetMapper :=
    DocumentFullInfoDTOFromDataSetMapper;

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO;
begin

  Result := TIncomingDocumentFullInfoDTO.Create;

end;

destructor TIncomingDocumentFullInfoDTOFromDataSetMapper.Destroy;
begin

  FreeAndNil(FDocumentFullInfoDTOFromDataSetMapper);
  inherited;

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.GetOriginalDocumentInfoHolder(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder): TDocumentInfoHolder;
begin

  Result :=
    (DocumentFullInfoDataSetHolder.DocumentInfoHolder
      as TIncomingDocumentInfoHolder
    ).OriginalDocumentInfoHolder;

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentApprovingCycleResultsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentApprovingCycleResultsInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentApprovingCycleResultsInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentApprovingsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentApprovingsInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentApprovingsInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentChargeSheetsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentChargeSheetsInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentChargeSheetsInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentChargesInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentChargesInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentChargesInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );
    
end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentDTO;
begin

  Result :=
    FDocumentDTOFromDataSetMapper.MapDocumentDTOFrom(DocumentFullInfoDataSetHolder.DocumentInfoHolder);

end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentFilesInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentFilesInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentFilesInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );
    
end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentFullInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentFullInfoDTO;
begin

  Result :=
    inherited MapDocumentFullInfoDTOFrom(DocumentFullInfoDataSetHolder);
    
end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentRelationsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentRelationsInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentRelationsInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );
    
end;

function TIncomingDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentSigningsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentSigningsInfoDTO;
begin

  Result :=
    FDocumentFullInfoDTOFromDataSetMapper.MapDocumentSigningsInfoDTOFrom(
      DocumentFullInfoDataSetHolder
    );

end;

end.
